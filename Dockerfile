# ----------------------------------
# Generic Wine image w/ steamcmd support
# Environment: Debian 19 Buster + Wine 5.0
# Minimum Panel Version: 0.7.15
# ----------------------------------
FROM quay.io/parkervcp/pterodactyl-images:base_debian

LABEL author="Michael Parker" maintainer="parker@pterodactyl.io"

## install required packages
RUN dpkg --add-architecture i386 \
 && apt update -y \
 && apt install -y --no-install-recommends libntlm0 winbind xvfb xauth python3 libncurses5:i386 libncurses6:i386

# Install winehq-stable and with recommends
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key \
 && apt-key add winehq.key \
 && echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" >> /etc/apt/sources.list \
 && apt update \
 && wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb \
 && wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb \
 && apt install -y ./libfaudio0_20.01-0~buster_* \
 && apt install -y --install-recommends winehq-stable cabextract xvfb

# Set up Winetricks
RUN	wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
 && chmod +x /usr/sbin/winetricks

ENV HOME=/home/container
ENV WINEPREFIX=/home/container/.wine
ENV WINEDLLOVERRIDES="mscoree,mshtml="
ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1024
ENV DISPLAY_HEIGHT=768
ENV DISPLAY_DEPTH=16
ENV AUTO_UPDATE=1
ENV XVFB=1

USER container
WORKDIR	/home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD	 ["/bin/bash", "/entrypoint.sh"]
