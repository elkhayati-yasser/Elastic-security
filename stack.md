Now that everything is in the order, let's build a high available distributed SOC SIEM. 


```
sudo su
```

Now that we have root privileges, we will create a working directory and start creating our configuration files:

```
mkdir ${HOME}/elkstack
cd ${HOME}/elkstack
```

First, we will define some environment variables, so that we can use them as we go along .

We are going to generate a random password, and we will consider it as the password for Elasticsearch and Kibana :

```
PASSWORD=`openssl rand -base64 29 | tr -d "=+/" | cut -c1-25`
```

The command bellow will create a ***.env*** file , where we will store all informations related to the stack :

```
cat > .env<<EOF
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

#### Elasticsearch , Kibana and Logstash configuration files 

Create elasticsearch.yml

```
cat > elasticsearch.yml<<EOF
network.host: 0.0.0.0
EOF
```

The ***network.host*** config is used to tell elasticsearch which IP in the server it will use to bind.We use 0.0.0.0 to tell the Elasticsearch service to bind to all the IPs available on the server

Change the file ownership . 
```
chown 1000 elasticsearch.yml >/dev/null 2>&1
```   
First Linux user has usually ***UID/GID 1000*** .

Create kibana.yml

```
cat > kibana.yml<<EOF
server.host: "0.0.0.0"
server.shutdownTimeout: "5s"
EOF
```

Logstash has two types of configuration files: **pipeline** configuration files, which define the Logstash processing pipeline, and settings files, which specify options that control **Logstash startup and execution**.

Create logstash.yml

```
cat > logstash.yml<<EOF
http.host: "0.0.0.0"
EOF
```
                        
Create pipeline.yml

```                        
cat > pipeline.yml<<EOF
- pipeline.id: beats
  path.config: "/usr/share/logstash/pipeline/*.conf"
  pipeline.workers:3
EOF
```

One last step before releasing the docker-compose files, we need to create the pipeline that logstash will use to receive the documents from different beats (filebeat, Heartbeat, packetbeat, etc.).

The Logstash event processing pipeline has three stages: ***inputs → filters → outputs***. Inputs generate events, filters modify them, and outputs ship them elsewhere.

To do this, we will create a folder, which will contain our **beats.conf** file so that we could load it into the logstash container in the following steps.

```
mkdir pipeline
cd pipeline
```
And we will copy the following command into the terminal:
```
cat > beats.conf<<EOF
input {
    beats {
        port => 5045
        ssl => true
        ssl_certificate => "/usr/share/logstash/config/certs/logstash.crt"
        ssl_key => "/usr/share/logstash/config/certs/logstash.pkcs8.key"
    }
}
filter {
}
output {
    elasticsearch {
        hosts => ["https://es01:9200"]
        user => "elastic"
        password => "${ELASTIC_PASSWORD}"
        ssl => true
        ssl_certificate_verification => true
        cacert => "/usr/share/logstash/config/certs/ca.crt"
        index => "%{[@metadata][beat]}-%{[@metadata][version]}" 
    }
}
EOF
```

This **input plugin** enables Logstash to receive events from the Beats framework and configure Logstash to listen on port ***5045*** for incoming Beats connections and to index into Elasticsearch.

***%{[@metadata][beat]}*** sets the first part of the index name to the value of the metadata field and ***%{[@metadata][version]}*** sets the second part to the Beat version.  For example: **metricbeat-6.1.6**.


In cryptography, **PKCS #8** is a standard syntax for storing private key information, we will generate it using **openssl**.

#### Creating the stack docker-compose file 

Back to the main working Directory :

```
cd ${HOME}/elkstack
```

Our Cluster will be exposed on a **public ip address**, in our case the ethernet network interface of the linux machine. The interface can have names like eth0 , ens33
.

It is recommended to have a static IP on your server so that your IP never expires or to ask your network administrator to allocate an IP on your DHCP server.

Please visit the link below to fix a static IP with internet on your Ubuntu Server.

https://www.makeuseof.com/configure-static-ip-address-settings-ubuntu-22-04/

***Make sure you have the Internet on your server before you proceed.***


 




















