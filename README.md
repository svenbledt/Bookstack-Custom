# Commands
Building the image
```bash
docker build . -t bookstack-custom
```
Docker create a tag
```bash
docker tag bookstack-custom svenbledt/bookstack-swissrp:latest
```
pushing the image
```bash
docker push svenbledt/bookstack-swissrp:latest
```