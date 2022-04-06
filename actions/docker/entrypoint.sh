#!/bin/sh -l

PERSONNAL_API_TOKEN=$1
DOCKERFILE=$2
CONTEXT=$3
USE_COMMIT_HASH=$4
PREFIX=$5

echo "$PERSONNAL_API_TOKEN" | docker login ghcr.io -u $GITHUB_ACTOR --password-stdin

IMAGE_ID=ghcr.io/$GITHUB_REPOSITORY

if [$PREFIX -ne '' ]
then
  IMAGE_ID="$IMAGE_ID/$PREFIX"
fi

echo $IMAGE_ID

# Change all uppercase to lowercase
IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')

if [ $USE_COMMIT_HASH = '0' ]
then
  # Strip git ref prefix from version
  VERSION=$(echo "$GITHUB_REF" | sed -e 's,.*/\(.*\),\1,')

  # Strip "v" prefix from tag name
  [[ "$GITHUB_REF" == "refs/tags/"* ]] && VERSION=$(echo $VERSION | sed -e 's/^v//')

  # Use Docker `latest` tag convention
  [ "$VERSION" == "master" ] && VERSION=latest
else
  VERSION=$(echo $GITHUB_SHA | cut -c1-8)
fi

docker build $CONTEXT --file $DOCKERFILE --tag $IMAGE_ID:$VERSION
docker push $IMAGE_ID:$VERSION

echo "::set-output name=image::$IMAGE_ID:$VERSION"