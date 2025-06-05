#!/bin/bash
# =======================================================================
# SCRIPT: docker-environment.sh
# DESCRIÇÃO: Configuração TURBINADA de Docker para StrateUp! 🐳🚀
# AUTOR: StrateUpCompany
# DATA: 2025-06-05
# VERSÃO: 1.0.0
# 
# VISÃO STRATEUP:
# "Transforme sua mente, transforme sua vida com estratégias reais 
# e resultados mensuráveis" 💯
# =======================================================================

# Carregar o estilo StrateUp COM TODA FORÇA! 💪
source "$(dirname "$0")/common/strateup-style.sh"

# Verificar se tá tudo pronto pra gente detonar!
if [ ! -f ".strateup-env.json" ]; then
  log_strateup "ERROR" "Eita! Ambiente não validado! Roda o 0.0-environment-validation.sh primeiro, parceiro! 🛠️"
  exit 1
fi

# Banner StrateUp COM ENERGIA MÁXIMA! 🔥
show_strateup_banner "DOCKER ENVIRONMENT - ESCALABILIDADE MÁXIMA! 🐳"
log_strateup "STRATEGY" "${BOLD}Docker é REPLICAÇÃO na veia! Vamos preparar o ambiente pra escalar SEM LIMITES! 📈${NC}"
log_strateup "INFO" "Este script vai configurar Docker pro StrateUp v3 - Consistência em todos os ambientes! 💪"

# Verificar se Docker está instalado
log_strateup "INFO" "Verificando se o Docker já tá na área... 🧐"

if command -v docker &> /dev/null; then
  docker_version=$(docker --version | cut -d ' ' -f3 | tr -d ',')
  log_strateup "SUCCESS" "Docker ${docker_version} detectado! Já temos o motor da escalabilidade! ✅"
else
  log_strateup "WARNING" "Docker não encontrado! Vamos instalar essa máquina de replicação? 🔧"
  
  # Perguntar se deseja instalar Docker
  read -p "Instalar Docker agora? (s/n): " install_docker
  
  if [ "$install_docker" = "s" ] || [ "$install_docker" = "S" ]; then
    log_strateup "INFO" "Instalando Docker... Isso vai dar um UP na sua capacidade de replicação! 🚀"
    
    # Detectar sistema operacional e instalar Docker
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      
      case $ID in
        ubuntu|debian|raspbian)
          log_strateup "INFO" "Sistema Debian/Ubuntu detectado! Instalando Docker... 🐧"
          sudo apt-get update
          sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
          curl -fsSL https://download.docker.com/linux/$ID/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
          echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$ID $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
          sudo apt-get update
          sudo apt-get install -y docker-ce docker-ce-cli containerd.io
          ;;
        fedora)
          log_strateup "INFO" "Sistema Fedora detectado! Instalando Docker... 🐧"
          sudo dnf -y install dnf-plugins-core
          sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
          sudo dnf -y install docker-ce docker-ce-cli containerd.io
          ;;
        centos|rhel)
          log_strateup "INFO" "Sistema CentOS/RHEL detectado! Instalando Docker... 🐧"
          sudo yum install -y yum-utils
          sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
          sudo yum install -y docker-ce docker-ce-cli containerd.io
          ;;
        *)
          log_strateup "WARNING" "Sistema não suportado para instalação automática! 😅"
          log_strateup "INFO" "Por favor, instale Docker manualmente: https://docs.docker.com/get-docker/"
          install_docker="n"
          ;;
      esac
      
      # Iniciar Docker se instalado com sucesso
      if [ "$install_docker" = "s" ] || [ "$install_docker" = "S" ]; then
        sudo systemctl enable docker
        sudo systemctl start docker
        sudo usermod -aG docker $USER
        log_strateup "INFO" "🚨 IMPORTANTE: Você precisa fazer logout e login novamente para usar Docker sem sudo! 🚨"
        log_strateup "SUCCESS" "Docker instalado com SUCESSO! A máquina de replicação tá PRONTA! 🚀"
      fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      log_strateup "INFO" "Sistema macOS detectado! 🍎"
      log_strateup "INFO" "Por favor, baixe e instale o Docker Desktop para Mac:"
      log_strateup "INFO" "https://docs.docker.com/desktop/mac/install/"
      install_docker="n"
    elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "win"* ]]; then
      log_strateup "INFO" "Sistema Windows detectado! 🪟"
      log_strateup "INFO" "Por favor, baixe e instale o Docker Desktop para Windows:"
      log_strateup "INFO" "https://docs.docker.com/desktop/windows/install/"
      install_docker="n"
    else
      log_strateup "WARNING" "Sistema operacional não reconhecido! 🤔"
      log_strateup "INFO" "Por favor, instale Docker manualmente: https://docs.docker.com/get-docker/"
      install_docker="n"
    fi
  else
    log_strateup "WARNING" "Docker não será instalado. Alguns recursos do projeto podem não funcionar como esperado! ⚠️"
    log_strateup "INFO" "Você pode instalar Docker mais tarde: https://docs.docker.com/get-docker/"
    exit 1
  fi
fi

# Verificar se Docker Compose está instalado
log_strateup "INFO" "Verificando se o Docker Compose tá pronto pra ação... 🧐"

if command -v docker-compose &> /dev/null; then
  compose_version=$(docker-compose --version | sed 's/.*version \([0-9.]*\).*/\1/')
  log_strateup "SUCCESS" "Docker Compose ${compose_version} detectado! Orquestração já tá garantida! ✅"
elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
  compose_version=$(docker compose version | sed 's/.*version \([0-9.]*\).*/\1/')
  log_strateup "SUCCESS" "Docker Compose integrado v${compose_version} detectado! Orquestração já tá garantida! ✅"
else
  log_strateup "WARNING" "Docker Compose não encontrado! É crucial pra orquestração dos serviços! ⚠️"
  
  # Tentar instalar Docker Compose se Docker estiver instalado
  if command -v docker &> /dev/null; then
    log_strateup "INFO" "Instalando Docker Compose..."
    
    # Instalar a versão mais recente do Docker Compose
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    
    sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    if command -v docker-compose &> /dev/null; then
      compose_version=$(docker-compose --version | sed 's/.*version \([0-9.]*\).*/\1/')
      log_strateup "SUCCESS" "Docker Compose ${compose_version} instalado! Orquestração GARANTIDA! 🚀"
    else
      log_strateup "WARNING" "Não foi possível instalar Docker Compose automaticamente. 😕"
      log_strateup "INFO" "Por favor, instale manualmente: https://docs.docker.com/compose/install/"
    fi
  fi
fi

# Entrar no diretório do projeto
PROJECT_DIR="strateup-v3"
if [ ! -d "$PROJECT_DIR" ]; then
  log_strateup "ERROR" "Cadê o diretório $PROJECT_DIR? Roda o script 0.1-dependency-installation.sh primeiro! 🤔"
  exit 1
fi

cd "$PROJECT_DIR"

# Configurar Docker para o projeto
log_strateup "INFO" "Configurando Docker pro projeto StrateUp v3 - Ambiente CONSISTENTE é tudo! 🔄"

# Criar diretório docker
mkdir -p docker/development
mkdir -p docker/production

# Criar arquivo docker-compose.yml para desenvolvimento
log_strateup "INFO" "Criando docker-compose.yml pra DESENVOLVIMENTO TURBINADO! 🛠️"

cat > docker-compose.yml << EOF
version: '3.8'

services:
  # Aplicação Next.js
  strateup-app:
    build:
      context: .
      dockerfile: docker/development/Dockerfile
    container_name: strateup-app
    restart: unless-stopped
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
      - /app/.next
    environment:
      - NODE_ENV=development
    depends_on:
      - strateup-db
    networks:
      - strateup-network
    command: npm run dev

  # Banco de dados
  strateup-db:
    image: postgres:14-alpine
    container_name: strateup-db
    restart: unless-stopped
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=strateup
      - POSTGRES_PASSWORD=strateup_password
      - POSTGRES_DB=strateup_db
    networks:
      - strateup-network

  # Serviço de cache (Redis)
  strateup-cache:
    image: redis:alpine
    container_name: strateup-cache
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - strateup-network

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

networks:
  strateup-network:
    driver: bridge
EOF

log_strateup "SUCCESS" "docker-compose.yml criado com MAESTRIA! 🎯"

# Criar Dockerfile de desenvolvimento
log_strateup "INFO" "Criando Dockerfile de desenvolvimento com TODAS AS TURBINADAS! 🧪"

cat > docker/development/Dockerfile << EOF
FROM node:18-alpine

# Definir diretório de trabalho - onde a mágica acontece!
WORKDIR /app

# Instalar ferramentas essenciais
RUN apk add --no-cache git curl

# Instalar pnpm globalmente - porque somos EFICIENTES! ⚡
RUN npm install -g pnpm

# Copiar apenas arquivos necessários para instalar dependências
# Estratégia para otimizar camadas Docker e usar cache
COPY package*.json ./
COPY pnpm-lock.yaml ./
COPY .npmrc ./

# Instalar dependências com cache turbinado
RUN pnpm install --frozen-lockfile

# Expor porta para acesso à aplicação
EXPOSE 3000

# Comando padrão para iniciar a aplicação em modo desenvolvimento
CMD ["pnpm", "run", "dev"]
EOF

log_strateup "SUCCESS" "Dockerfile de desenvolvimento criado e pronto pra ACELERAR! 🏎️"

# Criar Dockerfile de produção
log_strateup "INFO" "Criando Dockerfile de produção OTIMIZADO AO MÁXIMO! 🚀"

cat > docker/production/Dockerfile << EOF
# Estágio 1: Construção da aplicação
FROM node:18-alpine AS builder

# Definir diretório de trabalho
WORKDIR /app

# Instalar pnpm globalmente
RUN npm install -g pnpm

# Copiar arquivos necessários para instalação
COPY package*.json ./
COPY pnpm-lock.yaml ./
COPY .npmrc ./

# Instalar dependências
RUN pnpm install --frozen-lockfile --prod

# Copiar código fonte
COPY . .

# Construir a aplicação para produção
RUN pnpm run build

# Estágio 2: Imagem final otimizada
FROM node:18-alpine AS runner

# Definir diretório de trabalho
WORKDIR /app

# Variáveis de ambiente para produção
ENV NODE_ENV=production
ENV PORT=3000

# Adicionar usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Copiar arquivos de build e dependências do estágio anterior
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

# Mudar para usuário não-root
USER nextjs

# Expor porta para a aplicação
EXPOSE 3000

# Iniciar a aplicação
CMD ["npm", "start"]
EOF

log_strateup "SUCCESS" "Dockerfile de produção criado e SUPER OTIMIZADO! 💯"

# Criar docker-compose para produção
log_strateup "INFO" "Criando docker-compose.prod.yml pra PRODUÇÃO SEM BUGS! 🛡️"

cat > docker-compose.prod.yml << EOF
version: '3.8'

services:
  # Aplicação Next.js em produção
  strateup-app:
    build:
      context: .
      dockerfile: docker/production/Dockerfile
    container_name: strateup-app-prod
    restart: always
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://strateup:strateup_password@strateup-db-prod:5432/strateup_db
      - REDIS_URL=redis://strateup-cache-prod:6379
    depends_on:
      - strateup-db
      - strateup-cache
    networks:
      - strateup-network-prod

  # Banco de dados
  strateup-db:
    image: postgres:14-alpine
    container_name: strateup-db-prod
    restart: always
    ports:
      - "5432:5432"
    volumes:
      - postgres_data_prod:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=strateup
      - POSTGRES_PASSWORD=strateup_password
      - POSTGRES_DB=strateup_db
    networks:
      - strateup-network-prod

  # Serviço de cache
  strateup-cache:
    image: redis:alpine
    container_name: strateup-cache-prod
    restart: always
    ports:
      - "6379:6379"
    volumes:
      - redis_data_prod:/data
    networks:
      - strateup-network-prod

  # Proxy reverso
  nginx:
    image: nginx:alpine
    container_name: strateup-nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/production/nginx:/etc/nginx/conf.d
      - ./docker/production/certbot/conf:/etc/letsencrypt
      - ./docker/production/certbot/www:/var/www/certbot
    depends_on:
      - strateup-app
    networks:
      - strateup-network-prod
    command: "/bin/sh -c 'while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'"

  # Certificados SSL
  certbot:
    image: certbot/certbot
    container_name: strateup-certbot
    restart: unless-stopped
    volumes:
      - ./docker/production/certbot/conf:/etc/letsencrypt
      - ./docker/production/certbot/www:/var/www/certbot
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"

