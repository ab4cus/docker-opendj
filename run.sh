#!/bin/bash
#set -ex
#docker rm $(docker ps -a -f status=exited -q)
# run docker
# Local
docker run --name=middleware-opendj  \
	--hostname=opendj.e4cash.local  \
	--network-alias=ldap \
	-m 1.5GB  \
	-p 389:389  \
	-p 636:636  \
	-p 4444:4444  \
	-p 8989:8989 \
	-v /opt/opendj/data:/opt/opendj/data  \
	-d e4cash/opendj-3.0.0:latest

sleep 5

docker ps -a

