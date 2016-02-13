#!/usr/bin/env bash

set -e

cat "config.example.yml" |
sed "s/<server.port>/${SERVER_PORT}/g" > config.yml

if [ "$1" = 'server' ]; then
    dart bin/server.dart
fi

exec "$@"