#include "codegen.h"
#include <stdio.h>
#include <string.h>

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

void gen_relop(const char* op) {
    // A real implementation would handle jump logic based on the comparison
    if (strcmp(op, "<") == 0) {
        printf("TLT 0, 0, 1 ; Test less than\n");
    } else if (strcmp(op, ">") == 0) {
        printf("TGT 0, 0, 1 ; Test greater than\n");
    } else if (strcmp(op, "=") == 0) {
        printf("TEQ 0, 0, 1 ; Test equal\n");
    } else if (strcmp(op, "<>") == 0) {
        printf("TNE 0, 0, 1 ; Test not equal\n");
    }
    printf("; Relational op %s\n", op);
}

void gen_if() {
    printf("; IF statement code generation stub\n");
}
