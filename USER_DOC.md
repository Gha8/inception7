# User Documentation — Inception

This document explains how to use, access, and manage the Inception infrastructure as an end user or administrator.

---

## What Services Are Provided?

The Inception stack runs three services, all inside Docker containers on your Virtual Machine:

| Service | Description | Access |
|---|---|---|
| **Nginx** | HTTPS web server — the only public entry point | `https://gmohamed.42.fr` (port 443) |
| **WordPress + PHP-FPM** | The WordPress website and its backend | Via Nginx (not directly exposed) |
| **MariaDB** | The database storing all WordPress content | Internal only (not exposed outside) |
| **Adminer** | A graphical interface thjat helps visualise and manages databases| `http://gmohamed@42.fr:8080/adminer.php` |
| **Static-Website** | a simple CV of me | `http//:gmohamed@42.fr:8082`|

All traffic goes through Nginx over **TLS (HTTPS)**. No other port is open to the outside (except for bonus part of course where i had to open two other ports 8080cand 8082 )

---

## Starting and Stopping the Project

Open a terminal on the Virtual Machine and navigate to the project root.

**Start everything:**
```bash
make
# or, if already built:
make up
```

**Stop everything (containers are paused, data is preserved):**
```bash
make down
```

**Full reset (removes containers, volumes, and images — data will be lost):**
```bash
make fclean
```

> ⚠️ Only run `make fclean` if you want to wipe all data and start fresh.

---

## Accessing the Website

Once the stack is running:

1. Open a browser and go to: **`https://gmohamed.42.fr`**
2. You may see a security warning about a self-signed certificate — this is expected. Click **"Advanced"** → **"Accept the Risk and Continue"** (or equivalent in your browser).
3. The WordPress homepage will load.

> Make sure `gmohamed.42.fr` resolves to your VM's local IP. You can verify this with:
> ```bash
> ping gmohamed.42.fr
> ```

---

## Accessing the Administration Panel

1. Go to: **`https://gmohamed.42.fr/wp-admin`**
2. Log in with the WordPress administrator credentials stored in `secrets/credentials.txt` file.
3. From the dashboard we can manage posts, pages, users, plugins, and settings.

> The administrator username does **not** contain "admin" or "administrator" — check `credentials.txt` for the exact username.

---

## Locating and Managing Credentials

All sensitive credentials are stored **locally** in the `secrets/` folder at the root of the project. They are never committed to Git.

| File | Contains |
|---|---|
| `secrets/credentials.txt` | WordPress admin password (used here for invite also cause of laziness) |
| `secrets/db_password.txt` | MariaDB user password |
| `secrets/db_root_password.txt` | MariaDB root password |

**To view a credential:**
```bash
cat secrets/credentials.txt
```

> ⚠️ Never share these files or commit them to any repository.

---

## Checking That Services Are Running Correctly

**List all running containers:**
```bash
docker ps
```
You should see three containers running: `nginx`, `wordpress`, and `mariadb`.

**Check logs for a specific service:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Check that the website responds:**
```bash
curl  https://gmohamed.42.fr
```
A successful response will return HTML output from the WordPress homepage.


If all three containers appear in `docker ps` and the site loads in the browser, the stack is healthy.
