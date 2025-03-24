
# BookStack - SwissRP Edition

## Docker Commands

Building the image
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t svenbledt/bookstack-swissrp:latest --push .
```

Tagging the image
```bash
docker tag bookstack-custom svenbledt/bookstack-swissrp:latest
```

Pushing the image
```bash
docker push svenbledt/bookstack-swissrp:latest
```

Running the image
```bash
docker run --platform linux/amd64 svenbledt/bookstack-swissrp:latest
```

---

# BookStack - Documentation Wiki

BookStack is a free and open source Wiki designed for creating beautiful documentation. Featuring a simple, but powerful WYSIWYG editor it allows for teams to create detailed and useful documentation with ease.

Powered by SQL and including a Markdown editor for those who prefer it, BookStack is geared towards making documentation more of a pleasure than a chore.

For more information on BookStack visit: https://www.bookstackapp.com

![bookstack](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/bookstack-logo.png)

## Supported Architectures

This image supports the following architectures:

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |
| armhf | ❌ | |

## Application Setup

The default username is admin@admin.com with the password of **password**, access the container at http://<host ip>:6875.

This application is dependent on a MariaDB database, be it one you already have or a new one. If you do not already have one, you can use the linuxserver MariaDB image.

If you intend to use this application behind a subfolder reverse proxy, such as SWAG container or Traefik you will need to make sure that the `APP_URL` environment variable is set to your external domain, or it will not work.

Documentation for BookStack can be found at https://www.bookstackapp.com/docs/.

### BookStack File & Directory Paths

This container ensures certain BookStack application files & folders, such as user file upload folders, are retained within the `/config` folder so that they are persistent & accessible when the `/config` container path is bound as a volume. There may be cases, when following the BookStack documentation, that you'll need to know how these files and folders are used relative to a non-container BookStack installation.

Below is a mapping of container `/config` paths to those relative within a BookStack install directory:

- **/config container path** => **BookStack relative path**
- `/config/www/.env` => `.env`
- `/config/log/bookstack/laravel.log` => `storage/logs/laravel.log`
- `/config/backups/` => `storage/backups/`
- `/config/www/files/` => `storage/uploads/files/`
- `/config/www/images/` => `storage/uploads/images/`
- `/config/www/themes/` => `themes/`
- `/config/www/uploads/` => `public/uploads/`

### Changing APP_URL

If you change the APP_URL after initial install, you should run the following line from your host terminal to update the database URL entries:

```shell
docker exec -it bookstack php /app/www/artisan bookstack:update-url ${OLD_URL} ${NEW_URL}
```

### Advanced Users (full control over the .env file)

If you wish to use the extra functionality of BookStack such as email, LDAP and so on you will need to set additional environment variables or make your own .env file with guidance from the BookStack documentation.

The container will copy an exemplary .env file to /config/www/.env on your host system for you to use.

## Usage

To help you get started creating a container from this image you can either use docker-compose or the docker cli.

> **Note:** Unless a parameter is flagged as 'optional', it is **mandatory** and a value must be provided.

### docker-compose (recommended)

```yaml
---
services:
  bookstack:
    image: svenbledt/bookstack-swissrp:latest
    container_name: bookstack
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Zurich
      - APP_URL=
      - APP_KEY=
      - DB_HOST=
      - DB_PORT=3306
      - DB_USERNAME=
      - DB_PASSWORD=
      - DB_DATABASE=
      - QUEUE_CONNECTION= #optional
    volumes:
      - /path/to/bookstack/config:/config
    ports:
      - 6875:80
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=bookstack \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Zurich \
  -e APP_URL= \
  -e APP_KEY= \
  -e DB_HOST= \
  -e DB_PORT=3306 \
  -e DB_USERNAME= \
  -e DB_PASSWORD= \
  -e DB_DATABASE= \
  -e QUEUE_CONNECTION= `#optional` \
  -p 6875:80 \
  -v /path/to/bookstack/config:/config \
  --restart unless-stopped \
  svenbledt/bookstack-swissrp:latest
```

## Parameters

Containers are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 6875:80` | http/s web interface. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/Zurich` | specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). |
| `-e APP_URL=` | The protocol, IP/URL, and port that your application will be accessed on (ie. `http://192.168.1.1:6875` or `https://bookstack.mydomain.com` |
| `-e APP_KEY=` | Session encryption key. You will need to generate this with `docker run -it --rm --entrypoint /bin/bash svenbledt/bookstack-swissrp:latest appkey` |
| `-e DB_HOST=` | The database instance hostname |
| `-e DB_PORT=3306` | Database port |
| `-e DB_USERNAME=` | Database user |
| `-e DB_PASSWORD=` | Database password (minimum 4 characters & non-alphanumeric passwords must be properly escaped.) |
| `-e DB_DATABASE=` | Database name |
| `-e QUEUE_CONNECTION=` | Set to `database` to enable async actions like sending email or triggering webhooks. See [documentation](https://www.bookstackapp.com/docs/admin/email-webhooks/#async-action-handling). |
| `-v /config` | Persistent config files |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

Will set the environment variable `MYVAR` based on the contents of the `/run/secrets/mysecretvariable` file.

## User / Group Identifiers

When using volumes (`-v` flags), permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id your_user` as below:

```bash
id your_user
```

Example output:

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Support Info

* Shell access whilst the container is running:

    ```bash
    docker exec -it bookstack /bin/bash
    ```

* To monitor the logs of the container in realtime:

    ```bash
    docker logs -f bookstack
    ```

* Container version number:

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' bookstack
    ```

* Image version number:

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' svenbledt/bookstack-swissrp:latest
    ```

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside.

Below are the instructions for updating containers:

### Via Docker Compose

* Update images:
    * All images:

        ```bash
        docker-compose pull
        ```

    * Single image:

        ```bash
        docker-compose pull bookstack
        ```

* Update containers:
    * All containers:

        ```bash
        docker-compose up -d
        ```

    * Single container:

        ```bash
        docker-compose up -d bookstack
        ```

* You can also remove the old dangling images:

    ```bash
    docker image prune
    ```

### Via Docker Run

* Update the image:

    ```bash
    docker pull svenbledt/bookstack-swissrp:latest
    ```

* Stop the running container:

    ```bash
    docker stop bookstack
    ```

* Delete the container:

    ```bash
    docker rm bookstack
    ```

* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images:

    ```bash
    docker image prune
    ```

## Version History

* **04.01.25:** - Add php-opcache.
* **17.12.24:** - Rebase to Alpine 3.21.
* **11.10.24:** - Default to environment config over .env file config.
* **06.09.24:** - Add php-exif for reading image EXIF data.
* **27.05.24:** - Rebase to Alpine 3.20. Existing users should update their nginx confs to avoid http2 deprecation warnings.
* **25.01.24:** - Existing users should update: site-confs/default.conf - Cleanup default site conf.
* **23.12.23:** - Rebase to Alpine 3.19 with php 8.3.
* **31.10.23:** - Further sanitize sed replace.
* **07.06.23:** - Add mariadb-client for bookstack-system-cli support.

## Contact Information

For support or inquiries, please contact:
- Email: [your-email@example.com]
- GitHub: [https://github.com/svenbledt]

---

*This image is based on the original BookStack application with customizations for SwissRP.*
