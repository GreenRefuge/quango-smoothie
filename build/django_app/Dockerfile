FROM debian:10.11

RUN \
	apt-get update \
	&& apt-get install -y --no-install-recommends \
		python3 python3-venv \
	&& rm -rf /var/lib/apt/lists/*

ARG U_NAME="user"
ARG G_NAME="userg"
ARG U_ID="1000"
ARG G_ID="1000"
RUN \
	groupadd -g ${G_ID} ${G_NAME} \
	&& useradd -m --uid ${U_ID} --gid ${G_ID} ${U_NAME}

WORKDIR /home/${U_NAME}



USER ${U_NAME}

RUN \
	python3 -m venv venv_django \
	&& . venv_django/bin/activate \
	&& pip install --upgrade pip \
	&& pip install Django==3.2.8 \
	&& deactivate



USER root

COPY start.sh .
RUN chmod 700 start.sh && chown ${U_ID}:${G_ID} start.sh
RUN mkdir app_src && chown -R ${U_ID}:${G_ID} app_src


USER ${U_NAME}

CMD /home/user/start.sh
