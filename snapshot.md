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





