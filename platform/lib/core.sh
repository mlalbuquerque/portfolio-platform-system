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

get_current_project() {
  local current_dir=$(pwd)
  local projects_dir_real=$(realpath "$PROJECTS_DIR")
  if [[ "$current_dir" == "$projects_dir_real"* ]]; then
    # Remove projects_dir_real from current_dir
    local relative_path=${current_dir#"$projects_dir_real"}
    # The first component is the project name
    local project_name=$(echo "$relative_path" | cut -d'/' -f2)
    echo "$project_name"
  fi
}
