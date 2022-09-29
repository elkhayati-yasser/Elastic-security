# One agent for multiple use cases

With Elastic Agent we can collect all forms of data from anywhere with a single unified agent per host. With elastic agent we can detect, investigate, and respond to evolving threats.


Elastic Security combines SIEM threat detection features with endpoint prevention and response capabilities in one solution. These analytical and protection capabilities, leveraged by the speed and extensibility of Elasticsearch, enable analysts to defend their organization from threats before damage and loss occur.


Elastic Security provides the following security benefits and capabilities:

* A detection engine to identify attacks and system misconfigurations.

* A workspace for event triage and investigations.

* Interactive visualizations to investigate process relationships.

* Inbuilt case management with automated actions.

* Detection of signatureless attacks with prebuilt machine learning anomaly jobs and detection rules.

To benefit of all of this elasticsearch gives us an awsome integration .

Before installing the agent on a windows computer we have to create a policy first.


```
curl -u elastic:${PASSWORD} --request POST \
  --url <kibana_url>/api/fleet/agent_policies?sys_monitoring=true \
  --header 'content-type: application/json' \
  --header 'kbn-xsrf: true' \
  --data '{"name":"WINDOWS","namespace":"default","endpoint"}'
```


curl -k -u "elastic:${PASSWORD}" "https://localhost:5601/api/fleet/agent_policies?sys_monitoring=true" \
    --header 'kbn-xsrf: true' \
    --header 'Content-Type: application/json' \
    -d '{"id":"WINDOWS","name":"WINDOWS","description":"","namespace":"default","monitoring_enabled":["logs","metrics"],"endpoint":"true"}'


