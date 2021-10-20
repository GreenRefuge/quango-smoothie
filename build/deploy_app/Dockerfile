FROM debian:10.11

RUN \
	apt-get update \
	&& apt-get install -y --no-install-recommends \
		rsync \
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
