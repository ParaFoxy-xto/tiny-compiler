#include "symbol_table.h"
#include <string.h>
#include <stdio.h>

Symbol symbol_table[MAX_SYMBOLS];
int symbol_count = 0;

int add_symbol(const char* name, int type) {
    if (find_symbol(name) != -1) return 0; // Already exists
    if (symbol_count >= MAX_SYMBOLS) return -1;
    strcpy(symbol_table[symbol_count].name, name);
    symbol_table[symbol_count].type = type;
    symbol_table[symbol_count].address = symbol_count; // Simple address assignment
    symbol_count++;
    return 1;
}

int find_symbol(const char* name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0)
            return i;
    }
    return -1;
}

void print_symbol_table() {
    printf("Symbol Table:\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%s (type: %d, address: %d)\n", symbol_table[i].name, symbol_table[i].type, symbol_table[i].address);
    }
} 