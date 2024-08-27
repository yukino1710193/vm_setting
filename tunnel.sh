#!/bin/bash

IP_SERVER="100.94.203.46"

# clear connect

connections=($(ps aux | grep ssh | grep $IP_SERVER | awk -F ' ' '{ print $2 }'))
for conn in "${connections[@]}"
do
    kill -9 $conn
done

# tunnel method

func(){
    autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -fNL $IP_SERVER:${param[0]}:${param[1]}:${param[2]} yuki@$IP_SERVER
}
param=("7001" "192.168.122.81" "22") && func
param=("7002" "192.168.122.82" "22") && func
param=("7003" "192.168.122.83" "22") && func
param=("8007" "192.168.101.7" "22") && func

# 
