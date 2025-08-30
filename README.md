# Linux Monitoring Dashboard with Grafana, Prometheus, Node Exporter & Process Exporter

Monitor multiple Linux VMs in real-time with **Grafana**, **Prometheus**, **Node Exporter**, and **Process Exporter**.  
This setup lets you visualize **system metrics, processes, and performance** in a centralized **Grafana Dashboard** from one base machine.

> 📊 Perfect for **Linux server monitoring**, **DevOps**, **multi-VM tracking**, and **infrastructure health visualization**.

---

## 🚀 Features
- 📍 **Multi-VM Support** – Monitor multiple Linux VMs from one base machine.
- 📈 **Grafana Dashboards** – Ready-to-use **Node Exporter** & **Process Exporter** dashboards.

---

## 📂 Files Required
Download all required installation files from **[Current Repository](#)**.  
Files include:
- Grafana `.deb` package
- Prometheus binaries
- Node Exporter & Process Exporter setup scripts
- Pre-configured `.service` files
- Pre-built Grafana dashboards

---

## 🖥️ Installation Guide

### 1️⃣ Install Grafana on Base Machine
```bash
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_12.0.2_amd64.deb
sudo dpkg -i grafana-enterprise_12.0.2_amd64.deb
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server

# Access Grafana UI:
http://localhost:3000/login

### 2️⃣ **Install Prometheus on Base Machine
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
tar xvf prometheus-2.52.0.linux-amd64.tar.gz
cd prometheus-2.52.0.linux-amd64
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo cp prometheus.yml /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

**Replace prometheus.service** with the above provided file Then :-
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus

Access Prometheus UI:
http://localhost:9090

