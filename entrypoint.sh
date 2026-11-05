#!/bin/sh
set -e

if [ -z "$UUID" ]; then
  echo "ERROR: UUID env var is not set. Set it in the platform's environment variables." >&2
  exit 1
fi

PORT="${PORT:-8080}"
export UUID PORT

# Render config from template
envsubst < /app/config.template.json > /app/config.json

echo "Starting xray on port ${PORT} ..."
exec /usr/local/bin/xray run -config /app/config.json
