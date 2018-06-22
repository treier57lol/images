#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Update Server
if [ ! -z ${APPID} ]; then
  ./steam/steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +force_install_dir /home/container +app_update ${APPID} +quit
fi

#Mod updates
modids="1113901982 ,1416651472"
cleanmodids=$(echo $modids | tr -d ' ')
if [ ! -z $cleanmodids ]; then
  #Conan Exiles
  if [[ ${APPID} == "443030" ]]; then
    printf "Updating Conan Exiles mods\n"
    for i in $(echo $cleanmodids | sed "s/,/ /g")
    do
      printf "Updating Mod ID $i\n"
      ./steam/steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +force_install_dir /home/container +workshop_download_item 443030 $i +quit
    done
    printf "Mods updated\n"
    mkdir -p /home/container/ConanSandbox/Mods
  fi
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
