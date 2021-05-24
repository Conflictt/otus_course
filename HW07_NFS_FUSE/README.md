Домашняя работа

Настройка сервера:

1. Установка и запуск необходимых пакетов

```
sudo yum install nfs-utils -y
sudo yum install firewalld -y
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl enable firewalld
sudo systemctl start firewalld
```

2. Добавление правил в firewall

```
sudo firewall-cmd --permanent --add-port=111/udp
sudo firewall-cmd --permanent --add-port=2049/udp
sudo firewall-cmd --permanent --add-port=4001/udp
sudo firewall-cmd --permanent --zone=public --add-service=nfs
sudo firewall-cmd --permanent --zone=public --add-service=mountd
sudo firewall-cmd --permanent --zone=public --add-service=rpc-bind
sudo firewall-cmd --reload
```

3. Создание папки для шары и изменение прав

`sudo mkdir /tmp/share`
`sudo mkdir /tmp/share/upload`
`sudo chmod -R 777 /tmp/share`

4. В `/etc/exports` публикация каталога и назначение прав доступа

`echo -e "/tmp/share \t192.168.50.11(ro,fsid=0,sync,no_root_squash,no_subtree_check)\n/tmp/share/upload\t192.168.50.11(rw,fsid=1,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports`

5. Применение новых настроек

`sudo exportfs -a`

6. В `/etc/nfs.conf` внесение настроек для NFSv3

`echo -e "[exportfs]\ndebug=all\n[mountd]\ndebug=all\n[nfsd]\ndebug=all\nudp=y\ntcp=n\nvers3=y\nvers4=n\nvers4.0=n\nvers4.1=n\nvers4.2=n" | sudo tee -a /etc/nfs.conf`


Настройка клиента:

1. Установка и запуск необходимых пакетов

```
sudo systemctl restart firewalld
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo yum install nfs-utils -y
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server
```

2. Создание точки монтирования

`sudo mkdir /mnt/share`

3. Монтирование каталога

`sudo mount -t nfs 192.168.50.10:/tmp/share /mnt/share`

4. Добавление записи в `/etc/fstab` для автоматического монтирования

`echo -e "192.168.50.10:/tmp/share\t/mnt/share\tnfs\tdefaults,vers=3\t0\t0" | sudo tee -a /etc/fstab`
