#!/bin/bash

# =======================================================================
# 01-project-init.sh
# Inicialização do Projeto e Configuração do Monorepo para StrateUp v3
# Passo 1 de 13 da construção do StrateUp v3
# Data: 2025-06-05 14:15:57
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
SCRIPT_NAME="01-project-init"
CURRENT_DATE="2025-06-05 14:15:57"
USER_NAME="StrateUpCompany"

# Verificar se estamos no diretório raiz do projeto
if [ ! -f ".strateup-step-0-complete" ] && [ ! -f ".strateup-step-0.1-complete" ]; then
  echo -e "${RED}${BOLD}ERRO:${NC} Este script deve ser executado no diretório raiz do projeto."
  echo -e "${YELLOW}Execute primeiro os scripts 00-environment-prep.sh e 00.1-fix-git-environment.sh.${NC}"
  exit 1
fi

# Criar diretório de logs se não existir
LOG_DIR="logs"
[ -d "logs 📊" ] && LOG_DIR="logs 📊"
BACKUP_DIR="backups/project-init-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DIR"
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}-$(date +%Y%m%d-%H%M%S).log"

# Definição de diretórios com emojis
DOC_DIR="docs"
[ -d "docs 📚" ] && DOC_DIR="docs 📚"

EMOJI_APPS="📱"
EMOJI_PACKAGES="📦"
EMOJI_UI="🎨"
EMOJI_UTILS="🧰"

# Banner de boas-vindas
welcome_banner() {
  clear
  echo -e "${BLUE}${BOLD}"
  echo "╔══════════════════════════════════════════════════════════════════════════╗"
  echo "║                                                                          ║"
  echo "║     STRATEUP V3 - INICIALIZAÇÃO DO PROJETO E CONFIGURAÇÃO DO MONOREPO    ║"
  echo "║                                                                          ║"
  echo "║                    Passo 1 de 13: Configuração Base                      ║"
  echo "║                                                                          ║"
  echo "╚══════════════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  echo -e "${CYAN}${BOLD}Versão:${NC} $SCRIPT_VERSION"
  echo -e "${CYAN}${BOLD}Data e Hora:${NC} $CURRENT_DATE"
  echo -e "${CYAN}${BOLD}Usuário:${NC} $USER_NAME"
  echo
  echo -e "${PURPLE}${BOLD}📋 Sobre este script:${NC}"
  echo -e "Este script configura o ambiente de desenvolvimento do StrateUp v3,"
  echo -e "incluindo setup completo do monorepo, pacotes compartilhados, configurações"
  echo -e "de TypeScript, ESLint, Prettier e inicialização do ambiente de testes."
  echo
  echo -e "${YELLOW}${BOLD}✨ Funcionalidades:${NC}"
  echo -e "✅ Configuração do monorepo com Turborepo"
  echo -e "✅ Criação de pacotes compartilhados (tsconfig, eslint-config, ui, utils)"
  echo -e "✅ Configuração de TypeScript para todos os pacotes"
  echo -e "✅ Setup de ESLint e Prettier com regras otimizadas"
  echo -e "✅ Configuração de ambiente de testes"
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
  
  # Verificar se Node.js está instalado
  if ! check_command node; then
    log_error "Node.js não encontrado. Por favor, instale o Node.js (v16+)."
    all_good=false
  else
    log_success "Node.js encontrado: $(node -v)"
  fi
  
  # Verificar se pnpm está instalado
  if ! check_command pnpm; then
    log_error "pnpm não encontrado. Por favor, instale o pnpm (v7+)."
    all_good=false
  else
    log_success "pnpm encontrado: $(pnpm -v)"
  fi
  
  # Verificar se Git está instalado
  if ! check_command git; then
    log_error "Git não encontrado. Por favor, instale o Git."
    all_good=false
  else
    log_success "Git encontrado: $(git --version)"
  fi
  
  # Verificar arquivos importantes
  for file in package.json pnpm-workspace.yaml .gitignore; do
    if [ ! -f "$file" ]; then
      log_error "Arquivo $file não encontrado. Execute os scripts anteriores primeiro."
      all_good=false
    else
      log_success "Arquivo $file encontrado."
    fi
  done
  
  # Verificar pastas principais
  APPS_DIR="apps"
  PACKAGES_DIR="packages"
  [ -d "apps ${EMOJI_APPS}" ] && APPS_DIR="apps ${EMOJI_APPS}"
  [ -d "packages ${EMOJI_PACKAGES}" ] && PACKAGES_DIR="packages ${EMOJI_PACKAGES}"
  
  for dir in "$APPS_DIR" "$PACKAGES_DIR"; do
    if [ ! -d "$dir" ]; then
      log_error "Diretório $dir não encontrado. Execute os scripts anteriores primeiro."
      all_good=false
    else
      log_success "Diretório $dir encontrado."
    fi
  done
  
  if [ "$all_good" != true ]; then
    log_error "Pré-requisitos não atendidos. Corrija os erros antes de continuar."
    exit 1
  fi
  
  log_success "Todos os pré-requisitos foram atendidos!"
}

