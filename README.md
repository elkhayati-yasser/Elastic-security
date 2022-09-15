# Elastic-security
Elastic cluster ( SIEM SOC )


Elastic Security unifies SIEM, endpoint security, and cloud security on an open platform, equipping teams to prevent, detect, and respond to threats.


This repo aims to build a stable and mature (on-prem) elastic cluster , we will start by defining  the Hardware prerequisites (CPU, RAM, Storage ..) ,the architecture ,the components and more ...

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Hardware prerequisites

For a dev enviroments we will need as minimum :

|Memory         | Storage       | CPU   |
| ------------- |:-------------:| -----:|
| 16 GB RAM     | 250 GB SSD    |8 CPU Cores|

For a Production enviroments we will need as minimum :

|Memory         | Storage       | CPU   |
| ------------- |:-------------:| -----:|
| 32 GB RAM     | 500 GB SSD with minimum 3k dedicated IOPS   |16 CPU cores|

# Architecture

In this project we will adopt the architecture bellow :

![alt text](https://github.com/whatisdeadmayneverdie/Elastic-security/blob/cfc8951b784fe39c1549f3d7b68276a4cf4d01bd/Architecture.png "Project architecture")

## Components

***Elasticsearch***  is a distributed, RESTful search and analytics engine, it centrally stores your data for  fast search, fine‑tuned relevancy, and powerful analytics. 

***Kibana***  is a free and open user interface that lets you visualize your Elasticsearch data .

***Logstash*** is a server-side pipeline for data processing.

***Beats*** is a free and open platform for single-purpose data shippers.

***Fleet Server*** is the mechanism to connect Elastic Agents to Fleet.

***MinIO*** is a High Performance Object Storage.

***Docker*** is a platform for running certain applications in software containers.


# Implementation process

[Detailled installation](../installation guide)

[Automation using bash](../blob/master/LICENSE)



