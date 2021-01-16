#!/bin/bash

# SteamCMD ID for the Arma 3 GAME (not server). Only used for Workshop mod downloads.
armaGameID=107410

cd /home/container
sleep 1

# Define make mods lowercase function
ModsLowercase () {
	echo -e "\nSTARTUP: Making mod $1 files/folders lowercase..."
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
	echo -e "\nSTARTUP: Checking for updates to game server with App ID: ${STEAMCMD_APPID}...\n"
	if [ -f ./steam.txt ]
	then
		echo -e "\nSTARTUP: steam.txt found in root folder! Using to run SteamCMD script...\n"
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update ${STEAMCMD_APPID} ${STEAMCMD_EXTRA_FLAGS} validate +runscript /home/container/steam.txt
	else
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update ${STEAMCMD_APPID} ${STEAMCMD_EXTRA_FLAGS} validate +quit
	fi
	echo -e "\nSTARTUP: Game server update check complete!\n"
fi

# Download/Update specified Steam Workshop mods, if specified
if [ ${UPDATE_WORKSHOP} != "" ]
then
	for i in $(echo -e ${UPDATE_WORKSHOP} | sed "s/,/ /g")
	do
		echo -e "\nSTARTUP: Downloading/Updating Steam Workshop mod ID: $i...\n"
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +workshop_download_item $armaGameID $i validate +quit
		mkdir -p ./@$i
		rm -rf ./@$i/*
		mv -f ./Steam/steamapps/workshop/content/$armaGameID/$i/* ./@$i
		rm -d ./Steam/steamapps/workshop/content/$armaGameID/$i
		ModsLowercase @$i
	done
fi

# Make mods lowercase, if specified
if [ ${MODS_LOWERCASE} == "1" ]
then
	for i in $(echo -e ${MODS} | sed "s/;/ /g")
	do
		ModsLowercase $i
	done
	
	for i in $(echo -e ${SERVERMODS} | sed "s/;/ /g")
	do
		ModsLowercase $i
	done
fi

# Run preflight, if applicable
if [ -f ./preflight.sh ]
then
	echo -e "\nSTARTUP: preflight.sh found in root folder! Running preflight...\n"
	./preflight.sh
fi

# Check if specified server binary exists
if [ ! -f ./${SERVER_BINARY} ]
then
	echo -e "\nSTARTUP_ERR: Specified server binary could not be found in files! Verify your Server Binary startup variable."
	exit 1
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo -e $(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo -e "\nSTARTUP: Starting server with the following startup command:"
echo -e "${MODIFIED_STARTUP}\n"

# $NSS_WRAPPER_PASSWD and $NSS_WRAPPER_GROUP have been set by the Dockerfile
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /passwd.template > ${NSS_WRAPPER_PASSWD}
export LD_PRELOAD=/libnss_wrapper.so

# Run the Server
${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo -e "\nPTDL_CONTAINER_ERR: There was an error while attempting to run the start command.\n"
    exit 1
fi
