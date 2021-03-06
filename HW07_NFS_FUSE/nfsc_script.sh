#!/bin/bash
sudo yum install mc nano -y
sudo yum install nfs-utils -y
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo mkdir /mnt/share
sudo mount -t nfs -o nfsvers=3 192.168.50.10:/tmp/share /mnt/share
echo -e "192.168.50.10:/tmp/share\t/mnt/share\tnfs\tdefaults,vers=3\t0\t0" | sudo tee -a /etc/fstab
exit 0
