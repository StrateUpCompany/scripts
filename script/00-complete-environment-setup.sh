#!/bin/bash

# =======================================================================
# 00-complete-environment-setup.sh
# Preparação Completa do Ambiente para StrateUp v3
# Passo 0 de 13 da construção do StrateUp v3
# Data: 2025-06-05 12:09:08
# Autor: StrateUpCompany
# =======================================================================

# Definições de cores e estilos
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Variáveis de controle
SCRIPT_VERSION="1.0.0"
SCRIPT_NAME="00-complete-environment-setup"
LOG_DIR="logs"
BACKUP_DIR="backups/environment-$(date +%Y%m%d-%H%M%S)"
NODE_MIN_VERSION="16.0.0"
PNPM_MIN_VERSION="7.0.0"
CURRENT_DATE="2025-06-05 12:09:08"
USER_NAME="StrateUpCompany"

# Criar diretórios necessários
mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DIR"
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}-$(date +%Y%m%d-%H%M%S).log"

# Arquivos de documentação
DOC_DIR="docs"
DOC_REFERENCES="${DOC_DIR}/references"
DOC_ENVIRONMENT="${DOC_DIR}/environment"
mkdir -p "$DOC_DIR"
mkdir -p "$DOC_REFERENCES"
mkdir -p "$DOC_ENVIRONMENT"

# Configurações do projeto
PROJECT_NAME="StrateUp v3"
REPO_URL="https://github.com/StrateUpCompany/strateup-v3"
AUTHOR="StrateUpCompany"

# Definição de emojis para diretórios
EMOJI_APPS="📱"           # Aplicações
EMOJI_PACKAGES="📦"       # Pacotes
EMOJI_DOCS="📚"           # Documentação
EMOJI_CONFIG="⚙️"         # Configuração
EMOJI_SCRIPTS="🛠️"        # Scripts de automação
EMOJI_LOGS="📊"           # Logs
EMOJI_WEB="🌐"            # App web
EMOJI_ADMIN="👤"          # Painel admin
EMOJI_API="🔌"            # API
EMOJI_AI="🤖"             # Serviço de IA
EMOJI_UI="🎨"             # Biblioteca UI
EMOJI_AUTH="🔒"           # Autenticação
EMOJI_DATABASE="💾"       # Banco de dados
EMOJI_UTILS="🧰"          # Utilitários
EMOJI_MARKETING="📣"      # Marketing
EMOJI_BACKUP="📥"         # Backup

# Banner de boas-vindas
welcome_banner() {
  clear
  echo -e "${BLUE}${BOLD}"
  echo "╔══════════════════════════════════════════════════════════════════════════╗"
  echo "║                                                                          ║"
  echo "║             STRATEUP V3 - PREPARAÇÃO COMPLETA DO AMBIENTE                ║"
  echo "║                                                                          ║"
  echo "║                 Passo 0 de 13: Configuração de Base                      ║"
  echo "║                                                                          ║"
  echo "╚══════════════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  echo -e "${CYAN}${BOLD}Versão:${NC} $SCRIPT_VERSION"
  echo -e "${CYAN}${BOLD}Data e Hora:${NC} $CURRENT_DATE"
  echo -e "${CYAN}${BOLD}Usuário:${NC} $USER_NAME"
  echo
  echo -e "${PURPLE}${BOLD}📋 Sobre este script:${NC}"
  echo -e "Este script realizará a preparação completa do seu ambiente de desenvolvimento"
  echo -e "para o projeto StrateUp v3, verificando e instalando todas as dependências"
  echo -e "necessárias e configurando o ambiente com as melhores práticas do setor."
  echo
  echo -e "${YELLOW}${BOLD}✨ Funcionalidades:${NC}"
  echo -e "✅ Verificação e instalação de dependências (Node.js, pnpm, Git)"
  echo -e "✅ Configuração do ambiente de desenvolvimento"
  echo -e "✅ Criação da estrutura de diretórios do projeto com identificação visual"
  echo -e "✅ Configuração inicial do monorepo com pnpm"
  echo -e "✅ Documentação completa com referências oficiais"
  echo
  echo -e "${RED}${BOLD}⚠️ Requisitos:${NC}"
  echo -e "• Permissões de administrador para instalar pacotes"
  echo -e "• Conexão com a internet"
  echo -e "• Aproximadamente 1GB de espaço em disco"
  echo
  echo -e "${YELLOW}Tempo estimado: 10-15 minutos${NC}"
  echo

  read -p "$(echo -e "${GREEN}Pressione ENTER para continuar ou Ctrl+C para cancelar...${NC}")"
  echo
}

# Funções de log
log() {
  local message="$1"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "$timestamp - $message" >> "$LOG_FILE"
  echo -e "$message"
}

log_section() {
  local section="$1"
  echo >> "$LOG_FILE"
  echo -e "====== $section ======" >> "$LOG_FILE"
  echo
  echo -e "${BLUE}${BOLD}====== $section ======${NC}"
}

log_success() {
  log "${GREEN}✓ $1${NC}"
}

log_warning() {
  log "${YELLOW}⚠️ $1${NC}"
}

log_error() {
  log "${RED}❌ $1${NC}"
}

log_info() {
  log "${CYAN}ℹ️ $1${NC}"
}

