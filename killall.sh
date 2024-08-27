#!/bin/bash

IP_SERVER="100.94.203.46"

# clear connect

connections=($(ps aux | grep ssh | grep $IP_SERVER | awk -F ' ' '{ print $2 }'))
for conn in "${connections[@]}"
do
    kill -9 $conn
done
