# Snapshot and restore

A snapshot is a backup of a running Elasticsearch cluster. We can use snapshots to:

1-  Regularly back up a cluster with no downtime.

2-  Recover data after deletion or a hardware failure.

3-  Transfer data between clusters.

4-  Reduce your storage costs by using searchable snapshots in the cold and frozen data tiers.


Elasticsearch supports several repository types with cloud storage options, including:

AWS S3

Google Cloud Storage (GCS)

Microsoft Azure


**Minio** is a popular, open-source distributed object storage server compatible with the Amazon AWS S3 API. We can use it in our installations when we want to store our Elasticsearch snapshots locally.


As always we must be root and place ourselves on the working directory, replace **@PASSWORD** with the elastic password generated previously.

```
sudo su 
cd ${HOME}/elkstack
PASSWORD=@PASSWORD
```

First we have to create a **data directory** , where snapshot data will be stored.

```
mkdir ${HOME}/elkstack/data
```

### create snapshot-compose.yml

```
cat > snapshot-compose.yml<<EOF
version: '2.2'

services:
  minio01:
    container_name: minio01
    image: minio/minio
    user: "0:0"
    environment:
      - MINIO_ROOT_USER=minio
      - MINIO_ROOT_PASSWORD=minio123
    volumes: ['./data:/data', './temp:/temp']
    command: server --address 0.0.0.0:9000 /data
    ports:
      - 9000:9000
    restart: on-failure
    healthcheck:
      test: curl http://localhost:9000/minio/health/live
      interval: 30s
      timeout: 10s
      retries: 5
  mc:
    image: minio/mc
    depends_on:
      - minio01
    entrypoint: >
      bin/sh -c '
      sleep 5;
      /usr/bin/mc config host add s3 http://minio01:9000 minio minio123 --api s3v4;
      /usr/bin/mc mb s3/elastic;
      /usr/bin/mc policy set public s3/elastic;
      '
EOF
```


```
docker-compose -f snapshot-compose.yml up -d
```


```
for((i=1;i<=3;i+=1)); do docker exec es0$i bin/elasticsearch-plugin install --batch repository-s3; done 


```

```
for((i=1;i<=3;i+=1))
do
docker exec -i es0$i bin/elasticsearch-keystore add -xf s3.client.minio01.access_key <<EOF
minio
EOF
done
```                                                                                         
                                                                                       

```
for((i=1;i<=3;i+=1))
do
docker exec -i es0$i bin/elasticsearch-keystore add -xf s3.client.minio01.secret_key <<EOF
minio123
EOF
done
```            

 ```                                                                                         
 for((i=1;i<=3;i+=1)); do docker restart es0$i; done 
 ``` 
 
 
 ```
 IPMINIO=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minio01`
 ```
 
 
 ```
 curl -k -u elastic:${PASSWORD} -XPUT "https://localhost:9200/_snapshot/minio01" -H 'Content-Type: application/json' -d'
{
  "type" : "s3",
  "settings" : {
    "bucket" : "elastic",
    "client" : "minio01",
    "endpoint": "'${IPMINIO}':9000",
    "protocol": "http",
    "path_style_access" : "true"
  }
}'
``` 

```
curl -k -u elastic:${PASSWORD} -XPUT "https://localhost:9200/_slm/policy/minio-snapshot-policy" -H 'Content-Type: application/json' -d'{  "schedule": "0 */30 * * * ?",   "name": "<minio-snapshot-{now/d}>",   "repository": "minio01",   "config": {     "partial": true  },  "retention": {     "expire_after": "5d",     "min_count": 1,     "max_count": 20   }}'
```



