# ----------------------------------
# Generic Wine image w/ steamcmd support
# Environment: Debian 19 Buster + Wine 5.0
# Minimum Panel Version: 0.7.15
# ----------------------------------
FROM debian:buster-slim

LABEL author="Terrahost" maintainer="opensource@terrahost.cloud"

ENV DEBIAN_FRONTEND noninteractive

# Add i386 arch and update
RUN dpkg --add-architecture i386 \
 && apt update \
 && apt upgrade -y

RUN apt install -y --no-install-recommends gnupg2 wget curl software-properties-common

# Install winehq-stable and  with recommends
RUN wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
RUN apt-add-repository https://dl.winehq.org/wine-builds/debian/
RUN wget -O- -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key | sudo apt-key add -    
RUN echo "deb http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" | sudo tee /etc/apt/sources.list.d/wine-obs.list
RUN apt install -y --install-recommends winehq-stable

# Install other packages
RUN apt install -y --no-install-recommends iproute2 cabextract lib32gcc1 libntlm0 ca-certificates winbind xvfb tzdata locales xauth

# Do misc stuff
RUN	wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
 && chmod +x /usr/sbin/winetricks \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && useradd -m -d /home/container container

USER container

ENV HOME=/home/container
ENV WINEPREFIX=/home/container/.wine
ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1024
ENV DISPLAY_HEIGHT=768
ENV DISPLAY_DEPTH=16
ENV AUTO_UPDATE=1
ENV XVFB=1

WORKDIR	/home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD	 ["/bin/bash", "/entrypoint.sh"]
