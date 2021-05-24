#!/bin/bash
sudo yum install nfs-utils -y
sudo yum install firewalld -y
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=111/tcp
sudo firewall-cmd --permanent --add-port=20048/tcp
sudo firewall-cmd --permanent --zone=public --add-service=nfs
sudo firewall-cmd --permanent --zone=public --add-service=mountd
sudo firewall-cmd --permanent --zone=public --add-service=rpc-bind
sudo firewall-cmd --reload
sudo mkdir /tmp/share
sudo mkdir /tmp/share/upload
sudo chmod -R 777 /tmp/share
echo -e "/tmp/share \t192.168.50.11(ro,fsid=0,sync,no_root_squash,no_subtree_check)\n/tmp/share/upload \t192.168.50.11(rw,fsid=1,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
sudo exportfs -a
sudo systemctl restart firewalld
sudo systemctl start rpcbind
sudo systemctl start nfs-server
exit 0
