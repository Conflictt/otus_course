#!/bin/bash
cat << EOF | sudo tee /usr/bin/watch.sh
#!/bin/bash
awk "/\$keyword/ {print}" \$logfile
EOF

cat << EOF | sudo tee /var/log/watch.log
ERROR
May 31 13:43:32 raspberrypi kernel: [4561269.875179] Voltage normalised (0x00000000)
May 31 14:09:59 raspberrypi kernel: [4562856.926779] Voltage normalised (0x00000000)
May 31 16:09:58 raspberrypi kernel: [4570055.862571] Voltage normalised (0x00000000)
May 31 16:13:32 raspberrypi kernel: [4570270.104328] Voltage normalised (0x00000000)
May 31 16:43:34 raspberrypi kernel ERROR: [4572071.398420] Voltage normalised (0x00000000)
May 31 17:21:58 raspberrypi kernel: [4574376.056402] Voltage normalised (0x00000000)
May 31 19:13:32 raspberrypi kernel: [4581069.548556] Voltage normalised (0x00000000)
May 31 20:43:33 raspberrypi kernel: [4586471.351065] Voltage normalised (0x00000000)
May 31 21:13:33 raspberrypi kernel: [4588270.565086] Voltage normalised (0x00000000)
May 31 21:22:06 raspberrypi kernel: [4588784.329177] Voltage normalised (0x00000000)
EOF

cat << EOF | sudo tee /etc/sysconfig/watch
keyword="ERROR"
logfile="/var/log/watch.log"
EOF

cat << EOF | sudo tee /etc/systemd/system/watch.service
[Unit]
Description=Readind log
After=network.target
[Service]
EnvironmentFile=-/etc/sysconfig/watch
ExecStart=/bin/bash /usr/bin/watch.sh
Type=simple
[Install]
WantedBy=multi-user.target
EOF

cat << EOF | sudo tee /etc/systemd/system/watch.timer
[Unit]
Description=Run every 30 seconds
[Timer]
OnBootSec=1m
OnUnitActiveSec=30s
Unit=watch.service
[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable watch.service
sudo systemctl enable watch.timer
sudo systemctl start watch.timer
#sudo tail -f /var/log/messages

#################################################################

cat << EOF | sudo tee /etc/sysconfig/spawn-fcgi
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u apache -g apache -s $SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cgi"
EOF

cat << EOF | sudo tee /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=spawn-fcgi service

[Service]
ExecStart=/usr/bin/spawn-fcgi -n -u apache -g apache -s /var/run/php-fcgi.sock -S -M 0600 -C 32 -F 1 -P /var/run/spawn-fcgi.pid -- /usr/bin/php-cgi


[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable spawn-fcgi.service
sudo systemctl start spawn-fcgi.service
sudo systemctl status spawn-fcgi.service

#####################################################################

cat << EOF | sudo tee /etc/systemd/system/httpd@.service
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd-%I
ExecStart=/usr/sbin/httpd \$OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd \$OPTIONS -k graceful
ExecStop=/bin/kill -WINCH \${MAINPID}
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

cat << EOF | sudo tee /etc/sysconfig/httpd-first
OPTIONS=-f /etc/httpd/conf/first.conf
EOF

cat << EOF | sudo tee /etc/sysconfig/httpd-second
OPTIONS=-f /etc/httpd/conf/second.conf
EOF

sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf

sudo sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/second.conf
sudo sh -c "echo 'PidFile /var/run/httpd-second.pid' >> /etc/httpd/conf/second.conf"

sudo systemctl start httpd@first.service

sudo systemctl start httpd@second.service

sudo systemctl status httpd@first.service
sudo systemctl status httpd@second.service
