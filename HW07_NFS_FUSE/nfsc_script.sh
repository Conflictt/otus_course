#!/bin/bash
sudo yum install nfs-utils -y
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo mkdir /mnt/share
sudo mount -t nfs 192.168.50.10:/tmp/share /mnt/share
echo -e "192.168.50.10:/tmp/share /mnt/share/" | sudo tee -a /etc/fstab
exit 0
