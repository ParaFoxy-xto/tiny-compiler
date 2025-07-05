#ifndef CODEGEN_H
#define CODEGEN_H

void gen_assign(int address);
void gen_while();
void gen_neg();
void gen_op(const char* op);
void gen_num(int value);
void gen_id(int address);

#endif 