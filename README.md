# 🚀 Portfolio Platform

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Laravel](https://img.shields.io/badge/laravel-%23FF2D20.svg?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com/)
[![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net/)

> **The Ultimate Local Engineering Ecosystem.** 
> Orchestrate multiple projects with isolated environments, professional routing, and cloud-native concepts directly on your machine.

---

<details open>
<summary><b>🇺🇸 English Version</b></summary>

## 🏛️ Architecture & Vision
This platform is a micro-orchestrator designed for developers who take responsibility and scalability seriously. It's more than a dev environment; it's a local private cloud.

*   **Isolated PHP Instances:** Every project (Laravel/PHP) gets its own dedicated container, preventing version conflicts.
*   **Smart Routing:** Caddy-powered automatic mapping for `*.local` and `*.preview.local` domains.
*   **Infrastructure as Code:** Pre-configured global services (MariaDB, Redis, Adminer) serving as a backbone.

## 🎨 Build your Showcase
Perfect for hosting your technical window. Show the world not just your code, but your ability to manage a full application ecosystem.
*   Deploy high-performance static resumes.
*   Scale complex Laravel dashboards.
*   Experiment with staging environments using the `preview` feature.

## 🐳 Master Docker & DevOps
Deep dive into the heart of modern engineering:
*   **Shared Services vs Isolation:** Learn how to balance global services with isolated app containers.
*   **Networking:** Understand traffic flow between Reverse Proxies and internal networks (`portfolio-dev-net`).
*   **Lifecycle:** Master the full cycle from creation (`new`) to real-time log monitoring and deployment.

## 🚀 Quick Start
```bash
# Start the platform
./platform/dev run platform

# Create a new project
./platform/dev new my-project laravel

# Run and Access (http://my-project.local)
./platform/dev run my-project
```

### Commands Table
| Command | Description |
| :--- | :--- |
| `dev new <name> [template]` | Create project (`php`, `static`, `laravel`). |
| `dev run [name\|platform]` | Start platform or project infra. |
| `dev stop [name\|platform]` | Stop services. |
| `dev restart [name\|platform]` | Quick restart. |
| `dev logs [name\|platform] [-f]` | Tail service logs. |
| `dev deploy <name>` | Laravel-specific deployment routines. |
| `dev preview <name> <branch>` | Create a non-destructive staging copy. |
| `dev npm [name] <command>` | Run npm inside project (uses 'app' folder if it exists). |
| `dev npx [name] <command>` | Run npx inside project (uses 'app' folder if it exists). |
| `dev exec [target] [service] <cmd>` | Execute command in container (uses 'app' folder if it exists). |

</details>

---

<details>
<summary><b>🇧🇷 Versão em Português</b></summary>

## 🏛️ Arquitetura e Visão
Esta plataforma é um micro-orquestrador desenhado para desenvolvedores que levam a sério a responsabilidade e a escalabilidade. É mais que um ambiente de dev; é uma nuvem privada local.

*   **Instâncias PHP Isoladas:** Cada projeto (Laravel/PHP) tem seu container dedicado, evitando conflitos de versão.
*   **Roteamento Inteligente:** Mapeamento automático via Caddy para domínios `*.local` e `*.preview.local`.
*   **Infraestrutura como Código:** Serviços globais pré-configurados (MariaDB, Redis, Adminer) como espinha dorsal.

## 🎨 Construa sua Vitrine
Ideal para hospedar seu currículo técnico. Mostre ao mundo não apenas seu código, mas sua habilidade em gerenciar um ecossistema completo de aplicações.
*   Hospede currículos estáticos de alta performance.
*   Escale dashboards complexos em Laravel.
*   Experimente ambientes de staging usando a funcionalidade de `preview`.

## 🐳 Mestria em Docker & DevOps
Mergulhe no coração da engenharia moderna:
*   **Serviços Compartilhados vs Isolamento:** Aprenda a equilibrar serviços globais com containers de app isolados.
*   **Networking:** Entenda o fluxo de tráfego entre Proxies Reversos e redes internas (`portfolio-dev-net`).
*   **Ciclo de Vida:** Domine o ciclo completo — da criação (`new`) ao monitoramento de logs e deploy.

## 🚀 Início Rápido
```bash
# Inicie a plataforma
./platform/dev run platform

# Crie um novo projeto
./platform/dev new meu-projeto laravel

# Rode e Acesse (http://meu-projeto.local)
./platform/dev run meu-projeto

# Compile assets frontend
./platform/dev npm meu-projeto run dev
```

### Tabela de Comandos
| Comando | Descrição |
| :--- | :--- |
| `dev new <nome> [template]` | Cria projeto (`php`, `static`, `laravel`). |
| `dev run [nome\|platform]` | Inicia a plataforma ou infra do projeto. |
| `dev stop [nome\|platform]` | Para os serviços. **`stop platform` para todos os projetos e previews.** |
| `dev restart [nome\|platform]` | Reinício rápido. |
| `dev logs [nome\|platform] [-f]` | Acompanha logs dos serviços. |
| `dev deploy <nome>` | Rotinas de deploy específicas para Laravel. |
| `dev preview <nome> <branch>` | Cria uma cópia de staging não destrutiva. |
| `dev npm [nome] <comando>` | Roda npm no projeto (usa a pasta 'app' se ela existir). |
| `dev npx [nome] <comando>` | Roda npx no projeto (usa a pasta 'app' se ela existir). |
| `dev exec [alvo] [serviço] <cmd>` | Executa comando no container (usa a pasta 'app' se ela existir). |

## 🛠️ Performance & UX
- **Fast Shutdown:** O serviço `node` está otimizado com `init: true` e `stop_grace_period: 1s` para encerramento imediato.
- **Visual Feedback:** A CLI utiliza logs coloridos (Verde/Vermelho) com suporte a TrueColor (RGB) para visibilidade em qualquer tema de terminal.

</details>

---
*Developed to master the workspace.* 🛠️
