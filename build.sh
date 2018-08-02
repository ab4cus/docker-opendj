set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=e4cash
# image name
IMAGE=ldap
# version opendj
VERSION=3.0.0

docker build --tag=$IMAGE-opendj-$VERSION -t $USERNAME/$IMAGE-opendj-$VERSION:latest .

