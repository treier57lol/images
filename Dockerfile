# ----------------------------------
# Environment: ubuntu
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM    mono:5-slim

LABEL   author="Michael Parker" maintainer="parker@pterodactyl.io"

RUN     apt update -y \
        && apt install -y iproute2 \
        && useradd -d /home/container -m container

USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]