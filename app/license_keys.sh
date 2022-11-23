#!/usr/bin/env bash

function license_keys() {
  echo 'Updating license keys'

  CONFIG_FILE="${LOCAL_PATH}wp-config.php"
  if [ -f "${LOCAL_PATH}../env-config.php" ]; then
    CONFIG_FILE="${LOCAL_PATH}../env-config.php"
  fi

  # Advanced Custom Fields
  ACF_KEY=$(wp @live config get ACF_PRO_LICENSE --skip-plugins --skip-themes)
  if [ ! -z "$ACF_KEY" ]; then
    wp config set ACF_PRO_LICENSE $ACF_KEY --skip-plugins --skip-themes --config-file=${CONFIG_FILE}
  fi


  # Google Maps API
  G_MAPS_KEY=$(wp @live config get GOOGLE_MAPS_KEY --skip-plugins --skip-themes)
  if [ ! -z "$G_MAPS_KEY" ]; then
    wp config set GOOGLE_MAPS_KEY $G_MAPS_KEY --skip-plugins --skip-themes --config-file=${CONFIG_FILE}
  fi

  echo 'Done updating license keys'
}
