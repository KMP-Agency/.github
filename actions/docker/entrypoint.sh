#!/bin/sh -l

PERSONNAL_API_TOKEN=$1
DOCKERFILE=$3
CONTEXT=$3

echo "$PERSONNAL_API_TOKEN" | docker login ghcr.io -u $GITHUB_ACTOR --password-stdin

IMAGE_ID=ghcr.io/$GITHUB_REPOSITORY

# Change all uppercase to lowercase
IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')

# Strip git ref prefix from version
VERSION=$(echo "$GITHUB_REF" | sed -e 's,.*/\(.*\),\1,')

# Strip "v" prefix from tag name
[[ "$GITHUB_REF" == "refs/tags/"* ]] && VERSION=$(echo $VERSION | sed -e 's/^v//')

# Use Docker `latest` tag convention
[ "$VERSION" == "master" ] && VERSION=latest

docker build $CONTEXT --file $DOCKERFILE --tag $IMAGE_ID:$VERSION
docker push $IMAGE_ID:$VERSION