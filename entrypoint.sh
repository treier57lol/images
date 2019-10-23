#!/bin/bash
cd /home/container
sleep 1

# Update Application
if [ ! -z ${APPID} ]; then
    if [ ! -z ${BETAID} ]; then
        if [ ! -z ${BETAPASS} ]; then
            ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${APPID} -beta ${BETAID} -betapassword ${BETAPASS} +quit
        else
            ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${APPID} -beta ${BETAID} +quit
        fi
    else
        ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${APPID} +quit
    fi
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
