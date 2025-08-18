FROM odoo:18.0

ARG LOCALE=en_US.UTF-8

ENV LANGUAGE=${LOCALE}
ENV LC_ALL=${LOCALE}
ENV LANG=${LOCALE}

USER 0

RUN apt-get -y update && apt-get install -y --no-install-recommends locales netcat-openbsd \
    && locale-gen ${LOCALE}

WORKDIR /app

COPY --chmod=755 entrypoint.sh ./

ENTRYPOINT ["/bin/sh"]

CMD ["entrypoint.sh"]
