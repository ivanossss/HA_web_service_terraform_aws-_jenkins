#!/bin/bash
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl stop grafana-server
sudo cp -r grafana/* /etc/grafana
sudo cp /home/ubuntu/grafana.db.bak /var/lib/grafana/grafana.db
sudo chown grafana:grafana /var/lib/grafana/grafana.db
# Установка AWS CLI
sudo apt-get install -y awscli

# Установка региона AWS
sudo aws configure set default.region eu-north-1

# Получение IP-адреса инстанса с именем "Prometheus"
prometheus_ip=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].[PrivateIpAddress]" --filters "Name=tag:Name,Values=Prometheus" "Name=instance-state-name,Values=running" --output text)

# Установка SQLite3
sudo apt-get install -y sqlite3

# Изменение URL сервера Prometheus в базе данных Grafana
sudo sqlite3 /var/lib/grafana/grafana.db <<EOF
UPDATE data_source SET url = 'http://${prometheus_ip}:9090/' WHERE name = 'Prometheus';
EOF

# Запуск сервера Grafana
sudo systemctl start grafana-server

