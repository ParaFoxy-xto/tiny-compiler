#ifndef SEMANTIC_H
#define SEMANTIC_H

// Inicializa o analisador semântico (zera a tabela de símbolos)
void semantic_init(void);

// Tenta declarar uma variável, retorna 0 se já existe, 1 se sucesso
int semantic_declare_var(const char* name, int lineno);

// Verifica se variável foi declarada, retorna 1 se sim, 0 se não
int semantic_check_var(const char* name, int lineno);

// Retorna o tipo da variável (TYPE_INT, TYPE_BOOL, TYPE_VOID)
int semantic_get_var_type(const char* name);

// Imprime tabela de símbolos (debug)
void semantic_print_table(void);

// Flag de erro semântico
typedef enum { SEM_OK = 0, SEM_ERROR = 1 } SemanticStatus;
void semantic_set_error(void);
int semantic_had_error(void);

#endif