set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=e4cash
# image name
IMAGE=opendj
# version tomcat
VERSION=3.0.0

# ensure we're up to date
git pull

# bump version
#docker run --rm -v "$PWD":/tmp $USERNAME/$IMAGE-$VERSION "$(git log -1 --pretty=%B)"
version=`cat VERSION`
echo "version: $version"

# run build
./build.sh

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags

docker tag $USERNAME/$IMAGE-$VERSION:latest $USERNAME/$IMAGE-$VERSION:$version

# push it
docker push $USERNAME/$IMAGE-$VERSION:latest
docker push $USERNAME/$IMAGE-$VERSION:$version

