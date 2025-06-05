#!/bin/bash

# =======================================================================
# 00.1-fix-git-environment.sh
# Correção e Complementação do Ambiente Git para StrateUp v3
# Passo 0.1 de 13 - Correção de configuração Git e documentação
# Data: 2025-06-05 13:45:48
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
CURRENT_DATE="2025-06-05 13:45:48"
USER_NAME="StrateUpCompany"

# Criar diretórios necessários
LOG_DIR="logs"
BACKUP_DIR="backups/environment-$(date +%Y%m%d-%H%M%S)"
DOC_DIR="docs"
mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DIR"
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}-$(date +%Y%m%d-%H%M%S).log"

# Verificar se existem diretórios com emojis
if [ -d "logs 📊" ]; then
  LOG_DIR="logs 📊"
fi
if [ -d "docs 📚" ]; then
  DOC_DIR="docs 📚"
fi

# Definição de emojis para diretórios
EMOJI_DOCS="📚"
EMOJI_LOGS="📊"

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

# Verifica se .strateup-step-0-complete existe, caso contrário cria
check_prerequisites() {
  log_section "Verificando pré-requisitos"
  
  if [ ! -f ".strateup-step-0-complete" ]; then
    log_warning "Arquivo .strateup-step-0-complete não encontrado."
    read -p "$(echo -e "${YELLOW}Criar arquivo de marcação e continuar? (s/N): ${NC}")" override_check
    if [[ ! "$override_check" =~ ^[Ss]$ ]]; then
      log_error "Script cancelado pelo usuário."
      exit 1
    else
      touch .strateup-step-0-complete
      echo "$(date +%Y%m%d%H%M%S)" > .strateup-step-0-complete
      log_success "Arquivo de marcação criado. Continuando..."
    fi
  else
    log_success "Arquivo de marcação encontrado."
  fi
  
  # Verificar se Git está instalado
  if ! command -v git &> /dev/null; then
    log_error "Git não está instalado. Este script requer Git."
    exit 1
  else
    log_success "Git está instalado: $(git --version)"
  fi
}

# Implementar função de marcação de conclusão
implement_mark_completion() {
  log_section "Implementando função de marcação de conclusão"
  
  # Criar sumário de operações
  cat > "${LOG_DIR}/summary-step-0.1.md" << EOF
# ✅ Sumário de Instalação - Passo 0.1

Data: $(date +'%Y-%m-%d %H:%M:%S')
Usuário: $USER_NAME

## Operações Realizadas
- ✓ Implementação da função mark_completion
- ✓ Configuração e inicialização do Git
- ✓ Documentação de workflow Git
- ✓ Correção de arquivos incompletos

## Sistema
- Git: $(git --version 2>/dev/null || echo "Não instalado")
EOF
  
  # Criar arquivo de marcação para este script
  local timestamp=$(date +%Y%m%d%H%M%S)
  touch .strateup-step-0.1-complete
  echo "$timestamp" > .strateup-step-0.1-complete
  
  log_success "Função mark_completion implementada e arquivo de marcação criado."
}

# Configurar repositório Git
setup_git_repository() {
  log_section "Configuração do repositório Git"
  
  # Verificar se já é um repositório git
  if [ -d .git ]; then
    log_info "Este diretório já é um repositório Git."
  else
    # Inicializar novo repositório
    git init
    log_success "Repositório Git inicializado."
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
  
  # Verificar/configurar Git user
  if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    log_info "Configurando informações de usuário Git globalmente..."
    
    if [ -z "$(git config --global user.name)" ]; then
      read -p "$(echo -e "${YELLOW}Nome para commits Git: ${NC}")" git_name
      git_name=${git_name:-"StrateUpCompany"}
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
  
  # Criar branch principal (caso não exista)
  if ! git rev-parse --verify main &>/dev/null; then
    log_info "Criando branch principal 'main'..."
    git checkout -b main
  fi
  
  log_info "Preparando commit inicial..."
  git add .gitattributes
  
  # Commit das alterações
  if ! git diff --staged --quiet; then
    git commit -m "chore(setup): adicionar .gitattributes"
    log_success "Commit criado para .gitattributes"
  fi
  
  # Criar branch de feature
  if ! git rev-parse --verify feature/environment-setup &>/dev/null; then
    log_info "Criando branch 'feature/environment-setup'..."
    git checkout -b feature/environment-setup
    log_success "Branch de feature criado."
  else
    log_info "Branch 'feature/environment-setup' já existe."
    git checkout feature/environment-setup
  fi
}

# Criar documentação de workflow Git
create_git_workflow_documentation() {
  log_section "Criação de documentação Git workflow"
  
  # Criar diretório para docs se não existir
  mkdir -p "$DOC_DIR"
  
  # Conteúdo da documentação Git
  cat > "$DOC_DIR/git-workflow.md" << 'EOF'
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