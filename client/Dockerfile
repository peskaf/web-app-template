FROM node:alpine as react-builder
WORKDIR /app
COPY package*.json yarn*.lock ./
RUN yarn install --production
COPY . .
RUN yarn build
