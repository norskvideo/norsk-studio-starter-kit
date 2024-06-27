mkdir -p deploy
npm run build
docker build -t norsk-studio-starter-kit .
docker save norsk-studio-starter-kit:latest > deploy/norsk-studio-starter-kit.tar

# TODO - move to package.json