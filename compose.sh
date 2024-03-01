#!/bin/bash
set -eu

# Function to extract specific environment variable from .env file
get_env_variable() {
    local env_file="$1"
    local variable_name="$2"
    local value

    # Check if .env file exists
    if [[ -f "$env_file" ]]; then
        # Extract the value of the specified variable
        value=$(grep -E "^$variable_name=" "$env_file" | cut -d '=' -f 2-)
        echo "$value"
    fi
}

# Load the PROD_SERVER_NAME environment variable from .env file
PROD_SERVER_NAME=$(get_env_variable ".env" "PROD_SERVER_NAME")

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
    DOCKER_COMPOSE_EXTENSION="docker-compose.dev.yml"
    if [ "$1" != "down" ]; then
        mkcert -install # Install root CA
        mkdir -p "$SCRIPT_DIR/local-certs/private"
        mkdir -p "$SCRIPT_DIR/local-certs/certs"
        # Generate certificate and key for localhost
        mkcert -key-file "$SCRIPT_DIR/local-certs/private/localhost.key" -cert-file "$SCRIPT_DIR/local-certs/certs/localhost.pem" localhost
    fi
elif [ "$MODE" = "prod" ]; then
    DOCKER_COMPOSE_EXTENSION="docker-compose.prod.yml"
    if [ "$1" != "down" ]; then # sep condition to make it clearer
        if [ ! -f "$SCRIPT_DIR/certbot/conf/live/${PROD_SERVER_NAME}/fullchain.pem;" ] && [ ! -f "$SCRIPT_DIR/certbot/conf/live/${PROD_SERVER_NAME}/privkey.pem;" ]; then
            # TODO: test
            # Run Certbot to generate certificates
            docker compose -f "$SCRIPT_DIR/docker-compose.yml" -f "$SCRIPT_DIR/$DOCKER_COMPOSE_EXTENSION" run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d $PROD_SERVER_NAME
            # docker compose -f "$SCRIPT_DIR/docker-compose.yml" -f "$SCRIPT_DIR/$DOCKER_COMPOSE_EXTENSION" restart
            docker compose -f "$SCRIPT_DIR/docker-compose.yml" -f "$SCRIPT_DIR/$DOCKER_COMPOSE_EXTENSION" down --remove-orphans
            echo "Certificates successfully generated."
        fi
    fi
else
    echo "Invalid mode. Please specify 'dev' or 'prod'."
    exit 1
fi

# Pass the remaining arguments to docker compose
docker compose -f "$SCRIPT_DIR/docker-compose.yml" -f "$SCRIPT_DIR/$DOCKER_COMPOSE_EXTENSION" "$@"
