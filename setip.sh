#!/bin/bash

hostname=""
nameserversip=""

read -p "Enter the desired hostname for this host [ubuntu]: " hostname
read -p "Enter the IPv4 static IP of the server in CIDR notation: " staticip
read -p "Enter the IPv4 address of your gateway: " gatewayip
read -p "Enter the IPv4 addresses of preferred nameservers [208.67.220.220,208.67.222.222]: " nameserversip
hostname="${hostname:-ubuntu}"
nameserversip="${nameserversip:-208.67.220.220,208.67.222.222}"
echo
echo "Setting hostname to ${hostname}"
echo "=========================================================="
echo "Settings to apply:"
echo "Hostname: ${hostname}"
echo "IPv4 Address/Netmask: ${staticip}"
echo "IPv4 Gateway: ${gatewayip}"
echo "IPv4 nameservers: ${nameserversip}"
echo "=========================================================="
read -p "Do you wish to proceed? [y/n]: " -n 1 -r
echo

if [[ ! $REPLY =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo "==========================="
  echo "Cancelled: No changes made!"
	exit 0
fi

cat > ~/01-netcfg.yaml <<EOF
network:
  version: 2
  ethernets:
    ens3:
      addresses:
        - $staticip
      routes:
        - to: default
          via: ${gatewayip}
      nameservers:
        addresses: [$nameserversip]
EOF

sudo /usr/bin/hostname ${hostname}

# remove the installer default config file if it exists
if [ -f /etc/netplan/00-installer-config.yaml ]; then
  sudo mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.bak
fi

# backup the 01-netcfg.yaml file if it exists
if [ -f /etc/netplan/01-netcfg.yaml ]; then
  sudo mv /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.bak
fi

sudo mv ~/01-netcfg.yaml /etc/netplan/01-netcfg.yaml
sudo chown root:root /etc/netplan/01-netcfg.yaml
echo "You may need to reconnect: ssh ${USER}@${staticip}"
sudo netplan apply
echo "==========================="

