#!/bin/bash

VERSION=0.0.1

sed -i "s/version \".*\"/version \"$VERSION\"/" Dockerfile

docker build --rm -t dongli/starman-test:$VERSION . && \
docker push dongli/starman-test:$VERSION
