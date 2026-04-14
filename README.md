# Inception

*This project has been created as part of the 42 curriculum by gmohamed.*

---

## Description
The goal of this project is to improve my system administration knowledge by using **Docker** to virtualize a complete network of services. The project consists of a small infrastructure composed of an **Nginx** server, a **WordPress** site powered by PHP-FPM, a **MariaDB** database, and two bonus services: **Adminer** (a database management UI) and a **static portfolio website**.

### Design Choices
* **Microservices Architecture:** Each service is encapsulated in its own dedicated container. We organized the source code into a directory structure (`srcs/requirements/`) where each service has its own configuration files and Dockerfile. This ensures **separation of concerns** and makes the system easier to maintain.
* **Operating System:** All containers are built using **Debian Bullseye**, providing a stable, lightweight, and secure environment.
* **Building from Scratch:** Instead of using pre-made images, every Dockerfile is custom-built to comply with the project constraints.

### Technical Comparisons
#### 1. Virtual Machines vs Docker
* **Virtual Machines (VM):** A VM virtualizes the entire hardware. It requires a full **Guest OS**, which consumes significant RAM and CPU. Running multiple services would require multiple VMs, leading to slow startup times and complex networking between different "virtual computers."
* **Docker:** Docker virtualizes the **Operating System kernel**. Containers share the host's resources and kernel, making them extremely lightweight. They start almost instantly and communicate easily through internal Docker networks.

#### 2. Secrets vs Environment Variables
* **Environment Variables:** In this project, we used a `.env` file to pass credentials (like `SQL_DATABASE`) to our containers. These are easy to set up but are stored in plain text. Anyone with access to the server can see them by running `docker inspect`.
* **Docker Secrets:** This is a more secure "industry-standard" method. Instead of being stored in the environment, secrets are stored as encrypted files and only mounted into the container's memory at runtime. They never touch the disk and aren't visible in `docker inspect`, making them much safer against accidental exposure.

#### 3. Docker Network vs Host Network
* **Host Network:** The container shares the host's IP address and ports directly. If MariaDB runs on port 3306, it is exposed to the entire internet/local network. There is no isolation, which is a major security risk.
* **Docker Network (Bridge):** This is what we used for Inception. It creates a private, isolated virtual network. Containers can talk to each other using their service names (like `mariadb`), but they are invisible to the outside world. Only Nginx is exposed to the host's network via port 443.

#### 4. Docker Volumes vs Bind Mounts
* **Bind Mounts:** A specific path on the host machine is linked to a path in the container. It depends on the host's file structure, making it less portable across different machines or users.
* **Docker Volumes:** These are managed entirely by Docker and stored in a part of the host filesystem isolated from the rest of the OS. They are more secure, easier to back up, and highly portable because they are referenced by a name rather than a specific file path.

---

## Instructions

### Prerequisites

- The project must be executed on a **Virtual Machine**
- A domain name configured as `gmohamed.42.fr` pointing to the local IP address (IN  `/etc/hosts`).
- **Docker** and **Docker Compose** installed on the host
- A `secrets/` folder with the required credential files (see `DEV_DOC.md`)
- A `srcs/.env` file populated with the required environment variables

### Installation & Execution

```bash
# Clone the repository
git clone
cd inception

# Build and start all containers
make

# Stop containers
make down

# Remove all containers, volumes, and built images
make fclean
```

Once running, access the WordPress site at: **https://gmohamed.42.fr**

> Make sure `gmohamed.42.fr` is mapped to your VM's local IP in `/etc/hosts`.

---

## Usage Examples

After running `make`, you can:

| Service | URL | Description |
|---|---|---|
| WordPress site | `https://gmohamed.42.fr` | Main website |
| WordPress admin | `https://gmohamed.42.fr/wp-admin` | Admin dashboard |
| Adminer | `http://gmohamed.42.fr:8080/adminer.php` | Database management UI |
| Portfolio | `http://gmohamed.42.fr:8082` | Static CV website |

**Useful commands:**
```bash
# Check all running containers
docker ps

# Inspect logs
docker logs <container_name>

# Simulate a crash and verify restart policy
kill -9 $(docker inspect --format='{{.State.Pid}}' <container_name>)
```

> Accept the self-signed certificate warning when accessing HTTPS pages.

---

## Bonus Services

### Adminer
A lightweight database management interface running on port **8080**. It connects directly to the MariaDB container via the internal Docker network. Access it at `http://gmohamed.42.fr:8080/adminer.php` and log in with the MariaDB credentials.

### Static Portfolio Website
A personal CV built with pure HTML and CSS, served by a dedicated Nginx container on port **8082**. No PHP, no backend (STATIC). Access it at `http://gmohamed.42.fr:8082`.

---

## Resources

### Documentation & References

- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [WordPress CLI (WP-CLI)](https://wp-cli.org/)
- [MariaDB Docker Setup](https://mariadb.com/kb/en/installing-and-using-mariadb-via-docker/)
- [Adminer Official Site](https://www.adminer.org/)
- [FreeCodeCamp courses](https://www.freecodecamp.org/)

### Use of Artificial Intelligence

AI was used during this project IN:

- **Understanding concepts and terms:** Asking for explanations such as PID 1 of a container, how to simulate a crush, differences between networking modes, daemon , ports, testing, secrets utility, usefull commands, and many other question of type WHY??.
- **Debugging assistance:** Describing error messages and getting guidance on causes (MariaDB initialization issues, Errors using bad ports like http (80), syntax errors in commands and configuration).
- **Frontend development:** The CSS styling for the static portfolio website was written with assistance from AI asking it to give stylish trics and explain rulesets and their {declaration : property} and some .md fromating tips.
