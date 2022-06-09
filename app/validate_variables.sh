#!/usr/bin/env bash

function validate_variables {
  echo -e "Syncing with the following variables:"
  echo -e ''
  echo -e "Live domainname:      ${C_GRN}${LIVE_URL}${C_OFF}"
  echo -e "Live ssh connection:  ${C_GRN}${LIVE_SSH}${C_OFF}"
  echo -e "Live path:            ${C_GRN}${LIVE_PATH}${C_OFF}"
  echo -e ''
  echo -e "Local domainname:     ${C_GRN}${LOCAL_URL}${C_OFF}"
  echo -e "Local path:           ${C_GRN}${LOCAL_PATH}${C_OFF}"

  while true; do
      read -p "$( echo -e Are the connection details above correct? ${C_ORN}[y/N]${C_OFF}) " yn
      case $yn in
          [Yy]* )
            break;; #yes, continue.
          * )
            echo -e "Check the ${C_ORN}wp-cli.yml${C_OFF} and that the local site is running."
            exit 1;; # the user found an error.
      esac
  done

  echo -e 'Validation remote connection...'
  wp @live db check &> /dev/null
  if [[ $? -ne 0 ]]; then
      echo -e "${C_RED}Error:${C_OFF} can't connect to the live database"
      wp @live db check
      exit 1;
  fi
  echo -e 'Validation local connection...'
  wp db check &> /dev/null
  if [[ $? -ne 0 ]]; then
      echo -e "${C_RED}Error:${C_OFF} can't connect to the local database"
      wp db check
      exit 1;
  fi
  echo -e "All ${C_GRN}valid! :)${C_OFF}"
}