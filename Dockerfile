# ----------------------------------
# Holdfast: Nations at War Dockerfile
# Environment: Ubuntu:18.04 + Wine + Xvfb
# Minimum Panel Version: 0.7.9
# ----------------------------------
FROM        quay.io/parkervcp/pterodactyl-images:base_ubuntu

LABEL       author="Mason Rowe" maintainer="mason@rowe.sh"

# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt update \
            && apt upgrade -y \
            && apt install -y bsdtar xvfb --install-recommends wine64 lib32gcc1 libntlm0 winbind winetricks \
            && apt clean \
            && mkdir -p /tmp/.X11-unix \
            && chmod 1777 /tmp/.X11-unix \
            && chown root:root /tmp/.X11-unix \
            && winetricks sound=disabled

COPY        ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]