# Criar arquivo se não existir
create_file_if_not_exists() {
  local file_path="$1"
  local content="$2"

  # Garantir que o diretório exista
  mkdir -p "$(dirname "$file_path")" 2>/dev/null

  if [ ! -f "$file_path" ]; then
    echo -e "${YELLOW}Criando arquivo: ${CYAN}$file_path${NC}"
    echo -e "$content" > "$file_path"
    echo -e "${GREEN}✓ Arquivo criado com sucesso${NC}"
  else
    echo -e "${YELLOW}O arquivo ${CYAN}$file_path${NC} já existe. Sobrescrever? (s/N)${NC}"
    read -r response
    if [[ "$response" =~ ^[Ss]$ ]]; then
      echo -e "$content" > "$file_path"
      echo -e "${GREEN}✓ Arquivo sobrescrito com sucesso${NC}"
    else
      echo -e "${YELLOW}Mantendo arquivo existente.${NC}"
    fi
  fi
}

# Verificação de comandos
check_command() {
  command -v "$1" &> /dev/null
}

# Verificação de versões
check_node_version() {
  local current_version=$(node -v | sed 's/v//')
  local required_version="$NODE_MIN_VERSION"

  if [[ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" != "$required_version" ]]; then
    return 1
  fi
  return 0
}

check_pnpm_version() {
  local current_version=$(pnpm -v)
  local required_version="$PNPM_MIN_VERSION"

  if [[ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" != "$required_version" ]]; then
    return 1
  fi
  return 0
}

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "linux"
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "windows"
  else
    echo "unknown"
  fi
}

# Verifica os pré-requisitos
check_prerequisites() {
  log_section "Verificação de Pré-requisitos"

  local missing_prereqs=false

  # Verificar Node.js
  if ! check_command node; then
    log_warning "Node.js não encontrado. Será instalado."
    missing_prereqs=true
  elif ! check_node_version; then
    log_warning "Node.js encontrado, mas a versão é muito antiga. Versão mínima: v$NODE_MIN_VERSION"
    missing_prereqs=true
  else
    log_success "Node.js está instalado corretamente: $(node -v)"
  fi

  # Verificar npm
  if ! check_command npm; then
    log_warning "npm não encontrado. Será instalado junto com o Node.js."
    missing_prereqs=true
  else
    log_success "npm está instalado: $(npm -v)"
  fi

  # Verificar pnpm
  if ! check_command pnpm; then
    log_warning "pnpm não encontrado. Será instalado."
    missing_prereqs=true
  elif ! check_pnpm_version; then
    log_warning "pnpm encontrado, mas a versão é muito antiga. Versão mínima: v$PNPM_MIN_VERSION"
    missing_prereqs=true
  else
    log_success "pnpm está instalado corretamente: $(pnpm -v)"
  fi

  # Verificar Git
  if ! check_command git; then
    log_warning "Git não encontrado. Será instalado."
    missing_prereqs=true
  else
    log_success "Git está instalado: $(git --version)"
  fi

  # Verificar Python (para alguns scripts de automação)
  if ! check_command python3; then
    log_warning "Python 3 não encontrado. Recomendamos instalar para scripts auxiliares."
  else
    log_success "Python 3 está instalado: $(python3 --version)"
  fi

  # Verificar espaço em disco
  local available_space=$(df -h . | awk 'NR==2 {print $4}')
  log_info "Espaço em disco disponível: $available_space"

  if [ "$missing_prereqs" = true ]; then
    log_info "Alguns pré-requisitos precisam ser instalados."
    read -p "$(echo -e "${YELLOW}Deseja instalar os pré-requisitos necessários? (s/N): ${NC}")" response
    if [[ ! $response =~ ^[Ss]$ ]]; then
      log_error "Operação cancelada pelo usuário."
      exit 1
    fi
  else
    log_success "Todos os pré-requisitos estão atendidos!"
  fi
}

# Instalação de pré-requisitos
install_prerequisites() {
  log_section "Instalação de Pré-requisitos"

  local os=$(detect_os)
  log_info "Sistema operacional detectado: $os"

  # Instalar Node.js se necessário
  if ! check_command node || ! check_node_version; then
    log_info "Instalando Node.js..."

    case "$os" in
      "macos")
        if check_command brew; then
          brew install node@16
          brew link --overwrite node@16
        else
          log_error "Homebrew não encontrado. Por favor instale o Homebrew primeiro:"
          log_info "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
          exit 1
        fi
        ;;
      "linux")
        curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        sudo apt-get install -y nodejs
        ;;
      "windows")
        log_error "No Windows, por favor instale o Node.js manualmente:"
        log_info "  https://nodejs.org/download/release/latest-v16.x/"
        exit 1
        ;;
      *)
        log_error "Sistema operacional não suportado: $os"
        exit 1
        ;;
    esac

    if check_command node && check_node_version; then
      log_success "Node.js instalado com sucesso: $(node -v)"
    else
      log_error "Falha ao instalar Node.js."
      exit 1
    fi
  fi

  # Instalar pnpm se necessário
  if ! check_command pnpm || ! check_pnpm_version; then
    log_info "Instalando pnpm..."

    npm install -g pnpm@latest

    if check_command pnpm; then
      log_success "pnpm instalado com sucesso: $(pnpm -v)"
    else
      log_error "Falha ao instalar pnpm."
      exit 1
    fi
  fi

  # Instalar outras dependências
  log_info "Instalando outras dependências de desenvolvimento..."

  case "$os" in
    "macos")
      if check_command brew; then
        brew install git python jq
      else
        log_warning "Homebrew não encontrado. Algumas dependências podem não ser instaladas."
      fi
      ;;
    "linux")
      sudo apt-get update
      sudo apt-get install -y git python3 python3-pip jq curl
      ;;
    "windows")
      log_warning "No Windows, instale manualmente: Git, Python, e outras dependências."
      log_info "  Git: https://git-scm.com/download/win"
      log_info "  Python: https://www.python.org/downloads/"
      ;;
  esac

  log_success "Dependências instaladas com sucesso!"
}

