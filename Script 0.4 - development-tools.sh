#!/bin/bash
# =======================================================================
# SCRIPT: development-tools.sh
# DESCRIÇÃO: Ferramentas de desenvolvimento TURBINADAS pra StrateUp! 🛠️🚀
# AUTOR: StrateUpCompany
# DATA: 2025-06-05
# VERSÃO: 1.0.0
# 
# VISÃO STRATEUP:
# "Transforme sua mente, transforme sua vida com estratégias reais 
# e resultados mensuráveis" 💯
# =======================================================================

# Carregar o estilo StrateUp com ENERGIA TOTAL! 💪
source "$(dirname "$0")/common/strateup-style.sh"

# Verificar se o ambiente tá pronto pra detonar!
if [ ! -f ".strateup-env.json" ]; then
  log_strateup "ERROR" "Eita! Ambiente não validado. Roda o 0.0-environment-validation.sh primeiro! 🛠️"
  exit 1
fi

# Banner StrateUp com TODA A ENERGIA! 🔥
show_strateup_banner "FERRAMENTAS DE DESENVOLVIMENTO - PRODUTIVIDADE MÁXIMA! 🛠️"
log_strateup "STRATEGY" "${BOLD}Ferramentas TOP reduzem o custo de expansão na fórmula de escalabilidade! 📈${NC}"
log_strateup "INFO" "Este script vai instalar e configurar ferramentas que vão TURBINAR sua produtividade! 🚀"

# Entrar no diretório do projeto
PROJECT_DIR="strateup-v3"
if [ ! -d "$PROJECT_DIR" ]; then
  log_strateup "ERROR" "Cadê o diretório $PROJECT_DIR? Roda o script 0.1-dependency-installation.sh primeiro! 🤔"
  exit 1
fi

cd "$PROJECT_DIR"

# Configurar VS Code (se instalado)
log_strateup "INFO" "Vamos turbinar o VS Code pro desenvolvimento StrateUp! 💻"

if command -v code &> /dev/null; then
  log_strateup "SUCCESS" "VS Code detectado! Vamos deixar ele MONSTRUOSO! 🦾"
  
  # Criar diretório .vscode
  mkdir -p .vscode
  
  # Configurar settings.json para o VS Code
  cat > .vscode/settings.json << EOF
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.rulers": [100],
  "editor.tabSize": 2,
  "editor.renderWhitespace": "boundary",
  "editor.guides.bracketPairs": true,
  "files.eol": "\n",
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.preferences.importModuleSpecifier": "shortest",
  
  // Tailwind CSS IntelliSense
  "tailwindCSS.includeLanguages": {
    "typescriptreact": "html"
  },
  "tailwindCSS.emmetCompletions": true,
  
  // Mostrar erro quando detectar @ts-ignore
  "typescript.tsserver.experimental.enableProjectDiagnostics": true,
  
  // Config para Testes
  "testing.automaticallyOpenPeekView": "never",

  // StrateUp Colors Theme
  "workbench.colorCustomizations": {
    "activityBar.background": "#0062ff11",
    "activityBar.foreground": "#0062FF",
    "titleBar.activeBackground": "#0062ff22",
    "titleBar.activeForeground": "#0062FF"
  }
}
EOF

  # Configurar recomendações de extensões
  cat > .vscode/extensions.json << EOF
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss",
    "formulahendry.auto-rename-tag",
    "streetsidesoftware.code-spell-checker",
    "streetsidesoftware.code-spell-checker-portuguese-brazilian",
    "mikestead.dotenv",
    "editorconfig.editorconfig",
    "dsznajder.es7-react-js-snippets",
    "eamodio.gitlens",
    "wix.vscode-import-cost",
    "pkief.material-icon-theme",
    "yoavbls.pretty-ts-errors",
    "rvest.vs-code-prettier-eslint",
    "christian-kohler.path-intellisense",
    "csstools.postcss",
    "rangav.vscode-thunder-client",
    "gruntfuggly.todo-tree"
  ]
}
EOF

  # Criar arquivo de snippets personalizados
  mkdir -p .vscode/snippets
  
  cat > .vscode/snippets/strateup.code-snippets << EOF
{
  "StrateUp React Component": {
    "prefix": "strc",
    "body": [
      "import React from 'react';",
      "",
      "interface ${1:ComponentName}Props {",
      "  ${2:prop}: ${3:type};",
      "}",
      "",
      "export const ${1:ComponentName}: React.FC<${1:ComponentName}Props> = ({ ${2:prop} }) => {",
      "  return (",
      "    <div className=\"${4:className}\">",
      "      $5",
      "    </div>",
      "  );",
      "};",
      "",
      "export default ${1:ComponentName};"
    ],
    "description": "StrateUp React Component with TypeScript"
  },
  "StrateUp Page Component": {
    "prefix": "strp",
    "body": [
      "import React from 'react';",
      "import { NextPage } from 'next';",
      "",
      "const ${1:PageName}: NextPage = () => {",
      "  return (",
      "    <div className=\"strateup-container py-10\">",
      "      <h1 className=\"text-3xl font-bold text-strateup-primary\">${2:Page Title}</h1>",
      "      <div className=\"mt-6\">",
      "        $3",
      "      </div>",
      "    </div>",
      "  );",
      "};",
      "",
      "export default ${1:PageName};"
    ],
    "description": "StrateUp Page Component with NextPage type"
  },
  "StrateUp React Hook": {
    "prefix": "strh",
    "body": [
      "import { useState, useEffect } from 'react';",
      "",
      "export function use${1:HookName}(${2:param}: ${3:Type}) {",
      "  const [${4:state}, set${4/(.*)/${4:/capitalize}/}] = useState<${5:Type}>(${6:initialValue});",
      "",
      "  useEffect(() => {",
      "    $7",
      "    ",
      "    return () => {",
      "      // Cleanup",
      "    };",
      "  }, [${2:param}]);",
      "",
      "  return { ${4:state} };",
      "}"
    ],
    "description": "StrateUp Custom React Hook"
  },
  "StrateUp Marketing Section": {
    "prefix": "strm",
    "body": [
      "<section className=\"py-16 bg-gradient-to-b from-white to-gray-50\">",
      "  <div className=\"strateup-container\">",
      "    <h2 className=\"text-4xl font-bold text-center mb-12\">",
      "      ${1:Section Title} <span className=\"text-strateup-primary\">${2:Highlight}</span>",
      "    </h2>",
      "    ",
      "    <div className=\"grid grid-cols-1 md:grid-cols-${3:3} gap-8 mt-10\">",
      "      $4",
      "    </div>",
      "  </div>",
      "</section>"
    ],
    "description": "StrateUp Marketing Section Template"
  }
}
EOF

  log_strateup "SUCCESS" "VS Code configurado com settings, extensões e snippets StrateUp! 🚀"
