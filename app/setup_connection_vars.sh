#!/usr/bin/env bash

function setup_connection_vars() {
  wp cli alias get @live &>/dev/null
  if [[ $? -eq 1 ]]; then
    echo -e "${C_RED}Error:${C_OFF} can't find alias @live, check your ${C_ORN}wp-cli.yml${C_OFF} file"
    exit
  fi

  # locate yml.
  WP_CLI_JSON=$(wp eval --skip-wordpress 'echo json_encode( Spyc::YAMLLoad( WP_CLI::get_runner()->project_config_path ) );')

  ###############################
  # Get all @live vars
  ###############################
  LIVE_SSH=$(jq -r '.["@live"] .ssh' <<<"$WP_CLI_JSON")

  LIVE_PATH=$(jq -r '.["@live"] .path' <<<"$WP_CLI_JSON")

  LIVE_URL=$(jq -r '.["@live"] .url' <<<"$WP_CLI_JSON")
  if [[ "$LIVE_URL" == "null" ]]; then
    LIVE_URL=$(wp @live option get home --skip-plugins --skip-themes)
  fi
  LIVE_URL=$(basename $LIVE_URL)
  
  ###############################
  # Set all local vars
  ###############################
  LOCAL_URL=$(jq -r '.url' <<<"$WP_CLI_JSON")
  if [[ "$LOCAL_URL" == "null" ]]; then
    LOCAL_URL=$(wp option get home --skip-plugins --skip-themes)
  fi
  LOCAL_URL=$(basename $LOCAL_URL)
  
  LOCAL_PATH=$(jq -r '.path' <<<"$WP_CLI_JSON")
  if [[ "$LOCAL_URL" == "null" ]]; then
    LOCAL_PATH=$(wp eval 'echo ABSPATH;' --skip-plugins --skip-themes)
  fi
  if [[ ! "$LOCAL_PATH" =~ ^/ ]]; then
    LOCAL_PATH="$WORKING_PATH/$LOCAL_PATH"
  fi

  #force Trailing slash
  LIVE_PATH=${LIVE_PATH/\/wp\//\/}
  LOCAL_PATH=${LOCAL_PATH/\/wp\//\/}
  LIVE_PATH=${LIVE_PATH/\/wp/\/}
  LOCAL_PATH=${LOCAL_PATH/\/wp/\/}
  LIVE_PATH=${LIVE_PATH%/}/
  LOCAL_PATH=${LOCAL_PATH%/}/
}
