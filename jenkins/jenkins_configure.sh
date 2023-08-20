#!/bin/bash

# Обновляем список пакетов
sudo apt-get update

# Устанавливаем Java (Jenkins требует Java для работы)
sudo apt-get install -y openjdk-11-jdk

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get install -y awscli
aws configure set region eu-north-1
sudo adduser ubuntu docker
sudo apt-get install -y jenkins
sudo systemctl stop jenkins
sudo adduser jenkins docker
sudo cp -r /var/lib/jenkins /var/lib/jenkins_backup
cd /home/ubuntu/
sudo cp -r jenkins/* /var/lib/jenkins/
sudo cp /home/ubuntu/my_ssh_key.pem /var/lib/jenkins/my_ssh_key.pem
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo chmod 600 /var/lib/jenkins/my_ssh_key.pem
sudo systemctl start jenkins
sudo systemctl enable jenkins

