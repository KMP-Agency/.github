#!/bin/sh -l

echo "Authenticating to docker registry"
echo "$2" | docker login ghcr.io -u $1 --password-stdin

ls -la