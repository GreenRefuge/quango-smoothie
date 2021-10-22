#!/bin/bash
set -e

#============================#
PROJECT_DIR=/home/user/project_dir
DJANGO_STATIC_DIR=/home/user/django_staticfiles
QUASAR_DIST_DIR=/home/user/quasar_dist

OUTPUT_DIR=/home/user/deploy_dist
BUILD_TEMP_DIR=/tmp/prod
#============================#

source ~/venv_pack/bin/activate

#============================#
# NOTE: this temp dir is re-created on each run (_not_ mounted to host)

mkdir $BUILD_TEMP_DIR
cd $BUILD_TEMP_DIR

mkdir ./build

# files from Docker named volumes will be moved here
mkdir ./static_files
mkdir ./static_files/quasar
mkdir ./static_files/django

mkdir ./mount
mkdir ./mount/database
mkdir ./mount/django_app

mkdir ./config
mkdir ./config/prod
#============================#

#============================#
# "docker-compose.yml"

# renames "prod.yml" to "docker-compose.yml" (for clarity and because now it's the only .yml file in directory)
cp $PROJECT_DIR/prod.yml ./docker-compose.yml

# NOTE: change "127.0.0.1" to "0.0.0.0" in port mapping(s)
# - "tweak" here ensures that local environment NEVER listening on all interfaces
# - in Production/public-facing (web) server, generally want to listen on all interfaces
sed -i 's/127.0.0.1/0.0.0.0/g' ./docker-compose.yml
#============================#

#============================#
# "build" directories

cp -r $PROJECT_DIR/build/nginx_app ./build/nginx_app
# (remove unnecessary/dev files)
rm ./build/nginx_app/ng_dev.conf ./build/nginx_app/NOTES.md
# remove reference to 'ng_dev.conf' in Dockerfile
sed -i 's/COPY ng_dev\.conf \/etc\/nginx\///g' ./build/nginx_app/Dockerfile

cp -r $PROJECT_DIR/build/django_app ./build/django_app
#============================#

#============================#
# handle Django static files

cp -r $DJANGO_STATIC_DIR/* ./static_files/django

# remove named volume definition
sed -i 's/    django_staticfiles: {}//g' ./docker-compose.yml

# replace named volume mount
sed -i 's/django_staticfiles/\.\/static_files\/django/g' ./docker-compose.yml
#============================#

#============================#
# handle Quasar dist files

cp -r $QUASAR_DIST_DIR/* ./static_files/quasar

# remove named volume definition
sed -i 's/    quasar_dist: {}//g' ./docker-compose.yml

# replace named volume mount
sed -i 's/quasar_dist/\.\/static_files\/quasar/g' ./docker-compose.yml
#============================#

#============================#
# handle Django source files

cp -r $PROJECT_DIR/mount/django_app/* ./mount/django_app
# NOTE: now _remove_ all: *.pyc/pyo files, "__pycache__" directories
pyclean ./mount/django_app &> /tmp/output_pyclean.txt
# NOTE: can inspect output of this command if desired
#cat /tmp/output_pyclean.txt
#============================#

#============================#
# handle database

# !! NOTE: for now: intentionally do NOT copy the databases (separate local env from remote env)
#cp -r $PROJECT_DIR/mount/database/* ./mount/database
#============================#

#============================#
# Finally: package "prod" directory into single file

# NOTE: append timestamp to filename so don't have to worry about overwriting existing here
# - also: not a bad idea to have some "canonical" Production archive to be able to point to anyway
date_tstamp=$(date +%s)

tar -czf $OUTPUT_DIR/prod_${date_tstamp}.tar.gz .
#============================#

# all temp files will be removed when Container is removed

echo "Done."
