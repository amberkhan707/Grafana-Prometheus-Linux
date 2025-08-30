#!/bin/bash

sudo mkdir /etc/process_exporter
sudo chown -R nodeuser:nodeuser /etc/process_exporter
sudo cp process-exporter /usr/local/bin/
filename="/etc/process_exporter/web.yml"
hash=$(htpasswd -bnB "" "prom" | tr -d ':\n')

content="\
tls_server_config:
  cert_file: /etc/node_exporter/node_exporter.crt
  key_file: /etc/node_exporter/node_exporter.key
basic_auth_users:
  prom: $hash
"
sudo echo "$content" | sudo tee /etc/process_exporter/web.yml

content="\
process_names:
 
   - comm:
     - bash
     - java
     - python3
     - mysqld
     - chrome
     - firefox
     - redis-server



"
sudo echo "$content" | sudo tee /etc/process_exporter/config.yml


content="\
[Unit]
Description=Process Exporter Service
After=network.target

[Service]
User=nodeuser
Group=nodeuser
Type=simple
ExecStart=/usr/local/bin/process-exporter -web.config.file /etc/process_exporter/web.yml -config.path /etc/process_exporter/config.yml
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
"

sudo echo "$content" | sudo tee /etc/systemd/system/process_exporter.service
sudo systemctl enable process_exporter

sudo systemctl daemon-reload
sudo systemctl start process_exporter
systemctl status process_exporter


