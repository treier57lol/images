FROM        ubuntu:16.04

MAINTAINER  ki2007, <ki2007@damw.eu>
ENV         DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y tar curl gcc g++ pulseaudio lib32gcc1 lib32tinfo5 lib32z1 lib32stdc++6 libtinfo5:i386 libncurses5:i386 libcurl3-gnutls:i386 iproute2 gdb libsdl1.2debian libfontconfig ca-certificates bzip2 wget less x11vnc xvfb libxcursor1 libnss3 libegl1-mesa libasound2 libglib2.0-0 python libxcomposite-dev ca-certificates bzip2 wget less x11vnc xvfb libxcursor1 libnss3 libegl1-mesa libasound2 libglib2.0-0 python libxcomposite-dev libgl1-mesa-glx x11-xkb-utils \
            && useradd -m -d /home/container container

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
