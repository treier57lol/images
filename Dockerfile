# ----------------------------------
# Generic Wine image w/ steamcmd support
# Environment: Debian 19 Buster + Wine 4.0
# Minimum Panel Version: 0.7.15
# ----------------------------------
FROM	debian:buster-slim

LABEL	author="WGOS" maintainer="wgos@wgos.org"

ENV		DEBIAN_FRONTEND noninteractive

# Add i386 arch and update
RUN		dpkg --add-architecture i386 \
		&& apt update \
		&& apt upgrade -y

# Install wine and wine64 with recommends
RUN 	apt install -y --install-recommends wine wine64

# Install other packages
RUN		apt install -y --no-install-recommends iproute2 cabextract wget curl lib32gcc1 libntlm0 ca-certificates winbind xvfb tzdata locales

# Do misc stuff
RUN		wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
		&& chmod +x /usr/sbin/winetricks \
		&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
		&& locale-gen \
		&& useradd -m -d /home/container container

USER	container

ENV		HOME=/home/container
ENV		WINEPREFIX=/home/container/.wine
ENV		DISPLAY=:0
ENV		DISPLAY_WIDTH=1024
ENV 	DISPLAY_HEIGHT=768
ENV		DISPLAY_DEPTH=16
ENV		AUTO_UPDATE=1
ENV		XVFB=1

WORKDIR	/home/container

COPY	./entrypoint.sh /entrypoint.sh
CMD		["/bin/bash", "/entrypoint.sh"]