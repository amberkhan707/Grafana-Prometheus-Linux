# Linux Monitoring Dashboard with Grafana, Prometheus, Node Exporter & Process Exporter

Monitor multiple Linux VMs in real-time with **Grafana**, **Prometheus**, **Node Exporter**, and **Process Exporter**.  
This setup lets you visualize **system metrics, processes, and performance** in a centralized **Grafana Dashboard** from one base machine.

> 📊 Perfect for **Linux server monitoring**, **DevOps**, **multi-VM tracking**, and **infrastructure health visualization**.

---

## 🚀 Features
- 📍 **Multi-VM Support** – Monitor multiple Linux VMs from one base machine.
- 📈 **Grafana Dashboards** – Ready-to-use **Node Exporter** & **Process Exporter** dashboards.
- ⚡ **Fast Installation** – Minimal manual configuration.
- 🔒 **Secure Setup** – Runs as non-root system users.

---

## 📂 Files Required
Download all required installation files from **[My GitHub Repository](#)**.  
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
