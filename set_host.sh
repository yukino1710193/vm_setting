#!/bin/bash

##### file /etc/sudoers
USERNAME=${SUDO_USER:-$(whoami)}
sudo grep -q "^$USERNAME ALL=(ALL) NOPASSWD:ALL" /etc/sudoers || echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

##### sửa file /etc/ssh/sshd_config nếu không tìm thấy văn bản gốc thì sẽ không sửa ( yên tâm khi file đó đã được config thì sẽ ko bị config lại
# gây trùng lặp)
sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#AuthorizedKeysFile\t.ssh\/authorized_keys .ssh\/authorized_keys2/AuthorizedKeysFile\t.ssh\/authorized_keys .ssh\/authorized_keys2/' /etc/ssh/sshd_config
#####
# restart sshd sau khi sửa config
sudo systemctl restart sshd
