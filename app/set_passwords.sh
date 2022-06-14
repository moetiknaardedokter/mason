#!/usr/bin/env bash

function set_passwords() {
  echo 'Setting passwords to 123'
  wp db query "UPDATE $(wp db prefix --skip-plugins --skip-themes)users SET user_pass = MD5('123');" --skip-plugins --skip-themes
}
