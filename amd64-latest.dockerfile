# :: Build
  FROM alpine AS build

  USER root

  RUN \
    apk --no-cache add \
      curl \  
      tar

  RUN \
  echo "**** traefik ****" && \
    if [ -z ${TRAEFIK_LATEST+x} ]; then \
      TRAEFIK_LATEST=$(curl -sX GET "https://api.github.com/repos/traefik/traefik/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]'); \
    fi && \
    curl -o \
      /tmp/traefik_${TRAEFIK_LATEST}_linux_amd64.tar.gz -L \
      "https://github.com/traefik/traefik/releases/download/${TRAEFIK_LATEST}/traefik_${TRAEFIK_LATEST}_linux_amd64.tar.gz" && \
    cd /tmp && \
    tar -xzvf traefik_${TRAEFIK_LATEST}_linux_amd64.tar.gz traefik && \
    mv traefik /usr/local/bin

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