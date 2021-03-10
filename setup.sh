#!/usr/bin/env bash

wget --no-check-certificate -O /root/.bash_aliases https://raw.githubusercontent.com/brightcolor/server-init-setup/master/files/.bash_aliases
rm /root/.bashrc
wget --no-check-certificate -O /root/.bashrc https://raw.githubusercontent.com/brightcolor/server-init-setup/master/files/.bashrc
source /root/.bashrc

wget -O- http://downloads-global.3cx.com/downloads/3cxpbx/public.key | sudo apt-key add -

echo "deb http://downloads-global.3cx.com/downloads/debian stretch main" | sudo tee /etc/apt/sources.list.d/3cxpbx.list

echo "deb http://downloads-global.3cx.com/downloads/debian stretch-testing main" | sudo tee /etc/apt/sources.list.d/3cxpbx-testing.list

aptitude update

aptitude install net-tools dphys-swapfile

aptitude update && aptitude install curl -y

curl https://get.acme.sh | sh

echo "Enter Cloudflare API Key: "
read apikey
export CF_Key="$apikey"

echo "Enter Cloudflare Mail: "
read cfmail
export CF_Email="$cfmail"

host=$(cat /etc/nginx/sites-enabled/3cxpbx | grep -m1 -Poe 'server_name \K[^; ]+')

host=$(hostname).xvoip.cloud

/root/.acme.sh/acme.sh --issue -d $host --dns dns_cf

/root/.acme.sh/acme.sh --install-cert -d $host --fullchain-file /var/lib/3cxpbx/Bin/nginx/conf/Instance1/$host-crt.pem --key-file /var/lib/3cxpbx/Bin/nginx/conf/Instance1/$host-key.pem --reloadcmd "service nginx force-reload"

