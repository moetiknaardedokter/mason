#!/usr/bin/env bash

function update_wp_config() {
  if wp config has FORCE_SSL_ADMIN --skip-plugins --skip-themes; then
    wp config set FORCE_SSL_ADMIN false --raw --skip-plugins --skip-themes
  fi
  wp config set table_prefix --type=variable $(wp @live config get table_prefix --type=variable --skip-plugins --skip-themes) --skip-plugins --skip-themes
  wp config set DB_CHARSET $(wp @live config get DB_CHARSET) --skip-plugins --skip-themes

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
  # Extra constants.
  ############################################################
}
