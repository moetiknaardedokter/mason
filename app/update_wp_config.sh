#!/usr/bin/env bash

function update_wp_config() {
  wp config set FORCE_SSL_ADMIN false --raw --skip-plugins --skip-themes
  wp config set table_prefix --type=variable $(wp @live db prefix)
  wp config set DB_CHARSET $(wp @live config get DB_CHARSET)
}
