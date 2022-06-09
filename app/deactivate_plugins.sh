#!/usr/bin/env bash

function deactivate_plugins {
  echo 'Deactivating plugins';
  wp plugin deactivate --skip-plugins --skip-themes wp-rocket wp-ses restricted-site-access litespeed-cache ithemes-security-pro smtp-mailer post-smtp worker wp-cerber
}