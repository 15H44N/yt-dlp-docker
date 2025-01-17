#!/bin/bash

# Repository Login
# echo -e "### login to docker.io ###"
# podman login docker.io

# Building Image
CURDIR=$PWD

cd Containerfile.d

for f in Containerfile*; do
    echo -e "\n### Build ${f/Containerfile./} ###"
    podman build --layers=true -t yt-dlp:"${f/Containerfile./}" -f $f
done

# Test
for f in Containerfile*; do
    echo -e "\n### Run ${f/Containerfile./} ###"
    podman run --rm yt-dlp:${f/Containerfile./} --version
done

# Push
for f in Containerfile*; do
    echo -e "\n### Push yt-dlp:${f/Containerfile./} ###"
    podman push yt-dlp:${f/Containerfile./} docker.io/ishn/yt-dlp:${f/Containerfile./} --format v2s2
    if [ "${f/Containerfile./}" = "alpine-static" ]; then
        echo -e "\n### Push yt-dlp:latest"
        podman push yt-dlp:${f/Containerfile./} docker.io/ishn/yt-dlp --format v2s2
    fi
done

cd $CURDIR
