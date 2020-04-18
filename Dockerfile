# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: python3
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        python3.8-slim

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

RUN         apt update \
            && apt -y install git ca-certificates dnsutils \
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
