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

Create logstash.yml

```
cat > logstash.yml<<EOF
http.host: "0.0.0.0"
EOF
```
                        
Create pipeline.yml

```                        
cat > pipeline.yml<<EOF
- pipeline.id: normal-beats
  path.config: "/usr/share/logstash/pipeline/*.conf"
  pipeline.workers:3
EOF
```
