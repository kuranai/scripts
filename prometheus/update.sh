#!/bin/bash

prometheus_version=2.10.0

os=$( uname )

if [ ${os} == 'Darwin' ]; then
    platform='darwin'
    esc='\x1B'
elif [ ${os} == 'Linux' ]; then
    platform='linux'
    esc='\e'
else
    echo "platform not supported"
    exit 1
fi

function info {
    echo -e "${esc}[32m[INFO] ${1}${esc}[39m"
}

function warning {
    echo -e "${esc}[33m[WARNING] ${1}${esc}[39m"
}

function fatal {
    echo -e "${esc}[91m[FATAL] ${1}${esc}[39m" >&2
    exit 2
}

info "stop running prometheus"
if [ ! -f "/usr/local/bin/prometheus" ]; then
    systemctl stop prometheus
fi


info "Downloading Prometheus Version "${prometheus_version}
if [ ! -f "prometheus.tar.gz" ]; then
    /usr/bin/curl -sLo prometheus.tar.gz https://github.com/prometheus/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.${platform}-amd64.tar.gz
else 
    warning "prometheus Download File already exists. Try to delete it"
    rm prometheus.tar.gz
    info "Success"
fi

info "Extracting Prometheus Version "${prometheus_version}
tar xfz prometheus.tar.gz

chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus

info "Move Prometheus to /usr/local/bin/"
cp prometheus-${prometheus_version}.${platform}-amd64/prometheus /usr/local/bin/
cp prometheus-${prometheus_version}.${platform}-amd64/promtool /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

info "Copy the consoles and console_libraries directories to /etc/prometheus"
cp -r prometheus-${prometheus_version}.${platform}-amd64/consoles /etc/prometheus/
cp -r prometheus-${prometheus_version}.${platform}-amd64/console_libraries /etc/prometheus/

info "Set the user and group ownership on the directories to the prometheus user"
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
systemctl status prometheus


info "Cleanup"
if [ -f "prometheus.tar.gz" ]; then
    rm prometheus.tar.gz
else
    warning "prometheus.tar.gz doesn't exists. Can't delete file"
fi 

if [ -d "prometheus-${prometheus_version}.${platform}-amd64" ]; then
    rm -r prometheus-${prometheus_version}.${platform}-amd64
else
    warning "Directory prometheus-${prometheus_version}.${platform}-amd64 doesn't exists. Can't delete folder"
fi 

