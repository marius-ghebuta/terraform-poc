#!/bin/bash 
set -x

export INSTANCE_ID=$(curl 169.254.169.254/latest/meta-data/instance-id)

sudo yum update -y 
sudo yum install httpd -y 
echo The instance ${INSTANCE_ID} welcomes you at Noaptea Companiilor |& sudo tee  -a /var/www/html/index.html

sudo systemctl enable --now httpd 