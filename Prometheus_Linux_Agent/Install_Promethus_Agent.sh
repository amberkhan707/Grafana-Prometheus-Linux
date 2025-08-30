#!/bin/bash
echo "Enter the IP address of the machine"
read ip_address
sudo useradd --no-create-home --shell /bin/false nodeuser
sudo mkdir /etc/node_exporter
sudo mkdir /etc/process_exporter
sudo chown -R nodeuser:nodeuser /etc/process_exporter
sudo cp process_exporter /usr/local/bin/
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout node_exporter.key -out node_exporter.crt -subj "/C=US/ST=Utah/L=Lehi/O=Your Company, Inc./OU=IT/CN=yourdomain.com" -addext "subjectAltName = IP:$ip_address"
sudo cp node_exporter.*  /etc/node_exporter
sudo chown -R nodeuser:nodeuser /etc/node_exporter
sudo cp node_exporter /usr/local/bin/
sudo chown -R nodeuser:nodeuser /etc/node_exporter
sudo apt install apache2-utils
filename="/etc/node_exporter/web.yml"
hash=$(htpasswd -bnB "" "prom" | tr -d ':\n')

content="\
tls_server_config:
  cert_file: /etc/node_exporter/node_exporter.crt
  key_file: /etc/node_exporter/node_exporter.key
basic_auth_users:
  prom: $hash
"
sudo echo "$content" | sudo tee /etc/node_exporter/web.yml

content="\
[Unit]
Description=Node Exporter Service
After=network.target

[Service]
User=nodeuser
Group=nodeuser
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.config=/etc/node_exporter/web.yml
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
"
sudo echo "$content" | sudo tee /etc/systemd/system/node_exporter.service



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
Description=Node Exporter Service
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
sudo systemctl start node_exporter
sudo systemctl start process_exporter
sudo systemctl enable node_exporter
systemctl status node_exporter
systemctl status node_exporter