# Configurar o ambiente de desenvolvimento
setup_dev_environment() {
  log_section "Configuração do Ambiente de Desenvolvimento"

  # Criar arquivo .nvmrc
  echo "$NODE_MIN_VERSION" > .nvmrc
  log_success "Arquivo .nvmrc criado para Node.js $NODE_MIN_VERSION."

  # Configurar Git
  if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    log_info "Configurando Git globalmente..."

    if [ -z "$(git config --global user.name)" ]; then
      read -p "$(echo -e "${YELLOW}Nome para commits Git (ex: $AUTHOR): ${NC}")" git_name
      git_name=${git_name:-"$AUTHOR"}
      git config --global user.name "$git_name"
    fi

    if [ -z "$(git config --global user.email)" ]; then
      read -p "$(echo -e "${YELLOW}Email para commits Git: ${NC}")" git_email
      git config --global user.email "$git_email"
    fi

    log_success "Git configurado com usuário: $(git config --global user.name)"
  else
    log_success "Git já está configurado com usuário: $(git config --global user.name)"
  fi

  # Configurar pnpm
  log_info "Configurando pnpm..."
  pnpm config set store-dir .pnpm-store

  # Criar arquivo .editorconfig
  cat > .editorconfig << 'EOF'
# EditorConfig is awesome: https://EditorConfig.org

root = true

[*]
end_of_line = lf
insert_final_newline = true
charset = utf-8
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[*.{md,mdx}]
trim_trailing_whitespace = false
EOF
  log_success "Arquivo .editorconfig criado."

  # Criar arquivo .gitignore
  cat > .gitignore << 'EOF'
# Dependências
node_modules/
.pnp/
.pnp.js
.pnpm-store/

# Arquivos de build
.next/
out/
build/
dist/
.turbo/
*.tsbuildinfo

# Arquivos de ambiente
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.env*.local

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# Arquivos de configuração sensíveis
*.pem
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Testes
coverage/
.nyc_output/

# IDEs e Editores
.idea/
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
*.code-workspace

# Mobile
.ionic/
.capacitor/
.gradle/
android/.gradle/
ios/App/Pods/
ios/DerivedData/
EOF
  log_success "Arquivo .gitignore criado."

  # Criar arquivo .env.example com variáveis comuns
  cat > .env.example << 'EOF'
# Ambiente (development, production, test)
NODE_ENV=development

# URLs públicas
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:3002/api

# Supabase (autenticação e banco de dados)
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-supabase-service-key

# WhatsApp Business API
WHATSAPP_API_KEY=your-whatsapp-api-key
WHATSAPP_PHONE_NUMBER_ID=your-whatsapp-phone-id

# Google Business API
GOOGLE_API_KEY=your-google-api-key
GOOGLE_BUSINESS_ACCOUNT_ID=your-google-business-account-id

# Instagram Graph API
INSTAGRAM_API_KEY=your-instagram-api-key
INSTAGRAM_ACCOUNT_ID=your-instagram-account-id

# Analytics
NEXT_PUBLIC_ANALYTICS_ID=your-analytics-id

# Stripe (pagamentos)
STRIPE_SECRET_KEY=your-stripe-secret-key
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key
EOF
  log_success "Arquivo .env.example criado."

  # Copiar .env.example para .env.local
  cp .env.example .env.local
  log_success "Arquivo .env.local criado. Por favor, atualize-o com suas credenciais."

  # Configurar VSCode settings
  mkdir -p .vscode
  cat > .vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "javascript.preferences.importModuleSpecifier": "non-relative",
  "typescript.preferences.importModuleSpecifier": "non-relative",
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/.turbo": true
  },
  "explorer.fileNesting.enabled": true,
  "explorer.fileNesting.patterns": {
    "*.tsx": "${capture}.test.tsx, ${capture}.stories.tsx, ${capture}.styles.ts",
    "*.ts": "${capture}.test.ts, ${capture}.d.ts",
    "package.json": "package-lock.json, yarn.lock, pnpm-lock.yaml, .npmrc"
  },
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorCustomizations": {
    "activityBar.background": "#1E293B",
    "titleBar.activeBackground": "#1E293B",
    "titleBar.activeForeground": "#FFFFFF"
  }
}
EOF

  # Configurar VSCode extensions
  cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-typescript-next",
    "styled-components.vscode-styled-components",
    "PKief.material-icon-theme",
    "streetsidesoftware.code-spell-checker",
    "formulahendry.auto-rename-tag",
    "naumovs.color-highlight",
    "yzhang.markdown-all-in-one",
    "mikestead.dotenv"
  ]
}
EOF

  log_success "Configuração VSCode criada."
  log_success "Ambiente de desenvolvimento configurado com sucesso!"
}

