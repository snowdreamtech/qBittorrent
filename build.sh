#!/bin/sh

DOCKER_HUB_PROJECT=snowdreamtech/qbittorrent

GITHUB_PROJECT=ghcr.io/snowdreamtech/qbittorrent

docker buildx build --platform=linux/386,linux/amd64,linux/arm64,linux/ppc64le,linux/riscv64 \
    -t ${DOCKER_HUB_PROJECT}:flood-latest \
    -t ${DOCKER_HUB_PROJECT}:flood-4.6.4 \
    -t ${DOCKER_HUB_PROJECT}:flood-4.6 \
    -t ${DOCKER_HUB_PROJECT}:flood-4 \
    -t ${GITHUB_PROJECT}:flood-latest \
    -t ${GITHUB_PROJECT}:flood-4.6.4 \
    -t ${GITHUB_PROJECT}:flood-4.6 \
    -t ${GITHUB_PROJECT}:flood-4 \
    . \
    --push
