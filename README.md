# Docker-GLPI

A Docker container for **GLPI** (Gestionnaire Libre de Parc Informatique) - An open-source IT and asset management system.

## 🎯 Overview

This project provides a containerized environment for running GLPI with Apache2, PHP-FPM, and Cron support. It's built on Ubuntu 26.10 with PHP 8.5 for optimal performance and security.

**GLPI** is a free, open-source web application designed to manage IT assets and IT service management. It allows organizations to track computers, printers, network devices, and software licenses efficiently.

## 📋 Features

- ✅ GLPI v11.0.8 pre-configured
- ✅ Apache2 web server with PHP-FPM 8.5
- ✅ `date.timezone` configured automatically from `TZ`
- ✅ Apache modules enabled: `rewrite`, `headers`, `proxy_fcgi`, `setenvif`
- ✅ PHP-FPM pool configured for `web` user and socket proxy
- ✅ Cron job support for GLPI scheduled tasks
- ✅ Health checks included
- ✅ Security hardening (removal of unnecessary binaries)
- ✅ Production-ready configuration

## 🔧 Prerequisites

- Docker
- Docker Compose (optional, for easier orchestration)
- At least 2GB of RAM
- Port 80 available (HTTP)

## 🚀 Quick Start

### Using Docker CLI (One-liner)

```bash
# Create networks and volumes first
docker network create net-proxy-glpi-prod
docker network create net-bdd-glpi-prod
docker volume create glpi-prod-data
docker volume create glpi-prod-conf
docker volume create glpi-prod-log

# Build and run the container
docker run -d \
  --name glpi-prod \
  --restart always \
  --network net-proxy-glpi-prod \
  --network net-bdd-glpi-prod \
  -v glpi-prod-data:/var/lib/glpi \
  -v glpi-prod-conf:/etc/glpi \
  -v glpi-prod-log:/var/log/glpi \
  -v $(pwd)/vhost-http.conf:/etc/apache2/sites-available/000-default.conf:ro \
  antoine/glpi:11.0.8
```

### Using Docker Compose (Recommended)

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  glpi-prod:
    image: 'antoine/glpi:11.0.8'
    container_name: glpi-prod
    restart: always
    networks:
      - net-proxy-glpi-prod
      - net-bdd-glpi-prod
    volumes:
      - glpi-prod-data:/var/lib/glpi
      - glpi-prod-conf:/etc/glpi
      - glpi-prod-log:/var/log/glpi
      - ./vhost-http.conf:/etc/apache2/sites-available/000-default.conf:ro

networks:
  net-proxy-glpi-prod:
    driver: bridge
  net-bdd-glpi-prod:
    driver: bridge

volumes:
  glpi-prod-data:
  glpi-prod-conf:
  glpi-prod-log:
```

Then start the container:

```bash
docker-compose up -d
```

## 📁 Project Structure

```
Docker-GLPI/
├── Dockerfile-http          # Main Dockerfile for HTTP deployment
├── entrypoint.sh           # Container initialization script
├── glpi-cron               # Cron job configuration for GLPI
├── vhost-http.conf         # Apache virtual host configuration
├── glpi-files/
│   ├── downstream.php      # GLPI downstream configuration
│   └── local_define.php    # GLPI local definitions
├── CHANGELOG.md            # Version history
├── LICENSE                 # Project license
└── README.md              # This file
```

## 🔐 Configuration

### Environment Variables

The following environment variables are configured by default:

| Variable | Value | Description |
|----------|-------|-------------|
| `TZ` | `Europe/Paris` | Timezone setting |
| `WEB_USER` | `web` | Web server user |
| `GLPI_VERSION` | `11.0.8` | GLPI version |
| `PHP_VERSION` | `8.5` | PHP version |

You can override these when building or running the container.

### Volume Mounts

It's recommended to mount the following directories for data persistence:

```bash
-v glpi-prod-data:/var/lib/glpi      # GLPI files and uploads
-v glpi-prod-conf:/etc/glpi          # Configuration files and local definitions
-v glpi-prod-log:/var/log/glpi       # Application logs
-v glpi_db:/var/lib/mysql             # Database (if using MariaDB container)
```

### Port Mapping

- **80** (HTTP): Web interface

For HTTPS support, use a reverse proxy (nginx, Traefik) or map port 443.

## 🛠️ Services

The container automatically starts the following services:

1. **Cron** - For scheduled tasks (backups, mailgate, etc.)
2. **PHP-FPM** - FastCGI Process Manager
3. **Apache2** - Web server

## ✅ Health Check

The container includes a health check that verifies GLPI is responding:

```
--interval=30s --timeout=10s --start-period=60s --retries=3
```

Check container status:
```bash
docker ps  # Look for "healthy" status
docker exec glpi-prod curl -fsS http://localhost/index.php
```

## 📝 First Time Setup

1. Open `http://localhost` in your browser
2. Follow the GLPI installation wizard
3. Configure the database connection
4. Set administrator credentials
5. Complete the initial setup

> ⚠️ **Important**: Change default credentials immediately after installation.

## 🔄 Cron Jobs

GLPI requires cron to run background tasks. The container includes a pre-configured cron job:

**File**: `glpi-cron`

The cron schedule is automatically loaded at container startup. Verify it's running:

```bash
docker exec glpi crontab -l
```

## 🐛 Troubleshooting

### Container won't start
```bash
docker logs glpi
```

### Permission issues
Ensure the volumes have proper permissions:
```bash
docker exec glpi-prod ls -la /var/lib/glpi/files
```

### PHP errors
Check the Apache error logs:
```bash
docker exec glpi tail -f /var/log/apache2/error.log
```

### GLPI not responding
Verify the health check:
```bash
docker exec glpi curl -v http://localhost/index.php
```

## 📚 Additional Resources

- [GLPI Official Documentation](https://glpi.readthedocs.io/)
- [GLPI GitHub Repository](https://github.com/glpi-project/glpi)
- [Docker Documentation](https://docs.docker.com/)

## 📄 License

This project is licensed under the LICENSE file included in the repository.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📞 Support

For issues and questions:
1. Check the [CHANGELOG.md](CHANGELOG.md) for recent updates
2. Review [troubleshooting](#-troubleshooting) section
3. Open an issue on GitHub

---

**Last Updated**: July 30, 2026  
**Version**: 1.1.0  
**GLPI Version**: 11.0.8
