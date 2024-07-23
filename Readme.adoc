# Dev
```
npm install
npm run build
npm run server
```

# Deploy

```
npm run release
```

stop the existing code if running
- /opt/gl/id3as-norsk-studio-starter-kit/deploy
- ./stop.sh

- Scp that up to the server (/opt/gl/id3as-norsk-studio-starter-kit/)
- rm -rf deploy
- Untar it
- cd deploy
- docker load < norsk-studio-starter-kit.tar
- ./run.sh sm


