Now that everything is in order, let's build a highly available and distributed SOC SIEM. 


```
sudo su
```
First, we will define some environment variables, so that we can use them as we go along :

```
cat > .env<<EOF
PASSWORD=`openssl rand -base64 29 | tr -d "=+/" | cut -c1-25`
WORKDIR="${HOME}/elkstack"
VERSION="8.2.0"
HEAP="512m"
ELASTIC_PASSWORD=${PASSWORD}
KIBANA_PASSWORD=${PASSWORD}
STACK_VERSION=${VERSION}
CLUSTER_NAME=lab
LICENSE=trial
ES_PORT=9200
LOGSTASH_HEAP=1g
KIBANA_PORT=5601
MEM_LIMIT=1073741824
COMPOSE_PROJECT_NAME=es
EOF
```

To load the .env to our session :

```
source .env
```
