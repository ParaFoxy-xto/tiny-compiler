/* Analisador Sintatico e Semantico para Tiny */

%{
#include <stdio.h>
#include "semantic.h"
#include "codegen.h"
#include "Analisador-Lexico/symbol_table.h"

int yylex();
void yyerror(const char *s);
extern int yylineno;

int result = 0;
%}

%union {
    int ival;      // Para NUM
    char* sval;    // Para IDENTIFIER
    int tipo;      // Para tipo de expressão
}

%token NUM IDENTIFIER INTEGER ASSGNOP WHILE DO END ELSE FI IF IN LET READ SKIP THEN WRITE
%type <tipo> expression
%type <sval> IDENTIFIER
%type <ival> NUM
%left '-' '+' 
%left '*' '/' 
%right '^'

/* Para numeros negativos */
%precedence NEG

%%

/* Programa principal */
program:
    decls stmts { semantic_print_table(); }
;

decls:
    /* vazio */
  | decls decl
;

decl:
    INTEGER IDENTIFIER { 
        semantic_declare_var($2, yylineno);
    }
;

stmts:
    /* vazio */
  | stmts stmt
;

stmt:
    IDENTIFIER ASSGNOP expression {
        if (semantic_check_var($1, yylineno)) {
            int idx = find_symbol($1);
            gen_assign(symbol_table[idx].address);
        }
    }
  | WHILE expression DO stmts END { gen_while(); }
;

/* Expressoes aceitas */
expression:
    '(' expression ')' { $$ = $2; }
  | '-' expression %prec NEG {
        if ($2 != TYPE_INT) {
            printf("Erro semântico (linha %d): Operação '-' requer inteiro.\n", yylineno);
            semantic_set_error();
            $$ = TYPE_VOID;
        } else {
            gen_neg();
            $$ = TYPE_INT;
        }
    }
  | expression '+' expression {
        if ($1 != TYPE_INT || $3 != TYPE_INT) {
            printf("Erro semântico (linha %d): Operação '+' requer inteiros.\n", yylineno);
            semantic_set_error();
            $$ = TYPE_VOID;
        } else {
            gen_op("ADD");
            $$ = TYPE_INT;
        }
    }
  | expression '-' expression {
        if ($1 != TYPE_INT || $3 != TYPE_INT) {
            printf("Erro semântico (linha %d): Operação '-' requer inteiros.\n", yylineno);
            semantic_set_error();
            $$ = TYPE_VOID;
        } else {
            gen_op("SUB");
            $$ = TYPE_INT;
        }
    }
  | expression '*' expression {
        if ($1 != TYPE_INT || $3 != TYPE_INT) {
            printf("Erro semântico (linha %d): Operação '*' requer inteiros.\n", yylineno);
            semantic_set_error();
            $$ = TYPE_VOID;
        } else {
            gen_op("MUL");
            $$ = TYPE_INT;
        }
    }
  | expression '/' expression {
        if ($1 != TYPE_INT || $3 != TYPE_INT) {
            printf("Erro semântico (linha %d): Operação '/' requer inteiros.\n", yylineno);
            semantic_set_error();
            $$ = TYPE_VOID;
        } else {
            gen_op("DIV");
            $$ = TYPE_INT;
        }
    }
  | NUM { gen_num($1); $$ = TYPE_INT; }
  | IDENTIFIER {
        if (semantic_check_var($1, yylineno)) {
            int idx = find_symbol($1);
            gen_id(symbol_table[idx].address);
            $$ = symbol_table[idx].type;
        } else {
            $$ = TYPE_VOID;
        }
    }
;

%%

void yyerror(const char *s)
{
	fprintf(stderr, "Erro de sintaxe: %s\n", s);
	result = 1;
}

int main(int argc, char **argv)
{
    extern FILE *yyin;
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("fopen");
            return 1;
        }
    } else {
        yyin = stdin;
    }
    semantic_init();
    if (yyparse() == 0 && result == 0 && !semantic_had_error()) 
    {
        printf("\nSintatico e semantico OK\n");
    } else 
    {
        printf("\nErro sintatico ou semantico.\n");
    }
    if (yyin != stdin) fclose(yyin);
    return result;
}