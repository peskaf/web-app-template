#!/bin/bash
set -eu

# Install required packages
sudo apt update
sudo apt install -y libnss3-tools git golang-go

# Clone mkcert repository
git clone https://github.com/FiloSottile/mkcert
cd mkcert

# Build mkcert
go build -ldflags "-X main.Version=$(git describe --tags)"

# Move mkcert binary
sudo mv mkcert /usr/local/bin/

cd ..
sudo rm -fr mkcert