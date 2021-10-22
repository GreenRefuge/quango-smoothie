#!/bin/bash
set -e

source venv_django/bin/activate

cd app_src/quango_backend

# NOTE: cleanup any existing socket here (prevents reuse in case e.g. server method is different)
rm /tmp/shared_sockets/uvicorn.sock || true

if [ "$DJANGO_DEV_ENV" == "1" ]
then
	
	# collects/copies Static files to shared Volume location
	python manage.py collectstatic --noinput
	
	# NOTE: just using the same args as in gunicorn command (adapted to uvicorn) + args defined in "gunicorn_run.py"
	exec uvicorn quango_backend.asgi:application --reload --workers 1 --uds /tmp/shared_sockets/uvicorn.sock --lifespan off --forwarded-allow-ips="*" --proxy-headers
	
	# !! ideally: could do something to react to changes to static files (i.e. rerun "collectstatic")
	
else
	
	# don't do any collectstatic -- files should already be in the proper location
	
	# if in some case ENV is _not_ set, this will still fallback to "safer"/production gunicorn
	exec gunicorn quango_backend.asgi:application -w 1 -b unix:/tmp/shared_sockets/uvicorn.sock -k gunicorn_run.MyUvicornWorker
	
fi
