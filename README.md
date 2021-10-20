# TYFYC Starter

This repo can be used as a starting point for [Django](https://www.djangoproject.com/)+[Quasar](https://quasar.dev/)-based projects, using [Docker Compose](https://github.com/docker/compose) for container orchestration.

`./mount/django_app/tyfyc_backend` is:
- a minimal Django app created with the `django-admin startproject` command (uses the default `SQLite` for storage)

`./mount/quasar_app/tyfyc_frontend` is:
- a minimal Quasar app created with the `quasar create` command (base installation)

[NGINX](https://www.nginx.com/) is used as a reverse proxy in both Development and Production environments in order to:

- provide centralized HTTPS termination
- serve static files (Django static files and Quasar build artifacts)
- facilitate environment-dependent routing

## :sunrise: Setup


### Download Project
```console
$ git clone https://github.com/GreenRefuge/tyfyc_starter.git
$ cd tyfyc_starter 
```


### Build Development Images
```console
$ docker-compose -f dev.yml build
```


#### *(optional)* Build Production Images
**NOTE**: it is not necessary to do this in a local/dev environment, but can be done for testing purposes
```console
$ docker-compose -f prod.yml build
```

#### *(optional)* Build Deployment Image
**NOTE**: deployment process is containerized here in order to:
  - standardize setup of remote/production server
  - avoid additional setup in host environment
  - facilitate interaction with build artifacts of dev environment
```console
$ docker-compose -f deploy.yml build
```



## :computer: Developing


### Running Development Containers
```console
$ docker-compose -f dev.yml up
```
The application can be accessed at `https://127.0.0.1`
- **Live Auto Reloading**
  - the Quasar dev server will watch for file changes under `./mount/quasar_app/tyfyc_frontend`
  - the Django server will watch for file changes under `./mount/django_app/tyfyc_backend`
  - changes to settings-related things (like `quasar.conf.js` or `settings.py`) will require a restart of the container
  - changes to package-related things (like `package.json`) will require a rebuild of the container image



## :book: Notes
- things under the `./build` directory are used during container build(s) only
- things under the `./mount` directory are mounted within the container(s) during runtime
- on first run, Django creates a file `db.sqlite3` in the (host-mounted) `./mount/databases` directory
- on each run, a symbolic link `node_modules` is created in the (host-mounted) `./mount/quasar_app/tyfyc_frontend` directory
