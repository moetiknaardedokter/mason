#!/usr/bin/env bash

function update_wp_config() {
  if wp config has FORCE_SSL_ADMIN --skip-plugins --skip-themes; then
    wp config set FORCE_SSL_ADMIN false --raw --skip-plugins --skip-themes
  fi
  wp config set table_prefix --type=variable $(wp @live config get table_prefix --type=variable) --skip-plugins --skip-themes
  wp config set DB_CHARSET $(wp @live config get DB_CHARSET) --skip-plugins --skip-themes
}
