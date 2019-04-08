#!/bin/bash
consul_version="1.4.4"

mkdir -p /tmp/consul_update
cd /tmp/consul_update

systemctl stop consul

wget https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
unzip consul_${consul_version}_linux_amd64.zip
mv consul /usr/local/bin/

cd -
rm -r /tmp/consul_update

systemctl daemon-reload
systemctl start consul
systemctl status consul

/usr/local/bin/consul members
