#!/bin/bash
# =======================================================================
# SCRIPT: environment-validation.sh
# DESCRIÇÃO: Validação do ambiente de desenvolvimento StrateUp
# AUTOR: StrateUpCompany
# DATA: 2025-06-05
# VERSÃO: 1.0.0
# 
# VISÃO STRATEUP:
# "Transforme sua mente, transforme sua vida com estratégias reais 
# e resultados mensuráveis"
# =======================================================================

# Definições de cores com a identidade visual da StrateUp
STRATEUP_BLUE='\033[0;34m'    # Azul primário da marca
STRATEUP_GREEN='\033[0;32m'   # Verde de sucesso e transformação
STRATEUP_GOLD='\033[0;33m'    # Dourado para insights estratégicos
STRATEUP_RED='\033[0;31m'     # Vermelho para alertas importantes
BOLD='\033[1m'
NC='\033[0m'  # No Color

# Criar diretório para logs e métricas
LOG_DIR="logs"
METRICS_DIR="metrics"
mkdir -p "$LOG_DIR" "$METRICS_DIR"
LOG_FILE="$LOG_DIR/environment-validation-$(date +%Y%m%d-%H%M%S).log"

# Início do banner StrateUp com elementos visuais distintivos
echo -e "${STRATEUP_BLUE}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║                                                                   ║"
echo "║   ███████╗████████╗██████╗  █████╗ ████████╗███████╗██╗   ██╗██████╗    ║"
echo "║   ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║   ██║██╔══██╗   ║"
echo "║   ███████╗   ██║   ██████╔╝███████║   ██║   █████╗  ██║   ██║██████╔╝   ║"
echo "║   ╚════██║   ██║   ██╔══██╗██╔══██║   ██║   ██╔══╝  ██║   ██║██╔═══╝    ║"
echo "║   ███████║   ██║   ██║  ██║██║  ██║   ██║   ███████╗╚██████╔╝██║        ║"
echo "║   ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚═╝        ║"
echo "║                                                                   ║"
echo "║               Transformação · Estratégia · Resultados             ║"
echo "║                                                                   ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Função de logging com estilo StrateUp
log_strateup() {
  local level="$1"
  local message="$2"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local color=""
  
  case "$level" in
    "INFO") color="${STRATEUP_BLUE}" ;;
    "SUCCESS") color="${STRATEUP_GREEN}" ;;
    "STRATEGY") color="${STRATEUP_GOLD}" ;;
    "WARNING") color="${STRATEUP_GOLD}" ;;
    "ERROR") color="${STRATEUP_RED}" ;;
    *) color="${NC}" ;;
  esac
  
  echo -e "[${timestamp}] [${color}${level}${NC}] ${message}" | tee -a "$LOG_FILE"
}

# Mensagem de boas-vindas orientada à transformação
log_strateup "STRATEGY" "${BOLD}Iniciando a jornada de transformação digital StrateUp v3${NC}"
log_strateup "INFO" "Este script validará o ambiente para garantir uma base sólida - a organização é o alicerce do sucesso."

# Validar Node.js com detecção e sugestões reais (alinhado ao valor de resultados)
log_strateup "INFO" "Verificando se Node.js está instalado..."
if command -v node &> /dev/null; then
  node_version=$(node -v | cut -d 'v' -f2)
  required_version="18.0.0"
  
  if [[ $(printf '%s\n' "$required_version" "$node_version" | sort -V | head -n1) == "$required_version" ]]; then
    log_strateup "SUCCESS" "Node.js v${node_version} detectado e atende aos requisitos ✓"
  else
    log_strateup "WARNING" "Node.js v${node_version} detectado, mas v${required_version}+ é recomendado para melhor performance."
    log_strateup "STRATEGY" "💡 Estratégia: Atualize o Node.js para garantir otimização e evitar problemas futuros."
    log_strateup "INFO" "Execute: nvm install ${required_version} && nvm use ${required_version}"
  fi
