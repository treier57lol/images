# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Mono
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        frolvlad/alpine-mono

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

RUN         apk add --update --no-cache openssl curl sqlite \
            && adduser -D -h /home/container container

USER        container
ENV         HOME=/home/container USER=container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/ash", "/entrypoint.sh"]
