#!/bin/bash
set -e

source venv_django/bin/activate

cd app_src/tyfyc_backend

# provide host/port explicitly here in case default changes in the future
exec python manage.py runserver 0.0.0.0:8000
