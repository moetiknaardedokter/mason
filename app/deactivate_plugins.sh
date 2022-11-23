#!/usr/bin/env bash

function deactivate_plugins() {
  echo 'Deactivating plugins'
  wp plugin deactivate \
  all-in-one-wp-security-and-firewall\
  autoptimize\
  easy-wp-smtp\
  ithemes-security-pro\
  litespeed-cache\
  limit-login-attempts-reloaded\
  mailgun\
  mainwp-child\
  post-smtp\
  query-monitor\
  restricted-site-access\
  smtp-mailer\
  under-construction-page\
  worker\
  wordfence\
  wp-cerber\
  wp-fastest-cache\
  w3-total-cache\
  wp-mail-smtp\
  wp-offload-ses\
  wp-rocket\
  wp-ses\
  wp-super-cache\
  --skip-plugins --skip-themes
}
