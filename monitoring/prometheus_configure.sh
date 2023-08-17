#!/bin/bash
sudo apt-get update
sudo apt-get install -y awscli
sudo apt-get install -y prometheus
sudo bash -c 'cat > /etc/prometheus/prometheus.yml <<EOF
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: "ec2"
    ec2_sd_configs:
      - region: eu-north-1
        port: 9100
    relabel_configs:
      - source_labels: [__meta_ec2_tag_Name]
        regex: "WebServer in ASG"
        action: keep
EOF'
sudo systemctl restart prometheus
sudo systemctl enable prometheus
