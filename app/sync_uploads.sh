#!/usr/bin/env bash

function sync_uploads() {
  LIVE_SSH_SERVER=$(echo ${LIVE_SSH} | awk -F: '{print $1}')
  LIVE_SSH_PORT=$(echo ${LIVE_SSH} | awk -F: '{print $2}')
  PORT=''
  if [[ ! -z "${LIVE_SSH_PORT}" ]]; then
    # @link https://superuser.com/a/360986
    PORT="-e 'ssh -p ${LIVE_SSH_PORT}'"
  fi

  LIVE_UPLOADS_DIR=$(wp @live eval 'echo wp_get_upload_dir()["basedir"];')
  LOCAL_UPLOADS_DIR=$(wp eval 'echo wp_get_upload_dir()["basedir"];')

  eval "rsync ${PORT} ${LIVE_SSH_SERVER}:${LIVE_UPLOADS_DIR%/}/ ${LOCAL_UPLOADS_DIR/}/ ${EXCLUDES} --delete -Pqavz"
}
