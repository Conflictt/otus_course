Домашняя работа

Разместить `Vagrantfile` и `sysD.sh` в одной папке, сделать `vagrant up`, подождать несколько минут

После создания виртуальной машины подключаемся `vagrant ssh`

Можно проверить результат выполнения заданий

1. `sudo tail -f /var/log/messages`

```
[vagrant@localhost ~]$ sudo tail -f /var/log/messages
Jun  7 20:58:01 localhost bash: May 31 16:43:34 raspberrypi kernel ERROR: [4572071.398420] Voltage normalised (0x00000000)
Jun  7 20:58:31 localhost systemd: Started Readind log.
Jun  7 20:58:31 localhost bash: ERROR
Jun  7 20:58:31 localhost bash: May 31 16:43:34 raspberrypi kernel ERROR: [4572071.398420] Voltage normalised (0x00000000)
Jun  7 20:59:01 localhost systemd: Started Readind log.
Jun  7 20:59:01 localhost bash: ERROR
Jun  7 20:59:01 localhost bash: May 31 16:43:34 raspberrypi kernel ERROR: [4572071.398420] Voltage normalised (0x00000000)
Jun  7 20:59:31 localhost systemd: Started Readind log.
Jun  7 20:59:31 localhost bash: ERROR
Jun  7 20:59:31 localhost bash: May 31 16:43:34 raspberrypi kernel ERROR: [4572071.398420] Voltage normalised (0x00000000)
```

2. `sudo systemctl status spawn-fcgi.service`

```
● spawn-fcgi.service - spawn-fcgi service
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2021-06-07 20:57:30 UTC; 2min 45s ago
 Main PID: 2696 (php-cgi)
   CGroup: /system.slice/spawn-fcgi.service
           ├─2696 /usr/bin/php-cgi
           ├─2700 /usr/bin/php-cgi
           ├─2701 /usr/bin/php-cgi
           ├─2702 /usr/bin/php-cgi
           ├─2703 /usr/bin/php-cgi
           ├─2704 /usr/bin/php-cgi
           ├─2705 /usr/bin/php-cgi
           ├─2706 /usr/bin/php-cgi
           ├─2707 /usr/bin/php-cgi
           ├─2708 /usr/bin/php-cgi
           ├─2709 /usr/bin/php-cgi
           ├─2710 /usr/bin/php-cgi
           ├─2711 /usr/bin/php-cgi
           ├─2712 /usr/bin/php-cgi
           ├─2713 /usr/bin/php-cgi
           ├─2714 /usr/bin/php-cgi
           ├─2715 /usr/bin/php-cgi
           ├─2716 /usr/bin/php-cgi
           ├─2717 /usr/bin/php-cgi
           ├─2718 /usr/bin/php-cgi
           ├─2719 /usr/bin/php-cgi
           ├─2720 /usr/bin/php-cgi
           ├─2721 /usr/bin/php-cgi
           ├─2722 /usr/bin/php-cgi
           ├─2723 /usr/bin/php-cgi
           ├─2724 /usr/bin/php-cgi
           ├─2725 /usr/bin/php-cgi
           ├─2726 /usr/bin/php-cgi
           ├─2727 /usr/bin/php-cgi
           ├─2728 /usr/bin/php-cgi
           ├─2729 /usr/bin/php-cgi
           ├─2731 /usr/bin/php-cgi
           └─2733 /usr/bin/php-cgi

Jun 07 20:57:30 localhost.localdomain systemd[1]: Started spawn-fcgi service.
```

3. `sudo systemctl status httpd@first.service` `sudo systemctl status httpd@second.service`

```
[vagrant@localhost ~]$ sudo systemctl status httpd@first.service
● httpd@first.service - The Apache HTTP Server
   Loaded: loaded (/etc/systemd/system/httpd@.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2021-06-07 20:57:31 UTC; 3min 45s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 2759 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/system-httpd.slice/httpd@first.service
           ├─2759 /usr/sbin/httpd -f /etc/httpd/conf/first.conf -DFOREGROUND
           ├─2760 /usr/sbin/httpd -f /etc/httpd/conf/first.conf -DFOREGROUND
           ├─2761 /usr/sbin/httpd -f /etc/httpd/conf/first.conf -DFOREGROUND
           ├─2762 /usr/sbin/httpd -f /etc/httpd/conf/first.conf -DFOREGROUND
           ├─2763 /usr/sbin/httpd -f /etc/httpd/conf/first.conf -DFOREGROUND
           ├─2764 /usr/sbin/httpd -f /etc/httpd/conf/first.conf -DFOREGROUND
           └─2765 /usr/sbin/httpd -f /etc/httpd/conf/first.conf -DFOREGROUND

Jun 07 20:57:30 localhost.localdomain systemd[1]: Starting The Apache HTTP Server...
Jun 07 20:57:31 localhost.localdomain httpd[2759]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using localhost.localdomain. Set the 'ServerName' directive globally to suppress this message        
Jun 07 20:57:31 localhost.localdomain systemd[1]: Started The Apache HTTP Server.


[vagrant@localhost ~]$ sudo systemctl status httpd@second.service
● httpd@second.service - The Apache HTTP Server
   Loaded: loaded (/etc/systemd/system/httpd@.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2021-06-07 20:57:31 UTC; 3min 50s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 2769 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/system-httpd.slice/httpd@second.service
           ├─2769 /usr/sbin/httpd -f /etc/httpd/conf/second.conf -DFOREGROUND
           ├─2770 /usr/sbin/httpd -f /etc/httpd/conf/second.conf -DFOREGROUND
           ├─2771 /usr/sbin/httpd -f /etc/httpd/conf/second.conf -DFOREGROUND
           ├─2772 /usr/sbin/httpd -f /etc/httpd/conf/second.conf -DFOREGROUND
           ├─2773 /usr/sbin/httpd -f /etc/httpd/conf/second.conf -DFOREGROUND
           ├─2775 /usr/sbin/httpd -f /etc/httpd/conf/second.conf -DFOREGROUND
           └─2776 /usr/sbin/httpd -f /etc/httpd/conf/second.conf -DFOREGROUND

Jun 07 20:57:31 localhost.localdomain systemd[1]: Starting The Apache HTTP Server...
Jun 07 20:57:31 localhost.localdomain httpd[2769]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using localhost.localdomain. Set the 'ServerName' directive globally to suppress this message        
Jun 07 20:57:31 localhost.localdomain systemd[1]: Started The Apache HTTP Server.
```
