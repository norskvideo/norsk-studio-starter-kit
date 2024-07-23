FROM node:lts-alpine
WORKDIR /usr/src/app
COPY package*.json ./
COPY node_modules ./node_modules/
COPY lib ./lib
COPY static ./static
COPY config ./config/
COPY prepack-local-packages ./prepack-local-packages/
HEALTHCHECK --interval=10s --timeout=10s --start-period=40s --start-interval=5s --retries=3 CMD [ "wget", "-O", "/dev/null", "http://127.0.0.1:8000" ]