# Criar estrutura de diretórios com emojis
create_directory_structure() {
  log_section "Criação da Estrutura de Diretórios"

  # Criar estrutura principal
  log_info "Criando diretórios principais..."

  # Diretórios raiz
  mkdir -p apps packages docs config scripts logs

  # Renomear para incluir emojis (preservando conteúdo se já existir)
  mv -n apps "apps ${EMOJI_APPS}" 2>/dev/null || true
  mv -n packages "packages ${EMOJI_PACKAGES}" 2>/dev/null || true
  mv -n docs "docs ${EMOJI_DOCS}" 2>/dev/null || true
  mv -n config "config ${EMOJI_CONFIG}" 2>/dev/null || true
  mv -n scripts "scripts ${EMOJI_SCRIPTS}" 2>/dev/null || true
  mv -n logs "logs ${EMOJI_LOGS}" 2>/dev/null || true
  mv -n backups "backups ${EMOJI_BACKUP}" 2>/dev/null || true

  # Criar e renomear diretórios de apps
  mkdir -p "apps ${EMOJI_APPS}/web" "apps ${EMOJI_APPS}/admin" "apps ${EMOJI_APPS}/api" "apps ${EMOJI_APPS}/ai-service"
  mv -n "apps ${EMOJI_APPS}/web" "apps ${EMOJI_APPS}/web ${EMOJI_WEB}" 2>/dev/null || true
  mv -n "apps ${EMOJI_APPS}/admin" "apps ${EMOJI_APPS}/admin ${EMOJI_ADMIN}" 2>/dev/null || true
  mv -n "apps ${EMOJI_APPS}/api" "apps ${EMOJI_APPS}/api ${EMOJI_API}" 2>/dev/null || true
  mv -n "apps ${EMOJI_APPS}/ai-service" "apps ${EMOJI_APPS}/ai-service ${EMOJI_AI}" 2>/dev/null || true

  # Criar e renomear diretórios de pacotes
  mkdir -p "packages ${EMOJI_PACKAGES}/ui" "packages ${EMOJI_PACKAGES}/auth" "packages ${EMOJI_PACKAGES}/database" "packages ${EMOJI_PACKAGES}/utils"
  mv -n "packages ${EMOJI_PACKAGES}/ui" "packages ${EMOJI_PACKAGES}/ui ${EMOJI_UI}" 2>/dev/null || true
  mv -n "packages ${EMOJI_PACKAGES}/auth" "packages ${EMOJI_PACKAGES}/auth ${EMOJI_AUTH}" 2>/dev/null || true
  mv -n "packages ${EMOJI_PACKAGES}/database" "packages ${EMOJI_PACKAGES}/database ${EMOJI_DATABASE}" 2>/dev/null || true
  mv -n "packages ${EMOJI_PACKAGES}/utils" "packages ${EMOJI_PACKAGES}/utils ${EMOJI_UTILS}" 2>/dev/null || true

  # Criar estrutura dentro de cada app
  for app_dir in "apps ${EMOJI_APPS}/"*; do
    if [ -d "$app_dir" ]; then
      mkdir -p "$app_dir/src" "$app_dir/public" "$app_dir/tests"
      touch "$app_dir/src/.gitkeep"
      touch "$app_dir/public/.gitkeep"
      touch "$app_dir/tests/.gitkeep"
    fi
  done

  # Criar estrutura dentro de cada pacote
  for pkg_dir in "packages ${EMOJI_PACKAGES}/"*; do
    if [ -d "$pkg_dir" ]; then
      mkdir -p "$pkg_dir/src" "$pkg_dir/tests"
      touch "$pkg_dir/src/.gitkeep"
      touch "$pkg_dir/tests/.gitkeep"
    fi
  done

  # Criar estrutura de documentação
  mkdir -p "docs ${EMOJI_DOCS}/design" "docs ${EMOJI_DOCS}/api" "docs ${EMOJI_DOCS}/guides" "docs ${EMOJI_DOCS}/architecture"

  log_success "Estrutura de diretórios criada com êxito!"

  # Criar arquivo README.md na raiz de cada diretório principal para documentar
  for dir in "apps ${EMOJI_APPS}" "packages ${EMOJI_PACKAGES}" "docs ${EMOJI_DOCS}" "config ${EMOJI_CONFIG}" "scripts ${EMOJI_SCRIPTS}"; do
    if [ -d "$dir" ]; then
      dir_name=$(echo $dir | cut -d' ' -f1)
      emoji=$(echo $dir | cut -d' ' -f2)

      cat > "$dir/README.md" << EOF
# $emoji $dir_name

> Parte do projeto StrateUp v3, criado em $CURRENT_DATE

## Descrição

Este diretório contém $(case $dir_name in
  "apps") "as aplicações autônomas do projeto StrateUp v3";;
  "packages") "os pacotes compartilhados que são utilizados pelas diferentes aplicações";;
  "docs") "a documentação completa do projeto";;
  "config") "os arquivos de configuração compartilhados";;
  "scripts") "os scripts de automação e utilidades";;
esac)

## Estrutura