volumes:
  postgres_data_prod:
    driver: local
  redis_data_prod:
    driver: local

networks:
  strateup-network-prod:
    driver: bridge
EOF

log_strateup "SUCCESS" "docker-compose.prod.yml criado! Produção vai VOAR! 🚀"

# Criar diretório e configuração para Nginx
mkdir -p docker/production/nginx
mkdir -p docker/production/certbot/conf
mkdir -p docker/production/certbot/www

cat > docker/production/nginx/app.conf << EOF
server {
    listen 80;
    server_name localhost;  # Substitua por seu domínio em produção
    server_tokens off;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name localhost;  # Substitua por seu domínio em produção
    server_tokens off;

    ssl_certificate /etc/letsencrypt/live/localhost/fullchain.pem;  # Substitua por seu domínio
    ssl_certificate_key /etc/letsencrypt/live/localhost/privkey.pem;  # Substitua por seu domínio

    # Recomendações de segurança para SSL
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;

    # Configurações HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Outras configurações de segurança
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    location / {
        proxy_pass http://strateup-app:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

log_strateup "SUCCESS" "Configuração Nginx criada! Segurança e performance GARANTIDAS! 🔒"

# Criar script de inicialização para desenvolvimento
log_strateup "INFO" "Criando script para iniciar ambiente de desenvolvimento FÁCIL e RÁPIDO! ⚡"

cat > start-dev.sh << EOF
#!/bin/bash

# Script para iniciar ambiente Docker de desenvolvimento StrateUp 🚀
echo "🚀 Iniciando ambiente de desenvolvimento StrateUp v3..."
echo "🔍 Verificando se Docker está rodando..."

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker não está rodando! Por favor, inicie o Docker e tente novamente."
  exit 1
fi

echo "✅ Docker está rodando!"
echo "🛠️ Construindo e iniciando containers..."

# Construir e iniciar containers
docker-compose up --build -d

# Verificar se containers estão rodando
if [ \$? -eq 0 ]; then
  echo "✨ Ambiente de desenvolvimento StrateUp v3 iniciado com SUCESSO!"
  echo ""
  echo "📱 Acesse a aplicação em: http://localhost:3000"
  echo "💾 Banco de dados disponível em: localhost:5432"
  echo "🗃️ Redis disponível em: localhost:6379"
  echo ""
  echo "📊 Para ver logs dos containers: docker-compose logs -f"
  echo "🛑 Para parar os containers: ./stop-dev.sh"
else
  echo "❌ Erro ao iniciar os containers. Verifique os logs com: docker-compose logs"
fi
EOF

chmod +x start-dev.sh

# Criar script para parar ambiente de desenvolvimento
cat > stop-dev.sh << EOF
#!/bin/bash

# Script para parar ambiente Docker de desenvolvimento StrateUp 🚀
echo "🛑 Parando ambiente de desenvolvimento StrateUp v3..."

# Parar containers
docker-compose down

if [ \$? -eq 0 ]; then
  echo "✅ Ambiente de desenvolvimento parado com sucesso!"
else
  echo "❌ Erro ao parar os containers. Tente manualmente: docker-compose down"
fi
EOF

chmod +x stop-dev.sh

log_strateup "SUCCESS" "Scripts de controle criados! Iniciar e parar ficou MAMÃO COM AÇÚCAR! 🍰"

# Criar arquivo .dockerignore para otimizar builds
log_strateup "INFO" "Criando .dockerignore para builds RÁPIDOS e EFICIENTES! ⚡"

cat > .dockerignore << EOF
# Ignore node_modules e arquivos temporários
node_modules
npm-debug.log
yarn-debug.log
yarn-error.log
.pnpm-debug.log
.DS_Store
Thumbs.db

# Ignore arquivos de ambiente
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Ignore arquivos de build
.next
out
dist
build

# Ignore arquivos de desenvolvimento
.git
.github
.vscode
.idea
*.md
LICENSE
Dockerfile*
docker-compose*
.dockerignore

# Ignore arquivos de teste
__tests__
coverage
*.test.js
*.spec.js

# Ignore outros
logs
*.log
.coverage
.nyc_output
.scannerwork
EOF

log_strateup "SUCCESS" ".dockerignore criado! Builds vão ficar VOANDO! 🚀"

# Atualizar o README.md com instruções Docker
log_strateup "INFO" "Atualizando README.md com instruções Docker... 📝"

if [ -f "README.md" ]; then
  # Fazer backup do README existente
  cp README.md README.md.bak
fi

cat > README.md << EOF
# StrateUp v3 🚀

> Transforme sua mente, transforme sua vida com estratégias reais e resultados mensuráveis!

## Rodando com Docker (Recomendado) 🐳

O projeto está configurado com Docker para garantir consistência em todos os ambientes.

### Pré-requisitos

- Docker
- Docker Compose

### Ambiente de Desenvolvimento

Para iniciar o ambiente de desenvolvimento:

\`\`\`bash
# Usando nosso script super fácil
./start-dev.sh

# OU manualmente
docker-compose up -d
\`\`\`

Acesse a aplicação em: http://localhost:3000

### Ambiente de Produção

Para preparar o ambiente de produção:

\`\`\`bash
# Construir e iniciar containers de produção
docker-compose -f docker-compose.prod.yml up -d
\`\`\`

## Rodando sem Docker (Alternativo)

Se preferir rodar sem Docker:

\`\`\`bash
# Instalar dependências
pnpm install

# Iniciar em desenvolvimento
pnpm dev

# Build para produção
pnpm build

# Iniciar em produção
pnpm start
\`\`\`

## Escalabilidade StrateUp 📈

Lembre-se da nossa fórmula de escalabilidade:

> Potencial de Escala = (Receita Recorrente × Capacidade de Replicação) ÷ Custo de Expansão

Este projeto foi estruturado para maximizar a capacidade de replicação e minimizar o custo de expansão!

## Valores StrateUp 💯

- **Autenticidade** - Somos genuínos em tudo que fazemos
- **Transparência** - Compartilhamos processos e resultados
- **Foco em Resultados** - Entregamos transformação mensurável
- **Organização** - A base de qualquer projeto de sucesso
- **Desenvolvimento Humano** - Crescemos juntos com nossos clientes

## Vamos transformar juntos! 💪
EOF

log_strateup "SUCCESS" "README.md atualizado com instruções Docker e valores StrateUp! 📚"

# Voltar ao diretório original
cd ..

# Resumo final com energia máxima!
echo -e "\n${STRATEUP_BLUE}${BOLD}════════ DOCKER CONFIGURADO COM SUCESSO! ════════${NC}"
log_strateup "SUCCESS" "✅ Ambiente Docker configurado e PRONTO PRA ESCALAR! 🚀"
log_strateup "INFO" "Docker preparado para REPLICAR sua solução como o McDonald's! 🍔"
log_strateup "INFO" "Próximo passo: Execute o script 0.4-development-tools.sh"
log_strateup "STRATEGY" "💡 Lembre-se: 'A capacidade de replicação é um dos fatores chave na fórmula da escalabilidade!' - StrateUp 📈"

# Coleta de métricas para análise futura
{
  echo "SCRIPT_NAME=docker-environment.sh"
  echo "EXECUTION_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "SUCCESS=true"
  echo "DOCKER_VERSION=${docker_version:-NONE}"
  echo "DOCKER_COMPOSE_VERSION=${compose_version:-NONE}"
} > "metrics/docker-environment-$(date +%Y%m%d-%H%M%S).metrics"

exit 0