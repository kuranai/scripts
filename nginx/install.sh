#!/bin/bash
apt install software-properties-common -y
add-apt-repository ppa:nginx/stable
apt update
apt install nginx -y
