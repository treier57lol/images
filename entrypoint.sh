#!/bin/bash
cd /home/container
sleep 1

# Update Application
if [ ! -z ${SRCDS_APPID} ] && $AUTO_UPDATE; then
        if [ ! -z ${SRCDS_BETAID} ]; then
                if [ ! -z ${SRCDS_BETAPASS} ]; then
                        ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} -beta ${SRCDS_BETAID} -betapassword ${SRCDS_BETAPASS} +quit
                else
                        ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} -beta ${SRCDS_BETAID} +quit
                fi
        else
                ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} +quit
        fi
fi

Xvfb :0 -screen 0 1024x768x16 &

echo "First Wine launch will throw some errors. Ignore them"

mkdir .wine
echo "Installing Gecko"
wine msiexec /i /wine/gecko_x86.msi /qn /quiet /norestart /log .wine/gecko_x86_install.log
wine msiexec /i /wine/gecko_x86_64.msi /qn /quiet /norestart /log .wine/gecko_x86_64_inatall.log

echo "Installing mono"
wine msiexec /i /wine/mono.msi /qn /quiet /norestart /log .wine/mono_install.log

wine --version

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
