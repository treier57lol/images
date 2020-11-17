FROM        debian:buster-slim

MAINTAINER  Terrahost <opensource@terrahost.cloud>
ENV         DEBIAN_FRONTEND noninteractive
ENV         USER_NAME container
ENV         NSS_WRAPPER_PASSWD /tmp/passwd 
ENV         NSS_WRAPPER_GROUP /tmp/group

# Install Dependencies
RUN         apt-get install -y --no-install-recommends --no-install-suggests \
            python3 \
            lib32stdc++6 \
            lib32gcc1 \
            wget \
            ca-certificates

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