else
  log_strateup "INFO" "VS Code não encontrado. Arquivos de configuração foram criados mesmo assim. 📁"
  log_strateup "INFO" "Recomendamos instalar o VS Code: https://code.visualstudio.com/"
  
  # Criar diretório .vscode mesmo sem o VS Code instalado
  mkdir -p .vscode
  
  # Adicionar mesmos arquivos de configuração para uso futuro
  cat > .vscode/settings.json << EOF
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.rulers": [100],
  "editor.tabSize": 2,
  "typescript.tsdk": "node_modules/typescript/lib"
}
EOF

  cat > .vscode/extensions.json << EOF
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss",
    "formulahendry.auto-rename-tag",
    "streetsidesoftware.code-spell-checker",
    "streetsidesoftware.code-spell-checker-portuguese-brazilian",
    "mikestead.dotenv",
    "editorconfig.editorconfig",
    "dsznajder.es7-react-js-snippets",
    "eamodio.gitlens",
    "wix.vscode-import-cost",
    "pkief.material-icon-theme",
    "yoavbls.pretty-ts-errors",
    "rvest.vs-code-prettier-eslint",
    "christian-kohler.path-intellisense",
    "csstools.postcss",
    "rangav.vscode-thunder-client",
    "gruntfuggly.todo-tree"
  ]
}
EOF
fi

# Configurar EditorConfig para consistência entre editores
log_strateup "INFO" "Configurando EditorConfig pra manter o código CONSISTENTE em qualquer editor! 📏"

cat > .editorconfig << EOF
# EditorConfig is awesome: https://EditorConfig.org

# top-most EditorConfig file
root = true

# All files
[*]
end_of_line = lf
insert_final_newline = true
charset = utf-8
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

# Markdown files
[*.md]
trim_trailing_whitespace = false

# JSON files
[*.json]
insert_final_newline = false
EOF

log_strateup "SUCCESS" "EditorConfig configurado! Consistência em todos os editores! ✅"

