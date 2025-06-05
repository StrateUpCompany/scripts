#!/bin/bash
# =======================================================================
# SCRIPT: dependency-installation.sh
# DESCRIÇÃO: Instalação de dependências para o ambiente StrateUp
# AUTOR: StrateUpCompany
# DATA: 2025-06-05
# VERSÃO: 1.0.0
# 
# VISÃO STRATEUP:
# "Transforme sua mente, transforme sua vida com estratégias reais 
# e resultados mensuráveis"
# =======================================================================

# Carregar configurações e estilos StrateUp
source "$(dirname "$0")/common/strateup-style.sh"

# Verificar se o ambiente foi validado
if [ ! -f ".strateup-env.json" ]; then
  log_strateup "ERROR" "Ambiente não validado. Execute primeiro 0.0-environment-validation.sh"
  exit 1
fi

# Banner StrateUp com foco em eficiência e resultados
show_strateup_banner "INSTALAÇÃO DE DEPENDÊNCIAS"
log_strateup "STRATEGY" "${BOLD}Preparando as ferramentas para sua transformação digital${NC}"
log_strateup "INFO" "Este script instalará as dependências necessárias para o projeto StrateUp v3"

# Criar diretório de projeto se não existir
PROJECT_DIR="strateup-v3"
if [ ! -d "$PROJECT_DIR" ]; then
  log_strateup "INFO" "Criando diretório principal do projeto..."
  mkdir -p "$PROJECT_DIR"
  log_strateup "SUCCESS" "Diretório $PROJECT_DIR criado com sucesso ✓"
else
  log_strateup "INFO" "Diretório $PROJECT_DIR já existe, usando-o..."
fi

cd "$PROJECT_DIR"

# Determinar o gerenciador de pacotes a utilizar (prefere pnpm)
if command -v pnpm &> /dev/null; then
  PACKAGE_MANAGER="pnpm"
elif command -v yarn &> /dev/null; then
  PACKAGE_MANAGER="yarn"
else
  PACKAGE_MANAGER="npm"
  log_strateup "STRATEGY" "💡 Por eficiência, recomendamos instalar pnpm: npm install -g pnpm"
fi

log_strateup "INFO" "Usando $PACKAGE_MANAGER como gerenciador de pacotes"

# Inicializar o projeto
log_strateup "INFO" "Inicializando o projeto..."

if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
  pnpm init -y
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
  yarn init -y
else
  npm init -y
fi

# Editar package.json para incluir informações da StrateUp
log_strateup "INFO" "Personalizando package.json com identidade StrateUp..."

tmp=$(mktemp)
jq '.name = "strateup-v3" |
    .description = "Plataforma StrateUp v3: Transformação através de estratégias reais" |
    .author = "StrateUpCompany" |
    .private = true |
    .license = "UNLICENSED" |
    .engines.node = ">=18.0.0"' package.json > "$tmp" && mv "$tmp" package.json

log_strateup "SUCCESS" "package.json personalizado com identidade StrateUp ✓"

# Instalar dependências principais
log_strateup "INFO" "Instalando dependências principais... Isso pode levar alguns minutos."

DEPENDENCIES=(
  "next"
  "react"
  "react-dom"
  "typescript"
  "@types/node"
  "@types/react"
  "@types/react-dom"
)

if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
  pnpm add "${DEPENDENCIES[@]}"
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
  yarn add "${DEPENDENCIES[@]}"
else
  npm install "${DEPENDENCIES[@]}"
fi

# Instalar dependências de desenvolvimento
log_strateup "INFO" "Instalando dependências de desenvolvimento..."

DEV_DEPENDENCIES=(
  "eslint"
  "eslint-config-next"
  "prettier"
  "husky"
  "lint-staged"
  "@testing-library/react"
  "jest"
  "@types/jest"
  "jest-environment-jsdom"
)

