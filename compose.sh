#!/bin/bash
set -eu

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if mode argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <mode> [docker-compose options]"
    exit 1
fi

MODE="$1"
shift  # Remove the first argument from the list of arguments

# Check if the mode is dev or prod
if [ "$MODE" = "dev" ]; then
    mkcert -install # Install root CA

    mkdir -p "$SCRIPT_DIR/local-certs/private"
    mkdir -p "$SCRIPT_DIR/local-certs/certs"
    # Generate certificate and key for localhost
    mkcert -key-file "$SCRIPT_DIR/local-certs/private/localhost.key" -cert-file "$SCRIPT_DIR/local-certs/certs/localhost.pem" localhost
    DOCKER_COMPOSE_EXTENSION="docker-compose.dev.yml"
elif [ "$MODE" = "prod" ]; then
    DOCKER_COMPOSE_EXTENSION="docker-compose.prod.yml"
else
    echo "Invalid mode. Please specify 'dev' or 'prod'."
    exit 1
fi

# Pass the remaining arguments to docker compose
docker compose -f "$SCRIPT_DIR/docker-compose.yml" -f "$SCRIPT_DIR/$DOCKER_COMPOSE_EXTENSION" "$@"
