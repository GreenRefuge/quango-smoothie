# TYFYC Starter

This repo can be used as a starting point for [Django](https://www.djangoproject.com/)+[Quasar](https://quasar.dev/)-based projects, using [Docker Compose](https://github.com/docker/compose) for container orchestration.

- `tyfyc_backend` is a minimal Django app created with the `django-admin startproject` command (uses the default `SQLite` for storage)
- `tyfyc_frontend` is a minimal Quasar app created with the `quasar create` command (base installation)

## :hourglass_flowing_sand: Building
`docker-compose build`

## :rocket: Running
`docker-compose up`

- Django start page can be accessed at `http://127.0.0.1:8000`
- Quasar start page can be accessed at `http://127.0.0.1:8080`

## :book: Notes
- things under the `./build` directory are used during container build(s) only
- things under the `./mount` directory are mounted within the container(s) during runtime
- on first run, Django creates a file `db.sqlite3` in the (host-mounted) `./mount/databases` directory
- on each run, a symbolic link `node_modules` is created in the (host-mounted) `./mount/quasar_app/tyfyc_frontend` directory
