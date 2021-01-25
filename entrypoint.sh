#!/bin/bash

# File: Pterodactyl Arma 3 Image - entrypoint.sh
# Author: David Wolfe (Red-Thirten)
# Date: 1-25-21

# SteamCMD ID for the Arma 3 GAME (not server). Only used for Workshop mod downloads.
armaGameID=107410
# Color Codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

cd /home/container
sleep 1

# Define make mods lowercase function
ModsLowercase () {
	echo -e "\n${GREEN}STARTUP: Making mod $1 files/folders lowercase...${NC}"
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
if [[ ${UPDATE_SERVER} == "1" ]];
then
	echo -e "\nSTARTUP: Checking for updates to game server with App ID: ${STEAMCMD_APPID}...\n"
	if [[ -f ./steam.txt ]];
	then
		echo -e "\nSTARTUP: steam.txt found in root folder. Using to run SteamCMD script...\n"
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update ${STEAMCMD_APPID} ${STEAMCMD_EXTRA_FLAGS} validate +runscript /home/container/steam.txt
	else
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update ${STEAMCMD_APPID} ${STEAMCMD_EXTRA_FLAGS} validate +quit
	fi
	echo -e "\nSTARTUP: Game server update check complete!\n"
fi

# Download/Update specified Steam Workshop mods, if specified
if [[ -n ${UPDATE_WORKSHOP} ]];
then
	for i in $(echo -e ${UPDATE_WORKSHOP} | sed "s/,/ /g")
	do
		echo -e "\nSTARTUP: Downloading/Updating Steam Workshop mod ID: $i...\n"
		./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +workshop_download_item $armaGameID $i validate +quit
		# Move the downloaded mod to the root directory, and replace existing mod if needed
		mkdir -p ./@$i
		rm -rf ./@$i/*
		mv -f ./Steam/steamapps/workshop/content/$armaGameID/$i/* ./@$i
		rm -d ./Steam/steamapps/workshop/content/$armaGameID/$i
		# Make the mods contents all lowercase
		ModsLowercase @$i
		# Move any .bikey's to the keys directory
		echo -e "\nSTARTUP: Moving any mod .bikey files to the ~/keys/ folder...\n"
		find ./@$i -name "*.bikey" -type f -exec cp {} ./keys \;
	done
	echo -e "\nSTARTUP: Download/Update Steam Workshop mods complete!\n"
fi

# Make mods lowercase, if specified
if [[ ${MODS_LOWERCASE} == "1" ]];
then
	for i in $(echo ${MODS} | sed "s/;/ /g")
	do
		ModsLowercase $i
	done
	
	for i in $(echo ${SERVERMODS} | sed "s/;/ /g")
	do
		ModsLowercase $i
	done
fi

# Check if specified server binary exists
if [[ ! -f ./${SERVER_BINARY} ]];
then
	echo -e "\nSTARTUP_ERR: Specified server binary could not be found in files! Verify your Server Binary startup variable."
	exit 1
fi

# Check if basic.cfg exists, and download if not (Arma really doesn't like it missing for some reason)
if [[ -n ${BASIC} ]] && [[ ! -f ./${BASIC} ]];
then
	echo -e "\nSTARTUP: Specified Basic Network Configuration file \"${BASIC}\" is missing!"
	echo -e "\tDownloading default file for use instead...\n"
	curl -sSL https://raw.githubusercontent.com/parkervcp/eggs/master/steamcmd_servers/arma/arma3/egg-arma3-config/basic.cfg -o ./${BASIC}
fi

# Run preflight, if applicable
if [[ -f ./preflight.sh ]];
then
	echo -e "\nSTARTUP: preflight.sh found in root folder. Running preflight...\n"
	./preflight.sh
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo -e "\nSTARTUP: Starting server with the following startup command:"
echo -e "${MODIFIED_STARTUP}\n"

# $NSS_WRAPPER_PASSWD and $NSS_WRAPPER_GROUP have been set by the Dockerfile
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /passwd.template > ${NSS_WRAPPER_PASSWD}

if [[ ${SERVER_BINARY} == *"x64"* ]];
then
	export LD_PRELOAD=/libnss_wrapper_x64.so
else
	export LD_PRELOAD=/libnss_wrapper.so
fi

# Run the Server
${MODIFIED_STARTUP}

if [ $? -ne 0 ];
then
    echo -e "\nPTDL_CONTAINER_ERR: There was an error while attempting to run the start command.\n"
    exit 1
fi
