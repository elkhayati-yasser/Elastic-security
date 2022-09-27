### Set up Fleet Server


Fleet Server is required if we plan to use Fleet for central management of all agent .It supports many Elastic Agent connections and serves as a control plane for updating agent policies, collecting status information, and coordinating actions across Elastic Agents. It also provides a scalable architecture. 


### add to .env the path of fleet certificate

```
cat >> .env<<EOF
FLEET_CERTS_DIR=/usr/share/elastic-agent/certificates
EOF
```

We will use Fleet API , Any actions we can perform through the Fleet UI are also available through the API.

Please refer to the [Fleet OpenAPI](https://github.com/elastic/kibana/blob/8.4/x-pack/plugins/fleet/common/openapi/README.md) file in the Kibana repository for more details.



```
curl -k -u "elastic:${PASSWD}" -s -XPOST https://localhost:5601/api/fleet/setup --header 'kbn-xsrf: true' >/dev/null 2>&1
```
We will be placed to the working directory 
```
cd ${HOME}/elkstack
```

### create fleet.yml docker compose file

```
cat > ${WORKDIR}/fleet.yml <<EOF
agent.monitoring:
enabled: true 
  logs: true 
  metrics: true 
  http:
      enabled: true 
      host: 0.0.0.0 
      port: 6791 
EOF
```

Now we will generate service tokens so that elastic agent can connect back to elasticsearch

```
SERVICETOKEN=`curl -k -u "elastic:${PASSWD}" -s -X POST https://localhost:5601/api/fleet/service-tokens --header 'kbn-xsrf: true' | jq -r .value`
```

### generate ***fleet-compose.yml***
```
cat > fleet-compose.yml<<EOF
version: '2.2'

services:
  fleet:
    container_name: fleet
    user: root
    image: docker.elastic.co/beats/elastic-agent:${VERSION}
    environment:
      - FLEET_SERVER_ENABLE=true
      - FLEET_URL=https://fleet:8220
      - FLEET_CA=/usr/share/elastic-agent/certificates/ca/ca.crt
      - FLEET_SERVER_ELASTICSEARCH_HOST=https://es01:9200
      - FLEET_SERVER_ELASTICSEARCH_CA=/usr/share/elastic-agent/certificates/ca/ca.crt
      - FLEET_SERVER_CERT=/usr/share/elastic-agent/certificates/fleet/fleet.crt
      - FLEET_SERVER_CERT_KEY=/usr/share/elastic-agent/certificates/fleet/fleet.key
      - FLEET_SERVER_SERVICE_TOKEN=${SERVICETOKEN}
      - CERTIFICATE_AUTHORITIES=/usr/share/elastic-agent/certificates/ca/ca.crt
    ports:
      - 8220:8220
      - 6791:6791
    restart: unless-stopped
    volumes: ['certs:\$FLEET_CERTS_DIR', './temp:/temp', './fleet.yml:/usr/share/elastic-agent/fleet.yml']

volumes: {"certs"}
EOF
```


```
curl -k -u "elastic:${PASSWD}" "https://localhost:5601/api/fleet/agent_policies?sys_monitoring=true" \
    --header 'kbn-xsrf: true' \
    --header 'Content-Type: application/json' \
    -d '{"id":"fleet-server-policy","name":"Fleet Server policy","description":"","namespace":"default","monitoring_enabled":["logs","metrics"],"has_fleet_server":true}'
```


```
docker-compose -f fleet-compose.yml up -d >/dev/null 2>&1
```