# Backup do package.json principal
backup_package_json() {
  log_section "Backup de Arquivos Importantes"
  
  if [ -f "package.json" ]; then
    cp package.json "${BACKUP_DIR}/package.json.bak"
    log_success "Backup de package.json criado: ${BACKUP_DIR}/package.json.bak"
  fi
  
  if [ -f "turbo.json" ]; then
    cp turbo.json "${BACKUP_DIR}/turbo.json.bak"
    log_success "Backup de turbo.json criado: ${BACKUP_DIR}/turbo.json.bak"
  fi
}

# Atualização do Turborepo
setup_turborepo() {
  log_section "Configuração do Turborepo"
  
  # Criar ou atualizar turbo.json
  cat > turbo.json << 'EOF'
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "globalEnv": [
    "NODE_ENV",
    "NEXT_PUBLIC_API_URL",
    "NEXT_PUBLIC_APP_URL",
    "NEXT_PUBLIC_SUPABASE_URL",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY",
    "NEXT_PUBLIC_ANALYTICS_ID",
    "PORT"
  ],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "!.next/cache/**", "build/**"]
    },
    "lint": {
      "dependsOn": ["^build"],
      "outputs": []
    },
    "test": {
      "dependsOn": ["^build"],
      "outputs": ["coverage/**"],
      "inputs": ["src/**/*.tsx", "src/**/*.ts", "test/**/*.ts", "test/**/*.tsx"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "start": {
      "cache": false
    },
    "clean": {
      "cache": false
    },
    "storybook": {
      "cache": false,
      "persistent": true
    },
    "build-storybook": {
      "dependsOn": ["^build"],
      "outputs": ["storybook-static/**"]
    }
  }
}
EOF
  log_success "turbo.json atualizado com configurações otimizadas"
  
  # Instalar turbo globalmente para ferramentas CLI
  log_info "Instalando turbo globalmente..."
  pnpm install -g turbo
  log_success "turbo instalado globalmente: $(turbo --version 2>/dev/null || echo "instalado")"
}

# Criar pacote de configuração TypeScript
create_tsconfig_package() {
  log_section "Criação do Pacote de Configuração TypeScript"
  
  local PKG_PATH="${PACKAGES_DIR}/tsconfig"
  
  # Criar diretório
  mkdir -p "$PKG_PATH"
  
  # Criar package.json
  cat > "${PKG_PATH}/package.json" << EOF
{
  "name": "@strateup/tsconfig",
  "version": "0.1.0",
  "private": true,
  "license": "UNLICENSED",
  "files": [
    "base.json",
    "nextjs.json",
    "react-library.json",
    "node-library.json"
  ]
}
EOF
  
  # Criar configuração TypeScript base
  cat > "${PKG_PATH}/base.json" << 'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "display": "Base Config",
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "node",
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "importHelpers": true,
    "declaration": true,
    "sourceMap": true,
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "useUnknownInCatchVariables": true,
    "alwaysStrict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noPropertyAccessFromIndexSignature": true,
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "isolatedModules": true,
    "skipLibCheck": true,
    "resolveJsonModule": true
  },
  "exclude": ["node_modules"]
}
EOF
  
  # Criar configuração TypeScript para Next.js
  cat > "${PKG_PATH}/nextjs.json" << 'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "display": "Next.js",
  "extends": "./base.json",
  "compilerOptions": {
    "allowJs": true,
    "jsx": "preserve",
    "noEmit": true,
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src", "next-env.d.ts", ".next/types/**/*.ts"],
  "exclude": ["node_modules", ".next", "dist"]
}
EOF
  
  # Criar configuração TypeScript para bibliotecas React
  cat > "${PKG_PATH}/react-library.json" << 'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "display": "React Library",
  "extends": "./base.json",
  "compilerOptions": {
    "jsx": "react-jsx",
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "outDir": "dist",
    "declaration": true,
    "declarationMap": true
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF
  
  # Criar configuração TypeScript para bibliotecas Node
  cat > "${PKG_PATH}/node-library.json" << 'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "display": "Node Library",
  "extends": "./base.json",
  "compilerOptions": {
    "lib": ["ESNext"],
    "module": "ESNext",
    "target": "ESNext",
    "outDir": "dist"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF
  
  log_success "Pacote de configuração TypeScript criado em ${PKG_PATH}"
}

# Criar pacote de configuração ESLint
create_eslint_package() {
  log_section "Criação do Pacote de Configuração ESLint"
  
  local PKG_PATH="${PACKAGES_DIR}/eslint-config-custom"
  
  # Criar diretório
  mkdir -p "$PKG_PATH"
  
  # Criar package.json
  cat > "${PKG_PATH}/package.json" << EOF
{
  "name": "@strateup/eslint-config-custom",
  "version": "0.1.0",
  "private": true,
  "license": "UNLICENSED",
  "main": "index.js",
  "dependencies": {
    "@typescript-eslint/eslint-plugin": "^5.62.0",
    "@typescript-eslint/parser": "^5.62.0",
    "eslint-config-next": "^13.5.6",
    "eslint-config-prettier": "^8.10.0",
    "eslint-plugin-import": "^2.29.1",
    "eslint-plugin-jsx-a11y": "^6.7.1",
    "eslint-plugin-react": "^7.33.2",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-simple-import-sort": "^10.0.0"
  }
}
EOF
  
  # Criar configuração ESLint base
  cat > "${PKG_PATH}/index.js" << 'EOF'
module.exports = {
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:jsx-a11y/recommended",
    "prettier"
  ],
  plugins: ["@typescript-eslint", "import", "simple-import-sort"],
  settings: {
    react: {
      version: "detect"
    }
  },
  rules: {
    // React
    "react/prop-types": "off",
    "react/react-in-jsx-scope": "off",
    "react/self-closing-comp": ["error", { "component": true, "html": true }],
    
    // Imports
    "simple-import-sort/imports": "error",
    "simple-import-sort/exports": "error",
    "import/first": "error",
    "import/newline-after-import": "error",
    "import/no-duplicates": "error",
    
    // TypeScript
    "@typescript-eslint/explicit-module-boundary-types": "off",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_", "varsIgnorePattern": "^_" }],
    "@typescript-eslint/no-non-null-assertion": "off",
    "@typescript-eslint/no-empty-interface": ["error", { "allowSingleExtends": true }],
    "@typescript-eslint/ban-ts-comment": ["error", { "ts-ignore": "allow-with-description" }],
    
    // General
    "no-console": ["warn", { "allow": ["warn", "error", "info"] }]
  }
};
EOF
  
  # Criar configuração ESLint para Next.js
  cat > "${PKG_PATH}/next.js" << 'EOF'
module.exports = {
  extends: [
    "./index.js",
    "next/core-web-vitals"
  ],
  rules: {
    "@next/next/no-html-link-for-pages": "off"
  }
};
EOF
  
  # Criar arquivo ESLintRC de exemplo
  cat > "${PKG_PATH}/.eslintrc.js.example" << 'EOF'
module.exports = {
  root: true,
  extends: ["@strateup/eslint-config-custom"],
  parserOptions: {
    project: "./tsconfig.json",
  }
};
EOF
  
  log_success "Pacote de configuração ESLint criado em ${PKG_PATH}"
}

