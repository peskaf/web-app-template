FROM node:alpine as react-builder
WORKDIR /app
COPY package*.json yarn*.lock ./
RUN yarn install
COPY . .
RUN yarn build