else
  log_strateup "ERROR" "Node.js não encontrado. Necessário para continuar."
  log_strateup "STRATEGY" "💡 Estratégia de resolução:"
  log_strateup "INFO" "1. Instale o NVM: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash"
  log_strateup "INFO" "2. Instale Node.js: nvm install ${required_version}"
  log_strateup "INFO" "3. Execute este script novamente após a instalação"
  exit 1
fi

# Validar gerenciador de pacotes
log_strateup "INFO" "Verificando gerenciador de pacotes..."
if command -v pnpm &> /dev/null; then
  pnpm_version=$(pnpm --version)
  log_strateup "SUCCESS" "pnpm ${pnpm_version} detectado ✓"
elif command -v yarn &> /dev/null; then
  yarn_version=$(yarn --version)
  log_strateup "SUCCESS" "yarn ${yarn_version} detectado ✓"
  log_strateup "STRATEGY" "💡 Recomendamos migrar para pnpm para melhor performance e economia de disco."
elif command -v npm &> /dev/null; then
  npm_version=$(npm --version)
  log_strateup "SUCCESS" "npm ${npm_version} detectado ✓"
  log_strateup "STRATEGY" "💡 Recomendamos migrar para pnpm para melhor performance e economia de disco."
else
  log_strateup "ERROR" "Nenhum gerenciador de pacotes detectado. Instale npm, yarn ou pnpm."
  exit 1
fi

# Validar Git
log_strateup "INFO" "Verificando instalação do Git..."
if command -v git &> /dev/null; then
  git_version=$(git --version | cut -d ' ' -f3)
  log_strateup "SUCCESS" "Git ${git_version} detectado ✓"
  
  # Verificar configuração do Git (essencial para colaboração autêntica - valor da StrateUp)
  if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    log_strateup "WARNING" "Git não está completamente configurado com suas credenciais."
    log_strateup "STRATEGY" "💡 A autenticidade é um valor essencial. Configure seu Git:"
    log_strateup "INFO" "  git config --global user.name \"Seu Nome\""
    log_strateup "INFO" "  git config --global user.email \"seu.email@exemplo.com\""
  fi
else
  log_strateup "ERROR" "Git não encontrado. Necessário para controle de versão e colaboração."
  log_strateup "STRATEGY" "💡 Instale o Git antes de continuar:"
  log_strateup "INFO" "  https://git-scm.com/downloads"
  exit 1
fi

# Verificar Docker (opcional mas recomendado)
log_strateup "INFO" "Verificando instalação do Docker..."
if command -v docker &> /dev/null; then
  docker_version=$(docker --version | cut -d ' ' -f3 | tr -d ',')
  log_strateup "SUCCESS" "Docker ${docker_version} detectado ✓"
else
  log_strateup "WARNING" "Docker não encontrado. Recomendado para ambientes consistentes."
  log_strateup "STRATEGY" "💡 Docker permite replicar ambientes consistentemente - fundamental para resultados previsíveis."
  log_strateup "INFO" "  https://docs.docker.com/get-docker/"
fi

# Verificar espaço em disco (essencial para prevenção de problemas)
log_strateup "INFO" "Verificando espaço em disco disponível..."
available_space=$(df -h . | awk 'NR==2 {print $4}')
available_inodes=$(df -i . | awk 'NR==2 {print $4}')

log_strateup "INFO" "Espaço disponível: ${available_space} (blocos), ${available_inodes} (inodes)"

# Use uma métrica de número de blocos para comparação em vez de interpretar unidades
available_blocks=$(df . | awk 'NR==2 {print $4}')
if [ "$available_blocks" -lt 5000000 ]; then  # aproximadamente 5GB
  log_strateup "WARNING" "Espaço em disco limitado. StrateUp v3 funciona melhor com pelo menos 10GB livres."
  log_strateup "STRATEGY" "💡 Otimização é importante! Considere liberar espaço para evitar problemas futuros."
else
  log_strateup "SUCCESS" "Espaço em disco adequado para desenvolvimento ✓"
fi

