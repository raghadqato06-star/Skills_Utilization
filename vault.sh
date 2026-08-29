#!/bin/bash

set -e

export VAULT_ADDR="http://127.0.0.1:8200"

SECRET_PATH="kv/skills-utilization"
ENV_FILE="$(pwd)/.env"

if [ -z "$VAULT_TOKEN" ]; then
    echo "ERROR: VAULT_TOKEN is not set."
    exit 1
fi

echo "Checking Vault..."

vault status >/dev/null

echo "Retrieving secrets from Vault..."

SECRETS=$(vault kv get -format=json "$SECRET_PATH")

echo "Saving secrets to $ENV_FILE..."

echo "$SECRETS" | jq -r '.data.data | to_entries[] | "\(.key)=\(.value)"' > "$ENV_FILE"

chmod 600 "$ENV_FILE"

echo "Secrets successfully saved to $ENV_FILE"

