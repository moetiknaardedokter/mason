#!/usr/bin/env bash

function display_help_mssg() {
  echo -e "Mason WordPress sync ${SCRIPT_VERSION}-${SCRIPT_VERSION_NAME}"
  echo 'Sync a remote WordPress installation to a local environment over SSH.'
  echo 'Development: https://github.com/janw-me/mason'
  echo ''
  echo '-h, --help     Print this help message'
  echo '--db-only      Sync the DB but not WP-core/themes/plugins/etc.'
  echo "--files-only   Sync the files (WP-core/themes/plugins/etc) but don't sync the database."
  echo '--uploads      Sync the uploads, by default uploads do not get synced.'
  echo '               Works separate from the --db-only and --files-only flags.'
}
