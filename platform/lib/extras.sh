#!/usr/bin/env bash
set -euo pipefail

extras_up() {
  NAME=$1

  if [ -f "../projects/$NAME/docker-compose.extra.yml" ]; then
    docker compose -f "../projects/$NAME/docker-compose.extra.yml" up -d
    echo "Extras de $NAME iniciados"
  else
    echo "Projeto não possui extras"
  fi
}

extras_down() {
  NAME=$1

  if [ -f "../projects/$NAME/docker-compose.extra.yml" ]; then
    docker compose -f "../projects/$NAME/docker-compose.extra.yml" down
    echo "Extras de $NAME parados"
  fi
}
