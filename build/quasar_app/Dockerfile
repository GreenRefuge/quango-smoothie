FROM node:16.11

ARG U_NAME="node"
ARG G_NAME="node"

RUN \
	mkdir /home/${U_NAME}/node_app \
	&& chown -R ${U_NAME}:${G_NAME} /home/${U_NAME}/node_app

RUN \
	mkdir -p /tmp/app_preinstall \
	&& chown -R ${U_NAME}:${G_NAME} /tmp/app_preinstall

WORKDIR /home/${U_NAME}/node_app



USER ${U_NAME}

# installs the dependencies necessary for Quasar CLI (only)
RUN npm install --verbose @quasar/cli@^1.2.1
# installs the dependencies for the App itself (NOTE: hardcoded/manually specified here to avoid needing access to "mount" dir here)
RUN cd /tmp/app_preinstall && npm install --verbose \
	@quasar/extras@^1.0.0 core-js@^3.6.5 quasar@^2.0.0 @quasar/app@^3.0.0



USER root

COPY start.sh /home/${U_NAME}/start.sh
RUN \
	chown ${U_NAME}:${G_NAME} /home/${U_NAME}/start.sh \
	&& chmod 700 /home/${U_NAME}/start.sh
RUN mkdir app_src app_dist && chown -R ${U_NAME}:${G_NAME} app_src app_dist


USER ${U_NAME}

CMD ["/home/node/start.sh"]
