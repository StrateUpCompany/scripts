Exemplo
Para criar uma nova aplicação web chamada "dashboard" na porta 3001:

bash
./config/templates/create-app.sh next-app dashboard 3001
Para criar uma nova API chamada "payment-api" na porta 3004:

bash
./config/templates/create-app.sh next-api payment-api 3004
O que é Configurado em cada Template
Template next-app
Estrutura Next.js completa
Integração com pacotes compartilhados
Configuração ESLint e TypeScript
Configuração de Jest para testes
Template next-api
API Routes Next.js
Middleware CORS e autenticação
Controladores básicos
Utilitários para logging e respostas padronizadas
Personalizações
Após criar um app a partir do template, você pode personalizá-lo conforme necessário:

Atualize o package.json para adicionar dependências específicas do app
Modifique next.config.js para necessidades específicas
Ajuste a estrutura de arquivos conforme o projeto evolui
Evoluindo os Templates
Para melhorar os templates, edite os arquivos em config/templates/apps/ e adicione boas práticas e componentes que possam ser reutilizados em novos apps. EOF

log_success "Templates para apps criados com sucesso." }

Marcação de conclusão do script
mark_completion() { log_section "Marcando Conclusão do Script"

local timestamp=$(date +%Y%m%d-%H%M%S) touch .strateup-step-1.1-complete echo "$timestamp" > .strateup-step-1.1-complete

Criar sumário de operações
cat > "${LOG_DIR}/summary-step-1.1.md" << EOF

✅ Sumário de Instalação - Passo 1.1
Data: 2025-06-05 16:51:53 Usuário: $USER_NAME

Operações Realizadas
✓ Expansão da biblioteca UI com tema e componentes adicionais
✓ Criação de integração entre pacotes UI e Utils
✓ Documentação arquitetural detalhada do projeto
✓ Configuração de diferentes ambientes (dev/staging/prod)
✓ Criação de templates para novos apps
Status do Projeto
Estrutura base expandida e preparada para desenvolvimento dos apps específicos.

Próximo passo: Implementação do app web (Passo 2) EOF

log_success "Passo 1.1 concluído com sucesso! Sumário criado em ${LOG_DIR}/summary-step-1.1.md"

Commit das alterações (se git estiver configurado)
if [ -d ".git" ]; then log_info "Realizando commit das alterações..." git add . git commit -m "feat(monorepo): integração entre pacotes e preparação para apps" log_success "Alterações commitadas."

Code
log_info "Para push das alterações, execute: git push origin [branch-atual]"
fi }

