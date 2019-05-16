#!/bin/bash
consul_version="1.4.4"

# create a tempoary folder for the consul download
mkdir -p /tmp/consul_update
cd /tmp/consul_update

# leave consul cluster before upgrade 
consul leave

# wait 3 secs
sleep 3

# stop running consul
systemctl stop consul

# wait 3 secs again
sleep 3

# download and unzip consul binary
wget https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
unzip consul_${consul_version}_linux_amd64.zip
mv consul /usr/local/bin/
cd -

# cleanup
rm -r /tmp/consul_update

# update systemd daemon
systemctl daemon-reload

# start consul again and print startup
systemctl start consul
systemctl status consul

# print the consul memberlist
sleep 1
/usr/local/bin/consul members
