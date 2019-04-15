#!/bin/bash
docker_compose_ver=1.24.0

apt-get remove docker docker-engine docker.io -y
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce -y
groupadd docker
usermod -aG docker ubuntu
systemctl enable docker
systemctl daemon-reload

apt-get autoremove -y

curl -L https://github.com/docker/compose/releases/download/${docker_compose_ver}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose