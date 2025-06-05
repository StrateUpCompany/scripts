#!/bin/bash
# =======================================================================
# SCRIPT: git-configuration.sh
# DESCRIÇÃO: Configuração turbinada do Git para o projeto StrateUp! 🚀
# AUTOR: StrateUpCompany
# DATA: 2025-06-05
# VERSÃO: 1.0.0
# 
# VISÃO STRATEUP:
# "Transforme sua mente, transforme sua vida com estratégias reais 
# e resultados mensuráveis" 💯
# =======================================================================

# Carregar o nosso estilo StrateUp vibrante!
source "$(dirname "$0")/common/strateup-style.sh"

# Verificar se ambiente tá pronto pra detonar
if [ ! -f ".strateup-env.json" ]; then
  log_strateup "ERROR" "Eita! Ambiente não validado. Roda primeiro o 0.0-environment-validation.sh, meu consagrado! 🛠️"
  exit 1
fi

# Banner StrateUp com TODA A NOSSA ENERGIA! 🔥
show_strateup_banner "CONFIGURAÇÃO GIT - POTENCIALIZANDO SEU WORKFLOW! 🚀"
log_strateup "STRATEGY" "${BOLD}Bora organizar esse Git pra escalar sem dor de cabeça! 📈${NC}"
log_strateup "INFO" "Esse script vai turbinar seu Git pro projeto StrateUp v3 - Organização é o alicerce do sucesso! 💪"

# Entrar no diretório do projeto
PROJECT_DIR="strateup-v3"
if [ ! -d "$PROJECT_DIR" ]; then
  log_strateup "ERROR" "Cadê o diretório $PROJECT_DIR? Roda o script 0.1-dependency-installation.sh primeiro! 🤔"
  exit 1
fi

cd "$PROJECT_DIR"

# Verificar se Git já está inicializado
if [ ! -d ".git" ]; then
  log_strateup "INFO" "Inicializando Git no projeto... 🏁"
  git init
  log_strateup "SUCCESS" "Git iniciado com sucesso! Agora vamos decolar! 🚀"
else
  log_strateup "INFO" "Git já inicializado nesse projeto. Vamos continuar turbinando! 💯"
fi

# Configurar .gitattributes para padronização
log_strateup "INFO" "Configurando atributos Git pra padronização MÁXIMA! 📏"

cat > .gitattributes << EOF
# Auto detect text files and perform LF normalization
* text=auto eol=lf

# JS/TS files must be handled as text
*.js text
*.ts text
*.jsx text
*.tsx text
*.json text

# Image files are treated as binary by default
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.ico binary
*.svg text

# Documents
*.md text diff=markdown
*.mdx text diff=markdown

# RC files (like .babelrc, .eslintrc)
*.*rc text

# Config files
*.yaml text
*.yml text
*.toml text
EOF

log_strateup "SUCCESS" "Arquivo .gitattributes configurado com sucesso! Padronização é TUDO! ✅"

# Criar .gitignore completo se não existir ou estiver vazio
if [ ! -f ".gitignore" ] || [ ! -s ".gitignore" ]; then
  log_strateup "INFO" "Criando um .gitignore completo pra não subir o que não deve! 🙅‍♂️"
  
  cat > .gitignore << EOF
# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage
/.nyc_output
*.lcov

# next.js
/.next/
/out/

# production
/build
/dist

# misc
.DS_Store
*.pem
Thumbs.db

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# local env files
.env*.local
.env
.env.development
.env.test
.env.production

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts

# IDE specific files
.idea
.vscode
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
.project
.classpath

# OS specific files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# StrateUp specific
/logs
/metrics
/temp
EOF

  log_strateup "SUCCESS" "Arquivo .gitignore criado com sucesso! Sem arquivo errado no nosso repositório! ✅"
else
  log_strateup "INFO" ".gitignore já existe e parece configurado. Verificando se precisa de upgrade... 🧐"
  
  # Verificar e adicionar entradas importantes que podem estar faltando
  if ! grep -q "StrateUp specific" .gitignore; then
    echo -e "\n# StrateUp specific\n/logs\n/metrics\n/temp" >> .gitignore
    log_strateup "SUCCESS" ".gitignore atualizado com regras específicas da StrateUp! 🚀"
  fi
fi

# Configurar fluxos de trabalho Git com branches principais
log_strateup "INFO" "Configurando fluxo de trabalho Git pra ESCALAR SEM DOR! 🚀"

# Criar branches principais se não existirem
if ! git branch | grep -q "main"; then
  git branch -M main
  log_strateup "SUCCESS" "Branch principal 'main' configurada! 💯"
fi

# Verificar se branch de desenvolvimento existe, senão criar
if ! git branch | grep -q "develop"; then
  git checkout -b develop
  log_strateup "SUCCESS" "Branch de desenvolvimento 'develop' criada! 👨‍💻"
fi

# Voltar para main
git checkout main

# Adicionar remote se não existir
log_strateup "INFO" "Vamos configurar o repositório remoto? 🌐"

# Perguntar se deseja adicionar um repositório remoto
read -p "Adicionar repositório remoto agora? (s/n): " add_remote

if [ "$add_remote" = "s" ] || [ "$add_remote" = "S" ]; then
  read -p "URL do repositório remoto: " remote_url
  
  if [ -n "$remote_url" ]; then
    # Verificar se já existe um remote origin
    if git remote | grep -q "origin"; then
      git remote set-url origin "$remote_url"
    else
      git remote add origin "$remote_url"
    fi
    log_strateup "SUCCESS" "Repositório remoto configurado em $remote_url! 🌐"
  else
    log_strateup "WARNING" "URL vazia, pulando configuração do repositório remoto. 🤷‍♂️"
  fi
else
  log_strateup "INFO" "Sem problema! Você pode adicionar um remote depois com:" 
  log_strateup "INFO" "  git remote add origin seu-repo-url.git"
fi

# Configurar git-flow para branches
log_strateup "INFO" "Configurando git-flow pra deixar nosso workflow ABSURDO DE BOM! 🔄"

# Instalar git-flow se disponível
if command -v apt-get &> /dev/null; then
  log_strateup "INFO" "Tentando instalar git-flow via apt... 📦"
  sudo apt-get update && sudo apt-get install -y git-flow || log_strateup "WARNING" "Não foi possível instalar git-flow automaticamente. 🤷‍♂️"
elif command -v brew &> /dev/null; then
  log_strateup "INFO" "Tentando instalar git-flow via Homebrew... 🍺"
  brew install git-flow || log_strateup "WARNING" "Não foi possível instalar git-flow automaticamente. 🤷‍♂️"
fi

# Criar arquivo de configuração git-flow
mkdir -p .github
cat > .github/git-flow-config.md << EOF
# Configuração de Git Flow StrateUp 🚀

## Branches Principais

- \`main\`: Código em produção, estável e testado
- \`develop\`: Branch de desenvolvimento, integração de features

## Branches de Apoio

- \`feature/*\`: Novas funcionalidades (ex: feature/auth-system)
- \`bugfix/*\`: Correções de bugs (ex: bugfix/login-error)
- \`release/*\`: Preparação para uma nova versão (ex: release/v1.2.0)
- \`hotfix/*\`: Correções urgentes em produção (ex: hotfix/critical-error)

## Fluxo de Trabalho

1. Desenvolva em uma branch \`feature/*\` ou \`bugfix/*\`
2. Quando finalizado, crie um Pull Request para \`develop\`
3. Para lançar, crie uma branch \`release/*\` a partir de \`develop\`
4. Após testes, mescle a branch de \`release/*\` com \`main\` e \`develop\`
5. Para correções urgentes, crie \`hotfix/*\` a partir de \`main\` e depois mescle em \`main\` e \`develop\`

## Convenção para Commit Messages

- \`feat:\`: Nova funcionalidade
- \`fix:\`: Correção de bug
- \`docs:\`: Documentação
- \`style:\`: Formatação, ponto e vírgula, etc.
- \`refactor:\`: Refatoração de código
- \`perf:\`: Melhorias de performance
- \`test:\`: Adicionando testes
- \`chore:\`: Tarefas de manutenção

Exemplo: \`feat: adiciona sistema de autenticação\`
EOF

log_strateup "SUCCESS" "Configuração git-flow documentada! Agora todo mundo segue o mesmo padrão! 📋✅"

# Criar template para Pull Requests
log_strateup "INFO" "Criando template para Pull Requests pra manter a QUALIDADE LÁ EM CIMA! 🔝"

mkdir -p .github/PULL_REQUEST_TEMPLATE
cat > .github/PULL_REQUEST_TEMPLATE/default.md << EOF
## Descrição da Transformação 🚀

[Descreva as mudanças que você fez e o problema que elas resolvem]

## Tipo de mudança

- [ ] ✨ Nova feature (mudança que adiciona funcionalidade)
- [ ] 🐛 Correção de bug (mudança que corrige um problema)
- [ ] 📚 Documentação (mudança apenas na documentação)
- [ ] ♻️ Refatoração (mudança que não altera o comportamento externo)
- [ ] 🧪 Testes (adicionando ou corrigindo testes)
- [ ] 🔧 Manutenção (mudança em configuração, CI, etc)

## Como foi testado?

[Descreva como você testou suas mudanças]

## Checklist:

- [ ] 📝 Meu código segue o estilo de código deste projeto
- [ ] 🧪 Eu adicionei testes que provam que minha correção é eficaz ou que minha feature funciona
- [ ] 📚 Atualizei a documentação, se necessário
- [ ] ✅ Meu código passa em todos os testes

## Screenshots (se aplicável)

[Screenshots do antes/depois]

## Impacto na Transformação do Cliente StrateUp 💪

[Como essa mudança contribui para transformar a experiência ou os resultados do cliente?]
EOF

log_strateup "SUCCESS" "Template de Pull Request criado! Colaboração TOP! 👥✅"

# Configurar template para issues
log_strateup "INFO" "Criando templates para issues pra ficar ORGANIZADO PRA CARAMBA! 📊"

mkdir -p .github/ISSUE_TEMPLATE
cat > .github/ISSUE_TEMPLATE/01_bug_report.md << EOF
---
name: 🐛 Bug Report
about: Algo não está funcionando como esperado? Conte-nos!
labels: bug, precisa-validação
---

## Descrição do Bug 🔍

[Uma descrição clara e concisa do bug]

## Como Reproduzir 🔄

Passos para reproduzir o comportamento:
1. Vá para '...'
2. Clique em '....'
3. Role até '....'
4. Veja o erro

## Comportamento Esperado ✨

[Uma descrição clara e concisa do que você esperava que acontecesse]

## Screenshots 📸

[Se aplicável, adicione screenshots para ajudar a explicar seu problema]

## Ambiente 🌐

- Dispositivo: [ex: Desktop, iPhone 12]
- OS: [ex: Windows 10, iOS 14]
- Navegador: [ex: Chrome 91, Safari 14]
- Versão: [ex: 1.0.0]

## Contexto Adicional 🔍

[Qualquer outra informação que possa ser relevante]

## Impacto no Cliente StrateUp 💼

[Como este bug está afetando a experiência ou resultados do cliente?]
EOF

cat > .github/ISSUE_TEMPLATE/02_feature_request.md << EOF
---
name: ✨ Solicitação de Funcionalidade
about: Sugira uma ideia para transformar nosso produto!
labels: enhancement, precisa-validação
---

## Problema Relacionado 🤔

[Uma descrição clara e concisa do problema. Ex: Sempre fico frustrado quando...]

## Solução Desejada 🚀

[Uma descrição clara e concisa do que você quer que aconteça]

## Alternativas Consideradas 🔄

[Uma descrição clara e concisa de quaisquer soluções alternativas que você considerou]

## Valor para o Cliente StrateUp 💰

[Como essa funcionalidade agrega valor ou transforma a experiência do cliente?]

## Requisitos Adicionais 📋

- [ ] Requisito 1
- [ ] Requisito 2
- [ ] Requisito 3

## Mockups ou Exemplos 🎨

[Se aplicável, adicione mockups ou exemplos para ajudar a explicar sua ideia]
EOF

log_strateup "SUCCESS" "Templates de issues criados! Organização no MÁXIMO! 📋✅"

# Configurar hooks do Git para manter qualidade do código
log_strateup "INFO" "Configurando hooks Git pra manter a QUALIDADE nas alturas! 🚀"

# Verificar se o Husky já está configurado
if [ ! -d ".husky" ]; then
  # Instalar e configurar Husky
  if command -v npx &> /dev/null; then
    npx husky install
    npx husky add .husky/pre-commit "npx lint-staged"
    chmod +x .husky/pre-commit
    log_strateup "SUCCESS" "Husky configurado para pre-commit! Qualidade garantida! ✅"
  else
    log_strateup "WARNING" "npx não encontrado. Instale o Node.js e npm primeiro. 🤷‍♂️"
  fi
else
  log_strateup "INFO" "Husky já está configurado. Vamos garantir que esteja turbinado! 🔧"
  
  # Verificar e atualizar o hook pre-commit
  if [ ! -f ".husky/pre-commit" ] || ! grep -q "lint-staged" ".husky/pre-commit"; then
    npx husky add .husky/pre-commit "npx lint-staged"
    chmod +x .husky/pre-commit
    log_strateup "SUCCESS" "Hook pre-commit atualizado! Qualidade BLINDADA! 🛡️"
  fi
fi

# Configurar lint-staged para verificações automáticas
if [ ! -f ".lintstagedrc.json" ]; then
  cat > .lintstagedrc.json << EOF
{
  "*.{js,jsx,ts,tsx}": [
    "eslint --fix",
    "prettier --write"
  ],
  "*.{css,scss,less}": [
    "prettier --write"
  ],
  "*.{json,md,mdx,yaml,yml}": [
    "prettier --write"
  ]
}
EOF
  log_strateup "SUCCESS" "lint-staged configurado! Código sempre IMPECÁVEL! ✨"
fi

# Configurar commit-msg hook para garantir padrão de mensagens
npx husky add .husky/commit-msg "npx --no-install commitlint --edit \$1"
chmod +x .husky/commit-msg

# Instalar commitlint se necessário
log_strateup "INFO" "Instalando commitlint pra garantir mensagens de commit PADRONIZADAS! 📝"

if [ -x "$(command -v npm)" ]; then
  npm install --save-dev @commitlint/{cli,config-conventional}
  
  # Configurar commitlint
  cat > .commitlintrc.json << EOF
{
  "extends": ["@commitlint/config-conventional"],
  "rules": {
    "header-max-length": [2, "always", 72],
    "subject-case": [0],
    "scope-case": [0]
  }
}
EOF
  log_strateup "SUCCESS" "commitlint instalado e configurado! Mensagens sempre TOP! 🔝"
else
  log_strateup "WARNING" "npm não encontrado. Instale o Node.js e npm primeiro. 🤷‍♂️"
fi

# Criar arquivo de contribuição
log_strateup "INFO" "Criando guia de contribuição pra todo mundo mandar bem! 🤝"

cat > CONTRIBUTING.md << EOF
# Guia de Contribuição StrateUp 🚀

## Nossa Filosofia 💯

Na StrateUp, acreditamos em **transformar mentes através de estratégias reais e resultados mensuráveis**. Este guia ajuda você a contribuir mantendo essa energia e visão.

## Como Contribuir 🤝

### 1. Escolha uma Issue 📋

- Procure issues marcadas com "good first issue" se é seu primeiro contribuição
- Discuta na issue antes de começar, para alinhar expectativas

### 2. Crie uma Branch 🌿

\`\`\`bash
# Clone o repositório
git clone https://github.com/StrateUpCompany/strateup-v3.git

# Atualize para a última versão
git checkout main
git pull

# Crie sua branch seguindo o padrão
git checkout -b feature/nome-da-feature
# ou
git checkout -b bugfix/nome-do-bug
\`\`\`

### 3. Desenvolva com ENERGIA! 💪

- Siga os padrões de código do projeto
- Escreva testes para suas mudanças
- Mantenha o foco em resultados mensuráveis
- Pense na experiência do cliente StrateUp

### 4. Commit com Padrão 📝

Usamos o padrão Conventional Commits:

\`\`\`
feat: adiciona novo sistema de autenticação
^     ^
|     |
|     +-> Resumo no presente, não no passado
|
+-------> Tipo: feat, fix, docs, style, refactor, test, chore
\`\`\`

### 5. Push e Pull Request 🚀

\`\`\`bash
git push origin feature/nome-da-feature
\`\`\`

Crie um Pull Request seguindo o template e aguarde a revisão!

## Valores que Guiam Nosso Código 🌟

- **Autenticidade**: Código que reflete quem somos
- **Transparência**: Documentação clara e aberta
- **Foco em Resultados**: Código que resolve problemas reais
- **Organização**: Estrutura limpa e planejada
- **Desenvolvimento Humano**: Código que ajuda outros a crescerem

## Lembre-se 🧠

"Transforme sua mente, transforme sua vida com estratégias reais e resultados mensuráveis!"

Juntos estamos construindo algo INCRÍVEL! 🚀
EOF

log_strateup "SUCCESS" "Guia de contribuição criado! Colaboração com PROPÓSITO! 🙌"

# Fazer commit inicial com toda a estrutura configurada
log_strateup "INFO" "Preparando commit inicial com toda essa estrutura PODEROSA! 💪"

git add .
git commit -m "feat: configuração inicial do projeto StrateUp v3 🚀"

log_strateup "SUCCESS" "Commit inicial realizado com sucesso! ✅"

# Voltar ao diretório original
cd ..

# Resumo final com toda a energia StrateUp!
echo -e "\n${STRATEUP_BLUE}${BOLD}════════ GIT CONFIGURADO COM SUCESSO! ════════${NC}"
log_strateup "SUCCESS" "✅ Git configurado e TURBINADO pro projeto StrateUp v3! 🚀"
log_strateup "INFO" "Repositório pronto para ESCALAR sem dor de cabeça!"
log_strateup "INFO" "Próximo passo: Execute o script 0.3-docker-environment.sh"
log_strateup "STRATEGY" "💡 Lembre-se: 'Potencial de Escala = (Receita Recorrente × Capacidade de Replicação) ÷ Custo de Expansão' - A organização do código é parte da nossa capacidade de replicação! 📈"

# Coleta de métricas para análise futura
{
  echo "SCRIPT_NAME=git-configuration.sh"
  echo "EXECUTION_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "SUCCESS=true"
} > "metrics/git-configuration-$(date +%Y%m%d-%H%M%S).metrics"

exit 0