# Criar pacote de configuração do Prettier
create_prettier_package() {
  log_section "Criação do Pacote de Configuração Prettier"
  
  local PKG_PATH="${PACKAGES_DIR}/prettier-config"
  
  # Criar diretório
  mkdir -p "$PKG_PATH"
  
  # Criar package.json
  cat > "${PKG_PATH}/package.json" << EOF
{
  "name": "@strateup/prettier-config",
  "version": "0.1.0",
  "private": true,
  "license": "UNLICENSED",
  "main": "index.js",
  "dependencies": {
    "prettier": "^2.8.8",
    "prettier-plugin-tailwindcss": "^0.3.0"
  }
}
EOF
  
  # Criar configuração Prettier
  cat > "${PKG_PATH}/index.js" << 'EOF'
module.exports = {
  semi: true,
  trailingComma: 'all',
  singleQuote: true,
  printWidth: 100,
  tabWidth: 2,
  useTabs: false,
  bracketSpacing: true,
  arrowParens: 'avoid'
};
EOF
  
  # Criar arquivo .prettierrc.js de exemplo
  cat > "${PKG_PATH}/.prettierrc.js.example" << 'EOF'
module.exports = {
  ...require('@strateup/prettier-config'),
  // Adicione customizações específicas do projeto aqui
};
EOF
  
  log_success "Pacote de configuração Prettier criado em ${PKG_PATH}"
}

# Criar pacote UI básico
create_ui_package() {
  log_section "Criação do Pacote UI Base"
  
  local PKG_PATH="${PACKAGES_DIR}/ui"
  [ -d "${PACKAGES_DIR}/ui ${EMOJI_UI}" ] && PKG_PATH="${PACKAGES_DIR}/ui ${EMOJI_UI}"
  
  # Garantir que o diretório existe
  mkdir -p "$PKG_PATH/src"
  
  # Criar package.json
  cat > "${PKG_PATH}/package.json" << 'EOF'
{
  "name": "@strateup/ui",
  "version": "0.1.0",
  "private": true,
  "license": "UNLICENSED",
  "sideEffects": false,
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.js",
      "types": "./dist/index.d.ts"
    },
    "./styles.css": "./dist/styles.css"
  },
  "files": [
    "dist/**"
  ],
  "scripts": {
    "build": "tsup",
    "dev": "tsup --watch",
    "lint": "eslint \"src/**/*.ts*\"",
    "clean": "rm -rf dist .turbo node_modules",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "clsx": "^1.2.1",
    "react": "^18.2.0"
  },
  "devDependencies": {
    "@strateup/eslint-config-custom": "workspace:*",
    "@strateup/tsconfig": "workspace:*",
    "@types/react": "^18.0.28",
    "@types/react-dom": "^18.0.11",
    "eslint": "^8.36.0",
    "tsup": "^6.7.0",
    "typescript": "^4.9.5"
  }
}
EOF
  
  # Criar tsconfig.json
  cat > "${PKG_PATH}/tsconfig.json" << 'EOF'
{
  "extends": "@strateup/tsconfig/react-library.json",
  "include": ["src"],
  "exclude": ["node_modules", "dist"],
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  }
}
EOF
  
  # Criar arquivo de configuração tsup
  cat > "${PKG_PATH}/tsup.config.ts" << 'EOF'
