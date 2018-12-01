#!/bin/bash



# echo "* soft nofile 65000" | sudo tee --append /etc/security/limits.conf
# echo "* soft nofile 65000" | sudo tee --append /etc/security/limits.conf

# Base
sudo apt -y update 
sudo apt -y install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen

# MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
sudo apt -y update
sudo apt -y install mongodb-org
sudo systemctl daemon-reload
sudo systemctl enable mongod.service
sudo systemctl restart mongod.service

# ElasticSearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt -y update && sudo apt -y install elasticsearch
sudo sed -i 's/.*cluster.name: .*/cluster.name: graylog/' /etc/elasticsearch/elasticsearch.yml
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl restart elasticsearch.service


# Graylog
wget https://packages.graylog2.org/repo/packages/graylog-2.4-repository_latest.deb
sudo dpkg -i graylog-2.4-repository_latest.deb
sudo apt -y update && sudo apt -y install graylog-server
# echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
# Default Password Graylog@Admin
sudo sed -i 's/^password_secret.*/password_secret = 10fbc943e0a8382d4c03b651fe6a5500559784f1e776e6ae5c0be6fc7c7bf3aa/' /etc/graylog/server/server.conf
sudo sed -i 's/^root_password_sha2.*/root_password_sha2 = 10fbc943e0a8382d4c03b651fe6a5500559784f1e776e6ae5c0be6fc7c7bf3aa/' /etc/graylog/server/server.conf
sudo sed -i 's/.*rest_listen_uri = .*/rest_listen_uri = http:\/\/0.0.0.0:9000\/api\//' /etc/graylog/server/server.conf
sudo sed -i 's/.*web_listen_uri = .*/web_listen_uri = http:\/\/0.0.0.0:9000\//' /etc/graylog/server/server.conf
# sudo sed -i 's/.*web_endpoint_uri = .*/web_endpoint_uri = http:\/\/127.0.0.1:9000\//' /etc/graylog/server/server.conf
sudo systemctl daemon-reload
sudo systemctl enable graylog-server.service
sudo systemctl start graylog-server.service

