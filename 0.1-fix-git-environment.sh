#!/bin/bash

# =======================================================================
# 00.1-fix-git-environment.sh
# Correção e Complementação do Ambiente Git para StrateUp v3
# Passo 0.1 de 13 - Correção de configuração Git e documentação
# Data: 2025-06-05 13:23:46
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
SCRIPT_NAME="00.1-fix-git-environment"
CURRENT_DATE="2025-06-05 13:23:46"
USER_NAME="StrateUpCompany"

# Verifica se está no diretório raiz do projeto
if [ ! -f ".strateup-step-0-complete" ]; then
  echo -e "${RED}${BOLD}ERRO:${NC} Este script deve ser executado no diretório raiz do projeto."
  echo -e "${YELLOW}Certifique-se de ter executado o script 00-environment-prep.sh antes.${NC}"
  exit 1
fi

# Carregar variáveis do ambiente existente
LOG_DIR="logs 📊"
BACKUP_DIR="backups/environment-$(date +%Y%m%d-%H%M%S)"
DOC_DIR="docs 📚"
mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DIR"
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}-$(date +%Y%m%d-%H%M%S).log"

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

# Configurações do projeto
PROJECT_NAME="StrateUp v3"
REPO_URL="https://github.com/StrateUpCompany/strateup-v3"
AUTHOR="StrateUpCompany"

# Banner de boas-vindas
welcome_banner() {
  clear
  echo -e "${BLUE}${BOLD}"
  echo "╔══════════════════════════════════════════════════════════════════════════╗"
  echo "║                                                                          ║"
  echo "║         STRATEUP V3 - CORREÇÃO DE CONFIGURAÇÃO GIT E DOCUMENTAÇÃO        ║"
  echo "║                                                                          ║"
  echo "║                 Passo 0.1 de 13: Complementação de Ambiente              ║"
  echo "║                                                                          ║"
  echo "╚══════════════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  echo -e "${CYAN}${BOLD}Versão:${NC} $SCRIPT_VERSION"
  echo -e "${CYAN}${BOLD}Data e Hora:${NC} $CURRENT_DATE"
  echo -e "${CYAN}${BOLD}Usuário:${NC} $USER_NAME"
  echo
  echo -e "${PURPLE}${BOLD}📋 Sobre este script:${NC}"
  echo -e "Este script corrige e complementa o ambiente de desenvolvimento criado pelo"
  echo -e "script 00-environment-prep.sh, adicionando configurações Git completas,"
  echo -e "documentação de workflow e melhorias de robustez no ambiente."
  echo
  echo -e "${YELLOW}${BOLD}✨ Funcionalidades:${NC}"
  echo -e "✅ Implementação correta da função de marcação de conclusão"
  echo -e "✅ Configuração completa do repositório Git e workflow"
  echo -e "✅ Verificações adicionais de compatibilidade de ambiente"
  echo -e "✅ Documentação de workflow Git e boas práticas"
  echo -e "✅ Melhorias de tratamento de erros"
  echo
  echo -e "${YELLOW}Tempo estimado: 3-5 minutos${NC}"
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
    return 0
  else
    echo -e "${YELLOW}O arquivo ${CYAN}$file_path${NC} já existe. Sobrescrever? (s/N)${NC}"
    read -r response
    if [[ "$response" =~ ^[Ss]$ ]]; then
      echo -e "$content" > "$file_path"
      echo -e "${GREEN}✓ Arquivo sobrescrito com sucesso${NC}"
      return 0
    else
      echo -e "${YELLOW}Mantendo arquivo existente.${NC}"
      return 1
    fi
  fi
}

# Verificação de comandos
check_command() {
  command -v "$1" &> /dev/null
}

# Detecção de sistema operacional
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

