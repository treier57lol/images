# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: python3
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        python:3.8-slim

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

RUN         mkdir -p /usr/share/man/man1 \
            && apt update \
            && apt -y install git ca-certificates dnsutils iproute2 wget curl xz-utils git openjdk-11-jre \
            && useradd -m -d /home/container container \
            && mkdir -p /home/container/.config/Red-DiscordBot/ \
            && ln -s /home/container/.config/Red-DiscordBot/ /usr/local/share/Red-DiscordBot

USER        container
ENV         USER=container HOME=/home/container 
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
