#!/usr/bin/env bash

function sync_files() {
  LIVE_SSH_SERVER=$(echo ${LIVE_SSH} | awk -F: '{print $1}')
  LIVE_SSH_PORT=$(echo ${LIVE_SSH} | awk -F: '{print $2}')
  PORT=''
  if [[ ! -z "${LIVE_SSH_PORT}" ]]; then
    # @link https://superuser.com/a/360986
    PORT="-e 'ssh -p ${LIVE_SSH_PORT}'"
  fi

  # Don't sync folders that have .git inside.
  # @see https://stackoverflow.com/a/54561526/933065
  # @see https://unix.stackexchange.com/a/333918/172853
  readarray -d '' EXCLUDES < <(find ${LOCAL_PATH} -type d -exec test -e '{}/.git' ';' -print0)

  # Never sync these folders.
  EXCLUDES+=('/wp-content/cache/')
  EXCLUDES+=('/wp-content/uploads/')
  EXCLUDES+=('/content/cache/')
  EXCLUDES+=('/content/uploads/')
  EXCLUDES+=('/phpmyadmin/')
  EXCLUDES+=('/wp-config.php')
  EXCLUDES+=('/.htaccess')

  for i in ${!EXCLUDES[@]}; do
    EXCLUDES[i]="${EXCLUDES[i]/"$LOCAL_PATH"/"/"}"
  done

  # Prefix the excludes for the argument.
  EXCLUDES=$(printf " --exclude=%s" "${EXCLUDES[@]}")

  eval "rsync ${PORT} ${LIVE_SSH_SERVER}:${LIVE_PATH} ${LOCAL_PATH} ${EXCLUDES} --delete -Pqavz"
}
