set -ex
#docker rm $(docker ps -a -f status=exited -q)
# run docker
docker run --name=opendj-3 -m 1.5GB -p 389:389 -p 636:636 -p 4444:4444 -p 8989:8989 -i -t -v /opt/opendj/data:/opt/opendj/data -d e4cash/ldap-opendj-3.0.0:latest 

docker ps