import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['esm', 'cjs'],
  dts: true,
  splitting: false,
  sourcemap: true,
  clean: true,
  outDir: 'dist',
  treeshake: true,
  external: ['react', 'react-dom'],
});
EOF
  
  # Criar arquivo .eslintrc.js
  cat > "${PKG_PATH}/.eslintrc.js" << 'EOF'
module.exports = {
  root: true,
  extends: ["@strateup/eslint-config-custom"],
  parserOptions: {
    project: "./tsconfig.json",
  }
};
EOF

  # Criar arquivo index.ts
  cat > "${PKG_PATH}/src/index.ts" << 'EOF'
// Export all components
export * from './components/Button';

// Export version
export const version = '0.1.0';
EOF
  
  # Criar diretório de componentes
  mkdir -p "${PKG_PATH}/src/components"
  
  # Implementar componente Button de exemplo
  cat > "${PKG_PATH}/src/components/Button.tsx" << 'EOF'
import React from 'react';
import clsx from 'clsx';

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /**
   * Button variant
   */
  variant?: 'primary' | 'secondary' | 'outline';
  
  /**
   * Button size
   */
  size?: 'sm' | 'md' | 'lg';
  
  /**
   * Optional icon
   */
  icon?: React.ReactNode;
  
  /**
   * Full width
   */
  fullWidth?: boolean;
}

/**
 * Primary button component for user interaction
 */
export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  (
    {
      className,
      variant = 'primary',
      size = 'md',
      children,
      disabled = false,
      icon,
      fullWidth = false,
      ...props
    },
    ref
  ) => {
    return (
      <button
        ref={ref}
        disabled={disabled}
        className={clsx(
          // Base
          'inline-flex items-center justify-center rounded-md font-medium transition-colors',
          'focus:outline-none focus:ring-2 focus:ring-offset-2',
          
          // Variants
          variant === 'primary' && 'bg-blue-600 text-white hover:bg-blue-700',
          variant === 'secondary' && 'bg-gray-100 text-gray-800 hover:bg-gray-200',
          variant === 'outline' && 'border border-gray-300 bg-transparent hover:bg-gray-50',
          
          // Size
          size === 'sm' && 'text-xs px-2.5 py-1.5 rounded-md',
          size === 'md' && 'text-sm px-4 py-2 rounded-md',
          size === 'lg' && 'text-base px-6 py-3 rounded-md',
          
          // Disabled
          disabled && 'opacity-50 cursor-not-allowed',
          
          // Full width
          fullWidth && 'w-full',
          
          // External class
          className
        )}
        {...props}
      >
        {icon && <span className="mr-2">{icon}</span>}
        {children}
      </button>
    );
  }
);

Button.displayName = 'Button';

export default Button;
EOF

  # Criar histórias básicas para o Storybook
  mkdir -p "${PKG_PATH}/src/components/stories"
  
  cat > "${PKG_PATH}/src/components/stories/Button.stories.tsx" << 'EOF'
import React from 'react';
import { Button } from '../Button';

export default {
  title: 'UI/Button',
  component: Button,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
};

export const Primary = {
  args: {
    variant: 'primary',
    children: 'Button',
  },
};

export const Secondary = {
  args: {
    variant: 'secondary',
    children: 'Button',
  },
};

export const Outline = {
  args: {
    variant: 'outline',
    children: 'Button',
  },
};

export const Small = {
  args: {
    size: 'sm',
    children: 'Small Button',
  },
};

export const Medium = {
  args: {
    size: 'md',
    children: 'Medium Button',
  },
};

export const Large = {
  args: {
    size: 'lg',
    children: 'Large Button',
  },
};

export const WithIcon = {
  args: {
    children: 'With Icon',
    icon: '🔍',
  },
};

export const FullWidth = {
  args: {
    children: 'Full Width Button',
    fullWidth: true,
  },
};

export const Disabled = {
  args: {
    children: 'Disabled Button',
    disabled: true,
  },
};
EOF
  
  log_success "Pacote UI base criado em ${PKG_PATH}"
}

# Criar pacote Utils básico
create_utils_package() {
  log_section "Criação do Pacote Utils Base"
  
  local PKG_PATH="${PACKAGES_DIR}/utils"
  [ -d "${PACKAGES_DIR}/utils ${EMOJI_UTILS}" ] && PKG_PATH="${PACKAGES_DIR}/utils ${EMOJI_UTILS}"
  
  # Garantir que o diretório existe
  mkdir -p "$PKG_PATH/src"
  
  # Criar package.json
  cat > "${PKG_PATH}/package.json" << 'EOF'
{
  "name": "@strateup/utils",
  "version": "0.1.0",
  "private": true,
  "license": "UNLICENSED",
  "sideEffects": false,
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.js",
      "types": "./dist/index.d.ts"
    }
  },
  "files": [
    "dist/**"
  ],
  "scripts": {
    "build": "tsup",
    "dev": "tsup --watch",
    "lint": "eslint \"src/**/*.ts*\"",
    "clean": "rm -rf dist .turbo node_modules",
    "type-check": "tsc --noEmit",
    "test": "jest"
  },
  "devDependencies": {
    "@strateup/eslint-config-custom": "workspace:*",
    "@strateup/tsconfig": "workspace:*",
    "@types/jest": "^29.5.1",
    "eslint": "^8.36.0",
    "jest": "^29.5.0",
    "ts-jest": "^29.1.0",
    "tsup": "^6.7.0",
    "typescript": "^4.9.5"
  }
}
EOF
  
  # Criar tsconfig.json
  cat > "${PKG_PATH}/tsconfig.json" << 'EOF'
{
  "extends": "@strateup/tsconfig/node-library.json",
  "include": ["src"],
  "exclude": ["node_modules", "dist"],
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  }
}
EOF
  
  # Criar configuração tsup
  cat > "${PKG_PATH}/tsup.config.ts" << 'EOF'