Lista de verificação final
final_checklist() { log_section "Lista de Verificação Final"

local all_good=true

1. Verificar se componentes UI adicionais foram criados
local UI_PKG_PATH="${PACKAGES_DIR}/ui" [ -d "
P
A
C
K
A
G
E
S
D
I
R
/
u
i
{PACKAGES_DIR}/ui ${EMOJI_UI}"

for component in "Card" "Input" "Badge" "Avatar" "Alert"; do if [ -f "
U
I
P
K
G
P
A
T
H
/
s
r
c
/
c
o
m
p
o
n
e
n
t
s
/
{component}.tsx" ]; then log_success "✓ Componente UI ${component} criado" else log_error "✗ Componente UI ${component} não encontrado" all_good=false fi done

2. Verificar integração entre pacotes
if [ -f "${UI_PKG_PATH}/src/integration/FormValidation.ts" ]; then log_success "✓ Integração UI e Utils criada" else log_error "✗ Integração UI e Utils não encontrada" all_good=false fi

3. Verificar documentação arquitetural
for doc in "overview" "data-flow" "apps-structure"; do if [ -f "
D
O
C
D
I
R
/
a
r
c
h
i
t
e
c
t
u
r
e
/
{doc}.md" ]; then log_success "✓ Documentação de arquitetura ${doc}.md criada" else log_error "✗ Documentação de arquitetura ${doc}.md não encontrada" all_good=false fi done

4. Verificar templates de apps
for template_type in "next-app" "next-api"; do if [ -d "config/templates/apps/${template_type}" ]; then log_success "✓ Template para ${template_type} criado" else log_error "✗ Template para ${template_type} não encontrado" all_good=false fi done

5. Verificar script de criação de app
if [ -f "config/templates/create-app.sh" ] && [ -x "config/templates/create-app.sh" ]; then log_success "✓ Script de criação de app criado e executável" else log_error "✗ Script de criação de app não encontrado ou não executável" all_good=false fi

6. Verificar configurações de ambiente
for env in "development" "staging" "production"; do if [ -f "config/environments/.env.${env}" ]; then log_success "✓ Configuração de ambiente ${env} criada" else log_error "✗ Configuração de ambiente ${env} não encontrada" all_good=false fi done

if [ "$all_good" = true ]; then log_success "Todas as verificações foram bem-sucedidas!" else log_warning "Algumas verificações falharam. Revise os erros acima." fi }

Função principal
main() { welcome_banner

Verificação inicial
check_prerequisites

Expansão da biblioteca UI
enhance_ui_library

Criar integrações entre pacotes
create_package_integrations

Criar documentação arquitetural
create_architecture_documentation

Otimizar configurações de build
optimize_build_configurations

Criar templates para apps
create_app_templates

Verificação final
final_checklist

Marcar conclusão
mark_completion

echo echo -e "
B
L
U
E
{BOLD}=============================================${NC}" echo -e "
G
R
E
E
N
{BOLD} PASSO 1.1 DE 13 CONCLUÍDO COM SUCESSO ${NC}" echo -e "
B
L
U
E
{BOLD}=============================================${NC}" echo echo -e "
Y
E
L
L
O
W
{BOLD}Próximos passos:${NC}" echo -e "1. Explore a documentação de arquitetura em 
C
Y
A
N
{DOC_DIR}/architecture/${NC}" echo -e "2. Verifique os componentes UI expandidos em 
C
Y
A
N
{PACKAGES_DIR}/ui/src/components/${NC}" echo -e "3. Utilize o script para criar novos apps: 
C
Y
A
N
.
/
c
o
n
f
i
g
/
t
e
m
p
l
a
t
e
s
/
c
r
e
a
t
e
−
a
p
p
.
s
h
{NC}" echo -e "4. Continue com o script do Passo 2: 
B
O
L
D
.
/
02
−
a
p
p
−
w
e
b
−
s
e
t
u
p
.
s
h
{NC}" echo echo -e "
G
R
E
E
N
{BOLD}Integração de pacotes e preparação para apps concluída!${NC}" }

Executar função principal com tratamento de erros
trap 'echo -e "
R
E
D
S
c
r
i
p
t
{NC}"; exit 1' INT TERM main exit 0

Code

## Como Usar este Script

1. Salve o script acima como `1.1-project-init.sh` na raiz do seu projeto
2. Torne o script executável:
   ```bash
   chmod +x 1.1-project-init.sh
Execute o script:
bash
./1.1-project-init.sh
O que Este Script Implementa
O script 1.1-project-init.sh complementa significativamente o script anterior, adicionando:

Componentes UI Expandidos:

Implementa 5 novos componentes (Card, Input, Badge, Avatar, Alert)
Adiciona sistema de temas para uso consistente
Integração entre Pacotes:

Cria sistema de validação que usa funções do pacote utils
Implementa hook de formulário com validação integrada
Demonstra padrão de uso entre componentes
Documentação Arquitetural Completa:

Visão geral da arquitetura com diagramas
Fluxo de dados detalhado
Estrutura dos apps
Configuração Multi-Ambiente:

Define configurações para dev/staging/production
Configurações de build específicas por ambiente
Templates para Novos Apps:

Templates para aplicações front-end e APIs
Script automatizado para criação de novos apps
Estruturas padronizadas e melhores práticas
Este script representa uma ponte importante entre a configuração inicial do projeto e os próximos passos de desenvolvimento dos apps específicos, garantindo uma base sólida e bem documentada para toda a equipe.