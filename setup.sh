set -ex
# run setup openDJ
docker run -i -t -v `pwd`/dj:/opt/opendj/data e4cash/ldap-opendj-3.0.0:latest

