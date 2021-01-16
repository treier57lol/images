#!/bin/bash

# SteamCMD ID for the Arma 3 GAME (not server). Only used for Workshop mod downloads.
armaGameID=107410

cd /home/container
sleep 1

# Define make mods lowercase function
ModsLowercase () {
	echo "STARTUP: Making mod ID $1 files/folders lowercase..."
	for SRC in `find ./$1 -depth`
	do
		DST=`dirname "${SRC}"`/`basename "${SRC}" | tr '[A-Z]' '[a-z]'`
		if [ "${SRC}" != "${DST}" ]
		then
			[ ! -e "${DST}" ] && mv -T "${SRC}" "${DST}"
		fi
	done
}

# Update dedicated server, if specified
if [ ${UPDATE_SERVER} == "1" ]
then
	echo "STARTUP: Checking for updates to game server with App ID: ${STEAMCMD_APPID}..."
	if [ -f ./steam.txt ]
	then
		echo "STARTUP: steam.txt found in root folder! Using to run SteamCMD script..."
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update ${STEAMCMD_APPID} ${STEAMCMD_EXTRA_FLAGS} validate +runscript /home/container/steam.txt
	else
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update ${STEAMCMD_APPID} ${STEAMCMD_EXTRA_FLAGS} validate +quit
	fi
	echo "STARTUP: Game server update check complete!"
fi

# Download/Update specified Steam Workshop mods, if specified
if [ ${UPDATE_WORKSHOP} != "" ]
then
	for i in $(echo ${UPDATE_WORKSHOP} | sed "s/,/ /g")
	do
		echo "STARTUP: Downloading/Updating Steam Workshop mod ID: $i..."
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +workshop_download_item $armaGameID $i validate +quit
		ln -s ./steamapps/workshop/content/$armaGameID/$i ./@$i
		ModsLowercase @$i
	done
fi

# Make mods lowercase, if specified
if [ ${MODS_LOWERCASE} == "1" ]
then
	for i in $(echo ${MODS} | sed "s/;/ /g")
		ModsLowercase $i
	do
	
	for i in $(echo ${SERVERMODS} | sed "s/;/ /g")
		ModsLowercase $i
	do
fi

# Run preflight, if applicable
if [ -f ./preflight.sh ]
then
	echo "STARTUP: preflight.sh found in root folder! Running preflight..."
	./preflight.sh
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo "STARTUP: Starting server with the following startup command:"
echo "${MODIFIED_STARTUP}"

# $NSS_WRAPPER_PASSWD and $NSS_WRAPPER_GROUP have been set by the Dockerfile
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /passwd.template > ${NSS_WRAPPER_PASSWD}
export LD_PRELOAD=/libnss_wrapper.so

# Run the Server
${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo "PTDL_CONTAINER_ERR: There was an error while attempting to run the start command."
    exit 1
fi
