from node:lts-alpine
WORKDIR /usr/src/app
COPY package*.json ./
COPY node_modules ./node_modules/
COPY lib ./lib
COPY static ./static
COPY config ./config/
COPY prepack-local-packages/* ./prepack-local-packages/