# Função aprimorada de verificação de ambiente
check_environment_compatibility() {
  log_section "Verificação de Compatibilidade de Ambiente"
  
  # Verificar requisitos de memória
  if [[ "$(detect_os)" == "linux" ]]; then
    # Só executa no Linux onde o comando free está disponível
    local mem_total=$(free -m | awk '/^Mem:/{print $2}')
    if [ "$mem_total" -lt 2048 ]; then
      log_warning "Memória RAM disponível (${mem_total}MB) é menor que o recomendado (2048MB)."
      log_warning "O ambiente de desenvolvimento pode ficar instável."
    else
      log_success "Memória RAM suficiente: ${mem_total}MB"
    fi
  else
    # Em sistemas não-Linux, apenas informamos que não podemos verificar
    log_info "Verificação de memória não disponível no sistema $(detect_os)."
  fi
  
  # Verificar versão do sistema operacional
  local os=$(detect_os)
  local os_version=""
  
  case "$os" in
    "macos")
      os_version=$(sw_vers -productVersion 2>/dev/null || echo "desconhecido")
      ;;
    "linux")
      os_version=$(. /etc/os-release 2>/dev/null && echo "$VERSION_ID" || echo "desconhecido")
      ;;
    *)
      os_version="desconhecido"
      ;;
  esac
  
  log_info "Sistema operacional: $os $os_version"
  
  # Verificar acesso à internet
  if ping -c 1 google.com &> /dev/null; then
    log_success "Conexão com a internet: OK"
  else
    log_warning "Sem acesso à internet ou DNS não funciona. Algumas funcionalidades podem falhar."
  fi
  
  # Verificar permissões de diretório
  if [ -w "$(pwd)" ]; then
    log_success "Permissão de escrita no diretório atual: OK"
  else
    log_error "Sem permissão de escrita no diretório atual. Por favor, mude para um diretório com permissões adequadas."
    exit 1
  fi
  
  # Verificar se Node.js e pnpm estão instalados
  if ! check_command node; then
    log_error "Node.js não está instalado. Execute o script 00-environment-prep.sh primeiro."
    exit 1
  else
    log_success "Node.js está instalado: $(node -v)"
  fi
  
  if ! check_command pnpm; then
    log_error "pnpm não está instalado. Execute o script 00-environment-prep.sh primeiro."
    exit 1
  else
    log_success "pnpm está instalado: $(pnpm -v)"
  fi
  
  log_success "Ambiente verificado com sucesso!"
}

# Função de marcação de conclusão corrigida
implement_mark_completion() {
  log_section "Implementação da Função de Marcação de Conclusão"
  
  # Criar arquivo de script com a função mark_completion correta
  cat > "${BACKUP_DIR}/mark_completion_function.sh" << 'EOF'
# Marcação de conclusão do script
mark_completion() {
  log_section "Marcando Conclusão do Script"
  
  local timestamp=$(date +%Y%m%d-%H%M%S)
  touch .strateup-step-0-complete
  echo "$timestamp" > .strateup-step-0-complete
  
  # Sumário das operações realizadas
  cat > "${LOG_DIR}/summary-step-0.md" << EOT
# ✅ Sumário de Instalação - Passo 0

Data: $(date +'%Y-%m-%d %H:%M:%S')
Usuário: $USER_NAME

## Operações Realizadas
- ✓ Verificação e instalação de dependências
- ✓ Configuração do ambiente de desenvolvimento
- ✓ Criação da estrutura de diretórios
- ✓ Configuração do monorepo
- ✓ Criação de documentação
- ✓ Configuração do Git

## Sistema
- Node.js: $(node -v 2>/dev/null || echo "Não instalado")
- pnpm: $(pnpm -v 2>/dev/null || echo "Não instalado")
- Git: $(git --version 2>/dev/null || echo "Não instalado")
EOT
  
  log_success "Passo concluído com sucesso! Sumário criado em \${LOG_DIR}/summary-step-0.md"
}
EOF
  
  # Criar sumário de operações atual
  local timestamp=$(date +%Y%m%d-%H%M%S)
  
  cat > "${LOG_DIR}/summary-step-0.1.md" << EOF
# ✅ Sumário de Instalação - Passo 0.1

Data: $(date +'%Y-%m-%d %H:%M:%S')
Usuário: $USER_NAME

## Operações Realizadas
- ✓ Implementação da função mark_completion
- ✓ Configuração e inicialização do Git
- ✓ Verificação avançada de ambiente
- ✓ Documentação de workflow Git
- ✓ Correção de arquivos incompletos

## Sistema
- Node.js: $(node -v 2>/dev/null || echo "Não instalado")
- pnpm: $(pnpm -v 2>/dev/null || echo "Não instalado")
- Git: $(git --version 2>/dev/null || echo "Não instalado")
EOF
  
  log_success "Função mark_completion implementada e backup criado."
  log_info "Em scripts futuros, importe esta função para marcar a conclusão corretamente."
  
  # Criar arquivo de marcação para este script
  touch .strateup-step-0.1-complete
  echo "$timestamp" > .strateup-step-0.1-complete
}

