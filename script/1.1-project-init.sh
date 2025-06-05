#!/bin/bash

# =======================================================================
# 1.1-project-init.sh
# Integração de Pacotes e Preparação para Apps do StrateUp v3
# Passo 1.1 de 13 da construção do StrateUp v3
# Data: 2025-06-05 16:21:10
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
SCRIPT_NAME="1.1-project-init"
CURRENT_DATE="2025-06-05 16:21:10"
USER_NAME="StrateUpCompany"

# Verificar se estamos no diretório raiz do projeto
if [ ! -f ".strateup-step-1-complete" ]; then
  echo -e "${RED}${BOLD}ERRO:${NC} Este script deve ser executado no diretório raiz do projeto."
  echo -e "${YELLOW}Execute primeiro o script 01-project-init.sh.${NC}"
  
  read -p "$(echo -e "${YELLOW}Ignorar esta verificação e continuar? (s/N): ${NC}")" override_check
  if [[ ! "$override_check" =~ ^[Ss]$ ]]; then
    exit 1
  else
    touch .strateup-step-1-complete
    echo "$(date +%Y%m%d%H%M%S)" > .strateup-step-1-complete
    echo -e "${GREEN}Verificação ignorada. Continuando...${NC}"
  fi
fi

# Criar diretório de logs se não existir
LOG_DIR="logs"
[ -d "logs 📊" ] && LOG_DIR="logs 📊"
BACKUP_DIR="backups/project-init-extended-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DIR"
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}-$(date +%Y%m%d-%H%M%S).log"

# Definição de diretórios com emojis
DOC_DIR="docs"
[ -d "docs 📚" ] && DOC_DIR="docs 📚"

APPS_DIR="apps"
PACKAGES_DIR="packages"
[ -d "apps 📱" ] && APPS_DIR="apps 📱"
[ -d "packages 📦" ] && PACKAGES_DIR="packages 📦"

EMOJI_APPS="📱"
EMOJI_PACKAGES="📦"
EMOJI_UI="🎨"
EMOJI_UTILS="🧰"
EMOJI_AUTH="🔒"
EMOJI_DATABASE="💾"

# Banner de boas-vindas
welcome_banner() {
  clear
  echo -e "${BLUE}${BOLD}"
  echo "╔══════════════════════════════════════════════════════════════════════════╗"
  echo "║                                                                          ║"
  echo "║       STRATEUP V3 - INTEGRAÇÃO DE PACOTES E PREPARAÇÃO PARA APPS         ║"
  echo "║                                                                          ║"
  echo "║                  Passo 1.1 de 13: Extensão da Base                       ║"
  echo "║                                                                          ║"
  echo "╚══════════════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  echo -e "${CYAN}${BOLD}Versão:${NC} $SCRIPT_VERSION"
  echo -e "${CYAN}${BOLD}Data e Hora:${NC} $CURRENT_DATE"
  echo -e "${CYAN}${BOLD}Usuário:${NC} $USER_NAME"
  echo
  echo -e "${PURPLE}${BOLD}📋 Sobre este script:${NC}"
  echo -e "Este script complementa a configuração inicial do projeto StrateUp v3,"
  echo -e "focando na integração entre pacotes, aprimoramento dos componentes UI,"
  echo -e "criação de documentação arquitetural e preparação de templates para apps."
  echo
  echo -e "${YELLOW}${BOLD}✨ Funcionalidades:${NC}"
  echo -e "✅ Integração prática entre pacotes compartilhados"
  echo -e "✅ Expansão da biblioteca de componentes UI"
  echo -e "✅ Documentação arquitetural detalhada"
  echo -e "✅ Otimização de builds para diferentes ambientes"
  echo -e "✅ Templates de scaffolding para os próximos apps"
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

# Verificar pré-requisitos
check_prerequisites() {
  log_section "Verificação de Pré-requisitos"
  
  local all_good=true
  
  # Verificar pacotes importantes
  for pkg in "tsconfig" "eslint-config-custom" "ui" "utils"; do
    # Verificar com e sem emoji
    local pkg_found=false
    if [ -d "${PACKAGES_DIR}/$pkg" ] || [ -d "${PACKAGES_DIR}/$pkg ${EMOJI_UI}" ] || [ -d "${PACKAGES_DIR}/$pkg ${EMOJI_UTILS}" ]; then
      log_success "✓ Pacote $pkg encontrado"
      pkg_found=true
    fi
    
    if [ "$pkg_found" = false ]; then
      log_error "✗ Pacote $pkg não encontrado. Execute o script 01-project-init.sh primeiro."
      all_good=false
    fi
  done
  
  if [ "$all_good" != true ]; then
    log_error "Pré-requisitos não atendidos. Corrija os erros antes de continuar."
    exit 1
  fi
  
  log_success "Todos os pré-requisitos foram atendidos!"
}

# Expandir biblioteca UI com mais componentes
enhance_ui_library() {
  log_section "Expansão da Biblioteca UI"
  
  local UI_PKG_PATH="${PACKAGES_DIR}/ui"
  [ -d "${PACKAGES_DIR}/ui ${EMOJI_UI}" ] && UI_PKG_PATH="${PACKAGES_DIR}/ui ${EMOJI_UI}"
  
  # Criar diretório de componentes se não existir
  mkdir -p "${UI_PKG_PATH}/src/components"
  mkdir -p "${UI_PKG_PATH}/src/theme"
  mkdir -p "${UI_PKG_PATH}/src/hooks"
  mkdir -p "${UI_PKG_PATH}/src/components/stories"
  
  # Criar tema base
  cat > "${UI_PKG_PATH}/src/theme/theme.ts" << 'EOF'
/**
 * Theme configuration for StrateUp v3
 * This exports a theme object that can be used throughout the application
 */

// Colors object with palette for light/dark mode
export const colors = {
  primary: {
    50: '#e3f2fd',
    100: '#bbdefb',
    200: '#90caf9',
    300: '#64b5f6',
    400: '#42a5f5',
    500: '#2196f3',
    600: '#1e88e5',
    700: '#1976d2',
    800: '#1565c0',
    900: '#0d47a1',
  },
  secondary: {
    50: '#ede7f6',
    100: '#d1c4e9',
    200: '#b39ddb',
    300: '#9575cd',
    400: '#7e57c2',
    500: '#673ab7',
    600: '#5e35b1',
    700: '#512da8',
    800: '#4527a0',
    900: '#311b92',
  },
  success: {
    50: '#e8f5e9',
    100: '#c8e6c9',
    500: '#4caf50',
    700: '#388e3c',
    900: '#1b5e20',
  },
  warning: {
    50: '#fffde7',
    100: '#fff9c4',
    500: '#ffeb3b',
    700: '#fbc02d',
    900: '#f57f17',
  },
  error: {
    50: '#ffebee',
    100: '#ffcdd2',
    500: '#f44336',
    700: '#d32f2f',
    900: '#b71c1c',
  },
  gray: {
    50: '#fafafa',
    100: '#f5f5f5',
    200: '#eeeeee',
    300: '#e0e0e0',
    400: '#bdbdbd',
    500: '#9e9e9e',
    600: '#757575',
    700: '#616161',
    800: '#424242',
    900: '#212121',
  },
  common: {
    white: '#ffffff',
    black: '#000000',
  },
};

// Spacing system
export const spacing = {
  0: '0',
  1: '0.25rem',
  2: '0.5rem',
  3: '0.75rem',
  4: '1rem',
  5: '1.25rem',
  6: '1.5rem',
  8: '2rem',
  10: '2.5rem',
  12: '3rem',
  16: '4rem',
  20: '5rem',
  24: '6rem',
};

// Font definitions
export const fonts = {
  body: '"Inter", system-ui, -apple-system, sans-serif',
  heading: '"Inter", system-ui, -apple-system, sans-serif',
  mono: '"Roboto Mono", monospace',
};

// Typography
export const typography = {
  h1: {
    fontSize: '2.5rem',
    fontWeight: 700,
    lineHeight: 1.2,
    letterSpacing: '-0.01em',
  },
  h2: {
    fontSize: '2rem',
    fontWeight: 700,
    lineHeight: 1.2,
    letterSpacing: '-0.01em',
  },
  h3: {
    fontSize: '1.75rem',
    fontWeight: 600,
    lineHeight: 1.3,
  },
  h4: {
    fontSize: '1.5rem',
    fontWeight: 600,
    lineHeight: 1.3,
  },
  h5: {
    fontSize: '1.25rem',
    fontWeight: 600,
    lineHeight: 1.4,
  },
  h6: {
    fontSize: '1rem',
    fontWeight: 600,
    lineHeight: 1.4,
  },
  body1: {
    fontSize: '1rem',
    lineHeight: 1.5,
  },
  body2: {
    fontSize: '0.875rem',
    lineHeight: 1.5,
  },
  caption: {
    fontSize: '0.75rem',
    lineHeight: 1.5,
  },
  button: {
    fontSize: '0.875rem',
    fontWeight: 500,
    lineHeight: 1.5,
    textTransform: 'none',
  },
};

// Breakpoints for responsive design
export const breakpoints = {
  xs: '0px',
  sm: '640px',
  md: '768px',
  lg: '1024px',
  xl: '1280px',
  '2xl': '1536px',
};

// Border radius
export const borderRadius = {
  none: '0',
  sm: '0.125rem',
  md: '0.25rem',
  lg: '0.5rem',
  xl: '0.75rem',
  '2xl': '1rem',
  full: '9999px',
};

// Elevation/shadows
export const shadows = {
  sm: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
  md: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
  lg: '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
  xl: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
  '2xl': '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
  inner: 'inset 0 2px 4px 0 rgba(0, 0, 0, 0.06)',
  none: 'none',
};

// Z-index system
export const zIndices = {
  hide: -1,
  auto: 'auto',
  base: 0,
  docked: 10,
  dropdown: 1000,
  sticky: 1100,
  banner: 1200,
  overlay: 1300,
  modal: 1400,
  popover: 1500,
  toast: 1600,
  tooltip: 1700,
};

// Animation/transition system
export const transitions = {
  easing: {
    easeInOut: 'cubic-bezier(0.4, 0, 0.2, 1)',
    easeOut: 'cubic-bezier(0.0, 0, 0.2, 1)',
    easeIn: 'cubic-bezier(0.4, 0, 1, 1)',
    sharp: 'cubic-bezier(0.4, 0, 0.6, 1)',
  },
  duration: {
    shortest: '150ms',
    shorter: '200ms',
    short: '250ms',
    standard: '300ms',
    complex: '375ms',
    enteringScreen: '225ms',
    leavingScreen: '195ms',
  },
};

// Complete theme object
export const theme = {
  colors,
  spacing,
  fonts,
  typography,
  breakpoints,
  borderRadius,
  shadows,
  zIndices,
  transitions,
};

export type Theme = typeof theme;

export default theme;
EOF

  # Adicionar mais componentes de UI
  
  # 1. Card Component
  cat > "${UI_PKG_PATH}/src/components/Card.tsx" << 'EOF'
import React from 'react';
import clsx from 'clsx';

export interface CardProps {
  /**
   * Card content
   */
  children: React.ReactNode;
  
  /**
   * Optional heading/title
   */
  title?: string;
  
  /**
   * Card variant
   */
  variant?: 'elevated' | 'outlined' | 'filled';
  
  /**
   * Additional CSS classes
   */
  className?: string;
  
  /**
   * Footer content
   */
  footer?: React.ReactNode;
  
  /**
   * Click handler
   */
  onClick?: () => void;
}

/**
 * Card component for content containers
 */
export const Card: React.FC<CardProps> = ({
  children,
  title,
  variant = 'elevated',
  className,
  footer,
  onClick,
}) => {
  return (
    <div 
      className={clsx(
        'rounded-lg overflow-hidden',
        variant === 'elevated' && 'bg-white shadow-md',
        variant === 'outlined' && 'bg-white border border-gray-200',
        variant === 'filled' && 'bg-gray-50',
        onClick && 'cursor-pointer hover:shadow-lg transition-shadow',
        className
      )}
      onClick={onClick}
    >
      {title && (
        <div className="px-4 py-3 border-b border-gray-100">
          <h3 className="text-lg font-medium text-gray-900">{title}</h3>
        </div>
      )}
      
      <div className="p-4">
        {children}
      </div>
      
      {footer && (
        <div className="px-4 py-3 bg-gray-50 border-t border-gray-100">
          {footer}
        </div>
      )}
    </div>
  );
};

export default Card;
EOF

  # 2. Input Component
  cat > "${UI_PKG_PATH}/src/components/Input.tsx" << 'EOF'
import React from 'react';
import clsx from 'clsx';

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  /**
   * Input label
   */
  label?: string;
  
  /**
   * Helper text
   */
  helperText?: string;
  
  /**
   * Error state
   */
  error?: boolean;
  
  /**
   * Error message
   */
  errorMessage?: string;
  
  /**
   * Start icon/adornment
   */
  startAdornment?: React.ReactNode;
  
  /**
   * End icon/adornment
   */
  endAdornment?: React.ReactNode;
  
  /**
   * Input size
   */
  size?: 'sm' | 'md' | 'lg';
  
  /**
   * Full width
   */
  fullWidth?: boolean;
}

/**
 * Input component for user text entry
 */
export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  (
    {
      label,
      helperText,
      error = false,
      errorMessage,
      startAdornment,
      endAdornment,
      className,
      size = 'md',
      fullWidth = false,
      disabled = false,
      id,
      ...props
    },
    ref
  ) => {
    // Generate a unique ID if not provided
    const inputId = id || `input-${Math.random().toString(36).substr(2, 9)}`;
    
    return (
      <div className={clsx('mb-4', fullWidth && 'w-full', className)}>
        {label && (
          <label
            htmlFor={inputId}
            className={clsx(
              'block mb-2 text-sm font-medium',
              error ? 'text-red-700' : 'text-gray-700',
              disabled && 'opacity-60'
            )}
          >
            {label}
          </label>
        )}
        
        <div className="relative">
          {startAdornment && (
            <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
              {startAdornment}
            </div>
          )}
          
          <input
            ref={ref}
            id={inputId}
            className={clsx(
              'bg-white border rounded-md w-full text-gray-900 focus:ring-blue-500 focus:border-blue-500',
              error ? 'border-red-500 text-red-900 placeholder-red-400' : 'border-gray-300',
              size === 'sm' && 'px-2 py-1 text-sm',
              size === 'md' && 'px-3 py-2',
              size === 'lg' && 'px-4 py-3 text-lg',
              startAdornment && 'pl-10',
              endAdornment && 'pr-10',
              disabled && 'bg-gray-100 opacity-60 cursor-not-allowed',
              fullWidth && 'w-full'
            )}
            disabled={disabled}
            aria-invalid={error ? 'true' : 'false'}
            aria-describedby={`${inputId}-helper`}
            {...props}
          />
          
          {endAdornment && (
            <div className="absolute inset-y-0 right-0 flex items-center pr-3">
              {endAdornment}
            </div>
          )}
        </div>
        
        {(helperText || (error && errorMessage)) && (
          <p
            id={`${inputId}-helper`}
            className={clsx(
              'mt-1 text-sm',
              error ? 'text-red-600' : 'text-gray-500'
            )}
          >
            {error ? errorMessage : helperText}
          </p>
        )}
      </div>
    );
  }
);

