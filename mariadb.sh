#!/bin/bash

printComment () {
    FORE="\033[32m"
    DEFAULT_COLOR='\033[m'

    printf "${FORE}$1${DEFAULT_COLOR}"
}

MARIA_USER='lab'
MARIA_PASS='ourLittleSecret'
MARIA_ROOTPASS='superSecret'

sudo apt install mariadb-client-core-10.6

ifconfig docker0

printComment "Enter the IP address for the docker0 interface: "
read IP_ADDRESS

docker stop mariadb
docker rm mariadb

printComment "Connecting MariaDB to private network on docker0\m"
docker run --detach --name mariadb -p ${IP_ADDRESS}:3306:3306 --env MARIADB_USER=${MARIA_USER} --env MARIADB_PASSWORD=${MARIA_PASS} --env MARIADB_ROOT_PASSWORD=${MARIA_ROOTPASS}  mariadb:latest

docker ps
printComment "Confirm that the MariaDB instance is bound to the private address you provided\n"
printComment "\nUser credentials to access the SQL server:\n"
printComment "\tUsername: " 
printf "%s\n" ${MARIA_USER}
printComment "\tPassword: " 
printf "%s\n" ${MARIA_PASS}
printComment "Root User Password: " 
printf "%s\n" ${MARIA_ROOTPASS}

printComment "Try:\n"
printf "\tmysql -h %s -u %s -p" ${IP_ADDRESS} ${MARIA_USER}
