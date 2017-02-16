#!/usr/bin/env bash

ORIGINAL_DOCKERFILE=Dockerfile.nginx.original
ADDON_DOCKER_FILE=Dockerfile.addon
TAG=${TAG:-`date +"%Y-%m-%d-%H-%M-%S"`}

curl -o ${ORIGINAL_DOCKERFILE} https://raw.githubusercontent.com/nginxinc/docker-nginx/e950fa7dfcee74933b1248a7fe345bdbc176fffb/mainline/alpine/Dockerfile


# Thanks to http://stackoverflow.com/questions/10107459/replace-a-word-with-multiple-lines-using-sed
DATA="$(cat ${ADDON_DOCKER_FILE})"
ESCAPED_DATA="$(echo "${DATA}" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/\$/\\$/g')"
cat ${ORIGINAL_DOCKERFILE} | sed 's~EXPOSE 80 443~'"${ESCAPED_DATA}"'~' > Dockerfile

sed -i 's/MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"/MAINTAINER Me Grimlock "grimlock@portnumber53.com"/g' Dockerfile

sed -i 's~--user=nginx~--user=grimlock~' Dockerfile
sed -i 's~--group=nginx~--group=grimlock~' Dockerfile
sed -i 's~addgroup -S nginx~addgroup -S grimlock~' Dockerfile
sed -i 's~adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx~adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G grimlock grimlock~' Dockerfile
#sed -i 's~~~' Dockerfile
#sed -i 's~~~' Dockerfile


docker build -t portnumber53/docker-nginx:${TAG} . \
  && docker push portnumber53/docker-nginx:${TAG} \
  && echo "Pushed image successfuly."
