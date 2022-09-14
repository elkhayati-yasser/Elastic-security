# Installation guide for Ubuntu Server 22.04 

Update statement will search for available updates for your system and installed programs based on the sources defined in ***/etc/apt/source.list***

```
sudo apt update
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

Install jq package :

jq is like sed for JSON data - we can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep .

```
sudo apt install jq
```

Check vm.max_map_count on linux :

To make it persistent, we can add this line:

```
vm.max_map_count=262144
```
in our ***/etc/sysctl.conf*** and run

```
sudo sysctl -p
```




