# 📚 Jogo Educativo de Programação – *"CodeQuest"*

Bem-vindo ao repositório oficial do **Jogo Educativo de Programação**, um jogo feito com amor para ajudar iniciantes a aprender lógica de programação de forma divertida e interativa! 💻🎮

---

## 🎮 Sobre o Jogo

Você assume o papel de um(a) aventureiro(a) que precisa resolver desafios de lógica e programação para progredir por fases. Interaja com terminais, escreva códigos em **Lua**, e use funções para controlar elementos do ambiente como **pontes**, **portas** e muito mais!

---

## 🧠 O que você vai aprender jogando

- Lógica de programação
- Uso de estruturas como `if`, `for`, e funções
- Sintaxe da linguagem Lua
- Solução de problemas com pensamento computacional

---

## 🛠️ Tecnologias e Ferramentas

- **Engine:** [Godot 4.4](https://godotengine.org/)
- **Linguagens:** Lua e GDScript
- **Extensões:** [godot-lua-cppextension](https://github.com/gabrielLV-BR/godot-lua-cppextension) – extensão baseada em **GDExtension** para executar scripts em Lua dentro da Godot
- **Diálogos:** DialogueManager 3

---

## 💾 Como Executar

### Opção 1 – Jogo Exportado (sem precisar do Godot)

✅ **Recomendado para jogadores**

1. Baixe o arquivo `.zip` da [release](https://github.com/GustavoHerpich/CodeQuest/releases/tag/V1.0).
2. Extraia os arquivos em uma pasta.
3. Execute o arquivo `jogo.exe`.
4. Certifique-se de que o arquivo `.pck` esteja na mesma pasta que o `.exe`.

### Opção 2 – Rodando com Godot (modo desenvolvimento)

🛠️ **Recomendado para desenvolvedores ou para estudar o código-fonte**

1. Instale a [Godot 4.4](https://godotengine.org/download).
2. Clone este repositório:
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
3. Abra o projeto na Godot.
4. Execute clicando em **F5**.

> ⚠️ **Observação:** Para rodar os scripts Lua, você precisa da extensão `godot-lua-cppextension`. Ela já está incluída no projeto, mas caso queira compilar manualmente ou estudar como ela funciona, acesse:  
> [https://github.com/gabrielLV-BR/godot-lua-cppextension](https://github.com/gabrielLV-BR/godot-lua-cppextension)

---

## 📖 Como Jogar

- **WASD**: movimentar o personagem
- **E**: interagir com o terminal
- **F1**: abrir e fechar o Livro de Ajuda
- **Esc**: sair de interações

## 💻 Terminal de Comandos

Nos desafios, você interage com terminais programáveis usando a linguagem **Lua**.

Cada terminal controla algum sistema do ambiente (como pontes ou portas). Você deve escrever o código correto para resolver o puzzle e avançar.

### Exemplos de comandos:

```lua
moveBridge("down")
showPassword(4)
openDoor(123)
```

## 📘 Livro de Ajuda

Durante o jogo, pressione **F1** para abrir o Livro de Ajuda.

Este livro traz informações essenciais para resolver os desafios de programação do jogo:

- 🧠 **Programação em Lua**: exemplos de `if`, `for`, funções e lógica básica
- 🧩 **Funções dos objetos do jogo**:
  - `moveBridge(direction)` – movimenta a ponte
  - `getDoorValues()` – retorna os valores da porta
  - `showPassword(valor)` – mostra a senha se o valor for correto
  - `openDoor(senha)` – tenta abrir a porta
- 📖 **Dicas visuais** para reforçar o aprendizado e auxiliar no raciocínio lógico

Use as setas ➡️ ⬅️ no livro para navegar entre páginas.

## 🚧 Em Desenvolvimento

Este jogo está em constante evolução!
Entre as melhorias planejadas estão:
- Mais fases e mecânicas
- Novos tipos de desafios lógicos
- Expansão do conteúdo no Livro de Ajuda
- Melhorias visuais e de acessibilidade