Input.displayName = 'Input';

export default Input;
EOF

  # 3. Badge Component
  cat > "${UI_PKG_PATH}/src/components/Badge.tsx" << 'EOF'
import React from 'react';
import clsx from 'clsx';

export interface BadgeProps {
  /**
   * Badge label/content
   */
  children: React.ReactNode;
  
  /**
   * Badge variant
   */
  variant?: 'primary' | 'secondary' | 'success' | 'warning' | 'error' | 'info';
  
  /**
   * Badge size
   */
  size?: 'sm' | 'md' | 'lg';
  
  /**
   * Whether to use outline style
   */
  outline?: boolean;
  
  /**
   * Optional icon
   */
  icon?: React.ReactNode;
  
  /**
   * Additional CSS classes
   */
  className?: string;
}

/**
 * Badge component for status indicators and labels
 */
export const Badge: React.FC<BadgeProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  outline = false,
  icon,
  className,
}) => {
  const getColorClasses = () => {
    if (outline) {
      switch (variant) {
        case 'primary':
          return 'bg-blue-50 text-blue-700 border border-blue-200';
        case 'secondary':
          return 'bg-purple-50 text-purple-700 border border-purple-200';
        case 'success':
          return 'bg-green-50 text-green-700 border border-green-200';
        case 'warning':
          return 'bg-yellow-50 text-yellow-700 border border-yellow-200';
        case 'error':
          return 'bg-red-50 text-red-700 border border-red-200';
        case 'info':
          return 'bg-sky-50 text-sky-700 border border-sky-200';
        default:
          return 'bg-gray-50 text-gray-700 border border-gray-200';
      }
    } else {
      switch (variant) {
        case 'primary':
          return 'bg-blue-100 text-blue-800';
        case 'secondary':
          return 'bg-purple-100 text-purple-800';
        case 'success':
          return 'bg-green-100 text-green-800';
        case 'warning':
          return 'bg-yellow-100 text-yellow-800';
        case 'error':
          return 'bg-red-100 text-red-800';
        case 'info':
          return 'bg-sky-100 text-sky-800';
        default:
          return 'bg-gray-100 text-gray-800';
      }
    }
  };

  const getSizeClasses = () => {
    switch (size) {
      case 'sm':
        return 'px-2 py-0.5 text-xs';
      case 'lg':
        return 'px-3 py-1 text-sm';
      case 'md':
      default:
        return 'px-2.5 py-0.5 text-xs';
    }
  };

  return (
    <span
      className={clsx(
        'inline-flex items-center font-medium rounded-full',
        getColorClasses(),
        getSizeClasses(),
        className
      )}
    >
      {icon && <span className="mr-1">{icon}</span>}
      {children}
    </span>
  );
};

export default Badge;
EOF

  # 4. Avatar Component
  cat > "${UI_PKG_PATH}/src/components/Avatar.tsx" << 'EOF'
import React from 'react';
import clsx from 'clsx';

export interface AvatarProps {
  /**
   * Image URL
   */
  src?: string;
  
  /**
   * Alt text
   */
  alt?: string;
  
  /**
   * Text to display when image is not available
   */
  fallback?: string;
  
  /**
   * Avatar size
   */
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  
  /**
   * Avatar shape
   */
  shape?: 'circle' | 'square' | 'rounded';
  
  /**
   * Status indicator (online, offline, away, busy)
   */
  status?: 'online' | 'offline' | 'away' | 'busy';
  
  /**
   * Additional CSS classes
   */
  className?: string;
}

/**
 * Avatar component for user profiles
 */
export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt = 'User avatar',
  fallback,
  size = 'md',
  shape = 'circle',
  status,
  className,
}) => {
  const [imgError, setImgError] = React.useState(false);
  
  const handleImgError = () => {
    setImgError(true);
  };

  const getSizeClasses = () => {
    switch (size) {
      case 'xs':
        return 'w-6 h-6 text-xs';
      case 'sm':
        return 'w-8 h-8 text-sm';
      case 'md':
        return 'w-10 h-10 text-base';
      case 'lg':
        return 'w-12 h-12 text-lg';
      case 'xl':
        return 'w-16 h-16 text-xl';
      default:
        return 'w-10 h-10 text-base';
    }
  };

  const getShapeClasses = () => {
    switch (shape) {
      case 'circle':
        return 'rounded-full';
      case 'square':
        return 'rounded-none';
      case 'rounded':
        return 'rounded-lg';
      default:
        return 'rounded-full';
    }
  };
  
  const getStatusClasses = () => {
    if (!status) return '';
    
    const baseStatusClasses = 'absolute border-2 border-white rounded-full';
    const statusSizeClasses = size === 'xs' || size === 'sm' 
      ? 'w-2 h-2 right-0 bottom-0'
      : 'w-3 h-3 right-0.5 bottom-0.5';
      
    let statusColorClass;
    switch (status) {
      case 'online':
        statusColorClass = 'bg-green-500';
        break;
      case 'offline':
        statusColorClass = 'bg-gray-500';
        break;
      case 'away':
        statusColorClass = 'bg-yellow-500';
        break;
      case 'busy':
        statusColorClass = 'bg-red-500';
        break;
      default:
        statusColorClass = '';
    }
    
    return `${baseStatusClasses} ${statusSizeClasses} ${statusColorClass}`;
  };
  
  // Generate initials from fallback text
  const getInitials = () => {
    if (!fallback) return '?';
    return fallback
      .split(' ')
      .map((word) => word.charAt(0).toUpperCase())
      .slice(0, 2)
      .join('');
  };

  return (
    <div className={clsx('relative inline-flex', className)}>
      {!imgError && src ? (
        <img
          src={src}
          alt={alt}
          onError={handleImgError}
          className={clsx(
            'object-cover',
            getSizeClasses(),
            getShapeClasses()
          )}
        />
      ) : (
        <div
          className={clsx(
            'flex items-center justify-center text-gray-700 bg-gray-200',
            getSizeClasses(),
            getShapeClasses()
          )}
          aria-label={alt}
        >
          {getInitials()}
        </div>
      )}
      
      {status && <span className={getStatusClasses()} />}
    </div>
  );
};

export default Avatar;
EOF

  # 5. Alert Component
  cat > "${UI_PKG_PATH}/src/components/Alert.tsx" << 'EOF'
import React from 'react';
import clsx from 'clsx';

export interface AlertProps {
  /**
   * Alert content
   */
  children: React.ReactNode;
  
  /**
   * Alert title
   */
  title?: string;
  
  /**
   * Alert type
   */
  type?: 'info' | 'success' | 'warning' | 'error';
  
  /**
   * Whether alert is dismissible
   */
  dismissible?: boolean;
  
  /**
   * Custom icon
   */
  icon?: React.ReactNode;
  
  /**
   * Additional CSS classes
   */
  className?: string;
  
  /**
   * Callback when alert is dismissed
   */
  onClose?: () => void;
}

/**
 * Alert component for notifications and messages
 */
export const Alert: React.FC<AlertProps> = ({
  children,
  title,
  type = 'info',
  dismissible = false,
  icon,
  className,
  onClose,
}) => {
  const [dismissed, setDismissed] = React.useState(false);
  
  const handleClose = () => {
    setDismissed(true);
    if (onClose) {
      onClose();
    }
  };
  
  if (dismissed) {
    return null;
  }
  
  const getTypeClasses = () => {
    switch (type) {
      case 'success':
        return 'bg-green-50 border-green-200 text-green-700';
      case 'warning':
        return 'bg-yellow-50 border-yellow-200 text-yellow-700';
      case 'error':
        return 'bg-red-50 border-red-200 text-red-700';
      case 'info':
      default:
        return 'bg-blue-50 border-blue-200 text-blue-700';
    }
  };
  
  const getIconByType = () => {
    if (icon) return icon;
    
    switch (type) {
      case 'success':
        return (
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path>
          </svg>
        );
      case 'warning':
        return (
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd"></path>
          </svg>
        );
      case 'error':
        return (
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd"></path>
          </svg>
        );
      case 'info':
      default:
        return (
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd"></path>
          </svg>
        );
    }
  };
  
  return (
    <div
      className={clsx(
        'flex p-4 mb-4 border-l-4 rounded-lg',
        getTypeClasses(),
        className
      )}
      role="alert"
    >
      <div className="flex-shrink-0 mr-3">
        {getIconByType()}
      </div>
      
      <div className="flex-1">
        {title && (
          <h3 className="text-sm font-medium mb-1">{title}</h3>
        )}
        <div className="text-sm">{children}</div>
      </div>
      
      {dismissible && (
        <button
          type="button"
          className="inline-flex flex-shrink-0 ml-auto -mr-1 -mt-1 bg-transparent text-current"
          aria-label="Close"
          onClick={handleClose}
        >
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd"></path>
          </svg>
        </button>
      )}
    </div>
  );
};

export default Alert;
EOF

  # Atualizar arquivo index.ts para exportar os novos componentes
  cat > "${UI_PKG_PATH}/src/index.ts" << 'EOF'
// Export components
export * from './components/Button';
export * from './components/Card';
export * from './components/Input';
export * from './components/Badge';
export * from './components/Avatar';
export * from './components/Alert';

// Export theme
export * from './theme/theme';

