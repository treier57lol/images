# ----------------------------------
# Environment: ubuntu
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM        quay.io/parkervcp/pterodactyl-images:base_debian

LABEL       author="Dex's Lab" maintainer="dex35803@gmail.com"

ENV         DEBIAN_FRONTEND noninteractive

RUN         apt update -y \
    && apt upgrade \
    && apt install -y apt-transport-https \
    && wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt update -y \
    && apt install -y dotnet-sdk-3.1


USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
