# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- **scripts/ldap_sync.sh**: LDAP user synchronization helper script for GLPI
- **cron.d/ldap.cron**: LDAP sync schedule every 10 minutes

## [1.1.0] - 2026-07-30

### Added
- **README.md**: Comprehensive project documentation with setup instructions, configuration guide, troubleshooting, and updated container naming/command examples
- **Dockerfile-http**: 
  - Apache modules configuration: `rewrite`, `headers`, `proxy_fcgi`, `setenvif`
  - PHP-FPM socket configuration via proxy_fcgi
  - PHP version variable usage for all PHP extensions
- **vhost-http.conf**: 
  - FilesMatch directive for PHP-FPM socket handler
  - Apache logging configuration (ErrorLog, CustomLog)

### Changed
- **Dockerfile-http**:
  - Explicit PHP version variable (`${PHP_VERSION}`) for all PHP dependencies
  - PHP-FPM configuration management (pool.d/www.conf)
  - Apache run user configuration improvements
  - Reordered RUN command for better module loading
  - Added `date.timezone` configuration in PHP-FPM php.ini via sed
- **vhost-http.conf**:
  - RewriteEngine enabled (changed from Off to On)
  - Complete VirtualHost configuration with logging

### Improved
- PHP-FPM to Apache2 integration via proxy_fcgi
- Rewrite rules for GLPI routing
- Production-ready logging configuration

## [1.0.0] - 2026-07-29

### Changed
- **Dockerfile-http**
  - Updated Ubuntu base image from `ubuntu:26.04` to `ubuntu:26.10` for latest security patches
  - Changed entrypoint permissions from `+x` to `755` for explicit permission setting
  - Added security hardening: removed `pebble` binary (`/usr/bin/pebble`)
  - Fixed HEALTHCHECK command formatting (proper line continuation)
  - Added WORKDIR directive pointing to `/var/www/html`

- **entrypoint.sh**
  - Changed PHP-FPM startup from `php-fpm -D` to `service php8.5-fpm start` for better service management
  - Added support for passing additional arguments to the entrypoint script with conditional execution
  - Improved script structure with proper argument handling

### Added
- Security improvements with removal of unnecessary binaries
- Better PHP-FPM service management through systemd

### Fixed
- Entrypoint script formatting and argument passing
- Docker HEALTHCHECK formatting and readability
