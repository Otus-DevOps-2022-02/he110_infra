#!/bin/bash
sleep 20
set -e
APP_DIR=${1:-$HOME}
sudo apt-get install -y git
if [ ! -d "$APP_DIR/reddit" ] ; then
    git clone -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
fi
cd $APP_DIR/reddit
bundle install
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