if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
  pnpm add -D "${DEV_DEPENDENCIES[@]}"
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
  yarn add -D "${DEV_DEPENDENCIES[@]}"
else
  npm install -D "${DEV_DEPENDENCIES[@]}"
fi

# Instalar dependências para UX aprimorada (foco no UX)
log_strateup "INFO" "Instalando dependências para experiência de usuário premium..."

UX_DEPENDENCIES=(
  "framer-motion"     # Para animações fluidas
  "react-spring"      # Para física de animação realista
  "tailwindcss"       # Para design responsivo e consistente
  "postcss"           # Processador CSS necessário para Tailwind
  "autoprefixer"      # Para compatibilidade cross-browser
  "@headlessui/react" # Componentes acessíveis sem estilos
  "react-hook-form"   # Para forms eficientes e validação
  "zod"               # Para validação de tipo em runtime
)

if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
  pnpm add "${UX_DEPENDENCIES[@]}"
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
  yarn add "${UX_DEPENDENCIES[@]}"
else
  npm install "${UX_DEPENDENCIES[@]}"
fi

# Configurar Tailwind CSS
log_strateup "INFO" "Configurando Tailwind CSS com as cores da identidade StrateUp..."

npx tailwindcss init -p

# Extrair as cores da identidade StrateUp
PRIMARY_COLOR=$(jq -r '.branding.colors.primary' ../.strateup-env.json)
SECONDARY_COLOR=$(jq -r '.branding.colors.secondary' ../.strateup-env.json)
ACCENT_COLOR=$(jq -r '.branding.colors.accent' ../.strateup-env.json)
WARNING_COLOR=$(jq -r '.branding.colors.warning' ../.strateup-env.json)
SUCCESS_COLOR=$(jq -r '.branding.colors.success' ../.strateup-env.json)

# Criar arquivo de configuração do Tailwind com cores da StrateUp
cat > tailwind.config.js << EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        'strateup-primary': '${PRIMARY_COLOR}',
        'strateup-secondary': '${SECONDARY_COLOR}',
        'strateup-accent': '${ACCENT_COLOR}',
        'strateup-warning': '${WARNING_COLOR}',
        'strateup-success': '${SUCCESS_COLOR}',
      },
      fontFamily: {
        'strateup-primary': ['Montserrat', 'sans-serif'],
        'strateup-secondary': ['Inter', 'sans-serif'],
      },
      animation: {
        'strateup-pulse': 'pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      }
    },
  },
  plugins: [],
}
EOF

log_strateup "SUCCESS" "Tailwind CSS configurado com a identidade visual da StrateUp ✓"

# Configurar scripts no package.json
log_strateup "INFO" "Configurando scripts úteis no package.json..."

tmp=$(mktemp)
jq '.scripts = {
  "dev": "next dev",
  "build": "next build",
  "start": "next start",
  "lint": "next lint",
  "test": "jest",
  "test:watch": "jest --watch",
  "prepare": "husky install"
}' package.json > "$tmp" && mv "$tmp" package.json

# Configurar Husky para garantir qualidade de código
log_strateup "INFO" "Configurando Husky para manter a qualidade do código..."

if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
  pnpm run prepare
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
  yarn prepare
else
  npm run prepare
fi

mkdir -p .husky

# Criar hook pre-commit para lint-staged
cat > .husky/pre-commit << EOF
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"

npx lint-staged
EOF

chmod +x .husky/pre-commit

# Configurar lint-staged
cat > .lintstagedrc << EOF
{
  "*.{js,jsx,ts,tsx}": [
    "eslint --fix",
    "prettier --write"
  ],
  "*.{css,scss,md,json}": [
    "prettier --write"
  ]
}
EOF

log_strateup "SUCCESS" "Husky e lint-staged configurados para manter a qualidade do código ✓"

# Criar arquivo de configuração do TypeScript
log_strateup "INFO" "Configurando TypeScript..."

cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"],
      "@components/*": ["components/*"],
      "@styles/*": ["styles/*"],
      "@utils/*": ["utils/*"],
      "@hooks/*": ["hooks/*"],
      "@context/*": ["context/*"],
      "@types/*": ["types/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOF

log_strateup "SUCCESS" "TypeScript configurado com caminhos otimizados ✓"

# Criar estrutura básica de diretórios
log_strateup "INFO" "Criando estrutura de diretórios seguindo os princípios de organização StrateUp..."

mkdir -p app/api
mkdir -p components/ui
mkdir -p components/marketing
mkdir -p components/icons
mkdir -p hooks
mkdir -p context
mkdir -p utils
mkdir -p public/images
mkdir -p styles
mkdir -p types
mkdir -p lib

log_strateup "SUCCESS" "Estrutura de diretórios criada ✓"

# Criar arquivo global CSS com estilos base da StrateUp
cat > styles/globals.css << EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  html {
    font-family: 'Inter', 'system-ui', sans-serif;
  }
  
  h1, h2, h3, h4, h5, h6 {
    font-family: 'Montserrat', sans-serif;
    font-weight: 700;
  }
}

@layer components {
  .strateup-button-primary {
    @apply bg-strateup-primary text-white px-6 py-3 rounded-lg font-medium transition-all hover:shadow-lg hover:scale-[1.03] active:scale-[0.98];
  }
  
  .strateup-button-secondary {
    @apply bg-strateup-secondary text-white px-6 py-3 rounded-lg font-medium transition-all hover:shadow-lg hover:scale-[1.03] active:scale-[0.98];
  }
  
  .strateup-container {
    @apply max-w-7xl mx-auto px-4 sm:px-6 lg:px-8;
  }
  
  .strateup-card {
    @apply bg-white rounded-lg shadow-md p-6 transition-all hover:shadow-lg;
  }
}
EOF

log_strateup "SUCCESS" "Arquivo global CSS criado com classes base da StrateUp ✓"

# Criar página inicial para demonstrar a identidade StrateUp
log_strateup "INFO" "Criando página inicial com identidade StrateUp..."

mkdir -p app
cat > app/layout.tsx << EOF
import './globals.css';
import { Inter, Montserrat } from 'next/font/google';

const inter = Inter({ 
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap'
});

const montserrat = Montserrat({
  subsets: ['latin'],
  variable: '--font-montserrat',
  display: 'swap'
});

