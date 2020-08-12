# ----------------------------------
# Environment: debian
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM    quay.io/parkervcp/pterodactyl-images:base_debian

LABEL   author="Michael Parker" maintainer="parker@pterodactyl.io"

ENV     DEBIAN_FRONTEND noninteractive

## install luvit
RUN     cd /usr/local/bin/ \
        && curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh


USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
