# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Source Engine
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM		debian:buster-slim

LABEL		author="WGOS" maintainer="wgos@wgos.org"

ENV		DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN		dpkg --add-architecture i386 \
		&& apt update \
		&& apt upgrade -y \
		&& apt install -y --install-recommends wine wine64 \
		&& apt install -y --no-install-recommends wget curl lib32gcc1 ca-certificates winbind xvfb tzdata \
		&& useradd -m -d /home/container container \
		&& mkdir /wine \
		&& wget -q -O /wine/gecko_x86.msi http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi \
		&& wget -q -O /wine/gecko_x86_64.msi http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi \
		&& wget -q -O /wine/mono.msi http://dl.winehq.org/wine/wine-mono/4.9.3/wine-mono-4.9.3.msi \
		&& chmod -R 0444 /wine

USER		container
ENV		HOME /home/container
ENV		DISPLAY :0
WORKDIR		/home/container

COPY		./entrypoint.sh /entrypoint.sh
CMD		["/bin/bash", "/entrypoint.sh"]

