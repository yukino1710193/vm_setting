# truyền file
FILE=${1}
IFS=$'\n'

for line in $(cat ${FILE})
do
    echo ${line}
    IFS=","
    read STT IDENTIFY_FILE IP_HOST USERNAME <<<${line}
    if [[ "${STT}" == "STT" ]]; then
        continue
    fi  
    # Truyen file
    scp -i "$IDENTIFY_FILE" ~/Projects/vm_setting/set_host.sh ${USERNAME}@${IP_HOST}:
    scp -i "$IDENTIFY_FILE" ~/.ssh/id_rsa.pub ${USERNAME}@${IP_HOST}:
    # thuc thi
    ssh -t -i "$IDENTIFY_FILE" ${USERNAME}@${IP_HOST} 'sudo cat *.pub >> ~/.ssh/authorized_keys'
    ssh -t -i "$IDENTIFY_FILE" ${USERNAME}@${IP_HOST} 'sudo sh set_host.sh'
done