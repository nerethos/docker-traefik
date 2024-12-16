# :: Build
FROM alpine AS build
ENV TRAEFIK_VERSION=v3.2.3 \
    ALPINE_VERSION=3.21.0
ARG TRAEFIK_VERSION \
    ALPINE_VERSION

USER root

RUN \
  apk --no-cache add \
    curl \  
    tar

RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) arch='armv6' ;; \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		s390x) arch='s390x' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
  curl -o \
    /tmp/traefik.tar.gz -L \
    "https://github.com/traefik/traefik/releases/download/${TRAEFIK_VERSION}/traefik_${TRAEFIK_VERSION}_linux_$arch.tar.gz"; \
	tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik; \
	rm -f /tmp/traefik.tar.gz; \
	chmod +x /usr/local/bin/traefik

# :: Header
FROM nerethos/alpine:latest
ENV APP_ROOT=/traefik
COPY --from=build /usr/local/bin/ /usr/local/bin

# :: Run
USER root

# :: prepare image
RUN \
  mkdir -p ${APP_ROOT}/etc && \
  apk --no-cache upgrade && \
  apk --no-cache add ca-certificates

# :: set home directory for existing docker user
RUN \
  usermod -d ${APP_ROOT} appuser

# :: copy root filesystem changes and set correct permissions
COPY ./rootfs /
RUN \
  chmod +x -R /usr/local/bin && \
  chown -R 1000:1000 \
  ${APP_ROOT}

# :: Volumes
VOLUME ["${APP_ROOT}/etc"]

# :: Start
USER appuser
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]