# ----------------------------------
# Wine Dockerfile
# Environment: Ubuntu:18.04 + Wine
# Minimum Panel Version: 0.7.6
# ----------------------------------
FROM        ubuntu:18.04

MAINTAINER  Kenny B, <kenny@venatus.digital>

# Install Dependencies
RUN         dpkg --add-architecture i386 && \
            apt update && \
            apt upgrade -y && \
            apt install -y wget software-properties-common apt-transport-https lib32gcc1 wine64 && \
            apt clean && \
            useradd -d /home/container -m container && \
            cd /home/container

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
