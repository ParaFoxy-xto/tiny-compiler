#include "codegen.h"
#include <stdio.h>

void gen_assign(int address) {
    printf("ST 0, %d(0) ; Store result to address %d\n", address, address);
}

void gen_while() {
    printf("; WHILE loop code generation stub\n");
}

void gen_neg() {
    printf("NEG 0, 0, 0 ; Negate top of stack\n");
}

void gen_op(const char* op) {
    if (op) printf("%s 0, 0, 1 ; Binary operation\n", op);
}

void gen_num(int value) {
    printf("LDC 0, %d(0) ; Load constant %d\n", value, value);
}

void gen_id(int address) {
    printf("LD 0, %d(0) ; Load variable at address %d\n", address, address);
} 