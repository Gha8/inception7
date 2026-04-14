# Developer Documentation — Inception

This document explains how to set up, build, run, and manage the project from a developer's perspective.

---

## Project Overview

The project is a multi-container Docker infrastructure managed with Docker Compose and a Makefile. The three core services are:

- **Nginx** — TLS-only reverse proxy (entry point on port 443)
- **WordPress + PHP-FPM** — Application layer (communicates with Nginx via port 9000)
- **Mariadb** — Database layer (communicates with WordPress via port 3306)

All containers are built from custom Dockerfiles based on **Debian Bullseye**. No pre-built images from DockerHub are used (except the base Debian/Alpine image).

---

## Directory Structure

```
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
│   ├── credentials.txt 
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        |── mariadb/
        |   ├── Dockerfile
        |   ├── conf/
        |   └── tools/
        |
        └── bonus/
            ├── Adminer/
            |   ├── Dockerfile
            |   └── tools/ 
            |       └── adminer.php
            |   
            └── static_website/
                ├── Dockerfile
                └── Ghaith_CV/
                    ├── index.html
                    └── style.css
```

---

## Setting Up the Environment from Scratch

### 1. Prerequisites

Make sure the following are installed on your Virtual Machine:

```bash
docker --version
docker compose version v2 
make --version
```

### 2. Configure the Domain Name

Add an entry to `/etc/hosts` on your host machine (or VM) so the domain resolves locally:

```bash
sudo nano /etc/hosts
```

Add the following line:

```
localhost    gmohamed.42.fr
```

Verify it works:
```bash
ping gmohamed.42.fr
```

### 3. Create the Secrets Files

Create the `secrets/` directory at the project root and populate each file with your chosen credentials:

```bash
mkdir -p secrets

echo "your_wp_admin_password" > secrets/credentials.txt
echo "your_db_user_password"  > secrets/db_password.txt
echo "your_db_root_password"  > secrets/db_root_password.txt
```

> ⚠️ These files must **never** be committed to Git. Confirm `.gitignore` excludes them.

### 4. Create the `.env` File

Create `srcs/.env` with the following variables (fill in your values):

```env
# Domain
DOMAIN_NAME=gmohamed.42.fr

# MariaDB
SQL_DATABASE=inception
SQL_USER=sqluserexemple
SQL_PASSWORD_FILE=/run/secrets/SQL_PASSWORD
SQL_ROOT_PASSWORD_FILE=/run/secrets/SQL_ROOT_PASSWORD

# WordPress
ADMIN_USER=admineofthesite
ADMIN_EMAIL=admin@42.fr
SITE_TITLE=Inception_site
USER_NAME=invite
USER_EMAIL=invite@42.fr
```

> The `_FILE` variables point to Docker secrets mounted at runtime inside `/run/secrets/`.

---

## Building and Launching the Project

### Build and start all services:
```bash
make
```

This runs `docker compose up -d --build`

### Start without rebuilding:
```bash
make up
```

### Stop all containers (data preserved):
```bash
make down
```

### Rebuild everything from scratch (wipes all data):
```bash
make fclean
make
```

---

## Managing Containers and Volumes

### View running containers:
```bash
docker ps
```

### View logs for a service:
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Open a shell inside a container:
```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

### List all Docker volumes:
```bash
docker volume ls
```

### Inspect a volume:
```bash

docker volume inspect <volume>
```

### Force remove all volumes (⚠️ destroys all data):
```bash
docker volume rm <volume>
```

---

## Data Persistence

Both named volumes store their data on the host machine at:

```
/home/gmohamed/data/
├── mariadb/
└── wordpress/
```


These directories persist across `make down` / `make up` cycles. Data is only lost when volumes are explicitly removed (e.g., `make fclean`).

**How it works in `docker-compose.yml`:**

```yaml
volumes:
  mariadb_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/gmohamed/data/mariadb

  wordpress:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/gmohamed/data/wordpress
```

> Bind mounts are used here only for the volume backing path — the volumes themselves are declared as **named volumes** in Docker Compose, satisfying the project requirement. Direct bind mount entries in the `services:` section are not used.

---

## SSL / TLS

Nginx uses a **self-signed certificate** generated with OpenSSL during the image build. The certificate is stored inside the Nginx container at:

```
/etc/nginx/ssl/gmohamed.crt
/etc/nginx/ssl/gmohamed.key
```

Only the versions **TLSv1.2** and **TLSv1.3** are accepted. HTTP is rejected , and only  port 443 is the only accepted entry point.

---

## WordPress Database Users

The MariaDB database contains two WordPress users as required:

| Role | Username | Notes |
|---|---|---|
| Administrator | Defined in `srcs/.env` | Username must not contain "admin" or "administrator" |
| Regular user | Created during WP-CLI setup (invite) | Standard subscriber or editor role |

---

## Troubleshooting

**Containers not starting:**
```bash
docker compose -f srcs/docker-compose.yml logs
```

**WordPress can't connect to the database:**
- Confirm `mariadb` container is running: `docker ps`
- Check that `SQL_DATABASE`, `SQL_USER`, and passwords match between `.env` and MariaDB init scripts
- Check MariaDB logs: `docker logs mariadb`

**Nginx returns a 502 Bad Gateway:**
- WordPress/PHP-FPM may not be ready yet so wait a few seconds and retry
- Check: `docker logs wordpress`

**Self-signed certificate warning in browser:**
- This is expected. Click "Advanced" → "Accept the Risk and Continue".
