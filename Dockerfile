# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: glibc
# Minimum Panel Version: 0.7.0
# ----------------------------------
FROM        alpine:latest

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

RUN         adduser -D -h /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/ash", "/entrypoint.sh"]