#!/bin/sh

set -e

exec caddy run \
    --config Caddyfile \
    --adapter caddyfile