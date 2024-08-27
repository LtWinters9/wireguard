#!/bin/bash

set -e

# -------------------------------------------
# Ensure we are running the updater  as root
# -------------------------------------------
if [[ $EUID -ne 0 ]]; then
  echo "  Aborting because you are not root" ; exit 1
fi

cat <<EOF
  
  -----------------------------------------------------------------
  This script updates wireguard container
  -----------------------------------------------------------------
EOF

# -------------------------------------------
# Vars
# -------------------------------------------
SMTP_TO=""
SMTP_FROM=""
SMTP_SERVER=""
SMTP_USER=""
SMTP_AUTH=''

########################
# functions start here #
########################

function start_script {
echo "Starting Script."
echo "Stopping wg container.."
docker stop wg-easy
docker rm wg-easy
echo "Updating wg container..."
docker pull ghcr.io/wg-easy/wg-easy
clear
}

function end_script {
sleep 1
echo "Prepare wg setup..."
cd #
cd home/scripts/wg
./install.sh
}

if start_script
then
 end_script
echo Finished updating - ${HN}
 exit 0
else
 echo " Script failed - sending email"
 swaks --to ${SMTP_TO} --from ${SMTP_FROM} --server ${SMTP_SERVER} --auth-user ${SMTP_USER} --auth-password ${SMTP_AUTH} --body "failed to update on $(date '+%Y-%m-%d')" --header 'Subject: UPDATE FAILED' ; exit 1
fi
