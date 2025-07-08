#ifndef TAC_H
#define TAC_H

typedef enum {
    TAC_OP_ADD,
    TAC_OP_SUB,
    TAC_OP_ASSIGN,
    TAC_OP_LABEL,
    TAC_OP_GOTO,
    TAC_OP_IF_FALSE,
    TAC_OP_LT,
    TAC_OP_GT,
    TAC_OP_EQ,
    TAC_OP_NEQ,
    TAC_OP_PARAM,
} TacOpCode;

typedef struct Tac {
    TacOpCode op;
    char* res;
    char* arg1;
    char* arg2;
    struct Tac* next;
} Tac;

extern Tac* tac_list_head;

void tac_init();
void tac_free();
void tac_print();

Tac* tac_create(TacOpCode op, const char* res, const char* arg1, const char* arg2);
char* tac_new_temp();
char* tac_new_label();

void tac_push_label(const char* label);
char* tac_pop_label();

#endif // TAC_H