\`\`\`
$(find "$dir" -type d | sort | sed 's/^//' | sed 's/[^/]*\//  /g')
\`\`\`

## Links para Documentação
$(case $dir_name in
  "apps") echo "- [Next.js](https://nextjs.org/docs) - Framework para as aplicações web
- [TypeScript](https://www.typescriptlang.org/docs/) - Linguagem utilizada no projeto";;
  "packages") echo "- [pnpm Workspaces](https://pnpm.io/workspaces) - Gerenciamento de monorepo
- [Turborepo](https://turborepo.org/docs) - Ferramenta de otimização de monorepo";;
  "docs") echo "- [Markdown Guide](https://www.markdownguide.org/) - Guia para formatação Markdown
- [Docusaurus](https://docusaurus.io/docs) - Ferramenta para documentação técnica";;
  "config") echo "- [ESLint](https://eslint.org/docs/) - Linting de código JavaScript/TypeScript
- [Prettier](https://prettier.io/docs/en/) - Formatação consistente de código";;
  "scripts") echo "- [Bash Scripting Guide](https://www.gnu.org/software/bash/manual/bash.html) - Guia para scripts bash
- [Node.js CLI](https://nodejs.org/api/cli.html) - Documentação da CLI do Node.js";;
esac)
EOF
    fi
  done

  log_success "README.md criado para cada diretório principal."

  # Criar arquivos base para apps e pacotes
  log_info "Criando arquivos base para apps e pacotes..."

  # Estrutura básica para o app web
  WEB_INDEX_CONTENT=$(cat << 'EOF'
import React from 'react';
import Head from 'next/head';

export default function Home() {
  return (
    <>
      <Head>
        <title>StrateUp v3 - Transforme seu negócio</title>
        <meta name="description" content="Plataforma StrateUp de Marketing e Vendas" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: '100vh',
        padding: '2rem',
        fontFamily: 'Arial, sans-serif'
      }}>
        <div style={{
          maxWidth: '800px',
          textAlign: 'center'
        }}>
          <h1 style={{
            fontSize: '3rem',
            marginBottom: '1rem',
            color: '#0070f3'
          }}>StrateUp v3</h1>

          <p style={{
            fontSize: '1.25rem',
            marginBottom: '2rem',
            color: '#444'
          }}>
            Plataforma de Marketing e Vendas
          </p>

          <div style={{
            display: 'flex',
            flexWrap: 'wrap',
            gap: '1rem',
            justifyContent: 'center',
            marginBottom: '3rem'
          }}>
            <div style={{
              background: '#f0f9ff',
              borderRadius: '8px',
              padding: '1.5rem',
              width: '200px',
              boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
            }}>
              <h3 style={{ color: '#0070f3' }}>📈 Funis de Vendas</h3>
              <p>Personalizados para seu negócio</p>
            </div>

            <div style={{
              background: '#f0f9ff',
              borderRadius: '8px',
              padding: '1.5rem',
              width: '200px',
              boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
            }}>
              <h3 style={{ color: '#0070f3' }}>🤖 Automação</h3>
              <p>WhatsApp e Google Business</p>
            </div>

            <div style={{
              background: '#f0f9ff',
              borderRadius: '8px',
              padding: '1.5rem',
              width: '200px',
              boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
            }}>
              <h3 style={{ color: '#0070f3' }}>📊 Analytics</h3>
              <p>Dados estratégicos em tempo real</p>
            </div>
          </div>

          <p style={{ color: '#666' }}>
            Preparado para transformar seu negócio!
          </p>

          <p style={{
            marginTop: '3rem',
            fontSize: '0.8rem',
            color: '#999'
          }}>
            StrateUp Company © 2025
          </p>
        </div>
      </main>
    </>
  );
}
EOF
)

  # Arquivos para o app web
  create_file_if_not_exists "apps ${EMOJI_APPS}/web ${EMOJI_WEB}/src/pages/index.tsx" "$WEB_INDEX_CONTENT"

  # Estrutura básica para o componente UI
  UI_BUTTON_CONTENT=$(cat << 'EOF'
import React from 'react';
import styled from 'styled-components';

export interface ButtonProps {
  /**
   * Texto do botão
   */
  children: React.ReactNode;

  /**
   * Variante visual do botão
   */
  variant?: 'primary' | 'secondary' | 'outline';

  /**
   * Tamanho do botão
   */
  size?: 'small' | 'medium' | 'large';

  /**
   * Desabilita o botão
   */
  disabled?: boolean;

  /**
   * Callback quando o botão é clicado
   */
  onClick?: () => void;
}

const StyledButton = styled.button<{
  variant: ButtonProps['variant'];
  size: ButtonProps['size'];
}>`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;

  /* Variantes */
  ${({ variant }) =>
    variant === 'primary' && `
      background-color: #0070f3;
      color: white;
      border: none;

      &:hover:not(:disabled) {
        background-color: #0060df;
      }
    `}

  ${({ variant }) =>
    variant === 'secondary' && `
      background-color: #f5f5f5;
      color: #333;
      border: none;

      &:hover:not(:disabled) {
        background-color: #e5e5e5;
      }
    `}

  ${({ variant }) =>
    variant === 'outline' && `
      background-color: transparent;
      color: #0070f3;
      border: 1px solid #0070f3;

      &:hover:not(:disabled) {
        background-color: rgba(0, 112, 243, 0.05);
      }
    `}

  /* Tamanhos */
  ${({ size }) =>
    size === 'small' && `
      padding: 0.375rem 0.75rem;
      font-size: 0.875rem;
    `}

  ${({ size }) =>
    size === 'medium' && `
      padding: 0.5rem 1rem;
      font-size: 1rem;
    `}

  ${({ size }) =>
    size === 'large' && `
      padding: 0.75rem 1.5rem;
      font-size: 1.125rem;
    `}

  /* Estado desabilitado */
  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
