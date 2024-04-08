#!/bin/bash

set -e

exec caddy run \
    --config Caddyfile \
    --adapter caddyfile