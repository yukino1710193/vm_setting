#!/bin/bash
# truyền file
FILE=${1}
IFS=$'\n'

for line in $(cat ${FILE})
do
    echo ${line}
    IFS=","
    read STT IDENTIFY_FILE IP_HOST <<<${line}
    if [[ "${STT}" == "STT" ]]; then
    continue
    fi  
    # Truyen file
    scp -i "$IDENTIFY_FILE" ~/Projects/vm_setting/set_host.sh ubuntu@$IP_HOST:
    scp -i "$IDENTIFY_FILE" ~/.ssh/id_rsa.pub ubuntu@$IP_HOST:
    # thuc thi
    ssh -i "$IDENTIFY_FILE" ubuntu@$IP_HOST 'sudo cat *.pub >> ~/.ssh/authorized_keys'
    ssh -i "$IDENTIFY_FILE" ubuntu@$IP_HOST 'sudo sh set_host.sh'
    ssh -i "$IDENTIFY_FILE" ubuntu@$IP_HOST 'sudo rm -rf set_host.sh'
    ssh -i "$IDENTIFY_FILE" ubuntu@$IP_HOST 'sudo rm -rf id_rsa.pub'
done

