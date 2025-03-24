# Commands
Building the image
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t svenbledt/bookstack-swissrp:latest --push .
```
Docker create a tag
```bash
docker tag bookstack-custom svenbledt/bookstack-swissrp:latest
```
pushing the image
```bash
docker push svenbledt/bookstack-swissrp:latest
```
Running the image
```bash
docker run --platform linux/amd64 svenbledt/bookstack-swissrp:latest
```