#!/bin/bash

##### file /etc/sudoers

sudo grep -q "^ubuntu ALL=(ALL) NOPASSWD:ALL" /etc/sudoers || echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# thực hiện khối lệnh 1 sẽ kiểm tra trong file /etc/sudoers có dòng ubuntu ... kia chưa -> kết quả trả về 0 hoặc 1 tương ứng với chưa có và có
# nếu chưa có thì thực hiện khối lệnh sau : bao gồm tải input sau phần echo , thêm input đó vào cuối file /etc/sudoers

##### sửa file /etc/ssh/sshd_config
sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#AuthorizedKeysFile\t.ssh\/authorized_keys .ssh\/authorized_keys2/AuthorizedKeysFile\t.ssh\/authorized_keys .ssh\/authorized_keys2/' /etc/ssh/sshd_config
#####
# restart sshd sau khi sửa config
sudo systemctl restart sshd
##### ADD KEY SSH
cd ~
sudo cat *.pub >> .ssh/authorized_keys



