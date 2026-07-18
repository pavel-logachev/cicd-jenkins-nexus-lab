#!/bin/sh
set -eu

nexus_url="${NEXUS_URL:-http://nexus:8081}"
target_password="${NEXUS_ADMIN_PASSWORD:?NEXUS_ADMIN_PASSWORD is required}"

echo "Waiting for Nexus REST API..."
until curl --fail --silent --output /dev/null "${nexus_url}/service/rest/v1/status"; do
  sleep 5
done

if curl --fail --silent --user "admin:${target_password}" \
  "${nexus_url}/service/rest/v1/repositories" >/dev/null 2>&1; then
  current_password="${target_password}"
else
  until [ -s /nexus-data/admin.password ]; do
    sleep 2
  done
  current_password="$(cat /nexus-data/admin.password)"
  curl --fail --silent --show-error \
    --request PUT \
    --user "admin:${current_password}" \
    --header 'Content-Type: text/plain' \
    --data "${target_password}" \
    "${nexus_url}/service/rest/v1/security/users/admin/change-password"
  current_password="${target_password}"
fi

# Nexus Repository 3.82+ blocks component uploads until the Community Edition
# EULA is accepted. The API requires the exact disclaimer returned by GET.
curl --fail --silent --show-error \
  --user "admin:${current_password}" \
  "${nexus_url}/service/rest/v1/system/eula" \
  --output /tmp/nexus-eula.json
if grep -q '"accepted" : false' /tmp/nexus-eula.json; then
  sed 's/"accepted" : false/"accepted" : true/' \
    /tmp/nexus-eula.json > /tmp/nexus-eula-accepted.json
  curl --fail --silent --show-error \
    --user "admin:${current_password}" \
    --header 'Content-Type: application/json' \
    --data-binary @/tmp/nexus-eula-accepted.json \
    "${nexus_url}/service/rest/v1/system/eula"
  echo "Nexus Community Edition EULA accepted"
fi

if curl --fail --silent --user "admin:${current_password}" \
  "${nexus_url}/service/rest/v1/repositories/raw/hosted/sdvps-releases" >/dev/null 2>&1; then
  echo "Repository sdvps-releases already exists"
  exit 0
fi

curl --fail --silent --show-error \
  --user "admin:${current_password}" \
  --header 'Content-Type: application/json' \
  --data '{
    "name": "sdvps-releases",
    "online": true,
    "storage": {
      "blobStoreName": "default",
      "strictContentTypeValidation": true,
      "writePolicy": "ALLOW"
    },
    "cleanup": {"policyNames": []},
    "component": {"proprietaryComponents": false},
    "raw": {"contentDisposition": "ATTACHMENT"}
  }' \
  "${nexus_url}/service/rest/v1/repositories/raw/hosted"

echo "Repository sdvps-releases created"
