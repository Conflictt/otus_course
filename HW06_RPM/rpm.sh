#!/usr/bin/env bash
# Загрузим SRPM пакет NGINX для дальнейшей работы над ним:
sudo -i
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.20.0-1.el7.ngx.src.rpm
# При установке такого пакета в домашней директории создается древо каталогов для сборки:
rpm -i nginx-1.20.0-1.el7.ngx.src.rpm
# Качаем исходники для openssl
wget https://www.openssl.org/source/latest.tar.gz
# Распаковываем их
tar -xvf latest.tar.gz
# Устанавливаем зависимости
yum-builddep -y rpmbuild/SPECS/nginx.spec
# Замена SPEC файла
cp -f /vagrant/nginx.spec /root/rpmbuild/SPECS/nginx.speс
# Собираем пакет
rpmbuild -bb /root/rpmbuild/SPECS/nginx.speс
# Убеждаемся что пакет создан
ll /root/rpmbuild/RPMS/x86_64/
# Устанавливаем наш пакет
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.20.0-1.el7.ngx.x86_64.rpm
# Запускаем
systemctl start nginx
# Проверяем
systemctl status nginx
# Создадим каталог repo
rm /usr/share/nginx/html/*
mkdir /usr/share/nginx/html/repo
# Копируем  собранный RPM
cp -r /root/rpmbuild/RPMS/x86_64/nginx-1.20.0-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
# Скачиваем rpm  Percona-server
wget http://www.percona.com/downloads/percona-release/redhat/1.0-26/percona-release-1.0-26.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-26.noarch.rpm
# Инициализируем репозиторий
createrepo /usr/share/nginx/html/repo/
createrepo --update /usr/share/nginx/html/repo/
# Замена default.conf
sudo cp -f /vagrant/default.conf /etc/nginx/conf.d/default.conf
# Проверяем синтаксис
nginx -t
# перезапускаем NGINX
nginx -s reload
#курл на страничку
curl -a http://localhost/repo/
#добавляем репозирторий
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
