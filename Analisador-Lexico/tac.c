#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"

Tac* tac_list_head = NULL;
static int temp_counter = 0;
static int label_counter = 0;

#define MAX_LABEL_STACK 100
static char* label_stack[MAX_LABEL_STACK];
static int label_stack_top = -1;

void tac_init() {
    tac_list_head = NULL;
    temp_counter = 0;
    label_counter = 0;
    label_stack_top = -1;
}

void tac_free() {
    Tac* current = tac_list_head;
    while (current != NULL) {
        Tac* to_free = current;
        current = current->next;

        free(to_free->res);
        free(to_free->arg1);
        free(to_free->arg2);
        free(to_free);
    }
    tac_list_head = NULL;

    while(label_stack_top > -1) {
        free(label_stack[label_stack_top--]);
    }
}

static char* safe_strdup(const char* s) {
    if (s == NULL) {
        return NULL;
    }
    char* new_str = malloc(strlen(s) + 1);
    if (new_str == NULL) {
        fprintf(stderr, "Error: malloc failed in safe_strdup\n");
        exit(EXIT_FAILURE);
    }
    strcpy(new_str, s);
    return new_str;
}

Tac* tac_create(TacOpCode op, const char* res, const char* arg1, const char* arg2) {
    Tac* new_tac = (Tac*)malloc(sizeof(Tac));
    if (new_tac == NULL) {
        fprintf(stderr, "Error: malloc failed for new TAC instruction\n");
        exit(EXIT_FAILURE);
    }

    new_tac->op = op;
    new_tac->res = safe_strdup(res);
    new_tac->arg1 = safe_strdup(arg1);
    new_tac->arg2 = safe_strdup(arg2);
    new_tac->next = NULL;

    if (tac_list_head == NULL) {
        tac_list_head = new_tac;
    } else {
        Tac* current = tac_list_head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_tac;
    }

    return new_tac;
}

char* tac_new_temp() {
    char buffer[16];
    sprintf(buffer, "t%d", temp_counter++);
    return safe_strdup(buffer);
}

char* tac_new_label() {
    char buffer[16];
    sprintf(buffer, "L%d", label_counter++);
    return safe_strdup(buffer);
}

void tac_print() {
    printf("\n--- Three-Address Code ---\n");
    Tac* current = tac_list_head;
    if (current == NULL) {
        printf("No TAC generated.\n");
        return;
    }

    while (current != NULL) {
        switch (current->op) {
            case TAC_OP_ASSIGN:
                printf("%s := %s\n", current->res, current->arg1);
                break;
            case TAC_OP_ADD:
                printf("%s := %s + %s\n", current->res, current->arg1, current->arg2);
                break;
            case TAC_OP_SUB:
                printf("%s := %s - %s\n", current->res, current->arg1, current->arg2);
                break;
            case TAC_OP_LT:
                printf("%s := %s < %s\n", current->res, current->arg1, current->arg2);
                break;
            case TAC_OP_GT:
                printf("%s := %s > %s\n", current->res, current->arg1, current->arg2);
                break;
            case TAC_OP_EQ:
                printf("%s := %s = %s\n", current->res, current->arg1, current->arg2);
                break;
            case TAC_OP_NEQ:
                printf("%s := %s <> %s\n", current->res, current->arg1, current->arg2);
                break;
            case TAC_OP_LABEL:
                printf("%s:\n", current->res);
                break;
            case TAC_OP_GOTO:
                printf("goto %s\n", current->res);
                break;
            case TAC_OP_IF_FALSE:
                printf("if_false %s goto %s\n", current->arg1, current->res);
                break;
            // Add other cases as you expand the language
            default:
                fprintf(stderr, "Unknown TAC opcode: %d\n", current->op);
        }
        current = current->next;
    }
     printf("--------------------------\n");
}


// --- Label Stack Implementation ---

void tac_push_label(const char* label) {
    if (label_stack_top >= MAX_LABEL_STACK - 1) {
        fprintf(stderr, "Error: Label stack overflow.\n");
        exit(EXIT_FAILURE);
    }
    label_stack[++label_stack_top] = safe_strdup(label);
}

char* tac_pop_label() {
    if (label_stack_top < 0) {
        fprintf(stderr, "Error: Label stack underflow.\n");
        exit(EXIT_FAILURE);
    }
    return label_stack[label_stack_top--];
}
