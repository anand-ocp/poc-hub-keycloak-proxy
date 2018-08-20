#!/bin/bash

set -x
set -eo pipefail

SOURCE=`dirname $0`
TARGET=${1:-/opt/jboss/conf}

mkdir -p $TARGET

cp $SOURCE/start-keycloak-proxy.sh $TARGET
cp $SOURCE/keycloak-proxy.conf $TARGET/proxy.json

SERVER="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT"
TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
NAMESPACE=`cat /var/run/secrets/kubernetes.io/serviceaccount/namespace`

URL="$SERVER/oapi/v1/namespaces/$NAMESPACE/routes/$JUPYTERHUB_SERVICE_NAME"

JUPYTERHUB_HOSTNAME=`curl -s -k -H "Authorization: Bearer $TOKEN" $URL | \
    python -c "import json, sys; \
               data = json.loads(sys.stdin.read()); \
               print(data['spec']['host'])"`

URL="$SERVER/oapi/v1/namespaces/$NAMESPACE/routes/$KEYCLOAK_SERVICE_NAME"

KEYCLOAK_HOSTNAME=`curl -s -k -H "Authorization: Bearer $TOKEN" $URL | \
    python -c "import json, sys; \
               data = json.loads(sys.stdin.read()); \
               print(data['spec']['host'])"`

cat > $TARGET/keycloak-proxy-envvars.sh << EOF
export UPSTREAM_URL=http://$JUPYTERHUB_SERVICE_NAME:8080
export SERVER_URL=https://$KEYCLOAK_HOSTNAME/auth
EOF
