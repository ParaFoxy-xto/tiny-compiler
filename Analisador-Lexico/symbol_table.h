#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_SYMBOLS 100

// Tipos suportados
#define TYPE_INT 0
#define TYPE_BOOL 1
#define TYPE_VOID 2

typedef struct {
    char name[32];
    int type; // TYPE_INT, TYPE_BOOL, TYPE_VOID
    int address; // For code generation
} Symbol;

extern Symbol symbol_table[MAX_SYMBOLS];
extern int symbol_count;

int add_symbol(const char* name, int type);
int find_symbol(const char* name);
void print_symbol_table();

#endif 