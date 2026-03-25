# Portfolio Platform - Próximos Passos (TODO)

Este documento lista as melhorias planejadas para o micro-orquestrador `platform/dev`. Contribuições são bem-vindas! Cada tarefa concluída deve resultar em um incremento de versão **minor** (ex: v1.1.0 -> v1.2.0).

---

## 🚀 Novos Templates para `platform/dev new`

O objetivo é expandir o comando `dev new <nome> <template>` para suportar mais stacks tecnológicas, seguindo o isolamento em containers e roteamento automático via Caddy.

### 🐍 1. Django (Python)
Implementar o template para o framework Django.
- **Tarefa:** Criar pasta `platform/templates/django/`.
- **Conteúdo:** `Dockerfile` (Python + Gunicorn/Uvicorn), `docker-compose.extra.yml`.
- **Lógica no `lib/project.sh`:** Utilizar `pip install django` e `django-admin startproject app .` para inicializar o projeto na pasta `app/`.
- **Requisito:** O container deve expor a porta 8000 para o Caddy.

### ⚡ 2. FastAPI (Python)
Implementar o template para FastAPI, focado em alta performance.
- **Tarefa:** Criar pasta `platform/templates/fastapi/`.
- **Conteúdo:** `Dockerfile` (Python + Uvicorn), `docker-compose.extra.yml`.
- **Lógica no `lib/project.sh`:** Inicializar uma estrutura básica com `main.py` e um `requirements.txt`.
- **Requisito:** Suporte a Hot Reload durante o desenvolvimento no volume montado.

### 🦁 3. NestJS (Node.js/TypeScript)
Implementar o template para NestJS, ideal para backends escaláveis em Node.
- **Tarefa:** Criar pasta `platform/templates/nestjs/`.
- **Conteúdo:** `Dockerfile` (Node.js), `docker-compose.extra.yml`.
- **Lógica no `lib/project.sh`:** Utilizar `npx @nestjs/cli new app --package-manager npm` para gerar o boilerplate.
- **Requisito:** Garantir que o `npm run start:dev` funcione corretamente dentro do container.

### 🍃 4. Spring Boot (Java/Kotlin)
Implementar o template para Spring Boot.
- **Tarefa:** Criar pasta `platform/templates/springboot/`.
- **Conteúdo:** `Dockerfile` (OpenJDK), `docker-compose.extra.yml`.
- **Lógica no `lib/project.sh`:** Utilizar o [Spring Initializr](https://start.spring.io/) via `curl` para baixar o projeto base e descompactar na pasta `app/`.
- **Requisito:** Configurar o `entrypoint` para usar Maven Wrapper ou Gradle Wrapper.

---

## 💡 Ideias de Novos Templates

Aqui estão algumas sugestões extras para quem quiser contribuir com algo diferente:

*   **Next.js (React):** Template pré-configurado com Tailwind CSS e App Router (`npx create-next-app`).
*   **Go Fiber:** Template minimalista para APIs em Go usando o framework Fiber.
*   **Ruby on Rails:** Template clássico de Rails com suporte a PostgreSQL/Redis.
*   **Static + Tailwind:** Um upgrade do template `static` atual, já vindo com CLI do Tailwind configurado.
*   **Astro:** Para sites estáticos ou híbridos focados em performance.

---

## 🛠 Como Implementar um Novo Template

1.  Crie uma pasta em `platform/templates/<nome-do-template>`.
2.  Adicione um `Dockerfile` e um `docker-compose.extra.yml` (use os placeholders `{{PROJECT_NAME}}`).
3.  Edite `platform/lib/project.sh`:
    - Adicione a lógica de criação dentro da função `create_project`.
    - Se o template exigir um comando de CLI externo (ex: `composer`, `django-admin`), certifique-se de que ele esteja disponível no ambiente ou rode via container temporário.
4.  Atualize a mensagem de ajuda no `platform/dev` para incluir o novo template.
5.  Teste com: `platform/dev new meu-projeto <nome-do-template>`.