import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['esm', 'cjs'],
  dts: true,
  splitting: false,
  sourcemap: true,
  clean: true,
  outDir: 'dist',
  treeshake: true,
});
EOF
  
  # Criar arquivo index.ts
  cat > "${PKG_PATH}/src/index.ts" << 'EOF'
export * from './format';
export * from './validation';

// Export version
export const version = '0.1.0';
EOF

  # Criar utilitários de formatação
  mkdir -p "${PKG_PATH}/src/format"
  cat > "${PKG_PATH}/src/format/index.ts" << 'EOF'
export * from './number';
export * from './date';
export * from './string';
EOF

  cat > "${PKG_PATH}/src/format/number.ts" << 'EOF'
/**
 * Formats a number as currency (BRL)
 */
export function formatCurrency(value: number): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(value);
}

/**
 * Formats a number with thousand separators
 */
export function formatNumber(value: number, decimals = 0): string {
  return new Intl.NumberFormat('pt-BR', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  }).format(value);
}

/**
 * Formats a number as percentage
 */
export function formatPercent(value: number, decimals = 0): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'percent',
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  }).format(value / 100);
}
EOF

  cat > "${PKG_PATH}/src/format/date.ts" << 'EOF'
/**
 * Format a date to Brazilian format (DD/MM/YYYY)
 */
export function formatDate(date: Date | string | number): string {
  const d = new Date(date);
  return d.toLocaleDateString('pt-BR');
}

/**
 * Format a date to Brazilian format with time (DD/MM/YYYY HH:MM)
 */
export function formatDateTime(date: Date | string | number): string {
  const d = new Date(date);
  return `${d.toLocaleDateString('pt-BR')} ${d.toLocaleTimeString('pt-BR', { 
    hour: '2-digit', 
    minute: '2-digit'
  })}`;
}

/**
 * Get relative time (5 minutes ago, Yesterday, etc)
 */
export function getRelativeTime(date: Date | string | number): string {
  const d = new Date(date);
  const now = new Date();
  
  const formatter = new Intl.RelativeTimeFormat('pt-BR', {
    numeric: 'auto'
  });
  
  const diffInSeconds = Math.floor((now.getTime() - d.getTime()) / 1000);
  
  if (diffInSeconds < 60) {
    return formatter.format(-diffInSeconds, 'second');
  }
  
  const diffInMinutes = Math.floor(diffInSeconds / 60);
  if (diffInMinutes < 60) {
    return formatter.format(-diffInMinutes, 'minute');
  }
  
  const diffInHours = Math.floor(diffInMinutes / 60);
  if (diffInHours < 24) {
    return formatter.format(-diffInHours, 'hour');
  }
  
  const diffInDays = Math.floor(diffInHours / 24);
  if (diffInDays < 30) {
    return formatter.format(-diffInDays, 'day');
  }
  
  const diffInMonths = Math.floor(diffInDays / 30);
  if (diffInMonths < 12) {
    return formatter.format(-diffInMonths, 'month');
  }
  
  const diffInYears = Math.floor(diffInMonths / 12);
  return formatter.format(-diffInYears, 'year');
}
EOF

  cat > "${PKG_PATH}/src/format/string.ts" << 'EOF'
/**
 * Truncate a string if it exceeds maxLength
 */
export function truncate(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text;
  return `${text.slice(0, maxLength - 3)}...`;
}

/**
 * Format phone number to (XX) XXXXX-XXXX
 */
export function formatPhone(phone: string): string {
  // Remove non-digit characters
  const digits = phone.replace(/\D/g, '');
  
  // Format based on length
  if (digits.length === 11) {
    return `(${digits.slice(0, 2)}) ${digits.slice(2, 7)}-${digits.slice(7)}`;
  } else if (digits.length === 10) {
    return `(${digits.slice(0, 2)}) ${digits.slice(2, 6)}-${digits.slice(6)}`;
  }
  
  // Return original if format doesn't match
  return phone;
}

/**
 * Format CPF to XXX.XXX.XXX-XX
 */
export function formatCPF(cpf: string): string {
  // Remove non-digit characters
  const digits = cpf.replace(/\D/g, '');
  
  if (digits.length !== 11) return cpf;
  
  return `${digits.slice(0, 3)}.${digits.slice(3, 6)}.${digits.slice(6, 9)}-${digits.slice(9)}`;
}

/**
 * Format CNPJ to XX.XXX.XXX/XXXX-XX
 */
