#!/bin/bash

set -e

# Fetch GVM
curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -o /tmp/gvm-installer
chmod +x /tmp/gvm-installer

export HOME=/home/ubuntu

# Run command as Ubuntu User
sudo -u ubuntu /tmp/gvm-installer
sudo -u ubuntu /bin/bash -c "source /home/ubuntu/.gvm/scripts/gvm && gvm install go1.4"