# Configurar Prettier para formatação de código
log_strateup "INFO" "Configurando Prettier pra deixar o código LINDO DE VIVER! ✨"

cat > .prettierrc << EOF
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100,
  "tabWidth": 2,
  "arrowParens": "avoid",
  "endOfLine": "lf"
}
EOF

# Criar arquivo .prettierignore
cat > .prettierignore << EOF
# dependencies
node_modules
.pnp
.pnp.js

# testing
coverage
.nyc_output

# next.js
.next/
out/

# production
build
dist

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# local env files
.env*.local
.env

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts

# other
README.md
EOF

log_strateup "SUCCESS" "Prettier configurado! Código formatado AUTOMATICAMENTE! 💅"

# Configurar ESLint avançado
log_strateup "INFO" "Configurando ESLint com regras TURBINADAS pra qualidade de código MÁXIMA! 🛡️"

cat > .eslintrc.json << EOF
{
  "extends": [
    "next/core-web-vitals",
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:jsx-a11y/recommended",
    "plugin:import/recommended",
    "plugin:import/typescript",
    "prettier"
  ],
  "plugins": [
    "@typescript-eslint",
    "react",
    "jsx-a11y",
    "import",
    "react-hooks"
  ],
  "rules": {
    "react/react-in-jsx-scope": "off",
    "react/prop-types": "off",
    "react/jsx-uses-react": "off",
    "@typescript-eslint/explicit-module-boundary-types": "off",
    "@typescript-eslint/no-unused-vars": ["warn", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/no-explicit-any": "warn",
    "no-console": ["warn", { "allow": ["warn", "error"] }],
    "jsx-a11y/anchor-is-valid": "warn",
    "import/order": [
      "warn",
      {
        "groups": ["builtin", "external", "internal", ["parent", "sibling"], "index"],
        "pathGroups": [
          { "pattern": "react", "group": "external", "position": "before" },
          { "pattern": "next/**", "group": "external", "position": "before" }
        ],
        "pathGroupsExcludedImportTypes": ["react", "next"],
        "newlines-between": "always",
        "alphabetize": { "order": "asc", "caseInsensitive": true }
      }
    ],
    "sort-imports": [
      "warn",
      {
        "ignoreCase": true,
        "ignoreDeclarationSort": true,
        "ignoreMemberSort": false
      }
    ]
  },
  "settings": {
    "react": {
      "version": "detect"
    },
    "import/resolver": {
      "typescript": {},
      "node": {
        "extensions": [".js", ".jsx", ".ts", ".tsx"]
      }
    }
  }
}
EOF

# Criar arquivo .eslintignore
cat > .eslintignore << EOF
node_modules
.next
out
build
public
EOF

log_strateup "SUCCESS" "ESLint configurado! Código com qualidade ABSURDA! 🔍"

# Instalar dependências necessárias para as configurações
log_strateup "INFO" "Instalando dependências para as ferramentas de desenvolvimento... 📦"

# Determinar o gerenciador de pacotes
if [ -f "pnpm-lock.yaml" ]; then
  PACKAGE_MANAGER="pnpm"
elif [ -f "yarn.lock" ]; then
  PACKAGE_MANAGER="yarn"
else
  PACKAGE_MANAGER="npm"
fi

log_strateup "INFO" "Usando $PACKAGE_MANAGER como gerenciador de pacotes..."

# Instalar dependências de desenvolvimento para ESLint e Prettier
TOOLS_DEPENDENCIES=(
  "eslint-config-prettier"
  "eslint-plugin-import"
  "eslint-plugin-jsx-a11y"
  "eslint-plugin-react"
  "eslint-plugin-react-hooks"
  "@typescript-eslint/eslint-plugin"
  "@typescript-eslint/parser"
  "eslint-import-resolver-typescript"
  "prettier-plugin-tailwindcss"
)

if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
  pnpm add -D "${TOOLS_DEPENDENCIES[@]}"
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
  yarn add -D "${TOOLS_DEPENDENCIES[@]}"
else
  npm install -D "${TOOLS_DEPENDENCIES[@]}"
fi

log_strateup "SUCCESS" "Dependências instaladas com sucesso! 🎉"

# Configurar Jest para testes
log_strateup "INFO" "Configurando Jest para TESTES DE PRIMEIRA! 🧪"

cat > jest.config.js << EOF
const nextJest = require('next/jest');

const createJestConfig = nextJest({
  // Provide the path to your Next.js app to load next.config.js and .env files
  dir: './',
});

// Add any custom config to be passed to Jest
const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    // Handle module aliases
    '^@/(.*)$': '<rootDir>/$1',
    '^@components/(.*)$': '<rootDir>/components/$1',
    '^@styles/(.*)$': '<rootDir>/styles/$1',
    '^@utils/(.*)$': '<rootDir>/utils/$1',
    '^@hooks/(.*)$': '<rootDir>/hooks/$1',
    '^@context/(.*)$': '<rootDir>/context/$1',
    '^@types/(.*)$': '<rootDir>/types/$1',
  },
  collectCoverage: true,
  collectCoverageFrom: [
    '**/*.{js,jsx,ts,tsx}',
    '!**/*.d.ts',
    '!**/node_modules/**',
    '!**/.next/**',
    '!**/coverage/**',
    '!jest.config.js',
    '!next.config.js',
    '!postcss.config.js',
    '!tailwind.config.js',
  ],
  testPathIgnorePatterns: ['/node_modules/', '/.next/'],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70,
    },
  },
};

