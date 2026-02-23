#!/usr/bin/env bash
set -euo pipefail

start_platform() {
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  
  echo "Iniciando infraestrutura global..."
  docker compose -f "$base_dir/docker-compose.yml" up -d --remove-orphans
}

stop_platform() {
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  
  echo "Parando infraestrutura global..."
  docker compose -f "$base_dir/docker-compose.yml" down
}
