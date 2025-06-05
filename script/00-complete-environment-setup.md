
Instale as dependências:
bash
pnpm install
Configure as variáveis de ambiente:
bash
cp .env.example .env.local
# Edite .env.local com suas configurações
Inicie o ambiente de desenvolvimento:
bash
pnpm run dev
📝 Fluxo de Trabalho
Atualize sua branch principal:
bash
git checkout main
git pull origin main
Crie uma branch para sua feature ou correção:
bash
git checkout -b feature/nome-descritivo
# ou
git checkout -b fix/nome-descritivo
Faça suas alterações e commits:
bash
git add .
git commit -m "tipo(escopo): descrição da alteração"
Envie sua branch para o repositório remoto:
bash
git push origin feature/nome-descritivo
Abra um Pull Request no GitHub descrevendo suas alterações.
📋 Convenções de Código
Commits
Seguimos o padrão de Conventional Commits:

feat: Nova funcionalidade
fix: Correção de bug
docs: Alterações na documentação
style: Formatação, ponto-e-vírgula faltando, etc.
refactor: Refatoração de código
perf: Melhorias de performance
test: Adicionando ou corrigindo testes
chore: Alterações em ferramentas e configurações
Estilo de Código
TypeScript: Seguir as diretrizes do ESLint e Prettier configurados no projeto
Componentes React: Utilizar componentes funcionais com hooks
CSS: Utilizar Styled Components com temas
Testes: Escrever testes para todas as novas funcionalidades
🧪 Testes
Execute os testes antes de enviar seu PR:

bash
# Executar todos os testes
pnpm run test

# Executar testes de um pacote específico
pnpm --filter @strateup/ui run test
📚 Documentação
Se sua contribuição incluir novos recursos ou alterações significativas:

Atualize a documentação relevante na pasta docs/
Adicione comentários ao código conforme necessário
Atualize o README.md se apropriado
🛠️ Ferramentas Recomendadas
VSCode com as seguintes extensões:
ESLint
Prettier
TypeScript
Styled Components
GitHub Copilot (opcional)
📮 Processo de Pull Request
Certifique-se de que seu código passa em todos os testes
Preencha o template de Pull Request completamente
Referencie qualquer issue relacionada usando #issue-number
Aguarde revisão - alguém irá revisar seu PR em breve
❓ Perguntas?
Se você tiver alguma dúvida ou precisar de ajuda:

Abra uma issue com a tag "question"
Entre em contato com a equipe de desenvolvimento
Agradecemos sua contribuição para tornar o StrateUp v3 ainda melhor! EOF log_success "Guia de contribuição criado."

Criar documentação dos scripts
mkdir -p "scripts ${EMOJI_SCRIPTS}" cat > "scripts ${EMOJI_SCRIPTS}/README.md" << 'EOF'

🛠️ Scripts de Configuração do StrateUp v3
Este documento descreve os scripts de automação disponíveis para configurar e manter o projeto StrateUp v3.

📋 Visão Geral
Os scripts estão organizados em uma sequência lógica de passos, do 0 ao 12, cada um responsável por uma parte específica da configuração e desenvolvimento do projeto.

🚀 Scripts Disponíveis
00-complete-environment-setup.sh
Propósito: Preparação completa do ambiente de desenvolvimento.

Funcionalidades:

Verificação e instalação de dependências (Node.js, pnpm, Git)
Configuração do ambiente de desenvolvimento
Criação da estrutura de diretórios com identificação visual por emojis
Configuração inicial do monorepo com pnpm
Documentação completa com referências oficiais
Criação de arquivos base para componentes e páginas
Como executar:

bash
./00-complete-environment-setup.sh
01-project-init.sh (Próximo passo)
Propósito: Inicialização do projeto e configuração base.

Funcionalidades:

Configuração do monorepo com Turborepo
Setup dos pacotes compartilhados básicos
Configuração de ESLint e Prettier
Configuração de TypeScript
Templates de componentes e páginas
Como executar:

bash
./01-project-init.sh
📝 Convenção de Nomeação
Todos os scripts seguem a convenção:

Code
XX-nome-descritivo.sh
Onde XX é um número de dois dígitos representando a sequência de execução.

⚠️ Precauções
Execute os scripts na ordem numérica
Faça backup antes de executar scripts que possam modificar arquivos existentes
Verifique os logs após a execução para identificar possíveis erros
📚 Documentação Relacionada
Ambiente de Desenvolvimento

Stack Tecnológica

Guia de Contribuição EOF log_success "Documentação dos scripts criada."

log_success "Toda a documentação de referência criada com sucesso!" }