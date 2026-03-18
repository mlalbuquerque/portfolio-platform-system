#!/usr/bin/env bash
set -euo pipefail

create_project() {
  NAME=$1
  TEMPLATE=${2:-php}
  
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  local projects_dir="${PROJECTS_DIR:-$base_dir/../projects}"
  local templates_dir="$base_dir/templates"
  local dir="$projects_dir/$NAME"

  mkdir -p "$projects_dir"

  if [ -d "$dir" ]; then
    echo "Erro: Projeto $NAME já existe em $dir"
    exit 1
  fi

  if [ "$TEMPLATE" = "laravel" ]; then
    echo "Criando projeto Laravel em $dir/app..."
    mkdir -p "$dir"
    composer create-project --prefer-dist laravel/laravel "$dir/app"
    # Copy docker files from template if they exist
    if [ -f "$templates_dir/laravel/Dockerfile" ]; then
      cp "$templates_dir/laravel/Dockerfile" "$dir/"
      cp "$templates_dir/laravel/docker-compose.extra.yml" "$dir/"
    fi
  elif [ -d "$templates_dir/$TEMPLATE" ]; then
    echo "Criando projeto $NAME com template $TEMPLATE..."
    mkdir -p "$dir"
    cp -r "$templates_dir/$TEMPLATE/." "$dir/"
  else
    echo "Erro: Template $TEMPLATE não encontrado em $templates_dir."
    echo "Templates disponíveis: php, static, laravel"
    exit 1
  fi

  # Replace placeholders in project files
  if [ -f "$dir/Dockerfile" ]; then
    sed -i "s/{{PROJECT_NAME}}/$NAME/g" "$dir/Dockerfile"
  fi
  if [ -f "$dir/docker-compose.extra.yml" ]; then
    sed -i "s/{{PROJECT_NAME}}/$NAME/g" "$dir/docker-compose.extra.yml"
  fi

  echo "Projeto $NAME criado em $dir"
  echo "Pode rodar o projeto com \"dev run $NAME\""
}

start_project() {
  NAME=$1
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  local projects_dir="${PROJECTS_DIR:-$base_dir/../projects}"
  local dir="$projects_dir/$NAME"

  if [ ! -d "$dir" ]; then
    echo "Erro: Projeto $NAME não encontrado em $projects_dir"
    exit 1
  fi

  start_platform

  if [ -f "$dir/docker-compose.extra.yml" ]; then
    echo "Iniciando containers extras para $NAME..."
    docker compose -f "$dir/docker-compose.extra.yml" up -d
  fi

  echo "Projeto $NAME rodando em http://$NAME.test/"
}

stop_project() {
  NAME=$1
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  local projects_dir="${PROJECTS_DIR:-$base_dir/../projects}"
  local dir="$projects_dir/$NAME"

  if [ ! -d "$dir" ]; then
    echo "Erro: Projeto $NAME não encontrado em $projects_dir"
    exit 1
  fi

  if [ -f "$dir/docker-compose.extra.yml" ]; then
    docker compose -f "$dir/docker-compose.extra.yml" down
  fi

  echo "Projeto $NAME parado"
}

deploy_project() {
  NAME=$1
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  local projects_dir="${PROJECTS_DIR:-$base_dir/../projects}"
  local dir="$projects_dir/$NAME"

  if [ ! -d "$dir" ]; then
    echo "Erro: Projeto $NAME não encontrado em $projects_dir"
    exit 1
  fi

  if [ -f "$dir/app/artisan" ]; then
    docker exec "${NAME}-php" php /var/www/projects/$NAME/app/artisan optimize
    docker exec "${NAME}-php" php /var/www/projects/$NAME/app/artisan migrate --force
    echo "Deploy Laravel concluído"
  else
    echo "Deploy genérico concluído"
  fi
}

preview_project() {
  NAME=$1
  BRANCH=$2
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local base_dir="${BASE_DIR:-$script_dir/..}"
  local projects_dir="${PROJECTS_DIR:-$base_dir/../projects}"
  local previews_dir="${PREVIEWS_DIR:-$base_dir/../previews}"
  
  local source_dir="$projects_dir/$NAME"
  local target_dir="$previews_dir/${NAME}-${BRANCH}"

  mkdir -p "$previews_dir"

  if [ ! -d "$source_dir" ]; then
    echo "Erro: Projeto $NAME não encontrado em $projects_dir"
    exit 1
  fi

  mkdir -p "$previews_dir"
  cp -r "$source_dir" "$target_dir"
  
  # Update project name in preview files
  if [ -f "$target_dir/Dockerfile" ]; then
    sed -i "s/$NAME/${NAME}-${BRANCH}/g" "$target_dir/Dockerfile"
  fi
  if [ -f "$target_dir/docker-compose.extra.yml" ]; then
    sed -i "s/$NAME/${NAME}-${BRANCH}/g" "$target_dir/docker-compose.extra.yml"
  fi

  echo "Preview criado em $target_dir"
  echo "Acesse em: http://${NAME}-${BRANCH}.preview.test/"
}

run_npm() {
  NAME=$1
  shift
  local project_dir="$PROJECTS_DIR/$NAME"
  local work_dir="$project_dir"
  
  if [ ! -d "$project_dir" ]; then
    echo "Erro: Projeto $NAME não encontrado"
    exit 1
  fi

  # Se existir a pasta app, o npm roda dentro dela
  if [ -d "$project_dir/app" ]; then
    work_dir="$project_dir/app"
  fi
  
  echo "Executando npm em $work_dir..."
  (cd "$work_dir" && npm "$@")
}

run_exec() {
  local target=$1
  shift

  if [ "$target" = "platform" ]; then
    local service=$1
    shift
    local container=""

    case "$service" in
      proxy) container="dev-proxy" ;;
      node)  container="dev-node" ;;
      db)    container="dev-db" ;;
      redis) container="dev-redis" ;;
      *)
        echo "Erro: Serviço platform \"$service\" não reconhecido (use: proxy, node, db, redis)"
        exit 1
        ;;
    esac

    echo "Executando no container $container..."
    docker exec -it "$container" "$@"
  else
    # Se target não for platform, assume que é um projeto
    local project_name=$target
    local container="${project_name}-php"
    local project_root="/var/www/projects/${project_name}"
    local work_dir="$project_root"
    
    # Se existir a pasta app, o WORKDIR é nela
    if [ -d "$PROJECTS_DIR/${project_name}/app" ]; then
      work_dir="${project_root}/app"
    fi
    
    if ! docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
      echo "Erro: Container $container não está rodando."
      exit 1
    fi

    echo "Executando no container $container (dir: $work_dir)..."
    docker exec -it -w "$work_dir" "$container" "$@"
  fi
}
