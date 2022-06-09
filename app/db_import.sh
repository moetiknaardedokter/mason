#!/usr/bin/env bash

function db_import {
  echo 'Dumping DB';
  wp @live db dump --exclude_tables=$(wp @live db prefix)toolset_maps_address_cache - > dump.sql

  echo 'Importing DB';
  wp db import dump.sql
  # cleanup
  rm dump.sql
}