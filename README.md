# Web App Template

This is a custom template for web app with React (TS) frontend, Flask backend, Nginx as a proxy and Postgres as database, all put together using Docker.

The web app can operate in development or production mode. Production mode serves built TS project whereas development mode offers real-time updates.

## Running

1. Rename `TODO.env` file to `.env` and fill in the values.

### Dev

1. Install [`mkcert`](https://github.com/FiloSottile/mkcert) using provided [script](/scripts/install-mkcert.sh).
2. Run `./compose.sh dev up --build` - this way, also certificates for localhost that are locally trusted get created.
3. Web app is available as `localhost` in a browser and works with HTTPS.

### Prod
1. Run `./compose.sh prod up --build -d`.
2. Web app is accessible on the domain provided in PROD_SERVER_NAME env variable and works with HTTPS.

## Idea

I want to create template for web app that can be developed on localhost and then sent to the production server using GitHub CI/CD pipeline. Idea is that developer would run the dev mode locally and production mode would be run on the production server. Dev mode has locally trusted certificates for HTTPS, production will create its certificates using certbot image.

## TODO

- [x] add certbot to docker-compose and script for auto HTTPS setting
- [ ] increase overall default security of the app
- [ ] template for GitHub CI/CD pipeline for upload to production server
