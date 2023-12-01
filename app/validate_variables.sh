#!/usr/bin/env bash

function validate_variables() {
  echo -e "Syncing with the following variables:"
  echo -e ''
  echo -e "Live domainname:      ${C_GRN}${LIVE_URL}${C_OFF}"
  echo -e "Live ssh connection:  ${C_GRN}${LIVE_SSH}${C_OFF}"
  echo -e "Live path:            ${C_GRN}${LIVE_PATH}${C_OFF}"
  echo -e ''
  echo -e "Local domainname:     ${C_GRN}${LOCAL_URL}${C_OFF}"
  echo -e "Local path:           ${C_GRN}${LOCAL_PATH}${C_OFF}"

  if [[ $(jq -r '.mason .extra_domains' <<<"$WP_CLI_JSON") == "null" ]]; then
    echo -e "No extra domains found in wp-cli.yml file(s)."
  else
    echo -e "Extra domains found in wp-cli.yml file(s):"
    ORIGINAL_URL=($(jq -r '.mason .extra_domains | keys_unsorted[]' <<<"$WP_CLI_JSON"))
    NEW_URL=($(jq -r '.mason .extra_domains[]' <<<"$WP_CLI_JSON"))

    # Iterate over the keys and values
    for ((i=0; i<${#ORIGINAL_URL[@]}; i++)); do
      echo -e "  replacing ${C_GRN}${ORIGINAL_URL[i]}${C_OFF} with ${C_ORN}${NEW_URL[i]}${C_OFF}"
    done
    echo -e ''
  fi

  while true; do
    read -p "$(echo -e Are the connection details above correct? ${C_ORN}[y/N]${C_OFF}) " yn
    case $yn in
    [Yy]*)
      break
      ;; #yes, continue.
    *)
      echo -e "Check the ${C_ORN}wp-cli.yml${C_OFF} and that the local site is running."
      exit 1
      ;; # the user found an error.
    esac
  done
}
