# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: python3
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        python:3.8-slim

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

ENV         CXX=/usr/bin/g++

RUN         mkdir -p /usr/share/man/man1 \
            && apt update \
            && apt -y install git ca-certificates dnsutils iproute2 make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
            libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev \
            libxmlsec1-dev libffi-dev liblzma-dev libgdbm-dev uuid-dev python3-openssl git openjdk-11-jre 

RUN         mkdir -p /home/container/.config/share/ \
            && ln -s /home/container/.config/share/ /usr/local/share/Red-DiscordBot

RUN         pip install -U Red-DiscordBot

RUN         useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container 
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