export function formatCNPJ(cnpj: string): string {
  // Remove non-digit characters
  const digits = cnpj.replace(/\D/g, '');
  
  if (digits.length !== 14) return cnpj;
  
  return `${digits.slice(0, 2)}.${digits.slice(2, 5)}.${digits.slice(5, 8)}/${digits.slice(8, 12)}-${digits.slice(12)}`;
}
EOF

  # Criar utilitários de validação
  mkdir -p "${PKG_PATH}/src/validation"
  cat > "${PKG_PATH}/src/validation/index.ts" << 'EOF'
export * from './validators';
EOF

  cat > "${PKG_PATH}/src/validation/validators.ts" << 'EOF'
/**
 * Validate email format
 */
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Validate CPF number
 */
export function isValidCPF(cpf: string): boolean {
  // Remove non-digits
  const strCPF = cpf.replace(/\D/g, '');
  
  // Check length
  if (strCPF.length !== 11) return false;
  
  // Check for all same digits
  if (/^(\d)\1{10}$/.test(strCPF)) return false;
  
  // Validate first check digit
  let sum = 0;
  for (let i = 0; i < 9; i++) {
    sum += parseInt(strCPF.charAt(i)) * (10 - i);
  }
  
  let remainder = 11 - (sum % 11);
  if (remainder === 10 || remainder === 11) remainder = 0;
  
  if (remainder !== parseInt(strCPF.charAt(9))) return false;
  
  // Validate second check digit
  sum = 0;
  for (let i = 0; i < 10; i++) {
    sum += parseInt(strCPF.charAt(i)) * (11 - i);
  }
  
  remainder = 11 - (sum % 11);
  if (remainder === 10 || remainder === 11) remainder = 0;
  
  if (remainder !== parseInt(strCPF.charAt(10))) return false;
  
  return true;
}

/**
 * Validate CNPJ number
 */
export function isValidCNPJ(cnpj: string): boolean {
  // Remove non-digits
  const strCNPJ = cnpj.replace(/\D/g, '');
  
  // Check length
  if (strCNPJ.length !== 14) return false;
  
  // Check for all same digits
  if (/^(\d)\1{13}$/.test(strCNPJ)) return false;
  
  // Validate first check digit
  let size = strCNPJ.length - 2;
  let numbers = strCNPJ.substring(0, size);
  const digits = strCNPJ.substring(size);
  let sum = 0;
  let pos = size - 7;
  
  for (let i = size; i >= 1; i--) {
    sum += parseInt(numbers.charAt(size - i)) * pos--;
    if (pos < 2) pos = 9;
  }
  
  let result = sum % 11 < 2 ? 0 : 11 - (sum % 11);
  if (result !== parseInt(digits.charAt(0))) return false;
  
  // Validate second check digit
  size = size + 1;
  numbers = strCNPJ.substring(0, size);
  sum = 0;
  pos = size - 7;
  
  for (let i = size; i >= 1; i--) {
    sum += parseInt(numbers.charAt(size - i)) * pos--;
    if (pos < 2) pos = 9;
  }
  
  result = sum % 11 < 2 ? 0 : 11 - (sum % 11);
  if (result !== parseInt(digits.charAt(1))) return false;
  
  return true;
}

/**
 * Validate if string contains only numbers
 */
export function isOnlyNumbers(value: string): boolean {
  return /^\d+$/.test(value);
}

/**
 * Validate phone number (accepts formats (xx)xxxxx-xxxx or xxxxxxxxxxx)
 */
export function isValidPhone(phone: string): boolean {
  const digits = phone.replace(/\D/g, '');
  return digits.length >= 10 && digits.length <= 11;
}

/**
 * Validate if value is between min and max (inclusive)
 */
export function isInRange(value: number, min: number, max: number): boolean {
  return value >= min && value <= max;
}

/**
 * Validate URL format
 */
export function isValidURL(url: string): boolean {
  try {
    new URL(url);
    return true;
  } catch (e) {
    return false;
  }
}
EOF

  # Configurar testes com Jest
  cat > "${PKG_PATH}/jest.config.js" << 'EOF'
/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: ['<rootDir>/src/**/*.test.ts'],
  collectCoverage: true,
  coverageDirectory: 'coverage',
  collectCoverageFrom: ['src/**/*.ts', '!src/**/*.test.ts', '!src/**/*.d.ts'],
};
EOF

  # Criar arquivo .eslintrc.js
  cat > "${PKG_PATH}/.eslintrc.js" << 'EOF'
module.exports = {
  root: true,
  extends: ["@strateup/eslint-config-custom"],
  parserOptions: {
    project: "./tsconfig.json",
  }
};
EOF

  # Criar alguns testes simples
  mkdir -p "${PKG_PATH}/src/format/__tests__"
  cat > "${PKG_PATH}/src/format/__tests__/number.test.ts" << 'EOF'
import { formatCurrency, formatNumber, formatPercent } from '../number';

