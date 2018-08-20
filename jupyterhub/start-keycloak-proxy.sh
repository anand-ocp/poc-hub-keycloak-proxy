#!/bin/bash

set -x

. `dirname $0`/keycloak-proxy-envvars.sh

exec /opt/jboss/docker-entrypoint.sh `dirname $0`/proxy.json