// createJestConfig is exported this way to ensure that next/jest can load the Next.js config which is async
module.exports = createJestConfig(customJestConfig);
EOF

# Criar arquivo de setup para Jest
cat > jest.setup.js << EOF
// Learn more: https://github.com/testing-library/jest-dom
import '@testing-library/jest-dom';

// Mock Next.js router
jest.mock('next/router', () => ({
  useRouter: () => ({
    push: jest.fn(),
    replace: jest.fn(),
    prefetch: jest.fn(),
    pathname: '/',
    route: '/',
    asPath: '/',
    query: {},
    events: {
      on: jest.fn(),
      off: jest.fn(),
    },
  }),
}));

// Mock next/image
jest.mock('next/image', () => ({
  __esModule: true,
  default: (props) => {
    // eslint-disable-next-line jsx-a11y/alt-text
    return <img {...props} />;
  },
}));

// Environment setup
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(), // Deprecated
    removeListener: jest.fn(), // Deprecated
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});
EOF

log_strateup "SUCCESS" "Jest configurado para testes IMBATÍVEIS! ✅"

# Criar exemplo de teste para componentes UI
mkdir -p __tests__/components
cat > __tests__/components/Button.test.tsx << EOF
import { render, screen, fireEvent } from '@testing-library/react';
import Button from '@/components/ui/Button';

