
Usage
=====

In the current folder there should be a `wp-cli.yml`
With the at least the `@live` alias:

```yaml
path: public_html/  # if the script is not run from the ABSPATH
@live:
  path: /var/www/exmaple.com/public_html
  ssh: user@exampl.com:123
mason:
  extra_domains: 
    # will do extra search replaces for urls.
    www.example.com: local-domain.test
  extra_config:
    ACF_PRO_LICENSE:      "@SYNC" # will sync the value from the live environment.
    WP_DEBUG_DISPLAY:     true # will always set the debug display to true
    WP_ENVIRONMENT_TYPE:  "development" # For stings quotes are required.
```

Just call the `/mason/mason` This will do the following:
 
- Rsyncs WP-core, themes, plugins and mu-plugins.
- Imports the live DB
- Replaces the url
- Deactivates some plugins in regard to caching, smtp-email, security, resticted access, manage-wp.
- set all user passwords to 123,

Options
-------

 - `-h, --help` Print the help message'
 - `--db-only` Sync the DB but not WP-core/themes/plugins/etc.'
 - `--files-only` Sync the files (WP-core/themes/plugins/etc) but don't sync the database.
 - `--uploads` Sync the uploads, by default uploads do not get synced.' Works separate from the --db-only and --files-only flags.'

Examples.

 - `/mason/mason` Will sync the DB and main files.
 - `/mason/mason --files-only` Syncs WP-core, themes, plugins and mu-plugins, that's all.
 - `/mason/mason --db-only` Syncs the Database, but no files.
 - `/mason/mason --uploads` Will sync all of the above, including the upload files.
