#!/bin/sh

set -e

echo Waiting for database...

while ! nc -z ${ODOO_DATABASE_HOST} ${ODOO_DATABASE_PORT} 2>&1; do sleep 0.25; done; 

echo Database is now available

exec parallel --ungroup --halt now,done=1 ::: \
    "./start_odoo.sh" \
    "./start_caddy.sh" 2>&1