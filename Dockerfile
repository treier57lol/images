# ----------------------------------
# Environment: ubuntu
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM        debian:stable-slim

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

ENV         DEBIAN_FRONTEND noninteractive

RUN         apt update -y \
            && apt upgrade \
            && apt install -y zip unzip wget curl iproute2 libatomic1 libsdl2-2.0-0 binutils xz-utils libfontconfig liblzo2-2 libicu63 youtube-dl ffmpeg libunwind8 icu-devtools libssl-dev lib32gcc1 sqlite3 \
            && useradd -d /home/container -m container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
