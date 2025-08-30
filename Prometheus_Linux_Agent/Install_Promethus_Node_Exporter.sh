#!/bin/bash
echo "Enter the IP address of the machine"
read ip_address
sudo useradd --no-create-home --shell /bin/false nodeuser
sudo mkdir /etc/node_exporter
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
sudo systemctl enable node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter
systemctl status node_exporter


