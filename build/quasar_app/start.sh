#!/bin/bash
set -e

# NOTE: tries to remove existing symbolic link from last run (cannot reuse between containers, must not exist after this point)
# - better: could use ENTRYPOINT to intercept signals and do some cleanup internally
rm /home/node/node_app/app_src/quango_frontend/node_modules || true
# create symbolic link to node_modules
# - Quasar refs "node_modules", but want to avoid polluting mounted "source" directory with lots of 3rd party things
# - this will _remain_ after container run (see NOTE above)
ln -s /tmp/app_preinstall/node_modules /home/node/node_app/app_src/quango_frontend/node_modules

cd /home/node/node_app/app_src/quango_frontend

# provide host/port explicitly here in case default changes in the future
exec npx quasar dev --hostname 0.0.0.0 --port 8080