describe('Number formatters', () => {
  describe('formatCurrency', () => {
    it('should format a number as BRL currency', () => {
      expect(formatCurrency(1000)).toBe('R$ 1.000,00');
      expect(formatCurrency(1000.5)).toBe('R$ 1.000,50');
      expect(formatCurrency(0)).toBe('R$ 0,00');
    });
  });
  
  describe('formatNumber', () => {
    it('should format a number with thousand separators', () => {
      expect(formatNumber(1000)).toBe('1.000');
      expect(formatNumber(1000.5)).toBe('1.000');
      expect(formatNumber(1000.5, 1)).toBe('1.000,5');
      expect(formatNumber(1000.56, 2)).toBe('1.000,56');
    });
  });
  
  describe('formatPercent', () => {
    it('should format a number as percentage', () => {
      expect(formatPercent(10)).toBe('10%');
      expect(formatPercent(10.5, 1)).toBe('10,5%');
    });
  });
});
EOF
  
  log_success "Pacote Utils base criado em ${PKG_PATH}"
}

# Atualizar o package.json principal
update_root_package_json() {
  log_section "Atualização do package.json Principal"
  
  # Obter o package.json atual
  local package_json=$(cat package.json)
  
  # Obter campos essenciais
  local name=$(echo "$package_json" | grep -o '"name": *"[^"]*"' || echo '"name": "strateup-v3"')
  local version=$(echo "$package_json" | grep -o '"version": *"[^"]*"' || echo '"version": "0.1.0"')
  local description=$(echo "$package_json" | grep -o '"description": *"[^"]*"' || echo '"description": "StrateUp v3 - Plataforma de Marketing e Vendas"')
  local author=$(echo "$package_json" | grep -o '"author": *"[^"]*"' || echo '"author": "StrateUpCompany"')
  local license=$(echo "$package_json" | grep -o '"license": *"[^"]*"' || echo '"license": "UNLICENSED"')
  
  # Criar novo package.json
  cat > package.json << EOF
{
  ${name},
  ${version},
  "private": true,
  ${description},
  "engines": {
    "node": ">=16.0.0",
    "pnpm": ">=7.0.0"
  },
  "packageManager": "pnpm@8.6.3",
  "scripts": {
    "dev": "turbo run dev",
    "build": "turbo run build",
    "start": "turbo run start",
    "lint": "turbo run lint",
    "test": "turbo run test",
    "clean": "turbo run clean && rm -rf node_modules",
    "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,md}\"",
    "format:check": "prettier --check \"**/*.{js,jsx,ts,tsx,json,md}\"",
    "storybook": "turbo run storybook",
    "build-storybook": "turbo run build-storybook",
    "prepare": "husky install"
  },
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  ${author},
  ${license},
  "devDependencies": {
    "@commitlint/cli": "^17.4.4",
    "@commitlint/config-conventional": "^17.4.4",
    "eslint": "^8.36.0",
    "husky": "^8.0.3",
    "lint-staged": "^13.1.2",
    "prettier": "^2.8.8",
    "turbo": "^1.10.12",
    "typescript": "^4.9.5"
  }
}
EOF
  
  log_success "package.json principal atualizado com scripts e dependências."
  
  # Criar arquivo commitlint.config.js
  cat > commitlint.config.js << 'EOF'
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'body-max-line-length': [0, 'always', 100],
    'footer-max-line-length': [0, 'always', 100],
  }
};
EOF
  
  # Criar configuração Husky
  mkdir -p .husky
  
  cat > .husky/pre-commit << 'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx lint-staged
EOF
  
  cat > .husky/commit-msg << 'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx --no -- commitlint --edit $1
EOF
  
  # Permitir execução dos scripts husky
  chmod +x .husky/pre-commit .husky/commit-msg
  
  # Criar lint-staged.config.js
  cat > lint-staged.config.js << 'EOF'
module.exports = {
  // Lint TS and TSX files
  '**/*.{ts,tsx}': (filenames) => [
    `eslint --fix ${filenames.join(' ')}`,
    `prettier --write ${filenames.join(' ')}`,
  ],
  
  // Format other files
  '**/*.{js,jsx,json,md,mdx}': (filenames) => [
    `prettier --write ${filenames.join(' ')}`,
  ],
};
EOF
  
  log_success "Configuração de Husky, Commitlint e Lint-Staged criada."
}

# Configuração de ambiente de testes
setup_test_environment() {
  log_section "Configuração do Ambiente de Testes"
  
  # Criar arquivo jest.config.base.js na raiz
  cat > jest.config.base.js << 'EOF'
/** @type {import('jest').Config} */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  transform: {
    '^.+\\.tsx?$': ['ts-jest', {
      tsconfig: "<rootDir>/tsconfig.json",
    }],
  },
  moduleNameMapper: {
    '\\.(css|less|sass|scss)$': '<rootDir>/node_modules/jest-css-modules',
  },
  coverageDirectory: '<rootDir>/coverage/',
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.stories.{ts,tsx}',
    '!src/**/*.test.{ts,tsx}',
    '!src/**/*.d.ts',
  ],
  watchPlugins: [
    'jest-watch-typeahead/filename',
    'jest-watch-typeahead/testname'
  ],
};
EOF
  
  log_success "Configuração base de Jest criada."
  
  log_info "Para configurar testes em um pacote ou app específico, crie um jest.config.js que estende o arquivo base."
  log_info "Exemplo:"
  log_info "module.exports = { ...require('../../jest.config.base'), displayName: 'ui' };"
}

