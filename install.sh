#!/bin/bash
set -e

WGPW='HASH HERE'
echo ""
echo "Please enter IP or Hostname"
read HST


# display usage if the script is not run as root user
        if [[ $USER != "root" ]]; then
                echo "This script must be run as root user!"
                exit 1
        fi

echo "Super User detected!!"


function add_gpg {
# Add Docker's official GPG key:
apt-get update
apt-get install -y ca-certificates curl git jq
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
}

function add_plugins {
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function setup_wg {
echo "docker run wireguard"
docker run --detach \
  --name wg-easy \
  --env LANG=en \
  --env WG_HOST=${HST} \
  --env PASSWORD_HASH=${WGPW} \
  --env PORT=51821 \
  --env WG_PORT=51820 \
  --volume ~/.wg-easy:/etc/wireguard \
  --publish 51820:51820/udp \
  --publish 51821:51821/tcp \
  --cap-add NET_ADMIN \
  --cap-add SYS_MODULE \
  --sysctl 'net.ipv4.conf.all.src_valid_mark=1' \
  --sysctl 'net.ipv4.ip_forward=1' \
  --restart unless-stopped \
  ghcr.io/wg-easy/wg-easy
}

##### Script Start
echo script is starting
add_gpg && clear
add_plugins && clear
setup_wg && clear

clear
echo all done!
echo ""
echo you can login here:  https://${HST}
exit 1
