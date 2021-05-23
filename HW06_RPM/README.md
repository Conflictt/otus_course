Домашняя работа

Загрузим SRPM пакет NGINX для дальнейшей работы над ним

`wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.20.0-1.el7.ngx.src.rpm`

Устанавливаем пакет

`rpm -i nginx-1.20.0-1.el7.ngx.src.rpm`

Качаем исходники для openssl

`wget https://www.openssl.org/source/latest.tar.gz`

Распаковываем их

`tar -xvf latest.tar.gz`

Устанавливаем зависимости

`yum-builddep -y rpmbuild/SPECS/nginx.spec`

Замена SPEC файла
`rm -rf /root/rpmbuild/SPECS/{*,.*}`
`cp -f /vagrant/nginx.spec /root/rpmbuild/SPECS/nginx.speс`

При добавлении опции в блок указаныый в инструкции пакет не хотел собираться, нашел вариант с добавлением параметра в следующем блоке:

```
%define BASE_CONFIGURE_ARGS $(echo "--prefix=%{_sysconfdir}/nginx --sbin-path=%{_sbindir}/nginx --modules-path=%{_libdir}/nginx/modules --conf-path=%{_sysconfdir}/nginx/nginx.conf --error-log-path=%{_localstatedir}/log/nginx/error.log --http-log-path=%{_localstatedir}/log/nginx/access.log --pid-path=%{_localstatedir}/run/nginx.pid --lock-path=%{_localstatedir}/run/nginx.lock --http-client-body-temp-path=%{_localstatedir}/cache/nginx/client_temp --http-proxy-temp-path=%{_localstatedir}/cache/nginx/proxy_temp --http-fastcgi-temp-path=%{_localstatedir}/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=%{_localstatedir}/cache/nginx/uwsgi_temp --http-scgi-temp-path=%{_localstatedir}/cache/nginx/scgi_temp --user=%{nginx_user} --group=%{nginx_group} --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-openssl=/root/openssl-1.1.1k")
```

Собираем пакет

`rpmbuild -bb /root/rpmbuild/SPECS/nginx.speс`

Убеждаемся что пакет создан

`ll /root/rpmbuild/RPMS/x86_64/`

```
[root@localhost ~]# ll /root/rpmbuild/RPMS/x86_64/
total 5632
-rw-r--r--. 1 root root 3749892 May 23 20:28 nginx-1.20.0-1.el7.ngx.x86_64.rpm
-rw-r--r--. 1 root root 2012812 May 23 20:28 nginx-debuginfo-1.20.0-1.el7.ngx.x86_64.rpm
```

Устанавливаем наш пакет

`yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.20.0-1.el7.ngx.x86_64.rpm`

Запускаем

`systemctl start nginx`

Проверяем

`systemctl status nginx`

Создадим каталог repo

`rm -rf /usr/share/nginx/html/*`
`mkdir /usr/share/nginx/html/repo`

Копируем  собранный RPM

`cp -r /root/rpmbuild/RPMS/x86_64/nginx-1.20.0-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/`

Скачиваем rpm  Percona-server

`wget http://www.percona.com/downloads/percona-release/redhat/1.0-26/percona-release-1.0-26.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-26.noarch.rpm`

Инициализируем репозиторий

`createrepo /usr/share/nginx/html/repo/`
`createrepo --update /usr/share/nginx/html/repo/`

Замена default.conf

`sudo cp -f /vagrant/default.conf /etc/nginx/conf.d/default.conf`

Проверяем синтаксис

`nginx -t`

Перезапускаем NGINX

`nginx -s reload`

Курл на страничку

`curl -a http://localhost/repo/`

Добавляем репозирторий

```
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
```

Убеждаемся наличию репозитория и пакетов в Инициализируем

```
yum repolist enabled | grep otus

yum list | grep otus

yum install percona-release -y
```
