#!/usr/bin/env bash

function update_wp_config() {
  #DB prefix is done in the replace_url.sh

  if wp config has FORCE_SSL_ADMIN --skip-plugins --skip-themes; then
    wp config set FORCE_SSL_ADMIN false --raw --skip-plugins --skip-themes
  fi

  ############################################################
  # Sync multisite constants
  ############################################################
  if wp @live config has WP_ALLOW_MULTISITE --skip-plugins --skip-themes; then
    WP_ALLOW_MULTISITE=$(wp @live config get WP_ALLOW_MULTISITE --skip-plugins --skip-themes)
    WP_ALLOW_MULTISITE=$( [ "$WP_ALLOW_MULTISITE" == '1' ] && echo true || echo false )

    wp config set WP_ALLOW_MULTISITE $WP_ALLOW_MULTISITE --skip-plugins --skip-themes --raw
  fi
  if wp @live config has MULTISITE --skip-plugins --skip-themes; then
    MULTISITE=$(wp @live config get MULTISITE --skip-plugins --skip-themes)
    MULTISITE=$( [ "$MULTISITE" == '1' ] && echo true || echo false )
    wp config set MULTISITE $MULTISITE --skip-plugins --skip-themes --raw
  fi
  if wp @live config has SUBDOMAIN_INSTALL --skip-plugins --skip-themes; then
    SUBDOMAIN_INSTALL=$(wp @live config get SUBDOMAIN_INSTALL --skip-plugins --skip-themes)
    SUBDOMAIN_INSTALL=$( [ "$SUBDOMAIN_INSTALL" == '1' ] && echo true || echo false )
    wp config set SUBDOMAIN_INSTALL $SUBDOMAIN_INSTALL --skip-plugins --skip-themes --raw
  fi
  if wp @live config has PATH_CURRENT_SITE --skip-plugins --skip-themes; then
    wp config set PATH_CURRENT_SITE $(wp @live config get PATH_CURRENT_SITE --skip-plugins --skip-themes) --skip-plugins --skip-themes
  fi
  if wp @live config has SITE_ID_CURRENT_SITE --skip-plugins --skip-themes; then
    wp config set SITE_ID_CURRENT_SITE $(wp @live config get SITE_ID_CURRENT_SITE --skip-plugins --skip-themes) --skip-plugins --skip-themes --raw
  fi
  if wp @live config has BLOG_ID_CURRENT_SITE --skip-plugins --skip-themes; then
    wp config set BLOG_ID_CURRENT_SITE $(wp @live config get BLOG_ID_CURRENT_SITE --skip-plugins --skip-themes) --skip-plugins --skip-themes --raw
  fi
  if wp @live config has DOMAIN_CURRENT_SITE --skip-plugins --skip-themes; then
    # replace the domain with the local domain
    PREFIX=$(wp db prefix --skip-plugins --skip-themes)
    SITE_ID=$(wp config get SITE_ID_CURRENT_SITE --skip-plugins --skip-themes)
    BLOG_ID=$(wp config get BLOG_ID_CURRENT_SITE --skip-plugins --skip-themes)
    DOMAIN_CURRENT_SITE=$(wp db query "SELECT domain FROM ${PREFIX}blogs WHERE blog_id = ${BLOG_ID} AND site_id = ${SITE_ID}" --skip-plugins --skip-themes --skip-column-names)
    wp config set DOMAIN_CURRENT_SITE $DOMAIN_CURRENT_SITE --skip-plugins --skip-themes
  fi

  ############################################################
  # Set extra config variables and constants
  ############################################################
  if [[ $(jq -r '.mason .extra_config' <<<"$WP_CLI_JSON") != "null" ]]; then
    # Extract the keys and values from the extra_config object
    VARS_CONSTS=($(jq -r '.mason .extra_config | keys_unsorted[]' <<<"$WP_CLI_JSON"))
    VALUES=($(jq '.mason .extra_config[]' <<<"$WP_CLI_JSON"))

    # Iterate over the keys and values
    for ((i=0; i<${#VARS_CONSTS[@]}; i++)); do
      echo -e "Setting  ${C_GRN}${VARS_CONSTS[i]}${C_OFF} to ${C_ORN}${VALUES[i]}${C_OFF}"

      # Const or var?
      if [[ ${VARS_CONSTS[i]} == \$* ]]; then
        TYPE="--type=variable"
        KEY="${VARS_CONSTS[i]:1}"  # Remove the leading dollar sign
      else
        TYPE="--type=constant"
        KEY="${VARS_CONSTS[i]}"
      fi

      if [[ "${VALUES[i]}" == '"@SYNC"' ]]; then
        # Try to get the value from the live site.
        if ( wp @live config has ${KEY} --skip-plugins --skip-themes ); then
          SYNC_VALUE=$(wp @live config get ${KEY} --skip-plugins --skip-themes --format=json ${TYPE})
          wp config set ${KEY} "${SYNC_VALUE}" --skip-plugins --skip-themes --raw ${TYPE}
        else
          echo -e "${C_RED}ERROR: ${C_OFF} ${C_GRN}${KEY}${C_OFF} is empty on live site."
        fi
      else
        # Flat sync from wp-cli.yml
        wp config set ${KEY} "${VALUES[i]}" --skip-plugins --skip-themes --raw ${TYPE}
      fi
    done
  fi
}
