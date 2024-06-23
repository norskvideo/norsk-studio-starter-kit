from node:lts-alpine
WORKDIR /usr/src/app
COPY package*.json ./
COPY node_modules ./node_modules/
COPY lib ./lib
COPY client ./client
COPY config ./config/

