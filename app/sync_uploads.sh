#!/usr/bin/env bash

function sync_uploads {
   LIVE_SSH_SERVER=$( echo ${LIVE_SSH} | awk -F: '{print $1}' )
    LIVE_SSH_PORT=$( echo ${LIVE_SSH} | awk -F: '{print $2}' )
    PORT=()
    if [[ ! -z "${LIVE_SSH_PORT}"  ]]; then
      # @link https://superuser.com/a/360986
      PORT=(-e "ssh -p ${LIVE_SSH_PORT}")
    fi

    rsync "${PORT[@]}" ${LIVE_SSH_SERVER}:${LIVE_PATH}wp-content/uploads/ ${LOCAL_PATH}wp-content/uploads/ -Pavz
}