describe('Button Component', () => {
  it('renders correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('calls onClick handler when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByText('Click me'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('renders with correct style variants', () => {
    const { rerender } = render(<Button variant="primary">Primary</Button>);
    expect(screen.getByText('Primary')).toHaveClass('strateup-button-primary');
    
    rerender(<Button variant="secondary">Secondary</Button>);
    expect(screen.getByText('Secondary')).toHaveClass('strateup-button-secondary');
  });
});
EOF

# Criar componente Button para passar no teste
mkdir -p components/ui
cat > components/ui/Button.tsx << EOF
import React from 'react';

export interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  onClick?: () => void;
  className?: string;
  disabled?: boolean;
  type?: 'button' | 'submit' | 'reset';
}

const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  onClick,
  className = '',
  disabled = false,
  type = 'button',
}) => {
  // Base classes que são aplicadas a todos os botões
  const baseClasses = 'rounded-lg font-medium transition-all hover:shadow-lg hover:scale-[1.03] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed';
  
  // Classes específicas para cada variante
  const variantClasses = {
    primary: 'bg-strateup-primary text-white',
    secondary: 'bg-strateup-secondary text-white',
    outline: 'bg-transparent border-2 border-strateup-primary text-strateup-primary hover:bg-strateup-primary hover:text-white',
  };
  
  // Classes específicas para cada tamanho
  const sizeClasses = {
    sm: 'px-3 py-1 text-sm',
    md: 'px-6 py-3',
    lg: 'px-8 py-4 text-lg',
  };
  
  // Combinar todas as classes
  const buttonClasses = \`\${baseClasses} \${variantClasses[variant]} \${sizeClasses[size]} \${className} strateup-button-\${variant}\`;
  
  return (
    <button
      type={type}
      className={buttonClasses}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </button>
  );
};

export default Button;
EOF

log_strateup "SUCCESS" "Componente Button e testes criados! Pronto pra crescer com qualidade! 🧪"

# Configurar GitHub Actions para CI/CD
log_strateup "INFO" "Configurando GitHub Actions para CI/CD AUTOMATIZADO! 🤖"

mkdir -p .github/workflows

cat > .github/workflows/ci.yml << EOF
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: 'pnpm'

      - name: Setup PNPM
        uses: pnpm/action-setup@v2
        with:
          version: 8
          run_install: false

      - name: Get PNPM store directory
        id: pnpm-cache
        shell: bash
        run: |
          echo "STORE_PATH=\$(pnpm store path)" >> \$GITHUB_OUTPUT

      - name: Setup PNPM cache
        uses: actions/cache@v3
        with:
          path: \${{ steps.pnpm-cache.outputs.STORE_PATH }}
          key: \${{ runner.os }}-pnpm-store-\${{ hashFiles('**/pnpm-lock.yaml') }}
          restore-keys: |
            \${{ runner.os }}-pnpm-store-

      - name: Install dependencies
        run: pnpm install

      - name: Lint
        run: pnpm run lint

      - name: Type check
        run: pnpm run type-check

      - name: Run tests
        run: pnpm run test

      - name: Build
        run: pnpm run build
        
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-output
          path: .next
          retention-days: 3

  deploy-preview:
    if: github.event_name == 'pull_request'
    needs: build-and-test
    runs-on: ubuntu-latest
    
    steps:
      - name: Deploy to Preview Environment
        run: |
          echo "Deploying preview environment for PR #\${{ github.event.pull_request.number }}"
          # Aqui você adicionaria seu script de deploy para ambiente de preview
          # Por exemplo, deploy para Vercel, Netlify, etc.

  deploy-production:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    needs: build-and-test
    runs-on: ubuntu-latest
    
    steps:
      - name: Deploy to Production
        run: |
          echo "Deploying to production environment"
          # Aqui você adicionaria seu script de deploy para ambiente de produção
          # Por exemplo, deploy para Vercel, AWS, etc.
EOF

log_strateup "SUCCESS" "GitHub Actions configurado! CI/CD totalmente automatizado! 🚀"

# Atualizar scripts no package.json para incluir ferramentas configuradas
log_strateup "INFO" "Atualizando scripts no package.json para facilitar uso das ferramentas... 🛠️"

# Criar um arquivo temporário para o novo package.json
tmp=$(mktemp)

# Atualizar os scripts
jq '.scripts = {
  "dev": "next dev",
  "build": "next build",
  "start": "next start",
  "lint": "next lint",
  "lint:fix": "next lint --fix",
  "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,md,css}\"",
  "test": "jest",
  "test:watch": "jest --watch",
  "test:coverage": "jest --coverage",
  "type-check": "tsc --noEmit",
  "prepare": "husky install",
  "analyze": "cross-env ANALYZE=true next build",
  "storybook": "start-storybook -p 6006",
  "build-storybook": "build-storybook"
}' package.json > "$tmp" && mv "$tmp" package.json

log_strateup "SUCCESS" "Scripts atualizados no package.json! Produtividade MÁXIMA! 🚀"

# Criar estrutura de pastas para Storybook (se quiser implementar depois)
mkdir -p .storybook
cat > .storybook/main.js << EOF
module.exports = {
  stories: [
    '../components/**/*.stories.mdx',
    '../components/**/*.stories.@(js|jsx|ts|tsx)'
  ],
  addons: [
    '@storybook/addon-links',
    '@storybook/addon-essentials',
    '@storybook/addon-interactions',
    {
      name: '@storybook/addon-postcss',
      options: {
        postcssLoaderOptions: {
          implementation: require('postcss'),
        },
      },
    },
  ],
  framework: '@storybook/react',
  core: {
    builder: 'webpack5',
  },
};
EOF

cat > .storybook/preview.js << EOF
import '../styles/globals.css';

export const parameters = {
  actions: { argTypesRegex: "^on[A-Z].*" },
  controls: {
    matchers: {
      color: /(background|color)$/i,
      date: /Date$/,
    },
  },
};
EOF

# Criar exemplo de história para o componente Button
mkdir -p components/ui
cat > components/ui/Button.stories.tsx << EOF
import { ComponentStory, ComponentMeta } from '@storybook/react';
import Button from './Button';

export default {
  title: 'StrateUp/Button',
  component: Button,
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'outline'],
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
    },
  },
} as ComponentMeta<typeof Button>;

const Template: ComponentStory<typeof Button> = (args) => <Button {...args} />;

export const Primary = Template.bind({});
Primary.args = {
  variant: 'primary',
  children: 'Botão Primário',
};

export const Secondary = Template.bind({});
Secondary.args = {
  variant: 'secondary',
  children: 'Botão Secundário',
};

export const Outline = Template.bind({});
Outline.args = {
  variant: 'outline',
  children: 'Botão Outline',
};

export const Small = Template.bind({});
Small.args = {
  size: 'sm',
  children: 'Botão Pequeno',
};

export const Large = Template.bind({});
Large.args = {
  size: 'lg',
  children: 'Botão Grande',
};

export const Disabled = Template.bind({});
Disabled.args = {
  disabled: true,
  children: 'Botão Desativado',
};
EOF

log_strateup "SUCCESS" "Storybook configurado para desenvolvimento de componentes INCRÍVEIS! 📚"

# Criar arquivos para intelisense de tipos
log_strateup "INFO" "Criando arquivos para melhorar o IntelliSense do TypeScript... 🧠"

mkdir -p types
cat > types/index.d.ts << EOF
// Tipos globais do projeto StrateUp
declare namespace StrateUp {
  // Definições de usuário
  interface User {
    id: string;
    name: string;
    email: string;
    role: 'admin' | 'user' | 'guest';
    avatar?: string;
    createdAt: Date;
  }
  
  // Definições de cliente
  interface Customer {
    id: string;
    name: string;
    email: string;
    company: string;
    segment: string;
    revenue?: number;
    employeeCount?: number;
    status: 'lead' | 'prospect' | 'active' | 'churned';
    createdAt: Date;
  }
  
  // Definições de campanha de marketing
  interface MarketingCampaign {
    id: string;
    name: string;
    type: 'email' | 'social' | 'ads' | 'content';
    budget: number;
    target: string;
    startDate: Date;
    endDate?: Date;
    metrics: CampaignMetrics;
    status: 'draft' | 'active' | 'paused' | 'completed';
  }
  
  interface CampaignMetrics {
    impressions: number;
    clicks: number;
    leads: number;
    conversions: number;
    roi: number;
  }
}

// Estender o namespace Window para tipagens globais
declare interface Window {
  gtag?: (command: string, ...args: any[]) => void;
  fbq?: (command: string, ...args: any[]) => void;
  dataLayer?: any[];
}
EOF

log_strateup "SUCCESS" "Tipos TypeScript configurados! IntelliSense PODEROSO! 🧠"

# Criar middleware para API
mkdir -p middlewares
cat > middlewares/withRateLimit.ts << EOF
import { NextApiRequest, NextApiResponse } from 'next';
import { RateLimiterMemory } from 'rate-limiter-flexible';

// Criar limitador com 100 requests por IP a cada 5 minutos
const rateLimiter = new RateLimiterMemory({
  points: 100, // número de pontos
  duration: 300, // segundos
});

export default function withRateLimit(handler: Function) {
  return async function(req: NextApiRequest, res: NextApiResponse) {
    try {
      // Identificar o cliente pelo IP
      const clientIp = req.headers['x-forwarded-for'] || 
                       req.connection.remoteAddress || 
                       'unknown';
                       
      // Limitar requisições
      await rateLimiter.consume(String(clientIp));
      
      // Seguir com o handler original
      return handler(req, res);
    } catch (error) {
      // Limite excedido
      return res.status(429).json({ 
        error: 'Muitas requisições. Tente novamente em alguns minutos.' 
      });
    }
  };
}
EOF

# Criar utils para formatação e validação
mkdir -p utils
cat > utils/format.ts << EOF
/**
 * Funções de formatação para o projeto StrateUp
 */

/**
 * Formata um valor monetário em Real brasileiro
 */
export function formatCurrency(value: number): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(value);
}

/**
 * Formata uma data para o formato brasileiro
 */
export function formatDate(date: Date | string): string {
  if (typeof date === 'string') {
    date = new Date(date);
  }
  
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
  }).format(date);
}

/**
 * Formata um número de telefone brasileiro
 */
export function formatPhone(phone: string): string {
  // Remove tudo que não for número
  const cleaned = phone.replace(/\D/g, '');
  
  // Verifica se é um celular (9 dígitos) ou fixo (8 dígitos)
  if (cleaned.length === 11) {
    return cleaned.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
  } else if (cleaned.length === 10) {
    return cleaned.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3');
  }
  
  // Se não seguir os padrões, retorna original
  return phone;
}

/**
 * Trunca um texto com reticências se passar do limite
 */
export function truncateText(text: string, limit: number): string {
  if (text.length <= limit) {
    return text;
  }
  
  return text.slice(0, limit) + '...';
}
EOF

cat > utils/validation.ts << EOF
/**
 * Funções de validação para o projeto StrateUp
 */

/**
 * Valida um email
 */
export function isValidEmail(email: string): boolean {
  const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  return regex.test(email);
}

/**
 * Valida um CNPJ
 */
export function isValidCNPJ(cnpj: string): boolean {
  // Remove caracteres não numéricos
  cnpj = cnpj.replace(/[^\d]+/g, '');
  
  // Deve ter 14 dígitos
  if (cnpj.length !== 14) return false;
  
  // Verifica se todos os dígitos são iguais
  if (/^(\d)\1+$/.test(cnpj)) return false;
  
  // Validação dos dígitos verificadores
  let tamanho = cnpj.length - 2;
  let numeros = cnpj.substring(0, tamanho);
  const digitos = cnpj.substring(tamanho);
  let soma = 0;
  let pos = tamanho - 7;
  
  // Primeiro dígito verificador
  for (let i = tamanho; i >= 1; i--) {
    soma += parseInt(numeros.charAt(tamanho - i)) * pos--;
    if (pos < 2) pos = 9;
  }
  
  let resultado = soma % 11 < 2 ? 0 : 11 - (soma % 11);
  if (resultado !== parseInt(digitos.charAt(0))) return false;
  
  // Segundo dígito verificador
  tamanho = tamanho + 1;
  numeros = cnpj.substring(0, tamanho);
  soma = 0;
  pos = tamanho - 7;
  
  for (let i = tamanho; i >= 1; i--) {
    soma += parseInt(numeros.charAt(tamanho - i)) * pos--;
    if (pos < 2) pos = 9;
  }
  
  resultado = soma % 11 < 2 ? 0 : 11 - (soma % 11);
  if (resultado !== parseInt(digitos.charAt(1))) return false;
  
  return true;
}

/**
 * Valida um CPF
 */
export function isValidCPF(cpf: string): boolean {
  // Remove caracteres não numéricos
  cpf = cpf.replace(/[^\d]+/g, '');
  
  // Deve ter 11 dígitos
  if (cpf.length !== 11) return false;
  
  // Verifica se todos os dígitos são iguais
  if (/^(\d)\1+$/.test(cpf)) return false;
  
  // Validação dos dígitos verificadores
  let soma = 0;
  let resto;
  
  // Primeiro dígito verificador
  for (let i = 1; i <= 9; i++) {
    soma = soma + parseInt(cpf.substring(i - 1, i)) * (11 - i);
  }
  
  resto = (soma * 10) % 11;
  if ((resto === 10) || (resto === 11)) resto = 0;
  if (resto !== parseInt(cpf.substring(9, 10))) return false;
  
  // Segundo dígito verificador
  soma = 0;
  for (let i = 1; i <= 10; i++) {
    soma = soma + parseInt(cpf.substring(i - 1, i)) * (12 - i);
  }
  
  resto = (soma * 10) % 11;
  if ((resto === 10) || (resto === 11)) resto = 0;
  if (resto !== parseInt(cpf.substring(10, 11))) return false;
  
  return true;
}

/**
 * Valida uma senha forte
 * - Pelo menos 8 caracteres
 * - Pelo menos uma letra maiúscula
 * - Pelo menos uma letra minúscula
 * - Pelo menos um número
 * - Pelo menos um caractere especial
 */
export function isStrongPassword(password: string): boolean {
  const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{8,}$/;
  return regex.test(password);
}

/**
 * Valida um formato de telefone brasileiro
 */
export function isValidPhone(phone: string): boolean {
  // Remove caracteres não numéricos
  const cleaned = phone.replace(/\D/g, '');
  
  // Verifica se é celular (com DDD) ou fixo (com DDD)
  return cleaned.length === 10 || cleaned.length === 11;
}
EOF

log_strateup "SUCCESS" "Utilitários de formatação e validação criados! Código mais organizado! 📝"

# Criar hooks personalizados
mkdir -p hooks
cat > hooks/useLocalStorage.ts << EOF
import { useState, useEffect } from 'react';

/**
 * Hook para usar localStorage com React
 * 
 * @param key Nome da chave no localStorage
 * @param initialValue Valor inicial (opcional)
 */
export function useLocalStorage<T>(key: string, initialValue?: T): [T, (value: T) => void] {
  // Estado para armazenar valor
  const [storedValue, setStoredValue] = useState<T>(() => {
    if (typeof window === 'undefined') {
      return initialValue as T;
    }
    
    try {
      // Obter do localStorage
      const item = window.localStorage.getItem(key);
      // Se existir, parse JSON, senão use valor inicial
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error('Erro ao ler do localStorage:', error);
      return initialValue as T;
    }
  });
  
  // Função para atualizar valor no estado e localStorage
  const setValue = (value: T) => {
    try {
      // Salva o estado
      setStoredValue(value);
      
      if (typeof window !== 'undefined') {
        // Salva no localStorage
        window.localStorage.setItem(key, JSON.stringify(value));
        
        // Dispara evento customizado para sincronização entre abas
        const event = new Event('localStorageChange');
        window.dispatchEvent(event);
      }
    } catch (error) {
      console.error('Erro ao escrever no localStorage:', error);
    }
  };
  
  // Sincronizar entre abas
  useEffect(() => {
    const handleStorageChange = () => {
      try {
        const item = window.localStorage.getItem(key);
        if (item) {
          setStoredValue(JSON.parse(item));
        }
      } catch (error) {
        console.error('Erro ao sincronizar localStorage:', error);
      }
    };
    
    window.addEventListener('localStorageChange', handleStorageChange);
    window.addEventListener('storage', handleStorageChange);
    
    return () => {
      window.removeEventListener('localStorageChange', handleStorageChange);
      window.removeEventListener('storage', handleStorageChange);
    };
  }, [key]);
  
  return [storedValue, setValue];
}
EOF

cat > hooks/useMediaQuery.ts << EOF
import { useState, useEffect } from 'react';

/**
 * Hook para usar media queries no React
 * 
 * @param query Media query a ser verificada (ex: '(min-width: 768px)')
 */
export function useMediaQuery(query: string): boolean {
  const [matches, setMatches] = useState(false);
  
  useEffect(() => {
    // Verifica se estamos no navegador
    if (typeof window === 'undefined') {
      return;
    }
    
    // Cria media query
    const media = window.matchMedia(query);
    
    // Define o estado inicial
    setMatches(media.matches);
    
    // Callback para mudanças
    const listener = (event: MediaQueryListEvent) => {
      setMatches(event.matches);
    };
    
    // Adiciona listener
    if (media.addEventListener) {
      media.addEventListener('change', listener);
    } else {
      // Para navegadores antigos
      media.addListener(listener);
    }
    
    // Cleanup
    return () => {
      if (media.removeEventListener) {
        media.removeEventListener('change', listener);
      } else {
        // Para navegadores antigos
        media.removeListener(listener);
      }
    };
  }, [query]);
  
  return matches;
}

// Hooks pré-definidos para breakpoints comuns
export function useIsMobile(): boolean {
  return useMediaQuery('(max-width: 767px)');
}

export function useIsTablet(): boolean {
  return useMediaQuery('(min-width: 768px) and (max-width: 1023px)');
}

export function useIsDesktop(): boolean {
  return useMediaQuery('(min-width: 1024px)');
}
EOF

log_strateup "SUCCESS" "Hooks React personalizados criados! Desenvolvimento TURBINADO! 🔄"

# Voltar ao diretório original
cd ..

# Resumo final com toda a energia StrateUp!
echo -e "\n${STRATEUP_BLUE}${BOLD}════════ FERRAMENTAS DE DESENVOLVIMENTO PRONTAS! ════════${NC}"
log_strateup "SUCCESS" "✅ Ambiente de desenvolvimento TOTALMENTE TURBINADO! 🚀"
log_strateup "INFO" "Ferramentas configuradas para PRODUTIVIDADE MÁXIMA!"
log_strateup "INFO" "Conjunto completo para qualidade, testes e desenvolvimento."
log_strateup "INFO" "Fase de Preparação do Ambiente (0.x) FINALIZADA com SUCESSO!"
log_strateup "INFO" "Próximo passo: Execute o script 1.0-monorepo-structure.sh"
log_strateup "STRATEGY" "💡 Lembre-se: 'Ferramentas eficientes reduzem o Custo de Expansão na fórmula da escalabilidade!' - StrateUp 📈"

# Coleta de métricas para análise futura
{
  echo "SCRIPT_NAME=development-tools.sh"
  echo "EXECUTION_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "SUCCESS=true"
} > "metrics/development-tools-$(date +%Y%m%d-%H%M%S).metrics"

exit 0