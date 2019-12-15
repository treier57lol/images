############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM debian:buster-slim

LABEL author="Pterodactyl Software" maintainer="support@pterodactyl.io"

ENV STEAMCMDDIR /root/steamcmd

# Install, update & upgrade packages
# Create user for the server
# This also creates the home directory we later need
# Clean TMP, apt-get cache and other stuff to make the image smaller
# Create Directory for SteamCMD
# Download SteamCMD
# Extract and delete archive
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests lib32stdc++6=8.3.0-6 lib32gcc1=1:8.3.0-6 wget=1.20.1-1.1 ca-certificates=20190110 curl \
	&& mkdir -p ${STEAMCMDDIR} \
	&& cd ${STEAMCMDDIR} \
	&& wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf - \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR $STEAMCMDDIR

VOLUME $STEAMCMDDIR