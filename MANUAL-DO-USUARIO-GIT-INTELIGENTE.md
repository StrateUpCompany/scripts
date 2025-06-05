# Manual do Usuário - Fluxo de Trabalho Git Inteligente

**Versão:** 1.0.0  
**Data:** 05/06/2025  
**Autor:** StrateUpCompany  

![Logo do Fluxo de Trabalho Git Inteligente](https://placeholder-for-your-logo.png)

## Sumário

1. [Introdução](#introdução)
2. [Instalação](#instalação)
3. [Primeiros Passos](#primeiros-passos)
4. [Opções do Menu Principal](#opções-do-menu-principal)
5. [Análise Inteligente de Commits](#análise-inteligente-de-commits)
6. [Análise Profunda de Conteúdo](#análise-profunda-de-conteúdo)
7. [Gerenciamento de Arquivos](#gerenciamento-de-arquivos)
8. [Gerenciamento de Branches](#gerenciamento-de-branches)
9. [Recursos Avançados](#recursos-avançados)
10. [Solução de Problemas](#solução-de-problemas)
11. [Dicas e Melhores Práticas](#dicas-e-melhores-práticas)
12. [Perguntas Frequentes](#perguntas-frequentes)

---

## Introdução

O Fluxo de Trabalho Git Inteligente é um script avançado em shell para Git projetado para melhorar sua experiência com o Git, fornecendo geração inteligente de mensagens de commit, análise detalhada de código e uma interface intuitiva para operações comuns do Git. O script analisa suas alterações, compreende o que foi modificado e gera automaticamente mensagens de commit significativas com base na natureza das suas alterações.

### Principais Recursos

- **Geração inteligente de mensagens de commit** baseada na análise de código
- **Análise profunda de conteúdo** com informações específicas por linguagem
- **Menu interativo** com interface colorida para melhor experiência do usuário
- **Ferramentas aprimoradas de gerenciamento de branches**
- **Análise pré-commit** para detectar possíveis problemas

---

## Instalação

### Pré-requisitos

- Git instalado em seu sistema
- Shell Bash (versão 4 ou superior recomendada)
- Conhecimento básico de comandos Git

### Configuração

1. **Download do Script `smart-git-workflow.sh`**:

   ```bash
   curl -O https://your-domain.com/smart-git-workflow.sh

Este comando baixa o script do servidor para seu diretório atual. Se você preferir, também pode baixar manualmente através do navegador ou clonar o repositório completo.

Tornar o Script Executável:

chmod +x smart-git-workflow.sh

O comando chmod +x adiciona permissão de execução ao arquivo, permitindo que você o rode como um programa.

Opcional: Adicionar ao PATH para Acesso Global:

Para poder executar o script de qualquer lugar no sistema, adicione-o ao seu PATH:

# Adicione esta linha ao seu arquivo .bashrc ou .zshrc
export PATH="$PATH:/caminho/para/o/diretório/contendo/script"

Substitua /caminho/para/o/diretório/contendo/script pelo caminho real onde você salvou o script.

Reiniciar o Terminal ou Recarregar o Arquivo de Configuração:

source ~/.bashrc  # ou ~/.zshrc se você usa o Zsh

Isso carrega as novas configurações sem precisar fechar e abrir o terminal novamente.

Verificação da Instalação:

Para confirmar que o script foi instalado corretamente:

which smart-git-workflow.sh

Este comando deve mostrar o caminho para o script se ele estiver disponível no PATH.

Primeiros Passos
Para começar a usar o script Fluxo de Trabalho Git Inteligente, navegue até qualquer repositório Git e execute:
./smart-git-workflow.sh

Ou, se você adicionou ao PATH:
smart-git-workflow.sh

Se você não estiver dentro de um repositório Git, o script perguntará se deseja inicializar um.

O script exibirá o menu principal com opções para gerenciar seu fluxo de trabalho Git.

Navegação Básica
Use os números correspondentes para selecionar opções do menu
Pressione Enter para confirmar uma seleção
Nas perguntas de sim/não/editar, use y (sim), n (não) ou e (editar)
A qualquer momento, você pode ver o status atual do seu repositório Git na parte superior da tela
Opções do Menu Principal
O menu principal apresenta as seguintes opções:

1. Analisar Alterações de Forma Inteligente e Sugerir Mensagem de Commit
Propósito: Analisa suas alterações preparadas (staged) e gera uma mensagem de commit apropriada baseada nos arquivos alterados, conteúdo modificado e a natureza das alterações.

O que faz:

Examina os arquivos preparados para determinar quais tipos de arquivos foram alterados
Analisa o conteúdo das alterações (código adicionado/removido)
Procura por palavras-chave que indiquem o propósito das alterações (correção, recurso, etc.)
Gera uma mensagem de commit seguindo o formato de commit convencional: tipo(escopo): assunto
Como usar:

Prepare suas alterações usando git add
Selecione a opção 1 no menu principal
Reveja a mensagem de commit sugerida e os detalhes da análise
O script mostrará:
Número de arquivos alterados
Tipos de arquivo modificados
Diretórios afetados
Uma sugestão completa no formato tipo(escopo): assunto
Quando usar: Quando você deseja uma mensagem de commit significativa sem gastar tempo elaborando-a manualmente.

Exemplo de saída:

Analisando Alterações de Forma Inteligente:
-----------------------------

Detalhes da Análise:
  Arquivos Alterados: 3
  Tipos de Arquivo: js css
  Diretórios Alterados: 2

Mensagem de Commit Sugerida:
feat(frontend): adicionar formulário de login

Analisar Profundamente as Alterações de Conteúdo
Propósito: Fornece uma análise detalhada com reconhecimento de linguagem das suas alterações para ajudar a compreender o impacto das suas modificações.

O que faz:

Analisa cada arquivo individualmente com informações específicas para cada linguagem
Detecta alterações em funções, classes e componentes
Identifica palavras-chave importantes (TODO, FIXME, BUG)
Conta linhas adicionadas e removidas
Fornece informações baseadas no tipo de arquivo (JavaScript, Python, Go, etc.)
Como usar:

Prepare suas alterações usando git add
Selecione a opção 2 no menu principal
Reveja a análise detalhada para cada arquivo
Para cada arquivo, você verá:
Nome e caminho do arquivo
Número de linhas adicionadas/removidas
Análise específica da linguagem (funções adicionadas, classes modificadas, etc.)
Palavras-chave importantes encontradas
Pressione Enter para voltar ao menu principal quando terminar
Quando usar: Quando você deseja entender o escopo e impacto das suas alterações antes de fazer commit, ou quando estiver preparando para uma revisão de código.

Exemplo de saída:

Análise Profunda de Alterações:
-----------------------

Analisando: src/components/Login.js
  Linhas Adicionadas: 45
  Linhas Removidas: 2
  Análise JavaScript/React:
  Funções: +3 / -1
  Componentes modificados ou adicionados
  Palavras-chave importantes: TODO (Melhorar validação de formulário)

Analisando: src/styles/login.css
  Linhas Adicionadas: 28
  Linhas Removidas: 0
  Análise CSS:
  Seletores: +12

3. Preparar Todas as Alterações
Propósito: Prepara (stage) todos os arquivos modificados e não rastreados para commit.

O que faz:

Executa git add . para preparar todas as alterações
Inclui todos os arquivos modificados, adicionados e não rastreados, exceto os que estão no .gitignore
Como usar:

Selecione a opção 3 no menu principal
Todas as alterações serão preparadas
O script confirmará que os arquivos foram preparados
Você verá uma lista colorida de todos os arquivos que foram preparados
Quando usar: Quando você deseja fazer commit de todas as alterações no seu diretório de trabalho.

Detalhamento do processo:

O script executa git add . internamente
Verifica se há algum problema com os arquivos preparados (arquivos muito grandes, etc.)
Mostra uma confirmação visual de quantos arquivos foram preparados
Retorna ao menu principal após pressionar Enter
4. Preparar Arquivos Específicos
Propósito: Permite selecionar arquivos específicos para preparar.

O que faz:

Solicita que você informe os caminhos dos arquivos
Prepara apenas os arquivos especificados usando git add <arquivos>
Como usar:

Selecione a opção 4 no menu principal
Digite os caminhos dos arquivos separados por espaços
Exemplo: src/main.js config.json README.md
Pressione Enter para confirmar
Os arquivos serão preparados para commit
O script confirmará quais arquivos foram preparados
Quando usar: Quando você deseja fazer commit apenas de arquivos específicos e manter outras alterações para depois.

Dicas para inserção de arquivos:

Você pode usar padrões glob: *.js, src/*.css
Use tabulação para autocompletar nomes de arquivo
Para arquivos em subdiretórios, inclua o caminho relativo: src/utils/helper.js
5. Remover Arquivos da Área de Preparação
Propósito: Remove arquivos especificados da área de preparação (unstage).

O que faz:

Solicita que você informe os caminhos dos arquivos
Remove os arquivos especificados da área de preparação usando git reset HEAD
Como usar:

Selecione a opção 5 no menu principal
Digite os caminhos dos arquivos separados por espaços que deseja remover da área de preparação
Pressione Enter para confirmar
Os arquivos serão removidos da área de preparação
O script confirmará quais arquivos foram removidos e mostrará o status atualizado
Quando usar: Quando você preparou arquivos que não deseja incluir no seu próximo commit.

Observação importante:

Esta operação não descarta as alterações nos arquivos; apenas os remove da área de preparação
Suas modificações permanecerão em seu diretório de trabalho
Você pode verificar o status após a operação para confirmar quais arquivos permanecem preparados
6. Fazer Commit com Mensagem Inteligente
Propósito: Faz commit das suas alterações preparadas com uma mensagem gerada de forma inteligente.

O que faz:

Analisa suas alterações preparadas
Gera uma mensagem de commit sugerida
Pergunta se você deseja usar a mensagem sugerida, editá-la ou escrever sua própria
Faz commit das suas alterações com a mensagem escolhida
Oferece a opção de enviar (push) suas alterações
Como usar:

Certifique-se de que você preparou suas alterações
Selecione a opção 6 no menu principal
Reveja a mensagem de commit sugerida
Escolha:
y para usar a mensagem sugerida sem alterações
e para editar a mensagem sugerida (abrirá uma linha para edição)
n para escrever sua própria mensagem do zero
Se você escolher editar ou escrever sua própria mensagem:
Digite a mensagem desejada
Pressione Enter para confirmar
O script confirmará que o commit foi realizado com sucesso
O script perguntará se você deseja enviar (push) as alterações imediatamente
Escolha y para enviar ou n para enviar depois
Quando usar: Quando você está pronto para fazer commit das suas alterações e deseja uma mensagem de commit significativa e descritiva.

Detalhamento do processo de commit:

Verificação se há alterações preparadas
Se não houver, oferece preparar todas as alterações
Mostra todos os arquivos que serão incluídos no commit
Gera e apresenta uma mensagem de commit sugerida
Permite personalização da mensagem
Executa git commit -m "<mensagem>" internamente
Confirma sucesso ou falha do commit
Oferece opção de envio (push)
7. Enviar (Push) Commits
Propósito: Envia seus commits para o repositório remoto.

O que faz:

Verifica se seu branch atual existe no repositório remoto
Envia alterações para o repositório remoto
Configura rastreamento upstream se o branch for novo
Como usar:

Selecione a opção 7 no menu principal
Se seu branch não existir remotamente, confirme se deseja configurá-lo como upstream:
Escolha y para enviar e configurar como upstream
Escolha n para cancelar o envio
O script mostrará o progresso do envio
Quando concluído, mostrará uma confirmação de sucesso ou mensagens de erro
Quando usar: Após fazer commit de alterações que você deseja publicar no repositório remoto.

Detalhamento do processo de envio:

O script identifica o branch atual
Verifica se esse branch existe no repositório remoto
Se existir, executa git push
Se não existir, pergunta se deseja configurar como upstream
Se sim, executa git push --set-upstream origin <nome-do-branch>
Se não, cancela a operação
Mostra o resultado completo da operação de envio
Retorna ao menu principal após pressionar Enter
8. Puxar (Pull) Alterações Recentes
Propósito: Atualiza seu repositório local com as alterações mais recentes do repositório remoto.

O que faz:

Executa git pull para buscar e mesclar alterações remotas
Mostra um resumo das alterações obtidas
Como usar:

Selecione a opção 8 no menu principal
O script executará o comando pull automaticamente
Você verá as alterações que foram recebidas do repositório remoto
Se houver conflitos, o script alertará sobre eles e oferecerá orientações
Pressione Enter para retornar ao menu principal
Quando usar: Antes de começar a trabalhar ou antes de enviar suas alterações para garantir que você tenha o código mais recente.

Detalhamento do processo de pull:

O script executa git pull internamente
Se bem-sucedido:
Mostra um resumo dos arquivos atualizados
Indica quantos commits foram recebidos
Se houver conflitos:
Lista os arquivos com conflitos
Fornece instruções básicas sobre como resolver conflitos
Sugere usar a análise profunda para examinar as alterações
Mostra o status atualizado do repositório após o pull
9. Gerenciamento de Branches
Propósito: Fornece ferramentas para criar, alternar e excluir branches.

O que faz:

Mostra seu branch atual e uma lista de branches locais
Oferece opções para criar, alternar para ou excluir branches
Como usar:

Selecione a opção 9 no menu principal
Você verá uma lista de todos os branches locais, com o branch atual destacado
Escolha uma das opções do submenu de gerenciamento de branches:
1. Criar novo branch
Digite o nome do novo branch
O script criará o branch e alternará para ele automaticamente
Confirmará que você está agora no novo branch
2. Alternar para branch
Digite o nome do branch existente para o qual deseja alternar
O script alternará para o branch especificado
Mostrará o status atualizado do branch
3. Excluir branch
Digite o nome do branch que deseja excluir
Se o branch estiver totalmente mesclado, será excluído imediatamente
Se não estiver totalmente mesclado, o script perguntará se deseja forçar a exclusão
Nota: Você não pode excluir o branch atual
4. Retornar ao menu principal
Volta para o menu principal
Quando usar: Quando você precisa gerenciar seus branches Git.

Detalhamento do processo de gerenciamento de branches:

Ao entrar no submenu, o script lista todos os branches locais

Para criar um novo branch:

O script executa git checkout -b <nome-do-branch>
Verifica se a criação foi bem-sucedida
Mostra status atualizado
Para alternar para um branch:

O script executa git checkout <nome-do-branch>
Mostra status do branch após a troca
Lista arquivos modificados no novo branch
Para excluir um branch:

Verifica se não é o branch atual
Tenta excluir com git branch -d <nome-do-branch>
Se falhar devido a alterações não mescladas:
Alerta sobre o risco de perda de commits
Oferece opção de exclusão forçada com -D
0. Sair
Propósito: Sai do script.

O que faz:

Encerra a execução do script com uma mensagem de despedida
Como usar:

Selecione a opção 0 no menu principal
O script terminará imediatamente
Quando usar: Quando você terminou de usar a ferramenta de fluxo de trabalho git inteligente.

Análise Inteligente de Commits
A geração inteligente de mensagens de commit é um dos principais recursos deste script. Ele analisa suas alterações e gera mensagens de commit que seguem o formato Conventional Commits:

tipo(escopo): assunto

Tipos de Commit
feat: Um novo recurso
fix: Correção de bug
docs: Alterações na documentação
style: Alterações que não afetam o significado do código (formatação, etc.)
refactor: Alterações de código que não corrigem bugs nem adicionam recursos
perf: Melhorias de desempenho
test: Adição ou correção de testes
chore: Tarefas de manutenção
Como Funciona a Análise
Análise de Arquivos

Conta o número de arquivos alterados
Identifica tipos de arquivo com base nas extensões
Determina os diretórios afetados
Exemplo: Detecta que você alterou 3 arquivos .js no diretório src/components/
Detecção do Tipo de Alteração

Detecta se arquivos foram adicionados, modificados ou excluídos
Procura por palavras-chave nos diffs para determinar o tipo de alteração
Exemplo: Se encontrar palavras como "fix", "bug", "error", classificará como fix
Determinação do Escopo

Usa nomes de diretórios para o escopo
Recorre a escopos comuns como "docs", "tests", "deps" com base nos arquivos
Exemplo: Se as alterações estão principalmente em src/auth/, usará "auth" como escopo
Geração do Assunto

Cria uma descrição concisa das alterações
Torna-se mais específico quando menos arquivos são alterados
Generaliza para alterações em vários arquivos
Exemplo: Para um único arquivo modificado, pode gerar "melhorar validação de formulário"
Exemplos de Mensagens de Commit
feat(auth): adicionar funcionalidade de login
fix(api): corrigir formato de resposta
docs(readme): atualizar seção de instalação
refactor(utils): melhorar tratamento de erros
style(css): formatar de acordo com guia de estilo
Como a Detecção Funciona em Detalhes
Para alterações em um único arquivo:

O script examina o nome do arquivo e o conteúdo das alterações
Se for um arquivo login.js com novos métodos, pode sugerir: feat(auth): implementar autenticação de usuário
Para múltiplos arquivos relacionados:

Procura um tema comum nas alterações
Se detectar arquivos de teste sendo adicionados, pode sugerir: test(core): adicionar testes unitários para módulos principais
Para correções de bugs:

Procura palavras-chave como "fix", "bug", "issue" no diff
Verifica se há padrões de código típicos de correção de bugs
Pode sugerir: fix(validação): corrigir erro em entrada de dados numéricos
Análise Profunda de Conteúdo
A análise profunda de conteúdo fornece informações específicas da linguagem sobre suas alterações de código.

Suporte a Linguagens
O script fornece análise especializada para:

JavaScript/TypeScript
Adições/remoções de funções
Alterações de componentes (React)
Detecção de hooks React
Identificação de alterações em importações/exportações
Python
Adições/remoções de funções
Adições/remoções de classes
Detecção de alterações em importações
Identificação de decorators
Go
Adições/remoções de funções
Detecção de alterações em estruturas
Identificação de interfaces modificadas
Java/Kotlin
Adições/remoções de classes
Adições/remoções de métodos
Detecção de alterações em interfaces/classes abstratas
PHP
Adições/remoções de funções
Adições/remoções de classes
Detecção de alterações em namespaces
HTML/CSS/SCSS
Alterações de seletores
Detecção de novos componentes UI
Identificação de alterações em media queries
Documentação (Markdown/Text)
Alterações de cabeçalho de seção
Detecção de adições/remoções de listas
Identificação de alterações em tabelas
Métricas de Análise
Para cada arquivo, a análise mostra:

Linhas adicionadas e removidas
Elementos específicos da linguagem adicionados/removidos
Palavras-chave importantes detectadas (TODO, FIXME, BUG, etc.)
Exemplos de Uso
Revisão de Código:

Usando a opção 2 (Análise Profunda), você pode rapidamente entender o que foi modificado
Exemplo: "O arquivo UserService.js teve 3 funções adicionadas relacionadas à validação"
Notas de Versão:

Use a análise profunda para gerar informações detalhadas sobre as alterações
Exemplo: "Esta versão atualiza o sistema de validação de formulários com 3 novas verificações"
Documentação:

Acompanhe quais funcionalidades foram alteradas
Exemplo: "O componente de login agora suporta autenticação de dois fatores"
Antes de um Commit Grande:

Verifique se há alterações não intencionais ou esquecidas
Identifique possíveis problemas antes de fazer commit
Processo Detalhado de Análise Profunda
Análise por Arquivo:

O script analisa cada arquivo individualmente
Identifica a linguagem com base na extensão
Aplica analisadores específicos para cada linguagem
Contagem de Alterações:

Conta linhas adicionadas e removidas
Identifica padrões específicos de linguagem (funções, classes, etc.)
Detecção de Padrões:

Procura estruturas de código importantes
Identifica palavras-chave e comentários significativos
Resumo e Relatório:

Apresenta os resultados em um formato fácil de ler
Destaca as alterações mais significativas
Fornece estatísticas resumidas
Gerenciamento de Arquivos
Preparando Alterações (Staging)
Alterações preparadas (staged) são arquivos que foram marcados para inclusão no próximo commit. O script fornece várias maneiras de gerenciar alterações preparadas:

Preparar Todas as Alterações (Opção 3)

Usa git add .
Inclui todos os arquivos modificados e não rastreados
Processo detalhado:
O script executa git add .
Verifica se há arquivos muito grandes ou problemáticos
Lista todos os arquivos que foram preparados
Indica quais são novos, modificados ou excluídos
Preparar Arquivos Específicos (Opção 4)

Usa git add <arquivo1> <arquivo2> ...
Prepara apenas os arquivos especificados
Processo detalhado:
Você fornece uma lista de arquivos separados por espaços
O script executa git add para cada arquivo
Verifica se cada arquivo foi preparado corretamente
Mostra um resumo dos arquivos preparados
Remover Arquivos da Área de Preparação (Opção 5)

Usa git reset HEAD <arquivo1> <arquivo2> ...
Remove arquivos da área de preparação
Processo detalhado:
Você fornece uma lista de arquivos para remover
O script executa git reset HEAD para cada arquivo
Confirma que os arquivos foram removidos da área de preparação
Mostra o status atualizado
Melhores Práticas para Gerenciamento de Arquivos
Preparar Alterações Relacionadas

Agrupe alterações que fazem parte da mesma funcionalidade ou correção
Exemplo: Se você corrigiu um bug em vários arquivos, prepare-os juntos
Revisar Antes de Preparar

Use git diff (ou a opção 2 do script) para revisar alterações antes de preparar
Garanta que não haja depurações ou código temporário
Preparar Incrementalmente

Para conjuntos grandes de alterações, prepare e faça commit em partes lógicas
Use a opção 4 para selecionar arquivos específicos
Verificar o que Foi Preparado

Após preparar, verifique o status para confirmar que os arquivos corretos estão preparados
Use a análise profunda (opção 2) para verificar em detalhes
Exemplos de Cenários
Desenvolvimento de Funcionalidade Nova

Inicie um branch novo (opção 9 → 1)
Desenvolva a funcionalidade
Prepare todos os arquivos (opção 3)
Analise as alterações (opção 2)
Faça commit com mensagem inteligente (opção 6)
Correção de Bug Complexo

Identifique todos os arquivos afetados
Faça as correções necessárias
Prepare apenas os arquivos relacionados à correção (opção 4)
Analise as alterações em profundidade (opção 2)
Faça commit com uma mensagem descritiva (opção 6)
Atualização de Documentação

Edite os arquivos de documentação
Prepare especificamente os arquivos .md ou de documentação (opção 4)
Use a análise inteligente para gerar uma mensagem apropriada (opção 1)
Faça commit e envie as alterações (opções 6 → y)
Gerenciamento de Branches
Ações Disponíveis no Menu de Branches (Opção 9)
Criar Novo Branch

Cria e alterna para um novo branch
Comando equivalente: git checkout -b <nome-do-branch>
Processo detalhado:
Digite o nome desejado para o novo branch
O script verifica se o nome é válido
Cria o branch e alterna automaticamente para ele
Confirma que você está agora no novo branch
Mostra o status inicial do branch
Alternar para Branch

Muda para um branch existente
Comando equivalente: git checkout <nome-do-branch>
Processo detalhado:
Digite o nome do branch para o qual deseja alternar
O script verifica se o branch existe
Alterna para o branch especificado
Mostra o status do branch, incluindo sua relação com o remoto
Lista quaisquer arquivos modificados no novo branch
Excluir Branch

Remove um branch
Comando equivalente: git branch -d <nome-do-branch> ou git branch -D <nome-do-branch> para exclusão forçada
Processo detalhado:
Digite o nome do branch que deseja excluir
O script verifica se não é o branch atual
Tenta excluir o branch com -d (exclusão segura)
Se o branch não estiver totalmente mesclado:
Mostra um aviso sobre possível perda de commits
Pergunta se deseja fazer uma exclusão forçada com -D
Confirma a exclusão ou cancelamento
Retornar ao Menu Principal

Volta para o menu principal do script
Processo detalhado:
Selecione esta opção para sair do submenu de branches
Retorna ao menu principal com todas as opções
Estratégias Recomendadas para Branches
Branch para Cada Funcionalidade

Crie um novo branch para cada funcionalidade ou correção
Use nomes descritivos como feature/login-redesign ou fix/validation-error
Passos:
Use a opção 9 → 1 para criar um novo branch
Nomeie de forma descritiva (ex: feature/novo-login)
Desenvolva a funcionalidade
Faça commits frequentes
Sincronizar com o Branch Principal

Mantenha seu branch atualizado com as alterações do branch principal
Passos:
Alterne para o branch principal (ex: main ou master) usando 9 → 2
Puxe as alterações recentes usando a opção 8
Volte para seu branch de trabalho usando 9 → 2
Mescle as alterações do branch principal
Limpar Branches Após Mesclar

Exclua branches após serem mesclados ao branch principal
Passos:
Confirme que o branch foi mesclado ao branch principal
Alterne para outro branch (geralmente o principal)
Use a opção 9 → 3 para excluir o branch mesclado
Exemplos Práticos de Fluxo de Trabalho com Branches
Desenvolvendo uma Nova Funcionalidade

1. Opção 8 → Puxar alterações recentes
2. Opção 9 → 1 → Criar branch "feature/nova-funcionalidade"
3. [Desenvolver a funcionalidade]
4. Opção 3 → Preparar todas as alterações
5. Opção 6 → Commit com mensagem inteligente
6. Opção 7 → Enviar alterações

Corrigindo um Bug Urgente

1. Opção 9 → 1 → Criar branch "hotfix/bug-critico"
2. [Fazer as correções necessárias]
3. Opção 4 → Preparar arquivos específicos relacionados ao bug
4. Opção 2 → Analisar alterações em profundidade
5. Opção 6 → Commit com mensagem detalhando a correção
6. Opção 7 → Enviar alterações imediatamente

Recursos Avançados
Visualização de Status
O script fornece visualização aprimorada de status em comparação com a saída padrão do Git:

Status com código de cores
Informações do branch com contagem de commits à frente/atrás
Arquivos modificados, adicionados e excluídos claramente marcados
Resumo estatístico das alterações
Exemplo de visualização de status:

Status Atual do Git:
------------------
Branch atual: feature/new-login
Rastreamento remoto: origin/feature/new-login
Seu branch está à frente por 2 commit(s)

Arquivos modificados:
  Modificado: src/components/Login.js
  Modificado (não preparado): src/utils/validation.js
  Adicionado: src/styles/login.css
  Não rastreado: src/components/LoginButton.js

Análise Pré-commit
Antes de fazer commit, o script verifica potenciais problemas:

Detecção de arquivos grandes

Arquivos com muitas alterações que podem ser divididos
Exemplo: "Aviso: Arquivo grande detectado: src/generated-code.js"
Verificação de espaços em branco no final das linhas

Identifica problemas comuns de formatação
Exemplo: "Aviso: Espaços em branco no final das linhas detectados"
Verificação de marcadores de conflito

Procura por <<<<<<<, =======, >>>>>>> indicando conflitos não resolvidos
Exemplo: "Erro: Marcadores de conflito detectados nos arquivos"
Estatísticas de tipos de arquivo

Mostra quais tipos de arquivo foram mais alterados
Exemplo: "Alterações: 5 arquivos .js, 2 arquivos .css, 1 arquivo .md"
Como Usar os Recursos Avançados:
Status Aprimorado

Visível sempre que o menu principal é exibido
Fornece um resumo rápido do estado do repositório
Análise Pré-commit

Executada automaticamente como parte do processo de commit
Também disponível como parte da opção 1 (Análise Inteligente)
Análise Profunda Específica para Linguagem

Use a opção 2 para obter análise detalhada do código
Particularmente útil antes de enviar pull requests
Exemplos de Cenários para Recursos Avançados:
Preparando um Pull Request

Use a opção 2 para análise profunda
Verifique por problemas com a opção 1
Commit com mensagem bem estruturada usando opção 6
Revisão de Código

Puxe alterações recentes com opção 8
Use opção 2 para entender as alterações recentes
Identifique áreas que precisam de atenção
Manutenção de Repositório

Gerenciamento de branches com opção 9
Análise do histórico de commits recentes
Limpeza de branches desnecessários
Solução de Problemas
Problemas Comuns e Soluções
Script não executa

Problema: Permissão negada ao tentar executar o script
Solução:
chmod +x smart-git-workflow.sh

Explicação: Este comando adiciona permissão de execução ao script
Erro "bash: não encontrado"

Problema: O bash não está instalado ou não está na PATH
Solução:

# No Debian/Ubuntu
sudo apt-get install bash

# No CentOS/RHEL
sudo yum install bash

# No macOS (geralmente já instalado)
brew install bash

Explicação: O script requer o shell bash para funcionar
Nenhum repositório Git detectado

Problema: O script deve ser executado dentro de um repositório Git
Solução:
# Navegar até um repositório Git existente
cd /caminho/para/seu/repositorio

# Ou inicializar um novo repositório
git init

Explicação: O script usa comandos Git que precisam ser executados dentro de um repositório
Não é possível gerar mensagem de commit

Problema: Sem alterações preparadas
Solução:
# Preparar alguns arquivos primeiro
git add <arquivos>

# Ou usar a opção 3 no script para preparar todas as alterações
Explicação: O script precisa de alterações preparadas para analisar e gerar uma mensagem
Falha no push

Problema: Não consegue enviar alterações para o repositório remoto
Solução:
# Verificar configuração do repositório remoto
git remote -v

# Configurar o remoto se necessário
git remote add origin https://github.com/usuario/repositorio.git

Explicação: O remoto pode não estar configurado ou você pode não ter permissão
Códigos de cores não aparecem corretamente

Problema: Terminal não exibe cores ANSI
Solução:
# No .bashrc ou .zshrc
export TERM=xterm-256color

# Ou atualize seu terminal/emulador de terminal

Explicação: Alguns terminais não suportam cores ANSI ou precisam de configuração adicional
Verificações Passo a Passo
Quando encontrar problemas, siga estas etapas para diagnosticar e resolver:

Verificar se Git está instalado
git --version

Se não estiver instalado, instale-o seguindo as instruções para seu sistema operacional

Verificar se está em um repositório Git
git status

Se não estiver em um repositório, você verá um erro

Verificar permissões do script

ls -l smart-git-workflow.sh
Verifique se o script tem permissão de execução (x)

Verificar a configuração do Git
git config --list

Verifique se user.name e user.email estão configurados

Testar comandos Git básicos
git status
git branch

Se estes comandos funcionarem, o Git está configurado corretamente

Mensagens de Erro Específicas
Erro: Git não está instalado ou não está na PATH - Instale Git ou adicione-o ao seu PATH
Erro: Não está dentro de um repositório Git - Navegue até um repositório Git ou inicialize um
Erro: A mensagem de commit não pode estar vazia - Forneça uma mensagem de commit
Erro: Não foi possível acessar o repositório remoto - Verifique sua conexão e configuração remota
Erro: Marcadores de conflito detectados - Resolva os conflitos de merge antes de continuar
Erro: Branch não existe - Verifique o nome do branch e tente novamente
Dicas e Melhores Práticas
Fluxo de Trabalho Git Eficiente
Puxar antes de começar a trabalhar

Sempre obtenha as alterações mais recentes antes de começar a trabalhar
Como fazer:
Use a opção 8 no menu principal
Verifique se há conflitos antes de começar a trabalhar
Mantenha-se sincronizado com o repositório remoto
Criar branches para funcionalidades

Trabalhe em funcionalidades em branches dedicados
Mantenha os branches focados em funcionalidades ou correções únicas
Como fazer:
Use a opção 9 → 1 para criar um novo branch
Nomeie descritivamente, como feature/nome-funcionalidade ou fix/nome-problema
Trabalhe exclusivamente na funcionalidade designada nesse branch
Fazer commits com frequência

Faça commits pequenos e focados em vez de grandes alterações
Use o gerador de mensagem inteligente para mensagens de commit consistentes
Como fazer:
Faça commits pequenos e lógicos
Use a opção 6 para gerar mensagens significativas
Evite misturar alterações não relacionadas no mesmo commit
Escrever mensagens de commit descritivas

Mesmo com sugestões automatizadas, revise a mensagem
Garanta que ela descreva com precisão suas alterações
Como fazer:
Use a opção 1 para gerar sugestões
Escolha 'e' na opção 6 para editar quando necessário
Mantenha-se no formato tipo(escopo): assunto para consistência
Revisar antes de fazer commit

Use a análise profunda para entender suas alterações
Verifique se há problemas antes de finalizar commits
Como fazer:
Use a opção 2 para análise profunda
Verifique por TODOs, FIXMEs ou bugs óbvios
Certifique-se de que todas as alterações são intencionais
Enviar regularmente

Não mantenha alterações localmente por muito tempo
Como fazer:
Use a opção 7 para enviar após commits importantes
Mantenha seu repositório remoto atualizado
Facilita a colaboração e o backup do seu trabalho
Fluxos de Trabalho Comuns
1. Desenvolvimento de Nova Funcionalidade

1. Puxar alterações recentes (opção 8)
2. Criar novo branch (opção 9 → 1) → "feature/nova-funcionalidade"
3. [Desenvolver a funcionalidade]
4. Verificar status regularmente (visível no menu principal)
5. Fazer análise profunda (opção 2)
6. Preparar alterações (opção 3 ou 4)
7. Gerar mensagem de commit inteligente (opção 6)
8. Enviar alterações (opção 7)
9. [Quando finalizado] Criar pull request (externo ao script)

2. Correção de Bug

1. Puxar alterações recentes (opção 8)
2. Criar novo branch (opção 9 → 1) → "fix/descricao-do-bug"
3. [Implementar correção]
4. Testar a correção localmente
5. Analisar alterações em profundidade (opção 2)
6. Preparar arquivos específicos (opção 4)
7. Commit com mensagem detalhada (opção 6)
8. Enviar alterações (opção 7)

3. Refatoração de Código
1. Puxar alterações recentes (opção 8)
2. Criar novo branch (opção 9 → 1) → "refactor/area-do-codigo"
3. [Refatorar código]
4. Fazer análise profunda (opção 2) para verificar impacto
5. Fazer commits incrementais para cada parte lógica:
   - Preparar parte relacionada (opção 4)
   - Commit com descrição específica (opção 6)
6. Enviar alterações (opção 7)

Organização de Commits
Commits Atômicos

Cada commit deve representar uma alteração lógica única
Evite commits com mensagens como "várias correções"
Agrupe Por Funcionalidade

Mantenha alterações relacionadas juntas no mesmo commit
Separe alterações não relacionadas em commits diferentes
Sequência Lógica

Organize seus commits em uma sequência que conte uma história
Facilita revisões e entendimento das alterações
Use a Análise Inteligente

Aproveite a opção 1 para entender melhor suas alterações
Use isso para planejar como dividir suas alterações em commits
Perguntas Frequentes
P: Posso usar este script com qualquer repositório Git?
R: Sim, o script funciona com qualquer repositório Git, independentemente do tipo de projeto ou plataforma de hospedagem.

P: O script modifica minha configuração do Git?
R: Não, o script apenas executa operações padrão do Git e não modifica sua configuração do Git.

P: O script substituirá minhas mensagens de commit?
R: Não, o script sugere mensagens de commit, mas sempre dá a opção de editar ou fornecer a sua própria mensagem.

P: Posso usar isto em um cliente Git com interface gráfica?
R: O script foi projetado para uso no terminal. Clientes Git com interface gráfica podem ter seus próprios recursos de geração de mensagem de commit.

P: O script envia dados para servidores externos?
R: Não, todas as operações são realizadas localmente. Nenhum dado é enviado para servidores externos.

P: Quão precisa é a geração inteligente de mensagens de commit?
R: A precisão depende da natureza das suas alterações. Funciona melhor com alterações claras e focadas. Sempre revise as sugestões antes de aceitá-las.

P: Posso personalizar o formato da mensagem de commit?
R: Atualmente, o script usa o formato Conventional Commits. Versões futuras podem incluir opções de personalização.

P: O script suporta GitFlow ou outros fluxos de trabalho?
R: O script é agnóstico quanto ao fluxo de trabalho, mas pode ser usado dentro de qualquer fluxo de trabalho como GitFlow, GitHub Flow ou outros.

P: Posso usar o script em pipelines de CI/CD?
R: O script foi projetado para uso interativo e pode não ser adequado para pipelines de CI/CD automatizados.

P: O que fazer se eu não concordar com a mensagem de commit sugerida?
R: Você pode sempre escolher 'e' para editar a sugestão ou 'n' para escrever sua própria mensagem quando solicitado durante o processo de commit.

P: O script funciona com submodules Git?
R: Sim, o script funciona com repositórios que contêm submodules, mas analisa apenas as alterações no repositório principal.

P: Como o script lida com branches protegidos?
R: O script usa comandos Git padrão, então ele respeitará as proteções de branch configuradas no servidor Git. Se você não puder enviar diretamente para um branch protegido, o script também não poderá.

P: O script requer conexão com a Internet?
R: Uma conexão com a Internet é necessária apenas para operações pull e push. Todas as outras funcionalidades funcionam offline.

Suporte e Contribuição
Reportando Problemas
Se você encontrar bugs ou tiver sugestões para melhorias, por favor, reporte-os via:

GitHub Issues: https://github.com/StrateUpCompany/smart-git-workflow/issues
Email: suporte@strateupcompany.com
Como Contribuir
Contribuições são bem-vindas! Sinta-se à vontade para fazer fork do repositório e enviar pull requests.

Faça um fork do repositório
Crie um branch de funcionalidade
Faça suas alterações
Envie um pull request
Licença
Este script é licenciado sob a Licença MIT. Consulte o arquivo LICENSE para mais informações.

© 2025 StrateUpCompany. Todos os direitos reservados.


Também criei uma versão resumida como cartão de referência rápida:

```markdown name=REFERENCIA-RAPIDA.md
# Fluxo de Trabalho Git Inteligente - Cartão de Referência Rápida

## Instalação

```bash
chmod +x smart-git-workflow.sh
./smart-git-workflow.sh

Comandos Principais
Opção	Descrição	Quando Usar
1	Analisar alterações de forma inteligente	Para obter uma mensagem de commit sugerida com base em suas alterações
2	Análise profunda de conteúdo	Para obter análise detalhada específica da linguagem de suas alterações
3	Preparar todas as alterações	Para adicionar todos os arquivos modificados à área de preparação
4	Preparar arquivos específicos	Para selecionar arquivos específicos para preparar
5	Remover arquivos da área de preparação	Para remover arquivos da área de preparação
6	Commit com mensagem inteligente	Para fazer commit usando uma mensagem gerada automaticamente
7	Enviar commits	Para enviar seus commits para o repositório remoto
8	Puxar alterações recentes	Para atualizar seu repositório local com alterações remotas
9	Gerenciamento de branches	Para criar, alternar ou excluir branches
0	Sair	Para sair do script
Mensagens de Commit Inteligentes
Formato: tipo(escopo): assunto

Tipos:

feat: Novo recurso
fix: Correção de bug
docs: Documentação
style: Formatação
refactor: Reestruturação de código
perf: Desempenho
test: Testes
chore: Manutenção
Gerenciamento de Branches
Opção	Descrição
1	Criar novo branch
2	Alternar para branch
3	Excluir branch
4	Retornar ao menu principal
Fluxos de Trabalho Comuns
Desenvolvimento de Funcionalidade
Puxar alterações recentes (8)
Criar novo branch (9→1)
Fazer alterações
Preparar alterações (3 ou 4)
Analisar alterações (1)
Fazer commit das alterações (6)
Enviar alterações (7)
Correção de Bug
Puxar alterações recentes (8)
Fazer correções
Preparar alterações (3 ou 4)
Análise profunda (2)
Commit com mensagem inteligente (6)
Enviar alterações (7)
© 2025 StrateUpCompany

Este manual do usuário em português brasileiro fornece instruções detalhadas para cada opção do script de fluxo de trabalho Git inteligente. Inclui explicações completas de cada função, exemplos de uso, dicas de solução de problemas e melhores práticas para utilização eficiente.

A documentação é abrangente e cobre todos os aspectos do script, incluindo todas as opções do menu principal com instruções passo a passo detalhadas para cada funcionalidade. Também incluí um cartão de referência rápida para consulta fácil.