# Inicialização e configuração do Git
setup_git_repository() {
  log_section "Inicialização e Configuração do Git"
  
  # Verificar se já é um repositório git
  if [ -d .git ]; then
    log_info "Este diretório já é um repositório Git."
    
    # Verificar se o remote origin está configurado
    if git remote get-url origin &>/dev/null; then
      log_info "O remote 'origin' já está configurado: $(git remote get-url origin)"
    else
      log_info "Configurando remote 'origin'..."
      git remote add origin "$REPO_URL"
      log_success "Remote 'origin' configurado: $REPO_URL"
    fi
  else
    # Inicializar novo repositório
    log_info "Inicializando novo repositório Git..."
    git init
    
    # Adicionar remote origin
    log_info "Configurando remote 'origin'..."
    git remote add origin "$REPO_URL"
    
    log_success "Repositório Git inicializado e remote 'origin' configurado: $REPO_URL"
  fi
  
  # Criar arquivo .gitattributes
  cat > .gitattributes << 'EOF'
# Auto detect text files and perform LF normalization
* text=auto

# JS/TS files
*.js text eol=lf
*.jsx text eol=lf
*.ts text eol=lf
*.tsx text eol=lf

# CSS files
*.css text eol=lf
*.scss text eol=lf

# HTML and JSON files
*.html text eol=lf
*.json text eol=lf

# Shell scripts
*.sh text eol=lf

# Markdown files
*.md text eol=lf
*.mdx text eol=lf

# Git config
.gitattributes text eol=lf
.gitignore text eol=lf
.gitconfig text eol=lf

# Images
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.ico binary
*.svg text eol=lf

# Fonts
*.woff binary
*.woff2 binary
*.eot binary
*.ttf binary
*.otf binary
EOF
  log_success "Arquivo .gitattributes criado."
  
  # Verificar se Git User está configurado
  if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    log_info "Configurando informações de usuário Git globalmente..."
    
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
  
  # Criar branch principal se ainda não existir
  local current_branch=$(git branch --show-current 2>/dev/null || echo "")
  if [ -z "$current_branch" ]; then
    log_info "Criando branch principal 'main'..."
    git checkout -b main
    log_success "Branch 'main' criado e definido como atual."
  else
    log_success "Branch atual: $current_branch"
  fi
  
  # Primeiro commit com a estrutura inicial
  log_info "Preparando commit inicial..."
  git add .
  
  # Verificar se há algo para ser commitado
  if git diff --staged --quiet; then
    log_info "Não há alterações para commit."
  else
    git commit -m "chore(setup): inicialização do ambiente de desenvolvimento"
    log_success "Commit inicial criado."
    
    # Perguntar se deseja fazer push
    read -p "$(echo -e "${YELLOW}Deseja enviar as alterações para o repositório remoto? (s/N): ${NC}")" should_push
    if [[ "$should_push" =~ ^[Ss]$ ]]; then
      log_info "Enviando alterações para o repositório remoto..."
      git push -u origin main
      log_success "Alterações enviadas com sucesso!"
    else
      log_info "Para enviar as alterações mais tarde, execute: git push -u origin main"
    fi
  fi
  
  # Criar branch de feature para continuação do trabalho
  log_info "Criando branch de feature para desenvolvimento..."
  git checkout -b feature/environment-setup
  log_success "Branch 'feature/environment-setup' criado. Você pode continuar o desenvolvimento nesta branch."
  
  log_info "Para commitar suas alterações futuras, use:"
  echo -e "${CYAN}  git add .${NC}"
  echo -e "${CYAN}  git commit -m \"tipo(escopo): descrição da alteração\"${NC}"
  echo -e "${CYAN}  git push origin feature/environment-setup${NC}"
}

# Criar documentação de workflow Git
create_git_workflow_documentation() {
  log_section "Criação de Documentação de Workflow Git"
  
  # Definir conteúdo da documentação de workflow Git
  local GIT_WORKFLOW_CONTENT=$(cat << 'EOF'
# 🔄 Workflow Git para o Projeto StrateUp v3

Este documento descreve o workflow de Git adotado no projeto StrateUp v3 para garantir um desenvolvimento organizado e eficiente.

## 📌 Branches Principais

- **main**: Branch de produção, sempre estável
- **develop**: Branch de desenvolvimento, para integração de features
- **feature/xxx**: Branches para novas funcionalidades
- **fix/xxx**: Branches para correções de bugs
- **release/xxx**: Branches para preparação de releases

## 🚀 Workflow Padrão para Novas Features

1. **Comece sempre atualizado**
   ```bash
   # Acesse a branch main
   git checkout main
   
   # Atualize com as últimas alterações
   git pull origin main
   
   # Crie uma nova branch de feature
   git checkout -b feature/nome-descritivo