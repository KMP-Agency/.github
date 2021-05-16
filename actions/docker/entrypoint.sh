#!/bin/sh -l

USERNAME=$1
PASSWORD=$2
REGISTRY=$3
IMAGE_NAME=$4
VERSION=$5
DOCKERFILE=$6
CONTEXT=$7

echo "$USERNAME $PASSWORD $REGISTRY $IMAGE_NAME $VERSION $DOCKERFILE $CONTEXT"


echo "Authenticating to docker registry"
echo "$PASSWORD" | docker login $REGISTRY -u $USERNAME --password-stdin

IMAGE_URL="$REGISTRY/$IMAGE_NAME"

# Change all uppercase to lowercase
IMAGE_NAME=$(echo IMAGE_NAME | tr '[A-Z]' '[a-z]')
IMAGE_URL=$(echo IMAGE_URL | tr '[A-Z]' '[a-z]')

# Use Docker `latest` tag convention
[ "$VERSION" == "master" ] && VERSION=latest

docker build $CONTEXT --file $DOCKERFILE --tag $IMAGE_NAME
docker tag $IMAGE_NAME $IMAGE_ID:$VERSION
docker push $IMAGE_ID:$VERSION