# ----------------------------------
# Environment: debian:buster-slim
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM quay.io/parkervcp/pterodactyl-images:base_debian

LABEL author="Michael Parker" maintainer="parker@pterodactyl.io"

## install reqs
RUN dpkg --add-architecture i386 \
 && apt update \
 && apt upgrade -y \
 && apt install -y tar curl gcc g++ libssl1.1:i386 lib32tinfo6 libtinfo6:i386 libtinfo5:i386 lib32gcc1 libgcc1 libcurl4-gnutls-dev:i386 libcurl4:i386 \
 libtinfo5 lib32z1 libstdc++6 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libreadline5 libncursesw5 iproute2 gdb libsdl1.2debian libfontconfig1 telnet \
 net-tools netcat libtcmalloc-minimal4:i386 faketime:i386 locales libmariadbclient-dev 

## install rcon
RUN cd /tmp/ \
 && curl -sSL https://github.com/gorcon/rcon-cli/releases/download/0.5.0/rcon-0.5.0-amd64_linux.tar.gz > rcon.tar.gz \
 && tar xvf rcon.tar.gz \
 && mv rcon-0.5.0-amd64_linux/rcon /usr/local/bin/

COPY ./entrypoint.sh /entrypoint.sh