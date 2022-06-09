Preparation
===========

In the current folder there should be a `wp-cli.yml`
With the at least the `@live` alias:

```yaml
path: public_html/  # if the script is not run form the ABSPATH
@live:
  path: /var/www/exmaple.com/public_html
  ssh: user@exampl.com:123
```

Usage
=====

Just call the `/mason/mason` script. (currently) no options.