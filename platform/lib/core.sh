#!/usr/bin/env bash
set -euo pipefail

# Funções de log formatado
log_info() {
  # \e[1m = Negrito
  # \e[38;2;255;255;255m = Texto Branco Puro (RGB)
  # \e[48;2;0;150;0m = Fundo Verde (RGB)
  printf "\e[1;38;2;255;255;255;48;2;0;150;0m %s \e[0m\n" "$1"
}

log_error() {
  # \e[1m = Negrito
  # \e[38;2;255;255;255m = Texto Branco Puro (RGB)
  # \e[48;2;200;0;0m = Fundo Vermelho (RGB)
  printf "\e[1;38;2;255;255;255;48;2;200;0;0m %s \e[0m\n" "$1"
}

start_platform() {
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  
  log_info "Iniciando infraestrutura global..."
  docker compose -f "$base_dir/docker-compose.yml" up -d --remove-orphans
}

stop_platform() {
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  local projects_dir="${PROJECTS_DIR:-$base_dir/../projects}"
  local previews_dir="${PREVIEWS_DIR:-$base_dir/../previews}"
  
  log_info "Parando todos os projetos..."
  if [ -d "$projects_dir" ]; then
    for project_dir in "$projects_dir"/*; do
      if [ -f "$project_dir/docker-compose.extra.yml" ]; then
        log_info "Parando projeto: $(basename "$project_dir")"
        docker compose -f "$project_dir/docker-compose.extra.yml" down
      fi
    done
  fi

  log_info "Parando todos os previews..."
  if [ -d "$previews_dir" ]; then
    for preview_dir in "$previews_dir"/*; do
      if [ -f "$preview_dir/docker-compose.extra.yml" ]; then
        log_info "Parando preview: $(basename "$preview_dir")"
        docker compose -f "$preview_dir/docker-compose.extra.yml" down
      fi
    done
  fi

  log_info "Parando infraestrutura global..."
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
