# ----------------------------------
# Environment: debian:buster-slim
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM debian:buster-slim

LABEL author="Michael Parker" maintainer="parker@pterodactyl.io"

ENV DEBIAN_FRONTEND noninteractive

## add container user
RUN useradd -m -d /home/container container

## update base packages
RUN apt update \
 && apt upgrade -y

## install dependencies
RUN apt install -y wget curl tar zip unzip binutils xz-utils liblzo2-2 iproute2 net-tools netcat telnet libatomic1 libsdl2-2.0-0 \
    libfontconfig libicu63 icu-devtools libunwind8 libssl-dev lib32gcc1 sqlite3 libsqlite3-dev libmariadbclient-dev locales

## configure locale
RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
