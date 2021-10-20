#!/bin/bash
set -e

source venv_django/bin/activate

cd app_src/tyfyc_backend

# !!
# collects/copies Static files to shared Volume location
python manage.py collectstatic --noinput

# provide host/port explicitly here in case default changes in the future
#exec python manage.py runserver 0.0.0.0:8000
exec gunicorn tyfyc_backend.asgi:application --reload -w 1 -b unix:/tmp/shared_sockets/uvicorn.sock -k gunicorn_run.MyUvicornWorker
