FROM alpine:latest AS parallel

RUN apk add --no-cache parallel

FROM caddy:latest AS caddy

COPY Caddyfile ./

RUN caddy fmt --overwrite Caddyfile

FROM bitnami/odoo:17

COPY --from=caddy /srv/Caddyfile ./

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

COPY --from=parallel /usr/bin/parallel /usr/bin/parallel

CMD parallel --ungroup --halt now,done=1 ::: \
    "/opt/bitnami/scripts/odoo/entrypoint.sh /opt/bitnami/scripts/odoo/run.sh" \
    "caddy run --config Caddyfile --adapter caddyfile" 2>&1