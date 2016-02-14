#!/usr/bin/env bash

set -e

cat "config.example.yml" |
sed "s/<server.port>/${SERVER_PORT}/g" |

sed "s/<db.host>/${DB_HOST}/g" |
sed "s/<db.port>/${DB_PORT}/g" |
sed "s/<db.name>/${DB_NAME}/g" |
sed "s/<db.username>/${DB_USERNAME}/g" |
sed "s/<db.password>/${DB_PASSWORD}/g" > config.yml

if [ "$1" = 'server' ]; then
    dart bin/server.dart
fi

exec "$@"