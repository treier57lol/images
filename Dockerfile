# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Source Engine
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM		debian:buster-slim

LABEL		author="WGOS"

ENV		DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN		dpkg --add-architecture i386 \
		&& apt-get update \
		&& apt-get upgrade -y \
		&& apt-get install -y --install-recommends wine64=4.0-2 xvfb \
		&& useradd -m -d /home/container container

USER		container
ENV		HOME /home/container
WORKDIR		/home/container

COPY		./entrypoint.sh /entrypoint.sh
COPY		--chown=container:container ./wineprefix /home/container/.wine
CMD		["/bin/bash", "/entrypoint.sh"]
