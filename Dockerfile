FROM alpine:latest AS parallel

RUN apk add --no-cache parallel

FROM ubuntu:latest AS netcat

RUN apt-get update && apt-get -y --no-install-recommends install netcat-openbsd

FROM caddy:latest AS caddy

COPY Caddyfile ./

RUN caddy fmt --overwrite Caddyfile

FROM odoo:17.0

ARG LOCALE=en_US.UTF-8

ENV LANGUAGE=${LOCALE}
ENV LC_ALL=${LOCALE}
ENV LANG=${LOCALE}

USER 0

RUN apt-get -y update && apt-get install -y --no-install-recommends locales && locale-gen ${LOCALE}

COPY --from=caddy /srv/Caddyfile ./
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

COPY --from=parallel /usr/bin/parallel /usr/bin/parallel

COPY --from=netcat /usr/bin/nc /usr/bin/nc

COPY --chmod=755 /scripts/start.sh /scripts/start_odoo.sh /scripts/start_caddy.sh ./

ENTRYPOINT ["/bin/sh"]

CMD ["start.sh"]