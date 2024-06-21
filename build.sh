#!/bin/sh

DOCKER_HUB_PROJECT=snowdreamtech/qbittorrent

GITHUB_PROJECT=ghcr.io/snowdreamtech/qbittorrent

docker buildx build --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
-t ${DOCKER_HUB_PROJECT}:latest \
-t ${DOCKER_HUB_PROJECT}:4.6.5 \
-t ${DOCKER_HUB_PROJECT}:4.6 \
-t ${DOCKER_HUB_PROJECT}:4 \
-t ${GITHUB_PROJECT}:latest \
-t ${GITHUB_PROJECT}:4.6.5 \
-t ${GITHUB_PROJECT}:4.6 \
-t ${GITHUB_PROJECT}:4 \
. \
--push
