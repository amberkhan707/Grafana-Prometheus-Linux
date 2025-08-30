# Grafana & Prometheus Installation in Linux

## Base Machine (Where you want to visualize):

### Grafana Installation:
```bash
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_12.0.2_amd64.deb
sudo dpkg -i grafana-enterprise_12.0.2_amd64.deb
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server
```

### Prometheus Installation:
```bash
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
```

➡️ Replace the `prometheus.service` file with the provided file.  
Save and Exit.

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
```

### Web Browser Access:
- 👉 [http://localhost:9090](http://localhost:9090)
- 👉 [http://localhost:3000/login](http://localhost:3000/login)

---

## VM (Machine that will be tracked):

### Step 1:
- Copy `Prometheus_Linux_Agent` (from provided ZIP file) into **Downloads** of VM.
- Give permission to this folder.

### Step 2:
Go inside `Prometheus_Linux_Agent` folder and run:
```bash
./Install_Promethus_Agent.sh        # Enter Current System IP
./Install_Promethus_Node_Exporter.sh # Enter Current System IP
./Install_Promethus_Process_Exporter.sh
```

### Step 3:
Go inside `/etc/systemd/system`  
➡️ Replace `node_exporter.service` & `process_exporter.service` with the provided files.

### Step 4:
Go inside `/etc/process_exporter`  
➡️ Replace `config.yml` with the provided file.

### Step 5:
```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart node_exporter
sudo systemctl restart process_exporter
```

---

## Base Machine (Final Setup):

### Step 1:
Go inside `/etc/promethus`  
➡️ Replace `prometheus.yml` with the provided file.  
(Change/Add the **IP of the VM** inside this `prometheus.yml`)

### Step 2:
```bash
sudo systemctl restart prometheus
```

### Step 3: Grafana Setup
Open Firefox → [http://localhost:3000](http://localhost:3000)

- **Home → Connection → Add new source → Prometheus**  
  - Name: `Prometheus`  
  - Link: `http://localhost:9090`  
  - Scroll down → Save  

- **Home → Dashboard → New → Import → Prometheus → Import.**  

- **Home → Dashboard → MDA_PSS Data.**  

---
✅ Done.