// Export version
export const version = '0.1.0';
EOF

  # Criar histórias para Card
  cat > "${UI_PKG_PATH}/src/components/stories/Card.stories.tsx" << 'EOF'
import React from 'react';
import { Card } from '../Card';
import { Button } from '../Button';

export default {
  title: 'UI/Card',
  component: Card,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
};

export const Basic = {
  args: {
    children: (
      <p>This is a basic card with some content. Cards are useful for grouping related information and actions.</p>
    )
  },
};

export const WithTitle = {
  args: {
    title: 'Card Title',
    children: (
      <p>This card includes a title in the header section.</p>
    )
  },
};

export const WithFooter = {
  args: {
    title: 'Card with Footer',
    children: (
      <p>This card includes both a title and footer section for actions.</p>
    ),
    footer: (
      <div className="flex justify-end space-x-2">
        <Button variant="outline" size="sm">Cancel</Button>
        <Button size="sm">Save</Button>
      </div>
    )
  },
};

export const Outlined = {
  args: {
    title: 'Outlined Card',
    variant: 'outlined',
    children: (
      <p>This card uses the outlined variant with a border instead of elevation.</p>
    )
  },
};

export const Filled = {
  args: {
    title: 'Filled Card',
    variant: 'filled',
    children: (
      <p>This card uses the filled variant with a background color.</p>
    )
  },
};

export const Clickable = {
  args: {
    title: 'Clickable Card',
    children: (
      <p>This card is clickable. Hover over it to see the effect.</p>
    ),
    onClick: () => alert('Card clicked!')
  },
};
EOF

  log_success "Biblioteca UI expandida com tema e componentes adicionais."
}

# Criar integrações entre pacotes
create_package_integrations() {
  log_section "Criação de Integrações entre Pacotes"
  
  local UI_PKG_PATH="${PACKAGES_DIR}/ui"
  local UTILS_PKG_PATH="${PACKAGES_DIR}/utils"
  
  [ -d "${PACKAGES_DIR}/ui ${EMOJI_UI}" ] && UI_PKG_PATH="${PACKAGES_DIR}/ui ${EMOJI_UI}"
  [ -d "${PACKAGES_DIR}/utils ${EMOJI_UTILS}" ] && UTILS_PKG_PATH="${PACKAGES_DIR}/utils ${EMOJI_UTILS}"
  
  # Criar forma de validação com pacote utils
  mkdir -p "${UI_PKG_PATH}/src/integration"
  
  # 1. Criar form validator que usa o pacote utils
  cat > "${UI_PKG_PATH}/src/integration/FormValidation.ts" << 'EOF'
/**
 * Form validation integration with @strateup/utils
 * This module demonstrates how the UI package can integrate with the Utils package
 */
import { isValidEmail, isValidCPF, isValidPhone } from '@strateup/utils';

export type ValidationRule = {
  test: (value: string) => boolean;
  message: string;
};

/**
 * Generate validation rules for common patterns
 */
export const createValidationRules = {
  /**
   * Required field validation
   */
  required: (message = 'Campo obrigatório'): ValidationRule => ({
    test: value => value.trim() !== '',
    message
  }),
  
  /**
   * Email format validation using utils package
   */
  email: (message = 'E-mail inválido'): ValidationRule => ({
    test: value => value === '' || isValidEmail(value),
    message
  }),
  
  /**
   * Minimum length validation
   */
  minLength: (length: number, message = `Mínimo ${length} caracteres`): ValidationRule => ({
    test: value => value === '' || value.length >= length,
    message
  }),
  
  /**
   * Maximum length validation
   */
  maxLength: (length: number, message = `Máximo ${length} caracteres`): ValidationRule => ({
    test: value => value === '' || value.length <= length,
    message
  }),
  
  /**
   * CPF validation using utils package
   */
  cpf: (message = 'CPF inválido'): ValidationRule => ({
    test: value => value === '' || isValidCPF(value),
    message
  }),
  
  /**
   * Phone validation using utils package
   */
  phone: (message = 'Telefone inválido'): ValidationRule => ({
    test: value => value === '' || isValidPhone(value),
    message
  }),
  
  /**
   * Custom pattern validation
   */
  pattern: (pattern: RegExp, message = 'Formato inválido'): ValidationRule => ({
    test: value => value === '' || pattern.test(value),
    message
  }),
  
  /**
   * Custom validation function
   */
  custom: (testFn: (value: string) => boolean, message = 'Valor inválido'): ValidationRule => ({
    test: testFn,
    message
  })
};

/**
 * Validate a field against multiple rules
 * @returns Empty string if valid, or error message
 */
export const validateField = (value: string, rules: ValidationRule[]): string => {
  for (const rule of rules) {
    if (!rule.test(value)) {
      return rule.message;
    }
  }
  return '';
};

/**
 * Validate an entire form
 * @param values Object with field values
 * @param validations Object with validation rules for each field
 * @returns Object with validation errors
 */
export const validateForm = (
  values: Record<string, string>,
  validations: Record<string, ValidationRule[]>
): Record<string, string> => {
  const errors: Record<string, string> = {};
  
  Object.keys(validations).forEach(fieldName => {
    const value = values[fieldName] || '';
    const rules = validations[fieldName];
    const error = validateField(value, rules);
    if (error) {
      errors[fieldName] = error;
    }
  });
  
  return errors;
};

/**
 * Check if form has any errors
 */
export const hasErrors = (errors: Record<string, string>): boolean => {
  return Object.keys(errors).length > 0;
};

/**
 * Fully validate form and return results
 */
export const validateFormValues = (
  values: Record<string, string>,
  validations: Record<string, ValidationRule[]>
): { 
  isValid: boolean;
  errors: Record<string, string>;
} => {
  const errors = validateForm(values, validations);
  return {
    isValid: !hasErrors(errors),
    errors
  };
};
EOF

  # 2. Criar hook de formulário integrado
  mkdir -p "${UI_PKG_PATH}/src/hooks"
  cat > "${UI_PKG_PATH}/src/hooks/useForm.ts" << 'EOF'
/**
 * Form hook that integrates with validation utilities
 */
import { useState, useCallback } from 'react';
import {
  ValidationRule,
  validateFormValues,
  validateField
} from '../integration/FormValidation';

/**
 * Hook for form handling with validation
 */
export function useForm<T extends Record<string, string>>(
  initialValues: T,
  validationRules: Partial<Record<keyof T, ValidationRule[]>> = {}
) {
  const [values, setValues] = useState<T>(initialValues);
  const [errors, setErrors] = useState<Partial<Record<keyof T, string>>>({});
  const [touched, setTouched] = useState<Partial<Record<keyof T, boolean>>>({});
  
  // Handler for input changes
  const handleChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setValues(prev => ({ ...prev, [name]: value }));
    
    // Validate field if it has been touched
    if (touched[name as keyof T]) {
      const rules = validationRules[name as keyof T] || [];
      const fieldError = validateField(value, rules);
      setErrors(prev => ({ ...prev, [name]: fieldError }));
    }
  }, [validationRules, touched]);
  
  // Handler for blur events (mark field as touched)
  const handleBlur = useCallback((e: React.FocusEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setTouched(prev => ({ ...prev, [name]: true }));
    
    // Validate on blur
    const rules = validationRules[name as keyof T] || [];
    const fieldError = validateField(value, rules);
    setErrors(prev => ({ ...prev, [name]: fieldError }));
  }, [validationRules]);
  
  // Reset form to initial values
  const resetForm = useCallback(() => {
    setValues(initialValues);
    setErrors({});
    setTouched({});
  }, [initialValues]);
  
  // Set specific field value programmatically
  const setFieldValue = useCallback((name: keyof T, value: string) => {
    setValues(prev => ({ ...prev, [name]: value }));
  }, []);
  
  // Validate the entire form
  const validateForm = useCallback(() => {
    const validationResult = validateFormValues(
      values as Record<string, string>,
      validationRules as Record<string, ValidationRule[]>
    );
    
    setErrors(validationResult.errors as Partial<Record<keyof T, string>>);
    
    // Mark all fields as touched
    const allTouched = Object.keys(validationRules).reduce(
      (acc, field) => ({ ...acc, [field]: true }),
      {} as Partial<Record<keyof T, boolean>>
    );
    setTouched(prev => ({ ...prev, ...allTouched }));
    
    return validationResult.isValid;
  }, [values, validationRules]);
  
  return {
    values,
    errors,
    touched,
    handleChange,
    handleBlur,
    resetForm,
    setFieldValue,
    validateForm,
    isValid: Object.keys(errors).length === 0,
  };
}

export default useForm;
EOF

  # 3. Exportar o hook no index.ts
  cat >> "${UI_PKG_PATH}/src/index.ts" << 'EOF'

// Export hooks
export * from './hooks/useForm';

// Export integrations
export * from './integration/FormValidation';
EOF

  # 4. Criar exemplo de Form Component que integra utils e UI
  cat > "${UI_PKG_PATH}/src/components/Form.tsx" << 'EOF'
import React from 'react';
import clsx from 'clsx';
import { Input, InputProps } from './Input';
import { Button } from './Button';
import { useForm } from '../hooks/useForm';
import { ValidationRule } from '../integration/FormValidation';

export interface FormField extends Omit<InputProps, 'name'> {
  name: string;
  type?: string;
  label?: string;
  validationRules?: ValidationRule[];
}

export interface FormProps {
  /**
   * Form fields configuration
   */
  fields: FormField[];
  
  /**
   * Initial values
   */
  initialValues?: Record<string, string>;
  
  /**
   * Submit handler
   */
  onSubmit: (values: Record<string, string>) => void;
  
  /**
   * Form title
   */
  title?: string;
  
  /**
   * Submit button text
   */
  submitText?: string;
  
  /**
   * Additional CSS classes
   */
  className?: string;
  
  /**
   * Show reset button
   */
  showReset?: boolean;
}

/**
 * Form component that integrates inputs with validation
 */
export const Form: React.FC<FormProps> = ({
  fields,
  initialValues = {},
  onSubmit,
  title,
  submitText = 'Submit',
  className,
  showReset = false,
}) => {
  // Create validation rules map
  const validationRules = fields.reduce((acc, field) => {
    if (field.validationRules) {
      acc[field.name] = field.validationRules;
    }
    return acc;
  }, {} as Record<string, ValidationRule[]>);
  
  // Initialize form with validation
  const {
    values,
    errors,
    touched,
    handleChange,
    handleBlur,
    resetForm,
    validateForm,
  } = useForm(initialValues, validationRules);
  
  // Handle form submission
  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const isValid = validateForm();
    if (isValid) {
      onSubmit(values);
    }
  };
  
  return (
    <form 
      onSubmit={handleSubmit} 
      className={clsx('space-y-4', className)}
      noValidate
    >
      {title && (
        <h3 className="text-lg font-medium mb-4">{title}</h3>
      )}
      
      {fields.map((field) => {
        const {
          name,
          label,
          validationRules,
          ...inputProps
        } = field;
        
        return (
          <Input
            key={name}
            id={name}
            name={name}
            value={values[name] || ''}
            onChange={handleChange}
            onBlur={handleBlur}
            label={label}
            error={!!(touched[name] && errors[name])}
            errorMessage={errors[name]}
            {...inputProps}
          />
        );
      })}
      
      <div className="flex justify-end space-x-3 pt-2">
        {showReset && (
          <Button
            type="button"
            variant="outline"
            onClick={resetForm}
          >
            Limpar
          </Button>
        )}
        <Button type="submit">
          {submitText}
        </Button>
      </div>
    </form>
  );
};

export default Form;
EOF

  # 5. Exportar Form no index.ts
  cat >> "${UI_PKG_PATH}/src/index.ts" << 'EOF'
export * from './components/Form';
EOF

  # 6. Criar storybook para Form
  cat > "${UI_PKG_PATH}/src/components/stories/Form.stories.tsx" << 'EOF'
import React from 'react';
import { Form } from '../Form';
import { createValidationRules } from '../../integration/FormValidation';

export default {
  title: 'UI/Form',
  component: Form,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
};

