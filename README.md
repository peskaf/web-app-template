# Web App Template

This is a custom template for web app with React (TS) frontend, Flask backend, Nginx as a proxy and Postgres as database, all put together using Docker.

The web app can operate in development or production mode. Production mode serves built TS project whereas development mode offers real-time updates.

## Running

1. Rename `TODO.env` file to `.env` and fill in the values.

### Dev

1. Install [`mkcert`](https://github.com/FiloSottile/mkcert) using provided [script](/scripts/install-mkcert.sh) if using Ubuntu. Use `brew install mkcert` on macOS, eventually look [here](https://github.com/FiloSottile/mkcert).
2. Run 
```shell
mkcert -install
mkdir -p "./local-certs/private"
mkdir -p "./local-certs/certs"
mkcert -key-file "./local-certs/private/localhost.key" -cert-file "./local-certs/certs/localhost.pem" localhost
```
from the root of this repo to create locally trusted certificates and to trust the local CA.

3. Run `docker compose --profile dev up`.
4. Web app is available as `localhost` in a browser and works with HTTPS.

### Prod
1. Run `docker compose --profile cert up --abort-on-container-exit` to generate certificates (first use only).
2. Run `docker compose --profile prod up`.
2. Web app is accessible on the domain provided in PROD_SERVER_NAME env variable and works with HTTPS.

## Idea

I want to create template for web app that can be developed on localhost and then sent to the production server using GitHub CI/CD pipeline. Idea is that developer would run the dev mode locally and production mode would be run on the production server. Dev mode has locally trusted certificates for HTTPS, production will create its certificates using certbot image.

## TODO

- [ ] increase overall default security of the app
- [ ] template for GitHub CI/CD pipeline for upload to production server
