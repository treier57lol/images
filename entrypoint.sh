#!/bin/bash
sleep 3

cd /home/container

export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

echo -e "The image the server is using is being deprecated and needs to be changes to `quay.io/parkervcp/pterodactyl-images:game_samp`"
echo -e "If you are renting the server and are seeing this message let your host know soon please."

sleep 15

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

${MODIFIED_STARTUP}