export const metadata = {
  title: 'StrateUp v3 - Transformação através de estratégias reais',
  description: 'Plataforma de transformação digital que eleva o nível mental dos clientes com estratégias reais e resultados mensuráveis',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="pt-BR" className={\`\${inter.variable} \${montserrat.variable}\`}>
      <body>
        {children}
      </body>
    </html>
  )
}
EOF

cat > app/page.tsx << EOF
'use client';

import { useState } from 'react';
import { motion } from 'framer-motion';

export default function Home() {
  const [isHovered, setIsHovered] = useState(false);
  
  const strateupValues = [
    "Autenticidade", "Transparência", "Honestidade", 
    "Paixão", "Energia", "Positividade", 
    "Foco em Resultados", "Organização", "Ética",
    "Desenvolvimento Humano"
  ];

  return (
    <div className="min-h-screen bg-gradient-to-b from-white to-gray-50">
      <header className="bg-white shadow">
        <div className="strateup-container py-6 flex justify-between items-center">
          <div className="flex items-center space-x-2">
            <span className="text-strateup-primary text-3xl font-bold font-strateup-primary">StrateUp</span>
          </div>
          <nav>
            <ul className="flex space-x-6">
              {['Home', 'Sobre', 'Serviços', 'Contato'].map((item) => (
                <li key={item}>
                  <a href="#" className="text-gray-600 hover:text-strateup-primary transition-colors">
                    {item}
                  </a>
                </li>
              ))}
            </ul>
          </nav>
        </div>
      </header>

      <main>
        <section className="py-20">
          <div className="strateup-container">
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
              className="max-w-3xl mx-auto text-center"
            >
              <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
                Transforme sua <span className="text-strateup-primary">mente</span>,
                <br /> transforme sua <span className="text-strateup-primary">vida</span>
              </h1>
              <p className="text-xl text-gray-600 mb-10">
                Com estratégias reais e resultados mensuráveis para o crescimento do seu negócio
              </p>
              
              <div className="flex flex-col sm:flex-row justify-center gap-4">
                <motion.button 
                  className="strateup-button-primary"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.98 }}
                >
                  Comece sua jornada
                </motion.button>
                <motion.button 
                  className="strateup-button-secondary"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.98 }}
                >
                  Saiba mais
                </motion.button>
              </div>
            </motion.div>
          </div>
        </section>

        <section className="py-16 bg-gray-50">
          <div className="strateup-container">
            <motion.h2 
              initial={{ opacity: 0 }}
              whileInView={{ opacity: 1 }}
              viewport={{ once: true }}
              className="text-3xl font-bold text-center mb-12"
            >
              Nossos Valores
            </motion.h2>

            <div className="grid grid-cols-2 md:grid-cols-5 gap-6">
              {strateupValues.map((value, index) => (
                <motion.div
                  key={value}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.1 }}
                  className="strateup-card text-center"
                  whileHover={{ scale: 1.05, boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.1)' }}
                >
                  <h3 className="font-semibold text-strateup-primary">{value}</h3>
                </motion.div>
              ))}
            </div>
          </div>
        </section>
      </main>

      <footer className="bg-gray-900 text-white py-12">
        <div className="strateup-container">
          <div className="flex flex-col md:flex-row justify-between">
            <div>
              <h3 className="text-2xl font-bold mb-4">StrateUp</h3>
              <p className="text-gray-400 max-w-md">
                Transformando negócios através de estratégias reais e resultados mensuráveis.
              </p>
            </div>
            <div className="mt-8 md:mt-0">
              <h4 className="text-lg font-semibold mb-4">Contato</h4>
              <p className="text-gray-400">contato@strateup.com.br</p>
            </div>
          </div>
          <div className="mt-12 pt-4 border-t border-gray-800">
            <p className="text-gray-500 text-center">
              &copy; {new Date().getFullYear()} StrateUp. Todos os direitos reservados.
            </p>
          </div>
        </div>
      </footer>
    </div>
  )
}
EOF

log_strateup "SUCCESS" "Página inicial criada com identidade visual da StrateUp ✓"

# Gerar arquivo .gitignore
cat > .gitignore << EOF
# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts
EOF

log_strateup "SUCCESS" "Arquivo .gitignore criado ✓"

# Voltar ao diretório original
cd ..

# Resumo final com toque estratégico da StrateUp
echo -e "\n${STRATEUP_BLUE}${BOLD}════════ INSTALAÇÃO CONCLUÍDA ════════${NC}"
log_strateup "SUCCESS" "✓ Dependências instaladas com sucesso!"
log_strateup "INFO" "Para iniciar o projeto:"
log_strateup "INFO" "  cd $PROJECT_DIR"
log_strateup "INFO" "  $PACKAGE_MANAGER run dev"
log_strateup "INFO" "Próximo passo: Execute o script 0.2-git-configuration.sh"
log_strateup "STRATEGY" "💡 Lembre-se: 'Estratégia sem execução é apenas uma ilusão.' - StrateUp"

# Coleta de métricas para análise futura
{
  echo "SCRIPT_NAME=dependency-installation.sh"
  echo "EXECUTION_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "SUCCESS=true"
  echo "PACKAGE_MANAGER=${PACKAGE_MANAGER}"
  echo "NODE_VERSION=$(node -v)"
} > "metrics/dependency-installation-$(date +%Y%m%d-%H%M%S).metrics"

exit 0