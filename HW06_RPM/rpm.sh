#!/bin/bash

# Для данного заданиā нам понадобятся следующие установленные пакеты:
yum install -y \
redhat-lsb-core \
wget \
rpmdevtools \
rpm-build \
createrepo \
yum-utils

# Загрузим SRPM пакет NGINX для дальнейшей работы над ним:
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

# При установке такого пакета в домашней директории создается древо каталогов для сборки:
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

# Качаем исходники для openssl
wget https://www.openssl.org/source/latest.tar.gz

# Распаковываем их
tar -xvf latest.tar.gz

# Устанавливаем зависимости
yum-builddep rpmbuild/SPECS/nginx.spec

# Добавить в %build --with-openssl=/root/openssl-1.1.1a
nano nano SPECS/nginx.spec

# Собираем пакет
rpmbuild -bb rpmbuild/SPECS/nginx.spec

# Убеждаемся что пакет создан
ll rpmbuild/RPMS/x86_64/

# Устанавливаем наш пакет
yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm

# Запускаем
systemctl start nginx

# Проверяем
systemctl status nginx

#
mkdir /usr/share/nginx/html/repo

#
cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

#
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

#
createrepo /usr/share/nginx/html/repo/

#
nano /etc/nginx/conf.d/default.conf

#
nginx -t

#
nginx -s reload

#
lynx http://localhost/repo/

#
curl -a http://localhost/repo/

#
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

#
yum repolist enabled | grep otus

#
yum list | grep otus

#
yum install percona-release -y

#


#