# Marcação de conclusão do script
mark_completion() {
  log_section "Marcando Conclusão do Script"
  
  local timestamp=$(date +%Y%m%d-%H%M%S)
  touch .strateup-step-1-complete
  echo "$timestamp" > .strateup-step-1-complete
  
  # Criar sumário de operações
  cat > "${LOG_DIR}/summary-step-1.md" << EOF
# ✅ Sumário de Instalação - Passo 1

Data: $(date +'%Y-%m-%d %H:%M:%S')
Usuário: $USER_NAME

## Operações Realizadas
- ✓ Configuração do monorepo com Turborepo
- ✓ Criação de pacotes compartilhados:
  - @strateup/tsconfig
  - @strateup/eslint-config-custom
  - @strateup/prettier-config
  - @strateup/ui
  - @strateup/utils
- ✓ Atualização do package.json principal
- ✓ Configuração de Husky, Commitlint e Lint-Staged
- ✓ Ambiente de testes configurado

## Status do Projeto
Estrutura base criada e pronta para desenvolvimento.

Próximo passo: Configuração dos apps específicos
EOF
  
  log_success "Passo 1 concluído com sucesso! Sumário criado em ${LOG_DIR}/summary-step-1.md"
  
  # Commit das alterações (se git estiver configurado)
  if [ -d ".git" ]; then
    log_info "Realizando commit das alterações..."
    git add .
    git commit -m "feat(monorepo): configuração base do monorepo e pacotes compartilhados"
    log_success "Alterações commitadas."
    
    log_info "Para push das alterações, execute: git push origin [branch-atual]"
  fi
}

# Realizar instalação de dependências
install_dependencies() {
  log_section "Instalação de Dependências"
  
  log_info "Instalando dependências do projeto..."
  pnpm install
  
  if [ $? -eq 0 ]; then
    log_success "Dependências instaladas com sucesso!"
  else
    log_error "Erro ao instalar dependências. Por favor, execute manualmente: pnpm install"
  fi
}

# Lista de verificação final
final_checklist() {
  log_section "Lista de Verificação Final"
  
  local all_good=true
  
  # Verificar arquivos e pastas importantes
  for file in turbo.json package.json commitlint.config.js; do
    if [ -f "$file" ]; then
      log_success "✓ $file existe"
    else
      log_error "✗ $file não encontrado"
      all_good=false
    fi
  done
  
  # Verificar pacotes criados
  for pkg in "tsconfig" "eslint-config-custom" "prettier-config" "ui" "utils"; do
    local pkg_path="${PACKAGES_DIR}/$pkg"
    if [ -d "${PACKAGES_DIR}/$pkg" ] || [ -d "${PACKAGES_DIR}/$pkg ${EMOJI_UI}" ] || [ -d "${PACKAGES_DIR}/$pkg ${EMOJI_UTILS}" ]; then
      log_success "✓ Pacote $pkg criado"
    else
      log_error "✗ Pacote $pkg não encontrado"
      all_good=false
    fi
  done
  
  # Verificar node_modules
  if [ -d "node_modules" ]; then
    log_success "✓ Dependências instaladas (node_modules existe)"
  else
    log_warning "⚠️ Dependências não instaladas. Execute: pnpm install"
  fi
  
  if [ "$all_good" = true ]; then
    log_success "Todas as verificações foram bem-sucedidas!"
  else
    log_warning "Algumas verificações falharam. Revise os erros acima."
  fi
}

# Função principal
main() {
  welcome_banner
  
  # Verificação inicial
  check_prerequisites
  
  # Backup de arquivos importantes
  backup_package_json
  
  # Configuração do monorepo
  setup_turborepo
  
  # Criar pacotes compartilhados
  create_tsconfig_package
  create_eslint_package
  create_prettier_package
  create_ui_package
  create_utils_package
  
  # Atualizar package.json principal
  update_root_package_json
  
  # Configuração de testes
  setup_test_environment
  
  # Instalação de dependências
  install_dependencies
  
  # Verificação final
  final_checklist
  
  # Marcar conclusão
  mark_completion
  
  echo
  echo -e "${BLUE}${BOLD}=============================================${NC}"
  echo -e "${GREEN}${BOLD}    PASSO 1 DE 13 CONCLUÍDO COM SUCESSO     ${NC}"
  echo -e "${BLUE}${BOLD}=============================================${NC}"
  echo
  echo -e "${YELLOW}${BOLD}Próximos passos:${NC}"
  echo -e "1. Verifique a estrutura criada com ${GREEN}ls -la${NC}"
  echo -e "2. Explore os pacotes compartilhados em ${CYAN}${PACKAGES_DIR}/${NC}"
  echo -e "3. Execute ${GREEN}pnpm run dev${NC} para verificar se tudo está funcionando"
  echo -e "4. Continue com o script do Passo 2: ${BOLD}./02-app-web-setup.sh${NC}"
  echo
  echo -e "${GREEN}${BOLD}Configuração do monorepo concluída!${NC}"
}

# Executar função principal com tratamento de erros
trap 'echo -e "${RED}Script interrompido.${NC}"; exit 1' INT TERM
main
exit 0