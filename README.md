# TYFYC Starter

This repo can be used as a starting point for [Django](https://www.djangoproject.com/)+[Quasar](https://quasar.dev/)-based projects, using [Docker Compose](https://github.com/docker/compose) for container orchestration.

- `./mount/django_app/tyfyc_backend` is a minimal Django app created with the `django-admin startproject` command (uses the default `SQLite` for storage)
- `./mount/quasar_app/tyfyc_frontend` is a minimal Quasar app created with the `quasar create` command (base installation)

[NGINX](https://www.nginx.com/) is used as a reverse proxy in both Development and Production environments in order to:

- provide HTTPS support
- serve Django static files
- provide proper routing depending on environment context


## Getting Started
```console
$ git clone https://github.com/GreenRefuge/tyfyc_starter.git
$ cd tyfyc_starter
```

## :hourglass_flowing_sand: Building Environment

### Development
```console
$ docker-compose -f dev.yml build
```
### Production
```console
$ docker-compose build
```

## Running Development Server(s)
```console
docker-compose -f dev.yml up
```

## Building Quasar Frontend
```console
docker-compose -f dev.yml run --rm quasar_app /bin/bash -c "cd app_src/tyfyc_frontend && npx quasar build"
```

## :rocket: Running Production Server(s)
**NOTE: must do the "Building Quasar Frontend" step before this**
```console
$ docker-compose up
```

- The application can be loaded at `https://127.0.0.1`

## :book: Notes
- things under the `./build` directory are used during container build(s) only
- things under the `./mount` directory are mounted within the container(s) during runtime
- on first run, Django creates a file `db.sqlite3` in the (host-mounted) `./mount/databases` directory
- on each run, a symbolic link `node_modules` is created in the (host-mounted) `./mount/quasar_app/tyfyc_frontend` directory
