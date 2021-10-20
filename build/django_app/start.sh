#!/bin/bash
set -e

source venv_django/bin/activate

cd app_src/tyfyc_backend

# !!
# collects/copies Static files to shared Volume location
python manage.py collectstatic --noinput

# NOTE: cleanup any existing socket here (prevents reuse in case e.g. server method is different)
rm /tmp/shared_sockets/uvicorn.sock || true

if [ "$DJANGO_DEV_ENV" == "1" ]
then
	# NOTE: just using the same args as in gunicorn command (adapted to uvicorn) + args defined in "gunicorn_run.py"
	exec uvicorn tyfyc_backend.asgi:application --reload --workers 1 --uds /tmp/shared_sockets/uvicorn.sock --lifespan off --forwarded-allow-ips="*" --proxy-headers
else
	# if in some case ENV is _not_ set, this will still fallback to "safer"/production gunicorn
	exec gunicorn tyfyc_backend.asgi:application -w 1 -b unix:/tmp/shared_sockets/uvicorn.sock -k gunicorn_run.MyUvicornWorker
fi
