#!/bin/bash

# Update our APT databases and upgrade any out of date packages
sudo apt update && sudo apt-get upgrade

# Make sure some necessary dependencies are installed
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Fetch the Docker GPG key so we can validate that the packages we're about to install haven't been tampered with
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker DPKG repository to the list of approved sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update our APT databases with the new info on Docker-provided packages
sudo apt update

# Confirm that we're getting Docker-CE from Docker and not from any other source
apt-cache policy docker-ce
echo "Review the information above and make sure the download URLs show 'https://download.docker.com'.  Press ENTER to continue or CTRL-C to abort installation"
read dummyVar

# Install Docker already
sudo apt install docker-ce

# Update group permissions so the current user can run Docker commands without SUDO
sudo usermod -aG docker ${USER}

echo "Installation is complete"
echo "Group permissions modified.  You will need to logout before group changes will take effect."