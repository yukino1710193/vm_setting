#!/bin/bash
# truyền file
FILE=${1}
IFS=$'\n'
SSH_DIR="~/.ssh"
AUTH_KEYS="~/.ssh/authorized_keys"
for line in $(cat ${FILE})
do
    echo ${line}
    IFS=","
    read STT IDENTIFY_FILE IP_HOST <<<${line}
    if [[ "${STT}" == "STT" ]]; then
    continue
    fi
    if [ ! -d "$SSH_DIR" ]; then
        echo "Thư mục .ssh không tồn tại. Đang tạo..."
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
    else
        echo "Thư mục .ssh đã tồn tại."
    fi

    # Kiểm tra và tạo tệp authorized_keys nếu chưa tồn tại
    if [ ! -f "$AUTH_KEYS" ]; then
        echo "Tệp authorized_keys không tồn tại. Đang tạo..."
        touch "$AUTH_KEYS"
        chmod 600 "$AUTH_KEYS"
    else
        echo "Tệp authorized_keys đã tồn tại."
    fi
    # Truyen file
    scp ~/Projects/vm_setting/set_host.sh yukino@$IP_HOST:
    scp ~/.ssh/id_rsa.pub yukino@$IP_HOST:
    # thuc thi
    ssh yukino@$IP_HOST "cat *.pub >> ~/.ssh/authorized_keys"
    ssh yukino@$IP_HOST "sudo -S sh set_host.sh"
    ssh yukino@$IP_HOST "sudo rm -rf set_host.sh"
    ssh yukino@$IP_HOST 'grep -v "^$" ~/.ssh/authorized_keys | sort | uniq > ~/.ssh/authorized_keys.tmp'
    ssh yukino@$IP_HOST "mv ~/.ssh/authorized_keys.tmp ~/.ssh/authorized_keys"
    ssh yukino@$IP_HOST "chmod 600 ~/.ssh/authorized_keys"
    ssh yukino@$IP_HOST "sudo rm -rf id_rsa.pub"
done

