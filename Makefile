# Makefile for Tiny Compiler Project

# Directories
LEX_DIR =Analisador-Lexico

# Source files
LEXER = $(LEX_DIR)/lexico_v1.1.l
PARSER = simple.y
SYMTAB_SRC = $(LEX_DIR)/symbol_table.c
SYMTAB_HDR = $(LEX_DIR)/symbol_table.h
CODEGEN_SRC = $(LEX_DIR)/codegen.c
CODEGEN_HDR = $(LEX_DIR)/codegen.h
SEMANTIC_SRC = $(LEX_DIR)/semantic.c
SEMANTIC_HDR = $(LEX_DIR)/semantic.h
TAC_SRC = $(LEX_DIR)/tac.c
TAC_HDR = $(LEX_DIR)/tac.h
TM_SRC = ./TM.c

# Generated files
LEX_C = lex.yy.c
PARSER_C = simple.tab.c
PARSER_H = simple.tab.h

# Output
TARGET = tiny_compiler
TM_TARGET = TM

# Compiler and tools
CC = gcc
FLEX = flex
BISON = bison
CFLAGS = -I"$(LEX_DIR)" -Wall -Wextra

all: $(TARGET) $(TM_TARGET)

$(LEX_C): $(LEXER)
	$(FLEX) $(LEXER)

$(PARSER_C) $(PARSER_H): $(PARSER)
	$(BISON) -d $(PARSER)

$(TARGET): $(PARSER_C) $(LEX_C) $(SYMTAB_SRC) $(CODEGEN_SRC) $(LEX_DIR)/semantic.c
	$(CC) $(CFLAGS) $(PARSER_C) $(LEX_C) $(SYMTAB_SRC) $(CODEGEN_SRC) $(TAC_SRC) $(SEMANTIC_SRC) -o $(TARGET)

$(TM_TARGET): $(TM_SRC)
	$(CC) $(TM_SRC) -o $(TM_TARGET)

clean:
	rm -f $(LEX_C) $(PARSER_C) $(PARSER_H) $(TARGET) $(TM_TARGET)

.PHONY: all clean 
