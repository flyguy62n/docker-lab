#!/bin/bash

kernelRelease="$(uname -r)"
prettyName="$(grep PRETTY_NAME /etc/os-release)"
FORE_RED='\033[31m'
DEFAULT_COLOR='\033[m'

# Update our APT databases and upgrade any out of date packages
sudo apt update && sudo apt-get --assume-yes upgrade

# Make sure some necessary dependencies are installed
sudo apt install --assume-yes apt-transport-https ca-certificates curl software-properties-common

# Fetch the Docker GPG key so we can validate that the packages we're about to install haven't been tampered with
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker DPKG repository to the list of approved sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update our APT databases with the new info on Docker-provided packages
sudo apt update

# Confirm that we're getting Docker-CE from Docker and not from any other source
apt-cache policy docker-ce
printf "Review the information above and make sure the ${FORE_RED}download URLs show 'https://download.docker.com'${DEFAULT_COLOR}.  Press ENTER to continue or CTRL-C to abort installation\n"
read dummyVar

# Install Docker already
sudo apt install --assume-yes docker-ce

# Update group permissions so the current user can run Docker commands without SUDO
sudo usermod -aG docker ${USER}

if [[ $kernelRelease =~ "WSL" ]]; then
  if [[ $prettyName =~ "Ubuntu 22" ]]; then
    printf "\n\nUbuntu 22.04 detected on WSL.  We need to reset IPTables to use the legacy engine.\n"
    printf "${FORE_RED}Select 'iptables-legacy' (usually #1) on the following prompt${DEFAULT_COLOR}\n\n"
    sudo update-alternatives --config iptables
  fi
  printf "\nWSL installation detected\n"
  printf "You'll need to start Docker each time WSL reboots.  Use the following command:\n"
  printf "\t${FORE_RED}sudo service docker start${DEFAULT_COLOR}\n"
fi

printf "Installation is complete\n"
printf "Docker group permissions modified.\n${FORE_RED}You will need to logout before group changes will take effect.${DEFAULT_COLOR}\n"