`;

/**
 * Componente de botão para ações primárias e secundárias
 */
export const Button = ({
  children,
  variant = 'primary',
  size = 'medium',
  disabled = false,
  onClick,
  ...props
}: ButtonProps) => {
  return (
    <StyledButton
      variant={variant}
      size={size}
      disabled={disabled}
      onClick={onClick}
      {...props}
    >
      {children}
    </StyledButton>
  );
};

export default Button;
EOF
)

  # Criar arquivos para o pacote UI
  create_file_if_not_exists "packages ${EMOJI_PACKAGES}/ui ${EMOJI_UI}/src/components/Button.tsx" "$UI_BUTTON_CONTENT"

  UI_INDEX_CONTENT=$(cat << 'EOF'
// Export components
export * from './components/Button';

// Export version
export const version = '0.1.0';
EOF
)

  create_file_if_not_exists "packages ${EMOJI_PACKAGES}/ui ${EMOJI_UI}/src/index.ts" "$UI_INDEX_CONTENT"

  log_success "Arquivos base para apps e pacotes criados com sucesso!"
}

# Configurar monorepo com pnpm
setup_pnpm_monorepo() {
  log_section "Configuração do Monorepo com PNPM"

  # Criar pnpm-workspace.yaml
  cat > pnpm-workspace.yaml << 'EOF'
packages:
  - 'apps/*'
  - 'packages/*'
EOF
  log_success "Arquivo pnpm-workspace.yaml criado."

  # Criar .npmrc
  cat > .npmrc << 'EOF'
# Configurações recomendadas para monorepo com pnpm
shamefully-hoist=true
strict-peer-dependencies=false
node-linker=hoisted
auto-install-peers=true
prefer-workspace-packages=true
EOF
  log_success "Arquivo .npmrc criado."

  # Criar package.json principal
  cat > package.json << EOF
{
  "name": "strateup-v3",
  "version": "0.1.0",
  "private": true,
  "description": "Plataforma StrateUp de Marketing e Vendas - Monorepo",
  "scripts": {
    "dev": "pnpm run --filter=!./packages/*/eslint-config --filter=!./packages/*/typescript-config dev",
    "build": "pnpm run -r build",
    "start": "pnpm --filter @strateup/web start",
    "lint": "pnpm run -r lint",
    "test": "pnpm run -r test",
    "clean": "pnpm run -r clean && rm -rf node_modules"
  },
  "engines": {
    "node": ">=16.0.0",
    "pnpm": ">=7.0.0"
  },
  "packageManager": "pnpm@10.11.1",
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "author": "$AUTHOR",
  "license": "UNLICENSED",
  "repository": {
    "type": "git",
    "url": "$REPO_URL"
  },
  "devDependencies": {
    "@types/node": "^18.15.3",
    "@types/react": "^18.0.28",
    "@types/react-dom": "^18.0.11",
    "eslint": "^8.36.0",
    "next": "^13.2.4",
    "prettier": "^2.8.8",
    "ts-node-dev": "^2.0.0",
    "tsup": "^6.6.3",
    "typescript": "^4.9.5",
    "turbo": "^1.10.12"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
EOF
  log_success "Arquivo package.json principal criado."

  # Criar turbo.json
  cat > turbo.json << 'EOF'
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "globalEnv": [
    "NODE_ENV",
    "NEXT_PUBLIC_API_URL",
    "NEXT_PUBLIC_SUPABASE_URL",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY"
  ],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "start": {
      "dependsOn": ["build"],
      "cache": false
    },
    "lint": {
      "outputs": []
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"]
    },
    "clean": {
      "cache": false
    }
  }
}
EOF
  log_success "Arquivo turbo.json criado."

  log_success "Monorepo PNPM configurado com sucesso!"
}

# Criar documentação de referência
create_documentation() {
  log_section "Criação de Documentação de Referência"

  # Criar README.md principal
  cat > README.md << EOF
# $PROJECT_NAME - Plataforma de Marketing e Vendas

<div align="center">
  <h3>Transforme sua mente, transforme seus negócios</h3>
</div>

## 🚀 Visão Geral

StrateUp é uma plataforma completa para marketing digital e vendas, projetada para ajudar PMEs a aumentar conversão, otimizar campanhas e gerenciar funis de vendas com tecnologia avançada de IA.

Nosso foco é transformar a realidade de pequenas e médias empresas através de estratégias comprovadas e mensuráveis, com ênfase em:

- $EMOJI_MARKETING Funis de vendas personalizados
- $EMOJI_AI Automação inteligente de WhatsApp e redes sociais
- 🔍 Google Meu Negócio e SEO local
- 📊 Analytics e tomada de decisão baseada em dados

## $EMOJI_PACKAGES Estrutura do Projeto

Este projeto utiliza uma arquitetura monorepo com pnpm:

### $EMOJI_APPS Aplicações

- \`$EMOJI_WEB web\`: Aplicação principal para clientes (Next.js)
- \`$EMOJI_ADMIN admin\`: Painel administrativo para equipe interna (Next.js)
- \`$EMOJI_API api\`: API backend com endpoints RESTful (Next.js API routes)
- \`$EMOJI_AI ai-service\`: Serviço de inteligência artificial para automação

### $EMOJI_PACKAGES Pacotes

- \`$EMOJI_AUTH auth\`: Sistema de autenticação e autorização com Supabase
- \`$EMOJI_DATABASE database\`: Cliente de banco de dados, modelos e utilitários
- \`$EMOJI_UI ui\`: Biblioteca de componentes compartilhados para UI consistente
- \`$EMOJI_UTILS utils\`: Utilitários compartilhados

## 🛠️ Desenvolvimento

### Requisitos

- Node.js 16+
- pnpm 7+
- Git

### Começando

\`\`\`bash
# Clone o repositório
git clone $REPO_URL
cd strateup-v3

# Instale as dependências
pnpm install

# Inicie o ambiente de desenvolvimento
pnpm run dev
\`\`\`

### Scripts Disponíveis

- \`pnpm run dev\` - Inicia todos os apps em modo de desenvolvimento
- \`pnpm run build\` - Constrói todos os apps e pacotes
- \`pnpm run lint\` - Executa linting em todo o código
- \`pnpm run test\` - Executa todos os testes
- \`pnpm run clean\` - Limpa caches e arquivos temporários

### Trabalhando com Pacotes Específicos

\`\`\`bash
# Executar apenas um app específico
pnpm --filter @strateup/web dev

# Adicionar uma dependência a um pacote
pnpm --filter @strateup/ui add [pacote]

# Construir um pacote específico
pnpm --filter @strateup/database build
\`\`\`

## 🏢 Focado em PMEs

A StrateUp é especialmente focada em PMEs que faturam acima de R$100.000,00, com ênfase inicial nos seguintes nichos:

- Oficinas mecânicas e auto elétricas
- Delivery (restaurantes, lanchonetes)
- Salões de beleza e barbearias
- Clínicas dentárias e de estética

## 📄 Licença

Proprietário - StrateUp Company © 2025
EOF
  log_success "README.md principal criado."

  # Criar documentação de referências
  cat > "${DOC_REFERENCES}/tech-stack.md" << 'EOF'
# 📚 Referências Tecnológicas Oficiais

Este documento contém links para as documentações oficiais de todas as tecnologias utilizadas no projeto StrateUp v3.

## 🖥️ Core Technologies

### Node.js
- [Documentação Oficial](https://nodejs.org/docs/)
- [API Reference](https://nodejs.org/api/)
- [Guias](https://nodejs.org/en/learn/)

### TypeScript
- [Documentação Oficial](https://www.typescriptlang.org/docs/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript Declaration Files](https://www.typescriptlang.org/docs/handbook/declaration-files/introduction.html)

### React
- [Documentação Oficial](https://reactjs.org/docs/getting-started.html)
- [React Hooks](https://reactjs.org/docs/hooks-intro.html)
- [React API Reference](https://reactjs.org/docs/react-api.html)

## 📦 Monorepo

### PNPM
- [Documentação Oficial](https://pnpm.io/motivation)
- [Workspaces](https://pnpm.io/workspaces)
- [Configuração](https://pnpm.io/npmrc)

### Turborepo
- [Documentação Oficial](https://turborepo.org/docs)
- [Guia de Início Rápido](https://turborepo.org/docs/getting-started)
- [Configuração](https://turborepo.org/docs/reference/configuration)

## 🌐 Front-end

### Next.js
- [Documentação Oficial](https://nextjs.org/docs)
- [API Routes](https://nextjs.org/docs/api-routes/introduction)
- [Data Fetching](https://nextjs.org/docs/basic-features/data-fetching)

### Styled Components
- [Documentação Oficial](https://styled-components.com/docs)
- [API Reference](https://styled-components.com/docs/api)

## 🔌 Back-end

### Supabase
- [Documentação Oficial](https://supabase.com/docs)
- [JavaScript Client](https://supabase.com/docs/reference/javascript)
- [Autenticação](https://supabase.com/docs/guides/auth)
- [Banco de Dados](https://supabase.com/docs/guides/database)

### API REST
- [MDN Web Docs - HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP)
- [RESTful API Design](https://restfulapi.net/)

## 🔍 Qualidade de Código

### ESLint
- [Documentação Oficial](https://eslint.org/docs/user-guide/getting-started)
- [Regras](https://eslint.org/docs/rules/)
- [Configuração](https://eslint.org/docs/user-guide/configuring/)

### Prettier
- [Documentação Oficial](https://prettier.io/docs/en/)
- [Opções](https://prettier.io/docs/en/options.html)
- [Integração](https://prettier.io/docs/en/integrating-with-linters.html)

## 🧪 Testes

### Jest
- [Documentação Oficial](https://jestjs.io/docs/getting-started)
- [API](https://jestjs.io/docs/api)
- [Expect](https://jestjs.io/docs/expect)

### Testing Library
- [Documentação Oficial](https://testing-library.com/docs/)
- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)

## 🤖 Integrações

### WhatsApp Business API
- [Documentação Oficial](https://developers.facebook.com/docs/whatsapp/api/reference)
- [Webhooks](https://developers.facebook.com/docs/whatsapp/api/webhooks)
- [Mensagens](https://developers.facebook.com/docs/whatsapp/api/messages)

### Google Business API
- [Documentação Oficial](https://developers.google.com/my-business/reference/rest)
- [Guia de Início Rápido](https://developers.google.com/my-business/reference/rest/v4/accounts/list)

### Stripe (Pagamentos)
- [Documentação Oficial](https://stripe.com/docs/api)
- [Stripe.js & Elements](https://stripe.com/docs/js)
- [Checkout](https://stripe.com/docs/payments/checkout)
EOF
  log_success "Documentação de referências tecnológicas criada."

  # Criar documentação do ambiente
  cat > "${DOC_ENVIRONMENT}/environment-info.md" << EOF
# 🛠️ Ambiente de Desenvolvimento StrateUp v3

Este documento contém informações sobre o ambiente de desenvolvimento configurado para o projeto StrateUp v3.

## 📋 Informações do Sistema

- **Data de Configuração:** $CURRENT_DATE
- **Configurado por:** $AUTHOR
- **Sistema Operacional:** $(uname -s 2>/dev/null || echo "Desconhecido") $(uname -r 2>/dev/null || echo "")
- **Arquitetura:** $(uname -m 2>/dev/null || echo "Desconhecida")

## 📦 Dependências Instaladas

- **Node.js:** $(node -v 2>/dev/null || echo "Não instalado")
- **npm:** $(npm -v 2>/dev/null || echo "Não instalado")
- **pnpm:** $(pnpm -v 2>/dev/null || echo "Não instalado")
- **Git:** $(git --version 2>/dev/null || echo "Não instalado")

## 🗂️ Estrutura de Diretórios

A estrutura de diretórios segue o padrão de monorepo, com emojis para identificação visual:

- $EMOJI_APPS \`apps/\`: Aplicações autônomas
  - $EMOJI_WEB \`web/\`: Aplicação web principal
  - $EMOJI_ADMIN \`admin/\`: Painel administrativo
  - $EMOJI_API \`api/\`: API backend
  - $EMOJI_AI \`ai-service/\`: Serviço de IA

- $EMOJI_PACKAGES \`packages/\`: Pacotes compartilhados
  - $EMOJI_UI \`ui/\`: Biblioteca de componentes UI
  - $EMOJI_AUTH \`auth/\`: Sistema de autenticação
  - $EMOJI_DATABASE \`database/\`: Acesso ao banco de dados
  - $EMOJI_UTILS \`utils/\`: Utilitários compartilhados

## ⚙️ Configurações

- **Node.js:** Versão mínima $NODE_MIN_VERSION (configurada em .nvmrc)
- **pnpm:** Versão mínima $PNPM_MIN_VERSION
- **Monorepo:** Configurado com pnpm workspaces e Turborepo

## 📝 Variáveis de Ambiente

As variáveis de ambiente estão configuradas no arquivo \`.env.local\`. Certifique-se de que as seguintes variáveis estejam definidas:

- \`NEXT_PUBLIC_APP_URL\`: URL da aplicação web
- \`NEXT_PUBLIC_API_URL\`: URL da API
- \`NEXT_PUBLIC_SUPABASE_URL\`: URL do projeto Supabase
- \`NEXT_PUBLIC_SUPABASE_ANON_KEY\`: Chave anônima do Supabase

## 🚀 Próximos Passos

1. Execute \`pnpm install\` para instalar todas as dependências
2. Configure as variáveis de ambiente no arquivo \`.env.local\`
3. Execute \`pnpm run dev\` para iniciar o ambiente de desenvolvimento
4. Continue com o próximo script da série: \`01-project-init.sh\`

## 🔍 Problemas Comuns e Soluções

### Problemas de Instalação de Dependências

- **Erro: EACCES ao instalar globalmente**:
\`\`\`
npm ERR! code EACCES
npm ERR! syscall mkdir
npm ERR! path /usr/local/lib/node_modules
\`\`\`
**Solução**: Execute \`sudo npm install -g pnpm\` ou configure o npm para usar um diretório de usuário global.

### Problemas com o pnpm

- **Erro: Cannot find module**:
\`\`\`
Error: Cannot find module '/path/to/module'
\`\`\`
**Solução**: Execute \`pnpm install\` para garantir que todas as dependências estejam instaladas corretamente.

- **Erro: Unsupported engine**:
\`\`\`
WARN Unsupported engine: wanted: {"node":">=16.0.0"} (current: {"node":"14.x.x"})
\`\`\`
**Solução**: Atualize o Node.js para a versão 16 ou superior, ou use nvm para alternar entre versões.

### Problemas de Porta em Uso

- **Erro: Port XXXX is already in use**:
\`\`\`
Error: listen EADDRINUSE: address already in use 127.0.0.1:3000
\`\`\`
**Solução**: Encerre o processo que está usando a porta ou altere a porta nos scripts de desenvolvimento.

## 📚 Recursos Adicionais

- [Documentação do pnpm](https://pnpm.io/)
- [Documentação do Next.js](https://nextjs.org/docs)
- [Documentação do Supabase](https://supabase.com/docs)
- [Guia de Contribuição](../CONTRIBUTING.md)
EOF
  log_success "Documentação do ambiente de desenvolvimento criada."

  # Criar guia de contribuição completo
  cat > "CONTRIBUTING.md" << 'EOF'
# 🤝 Guia de Contribuição para StrateUp v3

Obrigado pelo interesse em contribuir para o StrateUp v3! Este guia fornece instruções detalhadas para contribuir com o projeto.

## 🚀 Começando

### Pré-requisitos

- Node.js 16 ou superior
- pnpm 7 ou superior
- Git

### Configuração do ambiente de desenvolvimento

1. Clone o repositório:
```bash
git clone https://github.com/StrateUpCompany/strateup-v3.git
cd strateup-v3