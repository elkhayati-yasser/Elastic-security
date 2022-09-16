# Detailed Installation guide for Ubuntu Server 22.04 

Update statement will search for available updates for your system and installed programs based on the sources defined in ***/etc/apt/source.list***

```
sudo apt update
sudo apt install unzip openssl -y;
```
Check if docker and docker compose is installed or not :

```
sudo docker --version
sudo docker-compose version
```
if it's not installed please check the link bellow :

https://docs.docker.com/engine/install/ubuntu/

Post-installation steps for Linux:

https://docs.docker.com/engine/install/linux-postinstall/

Install docker-compose :

```
sudo apt install docker-compose
```
Or follow the instructions here : https://phoenixnap.com/kb/install-docker-compose-on-ubuntu-20-04

Install jq package :

jq is like sed for JSON data - we can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep .

```
sudo apt install jq
```

Change the vm.max_map_count on linux :

```
sudo sysctl -w vm.max_map_count=262144
```

For changes to persist please add a linge into  ***/etc/sysctl.conf*** and realod with (sudo sysctl -p)

```
echo "vm.max_map_count=262144" >> /etc/sysctl.conf && sudo sysctl -p
```
Now that the environment prerequisites are installed and we are ready to go, we will divide the SIEM implementation into 5 sections:

[Elastic cluster only (3 nodes)](../blob/master/LICENSE)

[Fleet server](../blob/master/LICENSE)

[Elastic Monitoring (Metricbeat)](../blob/master/LICENSE)

[Snapshot and Backup (Minio)](../blob/master/LICENSE)

[Sysymon and Elastic Security Endpoint integration ( Windows)](../blob/master/LICENSE)