export const SimpleForm = {
  args: {
    title: 'Contact Information',
    submitText: 'Save',
    initialValues: {
      firstName: '',
      lastName: '',
      email: '',
    },
    fields: [
      {
        name: 'firstName',
        label: 'First Name',
        placeholder: 'Enter your first name',
        validationRules: [
          createValidationRules.required('First name is required'),
        ],
      },
      {
        name: 'lastName',
        label: 'Last Name',
        placeholder: 'Enter your last name',
        validationRules: [
          createValidationRules.required('Last name is required'),
        ],
      },
      {
        name: 'email',
        type: 'email',
        label: 'Email',
        placeholder: 'Enter your email',
        validationRules: [
          createValidationRules.required('Email is required'),
          createValidationRules.email('Please enter a valid email'),
        ],
      },
    ],
    onSubmit: values => console.log('Form submitted:', values),
    showReset: true,
  },
};

export const LoginForm = {
  args: {
    title: 'Login',
    submitText: 'Sign In',
    initialValues: {
      email: '',
      password: '',
    },
    fields: [
      {
        name: 'email',
        type: 'email',
        label: 'Email',
        placeholder: 'Enter your email',
        validationRules: [
          createValidationRules.required('Email is required'),
          createValidationRules.email('Please enter a valid email'),
        ],
      },
      {
        name: 'password',
        type: 'password',
        label: 'Password',
        placeholder: 'Enter your password',
        validationRules: [
          createValidationRules.required('Password is required'),
          createValidationRules.minLength(8, 'Password must be at least 8 characters'),
        ],
      },
    ],
    onSubmit: values => console.log('Login submitted:', values),
    showReset: false,
  },
};

export const CheckoutForm = {
  args: {
    title: 'Shipping Information',
    submitText: 'Continue to Payment',
    initialValues: {
      name: '',
      address: '',
      city: '',
      zipCode: '',
      phone: '',
    },
    fields: [
      {
        name: 'name',
        label: 'Full Name',
        placeholder: 'Enter your full name',
        validationRules: [
          createValidationRules.required('Full name is required'),
        ],
      },
      {
        name: 'address',
        label: 'Address',
        placeholder: 'Enter your address',
        validationRules: [
          createValidationRules.required('Address is required'),
        ],
      },
      {
        name: 'city',
        label: 'City',
        placeholder: 'Enter your city',
        validationRules: [
          createValidationRules.required('City is required'),
        ],
      },
      {
        name: 'zipCode',
        label: 'ZIP Code',
        placeholder: 'Enter ZIP code',
        validationRules: [
          createValidationRules.required('ZIP code is required'),
          createValidationRules.pattern(/^\d{5}(-\d{4})?$/, 'Enter a valid ZIP code'),
        ],
      },
      {
        name: 'phone',
        label: 'Phone Number',
        placeholder: '(00) 00000-0000',
        validationRules: [
          createValidationRules.required('Phone number is required'),
          createValidationRules.phone('Enter a valid phone number'),
        ],
      },
    ],
    onSubmit: values => console.log('Checkout submitted:', values),
    showReset: true,
  },
};
EOF

  # 7. Adicionar função de formatação para moedas ao pacote utils
  mkdir -p "${UTILS_PKG_PATH}/src/currency"
  cat > "${UTILS_PKG_PATH}/src/currency/index.ts" << 'EOF'
/**
 * Currency utilities for handling monetary values
 */

/**
 * Format a number as BRL currency
 * @param value Number to format
 * @returns Formatted currency string
 */
export function formatBRL(value: number): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL'
  }).format(value);
}

/**
 * Format a number as USD currency
 * @param value Number to format
 * @returns Formatted currency string
 */
export function formatUSD(value: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  }).format(value);
}

/**
 * Format a number as EUR currency
 * @param value Number to format
 * @returns Formatted currency string
 */
export function formatEUR(value: number): string {
  return new Intl.NumberFormat('de-DE', {
    style: 'currency',
    currency: 'EUR'
  }).format(value);
}

/**
 * Convert string currency value to number
 * @param value Currency string (e.g. "R$ 1.234,56")
 * @param locale Locale to use (default: 'pt-BR')
 * @returns Numeric value
 */
export function parseCurrencyToNumber(value: string, locale = 'pt-BR'): number {
  // Remove currency symbol and non-numeric characters except decimal separator
  const cleanValue = value
    .replace(/[^\d,.]/g, '')
    .replace(',', '.');
  
  return parseFloat(cleanValue);
}

/**
 * Calculate discount amount
 * @param price Original price
 * @param discountPercent Discount percentage
 * @returns Discounted price
 */
export function calculateDiscount(price: number, discountPercent: number): number {
  return price - (price * (discountPercent / 100));
}

/**
 * Calculate tax amount
 * @param price Price before tax
 * @param taxRate Tax rate percentage
 * @returns Price with tax
 */
export function calculateTax(price: number, taxRate: number): number {
  return price * (1 + (taxRate / 100));
}

/**
 * Calculate installment value
 * @param total Total amount
 * @param installments Number of installments
 * @param interestRate Monthly interest rate (percentage)
 * @returns Installment value
 */
export function calculateInstallment(
  total: number,
  installments: number,
  interestRate: number = 0
): number {
  if (installments <= 0) return 0;
  if (installments === 1 || interestRate === 0) return total;
  
  // Convert percentage to decimal
  const rate = interestRate / 100;
  
  // Compound interest formula
  return (total * rate * Math.pow(1 + rate, installments)) / (Math.pow(1 + rate, installments) - 1);
}
EOF

  # 8. Atualizar index.ts do pacote utils
  cat >> "${UTILS_PKG_PATH}/src/index.ts" << 'EOF'
export * from './currency';
EOF

  # 9. Adicionar testes
  mkdir -p "${UTILS_PKG_PATH}/src/currency/__tests__"
  cat > "${UTILS_PKG_PATH}/src/currency/__tests__/currency.test.ts" << 'EOF'
import { 
  formatBRL,
  parseCurrencyToNumber,
  calculateDiscount,
  calculateTax,
  calculateInstallment
} from '../index';

