# TaskMaster - Calendário Acadêmico e Gerenciador de Tarefas

O TaskMaster é um aplicativo mobile desenvolvido em Flutter que combina autenticação de usuários, navegação por calendário temporal e gerenciamento dinâmico de tarefas diárias. O projeto foi construído focando em uma interface criativa de alto contraste, performance de memória e regras estritas de ordenação de dados.

---

## Funcionalidades Principais

* **Autenticação Local Adaptativa:** Sistema integrado de Login e Cadastro que gerencia usuários dinamicamente em memória, validando credenciais com tratamento de exceções.
* **Interface Dinâmica:** Saudação personalizada na tela principal com o nome fornecido pelo usuário durante o fluxo de cadastro.
* **Filtro por Calendário:** Navegação temporal intuitiva baseada no componente `CalendarDatePicker`, permitindo isolar as tarefas de cada dia específico.
* **CRUD de Tarefas:** Adição de novos afazeres via caixas de diálogo (`showDialog`), marcação de conclusão em tempo real (`Checkbox`) e exclusão de itens.
* **Pipeline de Ordenação Estrita:** Exibição inteligente que posiciona tarefas pendentes no topo e concluídas abaixo, aplicando ordenação alfabética case-insensitive individual em ambos os blocos.

---

## Identidade Visual e Layout

Afastando-se dos layouts genéricos de mercado, o aplicativo utiliza uma paleta de cores vibrantes com temática *Dark Modern*:
* **Fundo:** Amethyst Black (`#120E2B`) e Deep Purple (`#251545`) em gradiente.
* **Destaques e Botões:** Neon Pink Accent e Teal.
* **Componentes:** Cards com bordas altamente arredondadas (`BorderRadius.circular(24)`) e elevações para profundidade visual.

---

## Arquitetura e Boas Práticas Utilizadas

* **Gerenciamento de Estado Nativo:** Utilização estruturada de `StatefulWidget` e `setState` para garantir reatividade e mutação previsível dos dados locais.
* **Descarte de Recursos (Memory Leaks):** Implementação rigorosa do método `dispose()` em todos os `TextEditingController` para liberação de memória do hardware ao destruir as telas.
* **Portabilidade e Segurança:** Arquivo `.gitignore` otimizado para omitir dependências locais, credenciais e caches gerados por IDEs (VS Code/Android Studio) ou compilações nativas de plataformas.
* **Tratamento de Erros:** Estruturas `try-catch` para capturar falhas de busca e emitir feedbacks amigáveis ao usuário final via `SnackBar`.

---

## Como Executar o Projeto

### Pré-requisitos
* Flutter SDK instalado e configurado no `PATH` do sistema. 
* Extensão do Flutter/Dart ativa no VS Code ou Android Studio.
* Emulador Android ou dispositivo físico conectado.

### Passo a Passo
1. Clone este repositório para o seu computador.
2. Abra a pasta do projeto no seu editor de código (IDE).
3. Abra o terminal integrado e baixe as dependências do ecossistema Dart:
  
   ```
   bash
   flutter pub get
   ```