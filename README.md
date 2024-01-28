# Traefik on Alpine

Traefik docker image based on Alpine Linux.

## Description
[Traefik](https://traefik.io/traefik). The default configuration will use the docker provider and any dynamic configuration located in `/traefik/var`. It will also by default redirect any http traffic to https.

## Volumes
* **/traefik/etc** - Directory of traefik configuration (traefik.yaml)
* **/traefik/var** - Directory of traefik dynamic files (configs, ssl certificates)

## Run
```shell
docker run --name traefik \
  --network host \
  -v .../docker.sock:/var/run/docker.sock \
  -v .../var:/traefik/var \
  -d 11notes/traefik:[tag]
```
Allow non-root ports < 1024 via `echo "net.ipv4.ip_unprivileged_port_start=80" > /etc/sysctl.d/traefik.conf` for using :80 and :443

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | appuser | user appuser |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /traefik | home directory of user appuser |
| `api` | https://${IP}:8080 | default |
| `config` | /traefik/etc/traefik.yaml | default configuration file |

## Environment
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | null |

## Parent image
* [nerethos/alpine:latest](https://hub.docker.com/r/nerethos/alpine)

## Built with (thanks to)
* [Traefik](https://traefik.io/traefik)
* [Alpine Linux](https://alpinelinux.org)
