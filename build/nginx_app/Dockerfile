
#=========================================#
FROM debian:10.11 AS builder

RUN \
	apt-get -y update \
	&& apt-get install -y --no-install-recommends \
		apache2-utils openssl \
	&& rm -rf /var/lib/apt/lists/*

RUN openssl req -newkey rsa:2048 -nodes -keyout /tmp/ssl.key -x509 -days 365 -out /tmp/ssl.crt -subj "/C=US/ST=_/L=_/O=_/OU=_/CN=nginx_app"
#=========================================#

#=========================================#
FROM nginx:1.21

ARG NGINX_USER_NAME="nginx_user"
ARG NGINX_USER_UID=1000

COPY --from=builder /tmp/ssl.key /tmp/ssl.key
COPY --from=builder /tmp/ssl.crt /tmp/ssl.crt

RUN adduser --disabled-password --gecos '' --no-create-home --uid ${NGINX_USER_UID} ${NGINX_USER_NAME}

RUN \
	touch /var/run/nginx.pid \
	&& chown -R ${NGINX_USER_NAME}:${NGINX_USER_NAME} /var/run/nginx.pid \
	&& chown -R ${NGINX_USER_NAME}:${NGINX_USER_NAME} /var/cache/nginx

RUN \
	chmod 700 /tmp/ssl.key \
	&& chmod 700 /tmp/ssl.crt \
	&& chown ${NGINX_USER_NAME}:${NGINX_USER_NAME} /tmp/ssl.key \
	&& chown ${NGINX_USER_NAME}:${NGINX_USER_NAME} /tmp/ssl.crt

COPY ng_prod.conf /etc/nginx/
COPY ng_dev.conf /etc/nginx/

# Volumes shared across containers
RUN mkdir -p /tmp/django_files/static /tmp/shared_sockets /tmp/quasar_files && chown -R ${NGINX_USER_NAME}:${NGINX_USER_NAME} /tmp/django_files /tmp/shared_sockets /tmp/quasar_files

USER ${NGINX_USER_NAME}

#=========================================#
