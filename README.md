# Web App Template

This is a custom template for web app with React (TS) frontend, Flask backend, Nginx as a proxy and Postgres as database, all put together using Docker.

The web app can operate in development or production mode. Production mode serves built TS project whereas development mode offers real-time updates.
## Running

1. Rename `TODO.env` file to `.env` and fill in the values,
2. run `./compose.sh <dev | prod> up --build` or `./compose.sh <dev | prod> up --build -d`.

## TODO

- [ ] add certbot to docker-compose and script for auto HTTPS setting
- [ ] increase overall default security of the app
