# ----------------------------------
# Holdfast: Nations at War Dockerfile
# Environment: Ubuntu:18.04 + Wine + Xvfb
# Minimum Panel Version: 0.7.9
# ----------------------------------
FROM        ubuntu:18.04

LABEL       author="Mason Rowe" maintainer="mason@rowe.sh"

ENV         DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt update \
            && apt upgrade -y \
            && apt install -y zip unzip wget curl libssl1.0.0 iproute2 fontconfig libsdl1.2debian bsdtar xvfb --install-recommends wine lib32gcc1 libntlm0 winbind winetricks \
            && apt clean

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]