describe('Currency utilities', () => {
  describe('formatBRL', () => {
    it('should format number as BRL currency', () => {
      expect(formatBRL(1234.56)).toBe('R$ 1.234,56');
      expect(formatBRL(0)).toBe('R$ 0,00');
      expect(formatBRL(1000000)).toBe('R$ 1.000.000,00');
    });

  describe('parseCurrencyToNumber', () => {
    it('should parse BRL currency string to number', () => {
      expect(parseCurrencyToNumber('R$ 1.234,56')).toBeCloseTo(1234.56);
      expect(parseCurrencyToNumber('R$1.234,56')).toBeCloseTo(1234.56);
      expect(parseCurrencyToNumber('1.234,56')).toBeCloseTo(1234.56);
      expect(parseCurrencyToNumber('0,00')).toBe(0);
    });
  });
  
  describe('calculateDiscount', () => {
    it('should calculate correct discount amount', () => {
      expect(calculateDiscount(100, 10)).toBe(90); // 10% off 100
      expect(calculateDiscount(200, 25)).toBe(150); // 25% off 200
      expect(calculateDiscount(50, 0)).toBe(50); // No discount
      expect(calculateDiscount(80, 100)).toBe(0); // 100% off (free)
    });
  });
  
  describe('calculateTax', () => {
    it('should calculate correct price with tax', () => {
      expect(calculateTax(100, 10)).toBe(110); // 100 + 10%
      expect(calculateTax(200, 6)).toBe(212); // 200 + 6%
      expect(calculateTax(50, 0)).toBe(50); // No tax
      expect(calculateTax(80, 100)).toBe(160); // Double the price (100% tax)
    });
  });
  
  describe('calculateInstallment', () => {
    it('should calculate installment without interest', () => {
      expect(calculateInstallment(1000, 10, 0)).toBe(100); // 1000 in 10x without interest
      expect(calculateInstallment(1000, 1, 0)).toBe(1000); // Single payment
    });
    
    it('should calculate installment with interest', () => {
      // With 1% monthly interest, 1000 in 10x should be approximately 105.16 per month
      expect(calculateInstallment(1000, 10, 1)).toBeCloseTo(105.16, 1);
      // Single payment should be just the total, even with interest
      expect(calculateInstallment(1000, 1, 2)).toBe(1000);
    });
    
    it('should handle edge cases', () => {
      expect(calculateInstallment(1000, 0, 1)).toBe(0); // Invalid installment number
      expect(calculateInstallment(0, 10, 1)).toBe(0); // Zero total amount
    });
  });
});
EOF

  log_success "Integração entre pacotes UI e utils criada com sucesso."
}

# Criar documentação arquitetural
create_architecture_documentation() {
  log_section "Criação de Documentação Arquitetural"
  
  # Criar diretório para documentação de arquitetura
  mkdir -p "${DOC_DIR}/architecture"
  
  # 1. Criar documento de visão geral da arquitetura
  cat > "${DOC_DIR}/architecture/overview.md" << 'EOF'
# 🏗️ Arquitetura do StrateUp v3

Este documento descreve a arquitetura de alto nível do sistema StrateUp v3, explicando a organização do monorepo, os princípios de design e o fluxo de dados entre os componentes.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Monorepo e Estrutura de Pacotes](#monorepo-e-estrutura-de-pacotes)
- [Padrões Arquiteturais](#padrões-arquiteturais)
- [Fluxo de Dados](#fluxo-de-dados)
- [Ambientes e Deploy](#ambientes-e-deploy)
- [Convenções e Padrões de Código](#convenções-e-padrões-de-código)

## Visão Geral

StrateUp v3 é uma plataforma de marketing e vendas dividida em vários aplicativos interconectados, todos partilhando uma base comum de componentes e utilidades. A arquitetura foi projetada para:

1. **Manutenibilidade**: Código modular e independente
2. **Reusabilidade**: Componentes compartilhados entre aplicações
3. **Desempenho**: Builds otimizados e código eficiente
4. **Escalabilidade**: Capacidade de adicionar novos aplicativos e funcionalidades
5. **Qualidade**: Testes automatizados e padrões de código consistentes

## Monorepo e Estrutura de Pacotes

O projeto utiliza uma estrutura de monorepo gerenciado pelo pnpm e Turborepo:

strateup-v3/ ├── apps/ # Aplicações autônomas │ ├── web/ # Frontend principal │ ├── admin/ # Painel administrativo │ ├── api/ # Backend API │ └── ai-service/ # Serviço de IA │ ├── packages/ # Pacotes compartilhados │ ├── ui/ # Biblioteca de componentes UI │ ├── utils/ # Funções utilitárias │ ├── auth/ # Autenticação compartilhada │ ├── database/ # Acesso à base de dados │ ├── tsconfig/ # Configurações TypeScript │ └── eslint-config/ # Configurações ESLint

Code

### Dependências entre Pacotes

```mermaid
graph TD
    A[apps/web] --> B[packages/ui]
    A --> C[packages/utils]
    A --> D[packages/auth]
    E[apps/admin] --> B
    E --> C
    E --> D
    F[apps/api] --> C
    F --> D
    F --> G[packages/database]
    H[apps/ai-service] --> C
    H --> G
    B --> C
    D --> C
    G --> C
Padrões Arquiteturais
Frontend (web e admin)
Next.js: Framework React para renderização híbrida (SSR, SSG e CSR)
Arquitetura em Camadas:
UI Layer: Componentes de apresentação
Hooks Layer: Lógica e estado
Service Layer: Comunicação com API
Model Layer: Estrutura de dados TypeScript
Backend (api e ai-service)
Next.js API Routes: Para endpoints RESTful
Clean Architecture: Para separação de responsabilidades
Controllers: Manipulação de requisições/respostas
Use Cases: Lógica de negócio
Repositories: Acesso a dados
Entities: Modelos de domínio
Pacotes Compartilhados
packages/ui: Design System baseado em componentes React
packages/utils: Funções utilitárias puras e independentes
packages/auth: Serviços de autenticação baseados em Supabase
packages/database: Camada de acesso ao banco de dados
Fluxo de Dados
Fluxo de Dados Front-end
Componentes UI: Capturam eventos do usuário
Hooks: Gerenciam estado local e efeitos colaterais
Services: Comunicam-se com APIs/backend
Context/State: Armazenam estado global quando necessário
Mermaid
sequenceDiagram
    participant U as Usuário
    participant C as Componente UI
    participant H as Hook
    participant S as Service
    participant A as API

    U->>C: Interage (click, input)
    C->>H: Dispara ação
    H->>S: Chama serviço
    S->>A: Requisição HTTP
    A-->>S: Resposta HTTP
    S-->>H: Retorna dados
    H-->>C: Atualiza estado
    C-->>U: Atualiza UI
Fluxo de Dados Back-end
API Routes: Recebem requisições HTTP
Controllers: Validam inputs e formatam outputs
Use Cases: Encapsulam a lógica de negócio
Repositories: Realizam operações no banco de dados
Mermaid
sequenceDiagram
    participant C as Cliente
    participant R as API Route
    participant CO as Controller
    participant U as Use Case
    participant RE as Repository
    participant D as Database

    C->>R: HTTP Request
    R->>CO: Passa requisição
    CO->>U: Executa caso de uso
    U->>RE: Solicita dados
    RE->>D: Query
    D-->>RE: Result
    RE-->>U: Retorna dados
    U-->>CO: Resultado processado
    CO-->>R: Resposta formatada
    R-->>C: HTTP Response
Ambientes e Deploy
O projeto possui três ambientes principais:

Development: Para desenvolvimento local
Staging: Para testes de integração antes de produção
Production: Ambiente de produção
Cada ambiente possui suas próprias variáveis de ambiente, configurações e processos de deployment.

Pipeline de CI/CD
Mermaid
graph TD
    A[Push para feature branch] --> B[Checks automatizados]
    B --> C{Todos os checks passaram?}
    C -->|Sim| D[Pull Request]
    C -->|Não| E[Correções necessárias]
    D --> F[Code Review]
    F --> G{Aprovado?}
    G -->|Sim| H[Merge para main]
    G -->|Não| E
    H --> I[Deploy para Staging]
    I --> J[Testes em Staging]
    J --> K{Testes OK?}
    K -->|Sim| L[Deploy para Production]
    K -->|Não| E
Convenções e Padrões de Código
Para manter a consistência e qualidade do código, adotamos:

TypeScript para tipagem estática
ESLint para linting de código
Prettier para formatação de código
Conventional Commits para mensagens de commit
Jest para testes unitários
Testing Library para testes de componentes
Storybook para documentação de componentes UI
Estrutura Padrão de Componente React
TSX
// Button.tsx
import React from 'react';
import clsx from 'clsx';
import { ButtonProps } from './Button.types';

// Função para geração de classes CSS
const getVariantClasses = (variant: string) => {
  switch(variant) {
    case 'primary': return 'bg-blue-600 text-white';
    case 'secondary': return 'bg-gray-200 text-gray-800';
    default: return '';
  }
};

// Componente como função
export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  className,
  ...props
}) => {
  // Composição de classes CSS
  const classes = clsx(
    'px-4 py-2 rounded', 
    getVariantClasses(variant),
    className
  );
  
  // JSX do componente
  return (
    <button className={classes} {...props}>
      {children}
    </button>
  );
};

// Typescript para props
// Button.types.ts
export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
}

// Teste do componente
// Button.test.tsx
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });
});
EOF

2. Criar documento de fluxo de dados detalhado
cat > "${DOC_DIR}/architecture/data-flow.md" << 'EOF'

🔄 Fluxo de Dados StrateUp v3
Este documento detalha o fluxo de dados através da arquitetura do StrateUp v3, explicando como os dados fluem entre os diferentes componentes do sistema.

📋 Índice
Introdução
Fluxo de Entrada de Dados
Processamento de Dados
Armazenamento e Persistência
Fluxo de Saída de Dados
Validação de Dados
Introdução
A arquitetura do StrateUp v3 segue um padrão de fluxo de dados unidirecional para garantir previsibilidade e rastreabilidade. Os dados fluem de maneira consistente através das camadas do aplicativo, desde a interface do usuário até o armazenamento persistente.

Fluxo de Entrada de Dados
Interface do Usuário
Componentes de Formulário: Capturam dados inseridos pelo usuário
Eventos de Interação: Registram ações do usuário (cliques, seleções)
Validação de Frontend: Primeira camada de validação de dados
Mermaid
graph TD
    A[Usuário] -->|Insere dados| B[Componente UI]
    B -->|Valida entrada| C{Válido?}
    C -->|Não| D[Mostra erro]
    C -->|Sim| E[Atualiza estado local]
    E -->|Envia dados| F[Hook/Service]
Endpoints de API
Requisições HTTP: Recebem dados via métodos HTTP (GET, POST, PUT, DELETE)
Middleware de Autenticação: Verifica tokens e permissões
Middleware de Validação: Valida a estrutura e conteúdo dos dados recebidos
Mermaid
graph TD
    A[Cliente] -->|Envia requisição| B[API Route]
    B -->|Verifica auth| C{Autenticado?}
    C -->|Não| D[Erro 401/403]
    C -->|Sim| E[Valida payload]
    E -->|Executa| F[Controller]
Processamento de Dados
Camada de Serviço (Frontend)
Formatting: Converte dados para formato adequado (usando @strateup/utils)
API Calls: Realiza chamadas para API usando fetch ou axios
Caching: Opcionalmente armazena resultados em cache para otimização
Camada de Casos de Uso (Backend)
Validação de Negócio: Aplica regras de negócio aos dados
Processamento: Transforma, agrega ou analisa os dados
Transações: Coordena operações que exigem atomicidade
Mermaid
sequenceDiagram
    participant C as Controller
    participant UC as Use Case
    participant R as Repository
    participant DB as Database
    
    C->>UC: Execute(data)
    UC->>UC: Validate business rules
    UC->>R: Save/Retrieve data
    R->>DB: SQL Query/Command
    DB-->>R: Result
    R-->>UC: Data entity
    UC-->>C: Result/Response
Armazenamento e Persistência
Camada de Repositório
Mapeamento: Converte entre modelos de domínio e estrutura de banco de dados
Execução de Queries: Implementa operações CRUD específicas
Retorno de Dados: Converte resultados do banco em entidades de domínio
Base de Dados (Supabase)
Tabelas: Armazenam dados estruturados
Row Level Security (RLS): Controla acesso aos dados por usuário
Triggers e Functions: Implementam lógica no nível do banco de dados
Mermaid
graph TD
    A[Repository] -->|Query| B[Supabase Client]
    B -->|SQL| C[PostgreSQL]
    C -->|Row Level Security| D{Autorizado?}
    D -->|Não| E[Erro/Nenhum dado]
    D -->|Sim| F[Executa operação]
    F -->|Resultado| G[Converte para modelo]
    G -->|Entidade| H[Camada de Use Case]
Fluxo de Saída de Dados
Resposta da API
Formatação: Estrutura os dados conforme contrato da API
Status Code: Define códigos HTTP apropriados
Headers: Configura cabeçalhos de resposta (cache, content-type)
Renderização na UI
Estado Global/Local: Armazena dados em estado React/Context/Redux
Data Binding: Conecta dados ao componente UI
Otimização: Memoização para evitar re-renderizações desnecessárias
Mermaid
sequenceDiagram
    participant A as API
    participant S as Service/Hook
    participant ST as State Manager
    participant C as Component
    participant U as User
    
    A->>S: Response data
    S->>S: Transform/Format data
    S->>ST: Update state
    ST->>C: Re-render with new data
    C->>U: Display updated UI
Validação de Dados
A validação ocorre em múltiplas camadas para garantir integridade dos dados:

Frontend Validation
Validação em tempo real: Feedback imediato durante digitação
Validação no envio: Antes de enviar para API
Utiliza: Form hooks personalizados + utilitários de validação
API Validation
Schema validation: Verifica estrutura e tipos de dados
Business rules: Aplica regras específicas de negócio
Utiliza: Middleware de validação + validadores de domínio
Database Validation
Constraints: Unique, foreign keys, not null, etc.
Check constraints: Validações específicas de valor
Triggers: Validações complexas antes de commit
Exemplo de Validação Multicamada (Criação de Usuário)
Mermaid
sequenceDiagram
    participant U as UI Form
    participant C as Client Validation
    participant A as API Endpoint
    participant B as Business Logic
    participant D as Database
    
    U->>C: Form submission
    C->>C: Validate email format
    C->>C: Validate password strength
    C->>A: POST /users
    A->>A: Validate request schema
    A->>B: Create user use case
    B->>B: Check if email exists
    B->>B: Hash password
    B->>D: INSERT user
    D->>D: Check constraints
    D-->>B: Success/Failure
    B-->>A: Response
    A-->>U: 201 Created / Error
Tratamento de Erros
Erros Previsíveis: Validados e tratados com mensagens específicas
Erros Técnicos: Capturados, logados e respondidos com mensagens genéricas
Erros de Frontend: Exibidos em componentes toast/alert
Erros de API: Respondidos com status codes e mensagens apropriados
A arquitetura de fluxo de dados do StrateUp v3 foi projetada para garantir consistência, manutenibilidade e desempenho ótimo, seguindo princípios de unidirecionalidade e responsabilidade única. EOF

3. Criar documento de arquitetura para apps
cat > "${DOC_DIR}/architecture/apps-structure.md" << 'EOF'

📱 Estrutura de Apps StrateUp v3
Este documento descreve a estrutura interna de cada aplicação no monorepo StrateUp v3, incluindo organização de diretórios, abordagens arquiteturais e padrões de design.

📋 Índice
Visão Geral
Estrutura Comum de Diretórios
App Web
App Admin
App API
Serviço AI
Visão Geral
Cada aplicação no monorepo StrateUp v3 segue uma estrutura de diretórios e organização de código consistente, porém adaptada às suas necessidades específicas. Todas as aplicações compartilham pacotes comuns como @strateup/ui, @strateup/utils, e outras dependências de base.

Estrutura Comum de Diretórios
Todas as aplicações seguem uma estrutura base comum:

Code
app/
├── public/         # Arquivos estáticos públicos
├── src/            # Código fonte
│   ├── components/ # Componentes específicos da aplicação
│   ├── hooks/      # Hooks React personalizados
│   ├── pages/      # Páginas/Rotas (Next.js)
│   ├── styles/     # Estilos específicos da aplicação
│   ├── types/      # Tipos TypeScript
│   └── utils/      # Utilitários específicos da aplicação
├── tests/          # Testes unitários e de integração
├── .env.example    # Exemplo de variáveis de ambiente
├── next.config.js  # Configuração Next.js
└── tsconfig.json   # Configuração TypeScript
App Web
O App Web é a interface principal para os clientes finais da plataforma StrateUp v3.

Estrutura Específica
Code
apps/web/
├── public/
│   ├── favicon.ico
│   └── images/      # Imagens específicas do app web
├── src/
│   ├── components/  
│   │   ├── layout/  # Layout components (Header, Footer, etc.)
│   │   ├── home/    # Componentes específicos da página inicial
│   │   ├── auth/    # Componentes de autenticação
│   │   ├── funnel/  # Componentes de funil de vendas
│   │   └── shared/  # Componentes compartilhados específicos do app
│   ├── hooks/
│   │   ├── useFunnel.ts      # Hooks de lógica de funil de vendas
│   │   ├── useLocalStorage.ts # Hook para gerenciar localStorage
│   │   └── useAuth.ts        # Hook para gerenciar autenticação
│   ├── pages/
│   │   ├── api/     # API Routes do Next.js
│   │   ├── auth/    # Páginas de autenticação
│   │   ├── dashboard/ # Dashboard do cliente
│   │   ├── funnel/  # Páginas de funil de vendas
│   │   ├── _app.tsx # App wrapper
│   │   ├── _document.tsx # Document wrapper
│   │   └── index.tsx # Página inicial
│   ├── services/
│   │   ├── api.ts   # Cliente de API
│   │   ├── auth.ts  # Serviço de autenticação
│   │   └── analytics.ts # Serviço de analytics
│   ├── contexts/
│   │   ├── AuthContext.tsx   # Contexto de autenticação
│   │   └── ThemeContext.tsx  # Contexto de tema
│   └── utils/
│       ├── constants.ts # Constantes específicas do app
│       └── helpers.ts   # Funções auxiliares do app
├── tests/
│   ├── components/ # Testes de componentes
│   ├── hooks/      # Testes de hooks
│   └── pages/      # Testes de páginas
└── next.config.js
Abordagem Arquitetural
O App Web utiliza uma arquitetura baseada em componentes com separation of concerns:

Componentes de Apresentação (UI): Focados apenas em renderização
Componentes Contêiner: Lidam com lógica de negócio e estado
Hooks Personalizados: Encapsulam lógica reutilizável
Contextos: Gerenciam estado global da aplicação
Fluxo de Renderização
Mermaid
graph TD
    A[_app.tsx] -->|Globals| B[Layout]
    B -->|Page structure| C[Page Component]
    C -->|Container| D[Container Components]
    D -->|Props| E[Presentation Components]
    C -->|Direct| E
    F[Context Providers] -->|Global state| D
    F -->|Global state| C
    G[Hooks] -->|Local state/effects| D
App Admin
O App Admin é o painel administrativo para uso interno da equipe StrateUp.

Estrutura Específica
Code
apps/admin/
├── src/
│   ├── components/  
│   │   ├── layout/  # Dashboard layout
│   │   ├── customers/ # Componentes relacionados a clientes
│   │   ├── campaigns/ # Componentes de campanhas
│   │   ├── reports/  # Componentes de relatórios
│   │   └── shared/   # Componentes compartilhados específicos
│   ├── pages/
│   │   ├── customers/ # Gerenciamento de clientes
│   │   ├── campaigns/ # Gerenciamento de campanhas
│   │   ├── reports/   # Página de relatórios
│   │   ├── settings/  # Configurações do sistema
│   │   └── index.tsx  # Dashboard principal
│   ├── services/
│   │   ├── customer.ts # Serviço para dados de clientes
│   │   ├── campaign.ts # Serviço para campanhas
│   │   └── reports.ts  # Serviço para relatórios
│   └── types/
│       ├── customer.ts # Tipos relacionados a cliente
│       └── campaign.ts # Tipos relacionados a campanha
└── next.config.js
Padrões Especiais
O painel Admin utiliza:

RBAC (Role-Based Access Control): Para controle de permissões granular
Data Tables Complexas: Para visualização e manipulação de dados
Visualização de Dados: Para relatórios e dashboards analíticos
App API
A API fornece endpoints para uso dos aplicativos web e admin, além de potencialmente servir integrações externas.

Estrutura Específica
Code
apps/api/
├── src/
│   ├── controllers/      # Controladores de rotas
│   │   ├── auth/         # Controladores de autenticação
│   │   ├── customer/     # Controladores de cliente
│   │   └── campaign/     # Controladores de campanha
│   ├── middlewares/      # Middlewares compartilhados
│   │   ├── auth.ts       # Middleware de autenticação
│   │   ├── validation.ts # Middleware de validação
│   │   └── rateLimit.ts  # Limitador de requisições
│   ├── models/           # Modelos de dados
│   ├── pages/
│   │   └── api/          # Endpoints da API
│   │       ├── auth/     # Rotas de autenticação
│   │       ├── customers/ # Rotas de clientes
│   │       ├── campaigns/ # Rotas de campanhas
│   │       └── webhooks/ # Webhooks para integrações
│   ├── services/         # Serviços business logic
│   │   ├── auth.ts       # Serviço de autenticação
│   │   ├── customer.ts   # Serviço de cliente
│   │   └── notification.ts # Serviço de notificação
│   ├── repositories/     # Camada de acesso a dados
│   │   ├── customer.ts   # Repository de cliente
│   │   └── campaign.ts   # Repository de campanha
│   ├── types/            # Tipos e interfaces
│   │   ├── api.ts        # Tipos de requisições/respostas
│   │   └── models.ts     # Tipos de modelos de dados
│   └── utils/
│       ├── constants.ts  # Constantes da API
│       ├── errors.ts     # Classes de erro personalizadas
│       └── logger.ts     # Utilitário de logging
└── next.config.js
Padrão Arquitetural
A API segue o padrão Clean Architecture:

Mermaid
graph TD
    A[API Routes] -->|HTTP Request| B[Controllers]
    B -->|Validated Data| C[Use Cases / Services]
    C -->|Business Logic| D[Repositories]
    D -->|Data Access| E[Database]
    
    F[DTOs] -.->|Input/Output Models| B
    G[Domain Entities] -.->|Domain Models| C
    H[Validation] -.->|Input Validation| B
    I[Error Handling] -.->|Error Processing| B
Serviço AI
O serviço de IA processa tarefas relacionadas a inteligência artificial e machine learning.

Estrutura Específica
Code
apps/ai-service/
├── src/
│   ├── lib/             # Bibliotecas e adaptadores
│   │   ├── openai.ts    # Adaptador OpenAI
│   │   └── supabase.ts  # Cliente Supabase
│   ├── models/          # Modelos para ML/AI
│   │   ├── sentiment/   # Modelo de análise de sentimento
│   │   └── classifier/  # Modelo de classificação
│   ├── services/        # Serviços de negócio
│   │   ├── messageAnalysis.ts # Análise de mensagens
│   │   └── customerSegmentation.ts # Segmentação de clientes
│   ├── pages/
│   │   └── api/         # Endpoints da API
│   │       ├── analyze/ # Endpoints de análise
│   │       └── predict/ # Endpoints de predição
│   ├── utils/
│   │   ├── text.ts      # Processamento de texto
│   │   └── vectorize.ts # Utilitários de vetorização
│   └── types/
│       ├── prediction.ts # Tipos relacionados a predição
│       └── analysis.ts   # Tipos relacionados a análise
└── next.config.js
Características Específicas
O serviço de IA apresenta:

Integração com APIs de ML/AI: Conexão com serviços como OpenAI, TensorFlow.js
Processamento Assíncrono: Para tarefas de longa duração
Estratégias de Caching: Para resultados de modelos frequentemente utilizados
Webhooks: Para notificação de conclusão de tarefas longas
Pacotes Compartilhados
Os pacotes compartilhados são utilizados por todos os apps e seguem padrões específicos:

UI (@strateup/ui)
Code
packages/ui/
├── src/
│   ├── components/     # Componentes UI reutilizáveis
│   ├── hooks/          # Hooks relacionados à UI
│   ├── theme/          # Definições de tema e estilos
│   └── utils/          # Utilitários específicos de UI
├── stories/            # Storybook stories
└── tests/              # Testes de componentes
Utils (@strateup/utils)
Code
packages/utils/
├── src/
│   ├── format/         # Formatadores (data, moeda, etc.)
│   ├── validation/     # Funções de validação
│   ├── string/         # Manipulação de strings
│   └── object/         # Manipulação de objetos
└── tests/              # Testes unitários
Database (@strateup/database)
Code
packages/database/
├── src/
│   ├── client.ts       # Cliente Supabase compartilhado
│   ├── schema/         # Definições de schema
│   ├── migrations/     # Migrações de banco de dados
│   └── repositories/   # Repositórios compartilhados
└── tests/              # Testes de integração
A consistência entre as estruturas dos aplicativos e pacotes compartilhados facilita o desenvolvimento e manutenção do projeto como um todo, permitindo aos desenvolvedores mudar de contexto rapidamente entre diferentes partes do sistema. EOF

log_success "Documentação arquitetural criada com sucesso." }

Otimizar configurações de build para diferentes ambientes
optimize_build_configurations() { log_section "Otimização de Builds para Múltiplos Ambientes"

1. Criar diretório de configurações de ambiente
mkdir -p "config/environments"

2. Criar configuração de ambiente de desenvolvimento
cat > "config/environments/.env.development" << 'EOF'

Ambiente de Desenvolvimento
NODE_ENV=development

URLs públicas
NEXT_PUBLIC_APP_URL=http://localhost:3000 NEXT_PUBLIC_ADMIN_URL=http://localhost:3001 NEXT_PUBLIC_API_URL=http://localhost:3002/api

API URLs internos
API_URL=http://localhost:3002/api AI_SERVICE_URL=http://localhost:3003/api

Configurações de Debug
DEBUG=true DEBUG_LEVEL=verbose

Performance
ANALYZE_BUNDLE=false EOF

3. Criar configuração de ambiente de staging
cat > "config/environments/.env.staging" << 'EOF'

Ambiente de Staging
NODE_ENV=production

URLs públicas
NEXT_PUBLIC_APP_URL=https://staging.strateup.app NEXT_PUBLIC_ADMIN_URL=https://staging-admin.strateup.app NEXT_PUBLIC_API_URL=https://staging-api.strateup.app/api

API URLs internos
API_URL=https://staging-api.strateup.app/api AI_SERVICE_URL=https://staging-ai.strateup.app/api

Configurações de Debug
DEBUG=true DEBUG_LEVEL=error

Performance
ANALYZE_BUNDLE=true EOF

4. Criar configuração de ambiente de produção
cat > "config/environments/.env.production" << 'EOF'

Ambiente de Produção
NODE_ENV=production

URLs públicas
NEXT_PUBLIC_APP_URL=https://strateup.app NEXT_PUBLIC_ADMIN_URL=https://admin.strateup.app NEXT_PUBLIC_API_URL=https://api.strateup.app/api

API URLs internos
API_URL=https://api.strateup.app/api AI_SERVICE_URL=https://ai.strateup.app/api

Configurações de Debug
DEBUG=false DEBUG_LEVEL=error

Performance
ANALYZE_BUNDLE=true EOF

5. Atualizar turbo.json para suporte a diferentes ambientes
cat > "turbo.json" << 'EOF' { "$schema": "https://turbo.build/schema.json", "globalDependencies": ["/.env.*local"], "globalEnv": [ "NODE_ENV", "NEXT_PUBLIC_API_URL", "NEXT_PUBLIC_APP_URL", "NEXT_PUBLIC_SUPABASE_URL", "NEXT_PUBLIC_SUPABASE_ANON_KEY", "NEXT_PUBLIC_ANALYTICS_ID", "PORT", "DEBUG", "DEBUG_LEVEL" ], "pipeline": { "build": { "dependsOn": ["^build"], "outputs": ["dist/", ".next/", "!.next/cache/", "build/"] }, "build:development": { "dependsOn": ["^build:development"], "outputs": ["dist/", ".next/", "!.next/cache/", "build/"], "env": ["NEXT_PUBLIC_*", "NODE_ENV=development"] }, "build:staging": { "dependsOn": ["^build:staging"], "outputs": ["dist/", ".next/", "!.next/cache/", "build/"], "env": ["NEXT_PUBLIC_*", "NODE_ENV=production"] }, "build:production": { "dependsOn": ["^build:production"], "outputs": ["dist/", ".next/", "!.next/cache/", "build/"], "env": ["NEXT_PUBLIC_*", "NODE_ENV=production"] }, "lint": { "dependsOn": ["^build"], "outputs": [] }, "test": { "dependsOn": ["^build"], "outputs": ["coverage/"], "inputs": ["src//*.tsx", "src//.ts", "test/**/.ts", "test//*.tsx"] }, "dev": { "cache": false, "persistent": true }, "start": { "cache": false }, "clean": { "cache": false }, "storybook": { "cache": false, "persistent": true }, "build-storybook": { "dependsOn": ["^build"], "outputs": ["storybook-static/"] } } } EOF

6. Atualizar package.json para incluir scripts de ambientes
local package_json=$(cat package.json)

Extrair o bloco de scripts existente
local scripts_block=$(echo "$package_json" | sed -n '/"scripts": {/,/}/p')

Atualizar o bloco de scripts mantendo os existentes e adicionando novos
local updated_scripts_block=$(echo "$scripts_block" | sed 's/"dev": "turbo run dev",/"dev": "turbo run dev",\n "build:development": "turbo run build:development",\n "build:staging": "turbo run build:staging",\n "build:production": "turbo run build:production",/')

Substituir o bloco antigo pelo novo no package.json
new_package_json=$(echo "$package_json" | sed "s|$scripts_block|$updated_scripts_block|")

Escrever o novo package.json
echo "$new_package_json" > package.json

7. Criar documentação de uso dos ambientes
cat > "config/environments/README.md" << 'EOF'

🌍 Configurações de Ambiente do StrateUp v3
Este diretório contém as configurações para diferentes ambientes de execução do StrateUp v3.

Ambientes Disponíveis
Development: Ambiente local de desenvolvimento
Staging: Ambiente de testes e homologação
Production: Ambiente de produção
Como Usar
Para utilizar estas configurações, escolha um dos scripts específicos de ambiente:

bash
# Desenvolvimento
pnpm run build:development

# Staging
pnpm run build:staging

# Produção
pnpm run build:production
Personalização por Projeto
Cada projeto pode sobrescrever estas configurações criando arquivos .env.local em sua raiz. A precedência seguida é:

.env.local (maior prioridade - não versionado)
.env.[ambiente].local (não versionado)
.env.[ambiente] (versionado)
.env (versionado)
Variáveis Comuns
Variável	Descrição	Valor Default
NODE_ENV	Ambiente Node.js	development ou production
NEXT_PUBLIC_APP_URL	URL da aplicação web	Varia por ambiente
NEXT_PUBLIC_API_URL	URL da API	Varia por ambiente
DEBUG	Ativa logs de debug	true ou false
DEBUG_LEVEL	Nível de detalhe dos logs	verbose, info, warn, error
ANALYZE_BUNDLE	Ativa análise de bundle	true ou false
Dicas de Segurança
Nunca comite credenciais em arquivos .env

Use .env.local para chaves de API e senhas

Mantenha os arquivos .env.example atualizados com todas as variáveis (sem valores sensíveis)

Configure segredos diretamente nas plataformas de deploy (Vercel, Netlify, etc.) EOF

log_success "Configurações de build para múltiplos ambientes criadas com sucesso." }

Criar templates para apps
create_app_templates() { log_section "Criação de Templates para Apps"

1. Criar diretório de templates
mkdir -p "config/templates/apps"

2. Criar template para app Next.js
mkdir -p "config/templates/apps/next-app"

2.1 Criar package.json template
cat > "config/templates/apps/next-app/package.json.template" << 'EOF' { "name": "@strateup/{{APP_NAME}}", "version": "0.1.0", "private": true, "scripts": { "dev": "next dev -p {{PORT}}", "build": "next build", "build:development": "next build", "build:staging": "next build", "build:production": "next build", "start": "next start -p {{PORT}}", "lint": "next lint", "test": "jest" }, "dependencies": { "@strateup/ui": "workspace:", "@strateup/utils": "workspace:", "next": "^13.5.6", "react": "^18.2.0", "react-dom": "^18.2.0" }, "devDependencies": { "@strateup/eslint-config-custom": "workspace:", "@strateup/tsconfig": "workspace:", "@types/node": "^18.15.3", "@types/react": "^18.0.28", "@types/react-dom": "^18.0.11", "eslint": "^8.36.0", "jest": "^29.5.0", "@testing-library/react": "^14.0.0", "typescript": "^4.9.5" } } EOF

2.2 Criar tsconfig.json template
cat > "config/templates/apps/next-app/tsconfig.json.template" << 'EOF' { "extends": "@strateup/tsconfig/nextjs.json", "compilerOptions": { "baseUrl": ".", "paths": { "@/": ["./src/"] } }, "include": ["next-env.d.ts", "/*.ts", "/.tsx", ".next/types/**/.ts"], "exclude": ["node_modules"] } EOF

2.3 Criar next.config.js template
cat > "config/templates/apps/next-app/next.config.js.template" << 'EOF' /** @type {import('next').NextConfig} */ const nextConfig = { reactStrictMode: true, swcMinify: true, transpilePackages: ["@strateup/ui"], images: { domains: ['strateup.app'] }, eslint: { // Ignoramos durante a build pois já executamos separadamente ignoreDuringBuilds: process.env.NODE_ENV === 'production', }, typescript: { // Ignoramos durante a build pois já executamos separadamente ignoreBuildErrors: process.env.NODE_ENV === 'production', }, experimental: { // Experimental features } };

module.exports = nextConfig; EOF

2.4 Criar .eslintrc.js template
cat > "config/templates/apps/next-app/.eslintrc.js.template" << 'EOF' module.exports = { root: true, extends: ["@strateup/eslint-config-custom/next"], parserOptions: { tsconfigRootDir: __dirname, project: "./tsconfig.json", }, settings: { next: { rootDir: ["./"] } } }; EOF

2.5 Criar estrutura básica de arquivos
mkdir -p "config/templates/apps/next-app/src/pages" mkdir -p "config/templates/apps/next-app/src/components" mkdir -p "config/templates/apps/next-app/src/hooks" mkdir -p "config/templates/apps/next-app/src/types" mkdir -p "config/templates/apps/next-app/src/styles" mkdir -p "config/templates/apps/next-app/src/utils" mkdir -p "config/templates/apps/next-app/public"

2.6 Criar _app.tsx template
cat > "config/templates/apps/next-app/src/pages/_app.tsx.template" << 'EOF' import type { AppProps } from 'next/app'; import '@/styles/globals.css';

export default function App({ Component, pageProps }: AppProps) { return <Component {...pageProps} />; } EOF

2.7 Criar _document.tsx template
cat > "config/templates/apps/next-app/src/pages/_document.tsx.template" << 'EOF' import { Html, Head, Main, NextScript } from 'next/document';

export default function Document() { return ( <Html lang="pt-BR"> <Head> {/* Fonts e meta tags */} <link rel="preconnect" href="https://fonts.googleapis.com" /> <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" /> <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" /> <meta name="theme-color" content="#0070f3" /> </Head> <body> <Main /> <NextScript /> </body> </Html> ); } EOF

2.8 Criar página index template
cat > "config/templates/apps/next-app/src/pages/index.tsx.template" << 'EOF' import React from 'react'; import Head from 'next/head'; import { Button } from '@strateup/ui'; import { formatDate } from '@strateup/utils';

export default function Home() { return ( <> <Head> <title>{{APP_TITLE}}</title> <meta name="description" content="{{APP_DESCRIPTION}}" /> <meta name="viewport" content="width=device-width, initial-scale=1" /> <link rel="icon" href="/favicon.ico" /> </Head> <main className="flex min-h-screen flex-col items-center justify-center p-8"> <div className="max-w-3xl text-center"> <h1 className="text-4xl font-bold mb-6 text-blue-600">{{APP_TITLE}}</h1> <p className="text-lg text-gray-700 mb-8"> Bem-vindo ao {{APP_NAME}}. Hoje é {formatDate(new Date())}. </p>

Code
      <div className="flex gap-4 justify-center">
        <Button variant="primary">Botão Primário</Button>
        <Button variant="secondary">Botão Secundário</Button>
      </div>
      
      <p className="mt-6 text-sm text-gray-500">
        Este app usa os pacotes compartilhados @strateup/ui e @strateup/utils.
      </p>
    </div>
  </main>
</>
); } EOF

2.9 Criar globals.css template
cat > "config/templates/apps/next-app/src/styles/globals.css.template" << 'EOF' @tailwind base; @tailwind components; @tailwind utilities;

:root { --foreground-rgb: 0, 0, 0; --background-rgb: 255, 255, 255; --primary-color: #0070f3; }

@media (prefers-color-scheme: dark) { :root { --foreground-rgb: 255, 255, 255; --background-rgb: 10, 10, 10; } }

body { color: rgb(var(--foreground-rgb)); background: rgb(var(--background-rgb)); font-family: 'Inter', sans-serif; }

h1, h2, h3, h4, h5, h6 { font-weight: 700; } EOF

2.10 Criar jest.config.js template
cat > "config/templates/apps/next-app/jest.config.js.template" << 'EOF' const nextJest = require('next/jest');

const createJestConfig = nextJest({ // Provide the path to your Next.js app to load next.config.js and .env files dir: './', });

/** @type {import('jest').Config} / const customJestConfig = { displayName: '{{APP_NAME}}', setupFilesAfterEnv: ['<rootDir>/jest.setup.js'], testEnvironment: 'jest-environment-jsdom', moduleNameMapper: { '^@/(.)$': '<rootDir>/src/$1', }, moduleDirectories: ['node_modules', '<rootDir>'], testMatch: ['**/?(*.)+(spec|test).[jt]s?(x)'], coveragePathIgnorePatterns: ['/node_modules/', '/.next/', '/out/', '/public/'], };

// createJestConfig is exported this way to ensure that next/jest can load the Next.js config module.exports = createJestConfig(customJestConfig); EOF

2.11 Criar jest.setup.js template
cat > "config/templates/apps/next-app/jest.setup.js.template" << 'EOF' // Learn more: https://github.com/testing-library/jest-dom import '@testing-library/jest-dom'; EOF

3. Criar template para app Next.js API
mkdir -p "config/templates/apps/next-api"

3.1 Criar package.json template para API
cat > "config/templates/apps/next-api/package.json.template" << 'EOF' { "name": "@strateup/{{APP_NAME}}", "version": "0.1.0", "private": true, "scripts": { "dev": "next dev -p {{PORT}}", "build": "next build", "build:development": "next build", "build:staging": "next build", "build:production": "next build", "start": "next start -p {{PORT}}", "lint": "next lint", "test": "jest" }, "dependencies": { "@strateup/utils": "workspace:", "@strateup/database": "workspace:", "next": "^13.5.6", "cors": "^2.8.5", "zod": "^3.22.4" }, "devDependencies": { "@strateup/eslint-config-custom": "workspace:", "@strateup/tsconfig": "workspace:", "@types/cors": "^2.8.17", "@types/node": "^18.15.3", "eslint": "^8.36.0", "jest": "^29.5.0", "supertest": "^6.3.3", "@types/supertest": "^2.0.16", "typescript": "^4.9.5" } } EOF

3.2 Criar tsconfig.json template para API
cat > "config/templates/apps/next-api/tsconfig.json.template" << 'EOF' { "extends": "@strateup/tsconfig/nextjs.json", "compilerOptions": { "baseUrl": ".", "paths": { "@/": ["./src/"] } }, "include": ["next-env.d.ts", "/*.ts", "/.tsx", ".next/types/**/.ts"], "exclude": ["node_modules"] } EOF

3.3 Criar next.config.js template para API
cat > "config/templates/apps/next-api/next.config.js.template" << 'EOF' /** @type {import('next').NextConfig} */ const nextConfig = { reactStrictMode: true, swcMinify: true, eslint: { ignoreDuringBuilds: process.env.NODE_ENV === 'production', }, typescript: { ignoreBuildErrors: process.env.NODE_ENV === 'production', }, experimental: { // Experimental features } };

module.exports = nextConfig; EOF

3.4 Criar estrutura básica de arquivos para API
mkdir -p "config/templates/apps/next-api/src/pages/api" mkdir -p "config/templates/apps/next-api/src/controllers" mkdir -p "config/templates/apps/next-api/src/services" mkdir -p "config/templates/apps/next-api/src/models" mkdir -p "config/templates/apps/next-api/src/middlewares" mkdir -p "config/templates/apps/next-api/src/utils" mkdir -p "config/templates/apps/next-api/src/types" mkdir -p "config/templates/apps/next-api/tests"

3.5 Criar middleware de CORS
cat > "config/templates/apps/next-api/src/middlewares/cors.ts.template" << 'EOF' import Cors from 'cors'; import type { NextApiRequest, NextApiResponse } from 'next';

// Inicializar o middleware CORS const cors = Cors({ methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'], credentials: true, origin: (origin, callback) => { // Permitir requests sem origin (como aplicações móveis ou curl) if (!origin) return callback(null, true);

Code
// Lista branca de domínios permitidos
const allowedOrigins = [
  // URLs de desenvolvimento
  'http://localhost:3000',
  'http://localhost:3001',
  
  // URLs de produção
  'https://strateup.app',
  'https://admin.strateup.app',
  
  // Regex para subdomínios
  /^https:\/\/[\w-]+\.strateup\.app$/,
];

// Verificar se o origin está na lista permitida
const isAllowed = allowedOrigins.some(allowedOrigin => {
  if (typeof allowedOrigin === 'string') {
    return allowedOrigin === origin;
  }
  if (allowedOrigin instanceof RegExp) {
    return allowedOrigin.test(origin);
  }
  return false;
});

if (isAllowed) {
  callback(null, true);
} else {
  callback(new Error('CORS não permitido para este origem'), false);
}
} });

// Helper para executar o middleware function runMiddleware(req: NextApiRequest, res: NextApiResponse, fn: Function) { return new Promise((resolve, reject) => { fn(req, res, (result: any) => { if (result instanceof Error) { return reject(result); } return resolve(result); }); }); }

// Exportar middleware pronto para uso export default async function corsMiddleware(req: NextApiRequest, res: NextApiResponse) { await runMiddleware(req, res, cors); } EOF

3.6 Criar middleware de autenticação
cat > "config/templates/apps/next-api/src/middlewares/auth.ts.template" << 'EOF' import { NextApiRequest, NextApiResponse } from 'next'; import { createClient } from '@supabase/supabase-js';

// Inicializar cliente Supabase const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || ''; const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

const supabase = createClient(supabaseUrl, supabaseServiceKey);

// Tipos export interface AuthenticatedRequest extends NextApiRequest { user?: { id: string; email: string; role: string; }; }

// Middleware de autenticação export async function withAuth( req: AuthenticatedRequest, res: NextApiResponse, next: () => Promise<void> ) { try { // Obter token JWT do cabeçalho Authorization const authHeader = req.headers.authorization;

Code
if (!authHeader || !authHeader.startsWith('Bearer ')) {
  return res.status(401).json({ error: 'Unauthorized: Missing or invalid token' });
}

const token = authHeader.split(' ')[1];

// Verificar token com Supabase
const { data: { user }, error } = await supabase.auth.getUser(token);

if (error || !user) {
  return res.status(401).json({ error: 'Unauthorized: Invalid token' });
}

// Buscar informações adicionais do usuário se necessário
const { data: userProfile } = await supabase
  .from('profiles')
  .select('role')
  .eq('id', user.id)
  .single();

// Adicionar usuário ao request para uso em controllers
req.user = {
  id: user.id,
  email: user.email || '',
  role: userProfile?.role || 'user',
};

// Continuar para o próximo middleware ou handler
await next();
} catch (error) { console.error('Auth middleware error:', error); return res.status(500).json({ error: 'Internal server error during authentication' }); } }

// Middleware de autorização baseada em função export function withRole(role: string | string[]) { return async ( req: AuthenticatedRequest, res: NextApiResponse, next: () => Promise<void> ) => { try { // Primeiro garantir que o usuário está autenticado await withAuth(req, res, async () => { if (!req.user) { return res.status(401).json({ error: 'Unauthorized: User not authenticated' }); }

Code
    const roles = Array.isArray(role) ? role : [role];
    
    // Verificar se o usuário tem a função necessária
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ 
        error: 'Forbidden: Insufficient permissions',
        requiredRole: roles,
        userRole: req.user.role
      });
    }

    // Usuário tem a função necessária, continuar
    await next();
  });
} catch (error) {
  console.error('Role middleware error:', error);
  return res.status(500).json({ error: 'Internal server error during authorization' });
}
}; } EOF

3.7 Criar controlador básico
cat > "config/templates/apps/next-api/src/controllers/healthController.ts.template" << 'EOF' import type { NextApiRequest, NextApiResponse } from 'next';

/**

Controlador para endpoint de health check */ export const healthController = async (req: NextApiRequest, res: NextApiResponse) => { try { // Verificar banco de dados (opcional) // const dbStatus = await checkDatabaseConnection();

res.status(200).json({ status: 'ok', timestamp: new Date().toISOString(), environment: process.env.NODE_ENV || 'development', // database: dbStatus ? 'connected' : 'error', uptime: process.uptime(), }); } catch (error) { console.error('Health check error:', error); res.status(500).json({ status: 'error', message: 'Health check failed', timestamp: new Date().toISOString() }); } }; EOF

3.8 Criar endpoint de health
cat > "config/templates/apps/next-api/src/pages/api/health.ts.template" << 'EOF' import type { NextApiRequest, NextApiResponse } from 'next'; import corsMiddleware from '@/middlewares/cors'; import { healthController } from '@/controllers/healthController';

/**

Endpoint de health check
@route GET /api/health */ export default async function handler(req: NextApiRequest, res: NextApiResponse) { // Aplicar CORS await corsMiddleware(req, res);
// Verificar método if (req.method !== 'GET') { return res.status(405).json({ error: 'Method not allowe

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  // Aplicar CORS
  await corsMiddleware(req, res);

  // Verificar método
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed', allowedMethods: ['GET'] });
  }

  // Chamar controlador
  return healthController(req, res);
}
EOF
  
  # 3.9 Criar base de tipos para API
  cat > "config/templates/apps/next-api/src/types/api.ts.template" << 'EOF'
import { NextApiRequest, NextApiResponse } from 'next';

/**
 * Tipo básico para controladores de API
 */
export type ApiHandler<T = any> = (
  req: NextApiRequest,
  res: NextApiResponse<T>
) => Promise<void> | void;

/**
 * Resposta de sucesso padrão
 */
export interface ApiSuccessResponse<T = any> {
  success: true;
  data: T;
  timestamp: string;
}

/**
 * Resposta de erro padrão
 */
export interface ApiErrorResponse {
  success: false;
  error: {
    code: string;
    message: string;
    details?: any;
  };
  timestamp: string;
}

/**
 * Criador de resposta de sucesso
 */
export function createSuccessResponse<T>(data: T): ApiSuccessResponse<T> {
  return {
    success: true,
    data,
    timestamp: new Date().toISOString(),
  };
}

/**
 * Criador de resposta de erro
 */
export function createErrorResponse(
  code: string, 
  message: string, 
  details?: any
): ApiErrorResponse {
  return {
    success: false,
    error: {
      code,
      message,
      ...(details && { details }),
    },
    timestamp: new Date().toISOString(),
  };
}
EOF
  
  # 3.10 Criar utilitário para logging
  cat > "config/templates/apps/next-api/src/utils/logger.ts.template" << 'EOF'
/**
 * Utilitário de logging para API
 */

type LogLevel = 'debug' | 'info' | 'warn' | 'error';

interface LogOptions {
  context?: string;
  metadata?: Record<string, any>;
}

class Logger {
  private levels: Record<LogLevel, number> = {
    debug: 0,
    info: 1,
    warn: 2,
    error: 3,
  };

  private currentLevel: LogLevel;

  constructor() {
    // Determinar nível de log baseado em variável de ambiente
    this.currentLevel = (process.env.DEBUG_LEVEL as LogLevel) || 'info';
  }

  /**
   * Verifica se um determinado nível deve ser logado
   */
  private shouldLog(level: LogLevel): boolean {
    return this.levels[level] >= this.levels[this.currentLevel];
  }

  /**
   * Formata mensagem de log com data e contexto
   */
  private formatMessage(level: LogLevel, message: string, options?: LogOptions): string {
    const timestamp = new Date().toISOString();
    const context = options?.context ? `[${options.context}]` : '';
    return `${timestamp} ${level.toUpperCase()} ${context} ${message}`;
  }

  /**
   * Log nível debug
   */
  debug(message: string, options?: LogOptions): void {
    if (this.shouldLog('debug')) {
      const formattedMsg = this.formatMessage('debug', message, options);
      console.debug(formattedMsg, options?.metadata || '');
    }
  }

  /**
   * Log nível info
   */
  info(message: string, options?: LogOptions): void {
    if (this.shouldLog('info')) {
      const formattedMsg = this.formatMessage('info', message, options);
      console.info(formattedMsg, options?.metadata || '');
    }
  }

  /**
   * Log nível warn
   */
  warn(message: string, options?: LogOptions): void {
    if (this.shouldLog('warn')) {
      const formattedMsg = this.formatMessage('warn', message, options);
      console.warn(formattedMsg, options?.metadata || '');
    }
  }

  /**
   * Log nível error
   */
  error(message: string, error?: Error, options?: LogOptions): void {
    if (this.shouldLog('error')) {
      const formattedMsg = this.formatMessage('error', message, options);
      console.error(formattedMsg, error || '', options?.metadata || '');
    }
  }

  /**
   * Log de requisição HTTP
   */
  logRequest(req: any, options?: LogOptions): void {
    this.info(`${req.method} ${req.url || req.path}`, {
      context: 'HTTP',
      metadata: {
        method: req.method,
        path: req.url || req.path,
        query: req.query,
        ip: req.headers['x-forwarded-for'] || req.connection?.remoteAddress,
        userAgent: req.headers['user-agent'],
      },
      ...options,
    });
  }
}

// Exportar instância singleton
export const logger = new Logger();
EOF
  
  # 4. Criar script para geração de app a partir de template
  cat > "config/templates/create-app.sh" << 'EOF'
#!/bin/bash

# =======================================================================
# create-app.sh
# Script para criar novo app a partir de template
# Parte do StrateUp v3
# =======================================================================

# Definições de cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Verificar argumentos
if [ "$#" -lt 2 ]; then
  echo -e "${RED}Uso: $0 <tipo-de-app> <nome-do-app> [porta]${NC}"
  echo -e "${YELLOW}Tipos disponíveis: next-app, next-api${NC}"
  echo -e "Exemplo: $0 next-app web 3000"
  exit 1
fi

APP_TYPE=$1
APP_NAME=$2
PORT=${3:-3000}
APP_TITLE=$(echo $APP_NAME | sed -r 's/(^|-)([a-z])/\U\2/g') # Capitalize each word

# Verificar tipo de app
if [ "$APP_TYPE" != "next-app" ] && [ "$APP_TYPE" != "next-api" ]; then
  echo -e "${RED}Tipo de app inválido: $APP_TYPE${NC}"
  echo -e "${YELLOW}Tipos disponíveis: next-app, next-api${NC}"
  exit 1
fi

# Definir diretório de destino
DEST_DIR="apps/$APP_NAME"
if [ -d "apps" ] && [ -d "apps 📱" ]; then
  DEST_DIR="apps 📱/$APP_NAME"
fi

# Verificar se diretório já existe
if [ -d "$DEST_DIR" ]; then
  echo -e "${RED}Diretório já existe: $DEST_DIR${NC}"
  echo -e "${YELLOW}Escolha outro nome ou remova o diretório existente.${NC}"
  exit 1
fi

# Caminho para templates
TEMPLATE_DIR="config/templates/apps/$APP_TYPE"

# Verificar se template existe
if [ ! -d "$TEMPLATE_DIR" ]; then
  echo -e "${RED}Diretório de template não encontrado: $TEMPLATE_DIR${NC}"
  exit 1
fi

echo -e "${BLUE}=== Criando novo app: $APP_NAME ===${NC}"
echo -e "${CYAN}Tipo: $APP_TYPE${NC}"
echo -e "${CYAN}Destino: $DEST_DIR${NC}"
echo -e "${CYAN}Porta: $PORT${NC}"

# Criar diretório de destino
mkdir -p "$DEST_DIR"

# Copiar arquivos sem extensão .template
echo -e "${YELLOW}Copiando estrutura de diretórios...${NC}"
find "$TEMPLATE_DIR" -type d -not -path "$TEMPLATE_DIR" | while read dir; do
  # Substituir caminho do template pelo destino
  new_dir="${dir/$TEMPLATE_DIR/$DEST_DIR}"
  mkdir -p "$new_dir"
done

# Processar arquivos template
echo -e "${YELLOW}Processando arquivos template...${NC}"
find "$TEMPLATE_DIR" -name "*.template" | while read file; do
  # Obter caminho relativo e nome de arquivo
  rel_path="${file#$TEMPLATE_DIR/}"
  rel_path="${rel_path%.template}"
  dest_file="$DEST_DIR/$rel_path"
  
  # Substituir variáveis no conteúdo
  cat "$file" | \
    sed "s/{{APP_NAME}}/$APP_NAME/g" | \
    sed "s/{{PORT}}/$PORT/g" | \
    sed "s/{{APP_TITLE}}/$APP_TITLE/g" | \
    sed "s/{{APP_DESCRIPTION}}/$APP_TITLE App para StrateUp v3/g" > "$dest_file"
  
  echo -e "${GREEN}Criado: $dest_file${NC}"
done

echo -e "${GREEN}App $APP_NAME criado com sucesso!${NC}"
echo -e "Para começar o desenvolvimento:"
echo -e "${CYAN}cd $DEST_DIR${NC}"
echo -e "${CYAN}pnpm run dev${NC}"
EOF

  # Tornar o script executável
  chmod +x "config/templates/create-app.sh"
  
  # 5. Criar README para templates
  cat > "config/templates/README.md" << 'EOF'
# 📋 Templates para Novos Apps no StrateUp v3

Este diretório contém templates para criar novos aplicativos no monorepo StrateUp v3.

## Tipos de Templates Disponíveis

- `next-app`: Template para aplicação Next.js front-end
- `next-api`: Template para API em Next.js

## Como Criar um Novo App

Use o script `create-app.sh` para gerar um novo aplicativo a partir de um template:

```bash
./config/templates/create-app.sh <tipo-de-app> <nome-do-app> [porta]