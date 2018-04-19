# Upspin Container

This image contains the upspinserver and its variants for hosting an [Upspin](https://upspin.io/) server.

By default this container runs `upspinserver` with HTTPS certificates via letsencrypt enabled.

Different storage variants can be selected by passing the appropriate variant via environment variables on container creation:

```shell
docker create --name=upspin-gcp -e VARIANT=gcp upspin:latest # Storage on gcp
docker create --name=upspin-drive -e VARIANT=drive upspin:latest # Storage on Google Drive
docker create --name=upspin-aws -e VARIANT=aws upspin:latest # Storage on AWS
docker create --name=upspin-dropbox -e VARIANT=dropbox upspin:latest # Storage on Dropbox
```

## Configuration and use

The image defines two volumes:

- `/upspin/data`: configuration and stored data for default `upsinserver`
- `/upspin/letsencrypt`: letsencrypt certificates and configuration for standalone operation

The default entrypoint defines the passes the arguments `-config`, `-serverconfig` and `-letscache` to use the defined volumes.

Any additional arguments can simply be passed as CMD/arguments on container creation.

## Standalone operation

``` 
docker create -v <data>:/upspin/data -v <letsencrypt>:/upspin/letsencrypt -p 80:80 -p 443:443 jabbrwcky/upspin:latest
```

## Reverse proxying with nginx, nginx-proxy and nginx-letsencrypt companion

This image works well behind a remote proxy, e.g. in combination with [evertramos/docker-compose-letsencrypt-nginx-proxy-companion](https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion).

The following sample illustrates how to use the upspin image with the multiple network configuration of evertramos/docker-compose-letsencrypt-nginx-proxy-companion:

```yaml
# ...
  upspin:
    restart: always
    image: jabbrwcky/upspin
    container_name: upspin
    command: [ "-web",  "-insecure" ]
    volumes:
      - ./upspin:/upspin/data
    environment:
      VIRTUAL_HOST: upspin.example.com
      LETSENCRYPT_HOST: upspin.example.com
      LETSENCRYPT_EMAIL: upspin@example.com
    networks:
      - default
# ...
```
