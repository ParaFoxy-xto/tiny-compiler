#include "semantic.h"
#include "symbol_table.h"
#include <stdio.h>
#include <string.h>

static int semantic_error_flag = 0;

void semantic_set_error(void) {
    semantic_error_flag = 1;
}

int semantic_had_error(void) {
    return semantic_error_flag;
}

void semantic_init(void) {
    symbol_count = 0;
    semantic_error_flag = 0;
}

int semantic_declare_var(const char* name, int lineno) {
    int result = add_symbol(name, TYPE_INT); // Por padrão, inteiro
    if (result == 0) {
        printf("Erro semântico (linha %d): variável '%s' já declarada.\n", lineno, name);
        semantic_set_error();
        return 0;
    } else if (result == -1) {
        printf("Erro semântico (linha %d): tabela de símbolos cheia.\n", lineno);
        semantic_set_error();
        return 0;
    }
    return 1;
}

int semantic_check_var(const char* name, int lineno) {
    int idx = find_symbol(name);
    if (idx == -1) {
        printf("Erro semântico (linha %d): variável '%s' não declarada.\n", lineno, name);
        semantic_set_error();
        return 0;
    }
    return 1;
}

void semantic_print_table(void) {
    print_symbol_table();
}

int semantic_get_var_type(const char* name) {
    int idx = find_symbol(name);
    if (idx == -1) return TYPE_VOID;
    return symbol_table[idx].type;
}