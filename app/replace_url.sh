#!/usr/bin/env bash

function replace_url() {
  # we need the prefix to be the same, before we can do a search-replace.
  wp config set table_prefix --type=variable $(wp @live config get table_prefix --type=variable --skip-plugins --skip-themes) --skip-plugins --skip-themes
  wp config set DB_CHARSET $(wp @live config get DB_CHARSET) --skip-plugins --skip-themes

  echo -e "replacing main URL ${C_GRN}${LIVE_URL}${C_OFF} with ${C_ORN}${LOCAL_URL}${C_OFF}"
  wp search-replace --all-tables --report-changed-only "${LIVE_URL}" "${LOCAL_URL}"
  wp search-replace --all-tables --report-changed-only "https://${LOCAL_URL}" "http://${LOCAL_URL}"

  if [[ $(jq -r '.mason .extra_domains' <<<"$WP_CLI_JSON") != "null" ]]; then
    # Extract the keys and values from the extra_domains object
    ORIGINAL_URL=($(jq -r '.mason .extra_domains | keys_unsorted[]' <<<"$WP_CLI_JSON"))
    NEW_URL=($(jq -r '.mason .extra_domains[]' <<<"$WP_CLI_JSON"))

    # Iterate over the keys and values
    for ((i=0; i<${#ORIGINAL_URL[@]}; i++)); do
      echo -e "replacing ${C_GRN}${ORIGINAL_URL[i]}${C_OFF} with ${C_ORN}${NEW_URL[i]}${C_OFF}"
      wp search-replace --all-tables --report-changed-only "${ORIGINAL_URL[i]}" "${NEW_URL[i]}"
      wp search-replace --all-tables --report-changed-only "https://${NEW_URL[i]}" "http://${NEW_URL[i]}"
    done
  fi
}
