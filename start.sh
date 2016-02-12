#!/usr/bin/env bash

cat "config.example.yml" |
sed "s/<server.port>/${SERVER_PORT}/g" > config.yml

dart bin/server.dart