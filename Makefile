init:
	cp .env.example .env

dev-certs:
	mkcert -install
	mkdir -p ./local-certs/private
	mkdir -p ./local-certs/certs
	mkcert -key-file ./local-certs/private/localhost.key -cert-file ./local-certs/certs/localhost.pem localhost

dev: dev-certs
	docker compose --profile dev up

prod-certs:
	docker compose --profile cert up --abort-on-container-exit

prod: prod-certs
	docker compose --profile prod up