# Verificar conexão com internet (crucial para desenvolvimento)
log_strateup "INFO" "Verificando conexão com internet..."
if ping -c 1 google.com &> /dev/null || ping -c 1 github.com &> /dev/null; then
  log_strateup "SUCCESS" "Conexão com internet estabelecida ✓"
else
  log_strateup "ERROR" "Sem conexão com internet. Necessária para download de dependências."
  exit 1
fi

# Verificar resolução de tela para desenvolvimento de UX (foco em UX desde o início)
if command -v xdpyinfo &> /dev/null; then
  resolution=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
  log_strateup "INFO" "Resolução de tela: ${resolution}"
  
  width=$(echo $resolution | cut -d'x' -f1)
  if [ "$width" -lt 1366 ]; then
    log_strateup "WARNING" "Resolução abaixo do ideal para desenvolvimento de UX."
    log_strateup "STRATEGY" "💡 Para uma melhor experiência de desenvolvimento de UX, recomendamos resolução mínima de 1366x768."
  else
    log_strateup "SUCCESS" "Resolução adequada para desenvolvimento de UX ✓"
  fi
fi

# Criar arquivo de configuração com estilo StrateUp
log_strateup "INFO" "Criando arquivo de configuração do ambiente StrateUp..."

cat > .strateup-env.json << EOF
{
  "environment": {
    "validated": true,
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "node": "${node_version}",
    "packageManager": "${pnpm_version:-${yarn_version:-${npm_version}}}",
    "git": "${git_version}",
    "docker": "${docker_version:-"not installed"}",
    "resolution": "${resolution:-"unknown"}",
    "availableSpace": "${available_space}"
  },
  "branding": {
    "colors": {
      "primary": "#0062FF",
      "secondary": "#00D68F",
      "accent": "#FFB400",
      "warning": "#FF3D71",
      "info": "#0095FF",
      "success": "#00D68F",
      "background": "#FFFFFF",
      "text": "#222B45"
    },
    "typography": {
      "primaryFont": "Montserrat, sans-serif",
      "secondaryFont": "Inter, sans-serif"
    }
  },
  "ux": {
    "designSystem": "https://www.figma.com/file/strateup-design-system",
    "responsive": {
      "breakpoints": {
        "xs": "320px",
        "sm": "576px",
        "md": "768px",
        "lg": "992px",
        "xl": "1200px"
      }
    },
    "interactions": {
      "animationDuration": "0.3s",
      "hoverEffect": "scale(1.03)"
    }
  },
  "values": [
    "Autenticidade",
    "Transparência",
    "Honestidade",
    "Paixão",
    "Energia",
    "Positividade",
    "Foco em Resultados",
    "Organização",
    "Ética",
    "Desenvolvimento Humano"
  ]
}
EOF

log_strateup "SUCCESS" "Arquivo de configuração criado com valores e identidade StrateUp ✓"

# Resumo final com toque estratégico da StrateUp
echo -e "\n${STRATEUP_BLUE}${BOLD}════════ RESULTADOS DA VALIDAÇÃO ════════${NC}"
log_strateup "SUCCESS" "✓ Ambiente validado com sucesso!"
log_strateup "INFO" "Próximo passo: Execute o script 0.1-dependency-installation.sh"
log_strateup "STRATEGY" "💡 Lembre-se: 'A organização é o alicerce de qualquer projeto de sucesso.' - StrateUp"

# Coleta de métricas para análise futura (alinhado ao valor de métricas e resultados)
{
  echo "SCRIPT_NAME=environment-validation.sh"
  echo "EXECUTION_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "SUCCESS=true"
  echo "NODE_VERSION=${node_version}"
  echo "GIT_VERSION=${git_version}"
  echo "PACKAGE_MANAGER=${pnpm_version:-${yarn_version:-${npm_version}}}"
  echo "DOCKER_AVAILABLE=${docker_version:-false}"
} > "$METRICS_DIR/environment-validation-$(date +%Y%m%d-%H%M%S).metrics"

exit 0