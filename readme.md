# Compilador Tiny

Um compilador simples para a linguagem Tiny, com análise léxica, sintática e semântica.

## Requisitos

- MSYS2 (no Windows)
- flex
- bison
- gcc
- make

## Como compilar

Abra o terminal MSYS2 MinGW 64-bit e execute:

```sh
make
```

## Como executar

Para compilar um programa Tiny:

```sh
./tiny_compiler teste_valido.tiny
```

Ou, para rodar todos os testes:

```sh
./testar_todos.sh
```

## Como limpar

Para remover todos os arquivos gerados:

```sh
make clean
```

## Observações

- Todo o código-fonte está na pasta `Analisador-Lexico`.
- Os arquivos de teste estão no diretório principal.

---

## Estrutura do Projeto

- `1 - Analisador Léxico/`
  - `lexico_v1.1.l` — Especificação do analisador léxico (Flex)
  - `symbol_table.h`, `symbol_table.c` — Tabela de símbolos (análise semântica)
  - `semantic.h`, `semantic.c` — Analisador semântico (checagem de declaração, uso e tipo de variáveis)
  - `codegen.h`, `codegen.c` — Geração de código para a Tiny Machine
- `simple.y` — Analisador sintático (Bison/Yacc) com ações semânticas e geração de código
- `readme.md` — Documentação do projeto
- `legacy/` — Arquivos antigos ou não utilizados
- `teste_*.tiny` — Exemplos de código Tiny para teste
- `testar_todos.sh` — Script para testar todos os exemplos automaticamente (Linux/WSL)

---

## Como Compilar e Executar

### Dependências

Você precisa ter instalados:
- **Flex** (ou WinFlexBison no Windows)
- **Bison**
- **GCC** (compilador C)
- **Make** (ou `mingw32-make` no Windows)

#### Linux (Ubuntu/Debian)
```sh
sudo apt update
sudo apt install build-essential flex bison
```

#### Windows
- Baixe e instale:
  - [WinFlexBison](https://github.com/lexxmark/winflexbison/releases) (coloque `win_flex.exe` e `win_bison.exe` em uma pasta no PATH)
  - [MinGW-w64](https://www.mingw-w64.org/) (adicione o `bin` ao PATH)
  - [Make para Windows](http://gnuwin32.sourceforge.net/packages/make.htm) ou use o `mingw32-make` que vem com o MinGW

---

### Compilando o Projeto

#### Linux
```sh
make
```

#### Windows
Se estiver usando o `mingw32-make`:
```sh
mingw32-make
```
Ou, se o comando for apenas `make`:
```sh
make
```

**Compilação manual (ordem correta):**
```sh
bison -d simple.y
flex "1 - Analisador Léxico/lexico_v1.1.l"
gcc -I"1 - Analisador Léxico" -Wall -Wextra simple.tab.c lex.yy.c \
  1\ -\ Analisador\ Léxico/symbol_table.c 1\ -\ Analisador\ Léxico/codegen.c 1\ -\ Analisador\ Léxico/semantic.c \
  -o tiny_compiler
```

---

### Executando o Compilador

Após compilar, execute:
```sh
./tiny_compiler
```
No Windows, pode ser:
```sh
tiny_compiler.exe
```

O compilador irá ler o código Tiny da entrada padrão.

---

### Limpando os Arquivos Gerados

#### Linux
```sh
make clean
```

#### Windows
```sh
mingw32-make clean
```
Ou
```sh
make clean
```

---

## Testes Automáticos

Vários exemplos de código Tiny estão disponíveis nos arquivos `teste_*.tiny`.

Para testar todos automaticamente no **Linux** ou **WSL**:
1. Dê permissão de execução ao script:
   ```sh
   chmod +x testar_todos.sh
   ```
2. Execute:
   ```sh
   ./testar_todos.sh
   ```

O script irá rodar o compilador para cada arquivo de teste e mostrar o resultado na tela.

**No Windows:**
- Você pode rodar cada teste manualmente:
  ```sh
  tiny_compiler.exe < teste_valido.tiny
  ```


---


### Compilando manualmente (exemplo)

```bash
bison -d simple.y
flex "1 - Analisador Léxico/lexico_v1.1.l"
gcc -I"1 - Analisador Léxico" -Wall -Wextra simple.tab.c lex.yy.c 1 - Analisador Léxico/symbol_table.c 1 - Analisador Léxico/codegen.c 1 - Analisador Léxico/semantic.c -o tiny_compiler
```

### Usando no Linux

- Entre um token por vez ou todos de uma vez e aperte ENTER;
- No final, CTRL + D no Linux para sinalizar o final do arquivo;
- ENTER de novo

### Testes Positivos

```
while x do y end
while x do while y do z end end
while x do while y do while z do w end end end
while x < 10 do y end
while (x + 1) * 2 < 100 do while z = 1 do w end end
while x < y do while y < z do x end end
```

---

