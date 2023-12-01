#!/usr/bin/env bash

function deactivate_plugins() {
  echo 'Deactivating plugins'

  declare -a plugins=(
    all-in-one-wp-security-and-firewall
    autoptimize
    better-wp-security
    coming-soon
    easy-wp-smtp
    fluent-smtp
    ithemes-security-pro
    litespeed-cache
    limit-login-attempts-reloaded
    mailgun
    mainwp-child
    post-smtp
    query-monitor
    restricted-site-access
    smtp-mailer
    sparkpost
    under-construction-page
    w3-total-cache
    worker
    wordfence
    wp-cerber
    wp-fastest-cache
    wp-mail-smtp
    wp-offload-ses
    wp-rocket
    wp-ses
    wp-staging-pro
    wp-super-cache
  )

  PLUGIN_LIST=''
  for plugin in "${plugins[@]}"; do
    PLUGIN_LIST+=" $plugin"
  done

  if ! wp core is-installed --network; then
      wp plugin deactivate ${PLUGIN_LIST} --skip-plugins --skip-themes
      return; # don't check further.
  fi

  wp plugin deactivate ${PLUGIN_LIST} --skip-plugins --skip-themes --network
  # loop over all sites.
  for site in $(wp site list --field=url --format=csv); do
    wp plugin deactivate ${PLUGIN_LIST} --skip-plugins --skip-themes --url=$site
  done
}
