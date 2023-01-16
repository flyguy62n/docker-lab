#!/bin/bash

printComment () {
    FORE="\033[32m"
    DEFAULT_COLOR='\033[m'

    printf "${FORE}$1${DEFAULT_COLOR}"
}

printComment "#Stopping nginx\n"
printf "docker stop nginx\n"
docker stop nginx 1> /dev/null

printComment "\n#Removing nginx container\n"
printf "docker rm nginx\n"
docker rm nginx 1> /dev/null

printComment "\n#Starting new container with a volume\n"
printComment "#As a short-cut, we're going to mount our new HTML on top of the default NGINX HTML location\n"
printf "docker run --name nginx -d -p 80:80 -v ${PWD}/html:/usr/share/nginx/html nginx\n"
docker run --name nginx -d -p 80:80 -v ${PWD}/html:/usr/share/nginx/html nginx 1> /dev/null

printComment "\nNow go refresh your browser...\n\n"
