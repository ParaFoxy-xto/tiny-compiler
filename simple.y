/* Analisador Sintatico e Semantico para Tiny */

%{
#include <stdio.h>
#include "semantic.h"
#include "tac.h"
#include "Analisador-Lexico/symbol_table.h"
#include <string.h>

int yylex();
void yyerror(const char *s);
extern int yylineno;

int result = 0;

int semantic_get_type(const char* name) {
    if (name == NULL) return TYPE_VOID;
    if (name[0] == 't') return TYPE_INT;
    if (name[0] >= '0' && name[0] <= '9') return TYPE_INT;
    
    int idx = find_symbol(name);
    if (idx != -1) {
        return symbol_table[idx].type;
    }
    return TYPE_VOID;
}


TacOpCode relop_to_tac(const char* op) {
    if (strcmp(op, "<") == 0) return TAC_OP_LT;
    if (strcmp(op, ">") == 0) return TAC_OP_GT;
    if (strcmp(op, "=") == 0) return TAC_OP_EQ;
    if (strcmp(op, "<>") == 0) return TAC_OP_NEQ;
    return -1;
}
%}

%union {
    int ival;      // Para NUM
    char* sval;    // Para IDENTIFIER
    int tipo;      // Para tipo de expressão
}

%token <ival> NUM
%token <sval> IDENTIFIER INTEGER ASSGNOP WHILE DO END ELSE IN LET READ SKIP THEN WRITE
%token <sval> LT GT EQ NEQ 

%type <sval> expression
%type <sval> condition
%type <sval> condition_statement
%type <sval> relop

%left '-' '+' 

/* Para numeros negativos */
%precedence NEG

%%

/* Programa principal */
program:
	decls stmts { 
		semantic_print_table();
		tac_print();
	}
;

decls: %empty 
  | decls decl
;

decl:
    INTEGER IDENTIFIER ';' { 
        semantic_declare_var($2, yylineno);
    }
;

stmts: %empty 
  | stmts stmt
;

relop:
      LT   { $$ = $1; }
    | GT   { $$ = $1; }
    | EQ   { $$ = $1; }
    | NEQ  { $$ = $1; }
;

condition:
    expression relop expression {
	if (semantic_get_type($1) != TYPE_INT || semantic_get_type($3) != TYPE_INT) {
             printf("Erro semântico (linha %d): Operadores de condição requerem inteiros.\n", yylineno);
	     semantic_set_error();
        } else {
             $$ = tac_new_temp();
	     tac_create(relop_to_tac($2), $$, $1, $3);
	}
	free($1); free($2); free($3);
    }
;

condition_statement:
      condition { $$ = $1; }
;

M_start_loop: %empty { 
    char* start_label = tac_new_label();
    tac_create(TAC_OP_LABEL, start_label, NULL, NULL);
    tac_push_label(start_label);
    free(start_label);
};

stmt:
    IDENTIFIER ASSGNOP expression ';' {
        if (semantic_check_var($1, yylineno)) {
            tac_create(TAC_OP_ASSIGN, $1, $3, NULL);
        }
        free($1); free($3);
    }
  | WHILE M_start_loop condition_statement DO {
        char* end_label = tac_new_label();

        tac_create(TAC_OP_IF_FALSE, end_label, $3, NULL);

        tac_push_label(end_label);

        free($3);
        free(end_label);
      }
      stmts END ';' {
        char* end_label = tac_pop_label();
        char* start_label = tac_pop_label();

        tac_create(TAC_OP_GOTO, start_label, NULL, NULL);
        tac_create(TAC_OP_LABEL, end_label, NULL, NULL);

        free(start_label);
        free(end_label);
    }
;

/* Expressoes aceitas */
expression:
    '(' expression ')' { $$ = $2; }
  | expression '+' expression {
	if (semantic_get_type($1) != TYPE_INT || semantic_get_type($3) != TYPE_INT) {
            printf("Erro semântico (linha %d): Operação '+' requer inteiros.\n", yylineno);
            semantic_set_error();
            $$ = TYPE_VOID;
        } else {
		$$ = tac_new_temp();
		tac_create(TAC_OP_ADD, $$, $1, $3);
        }
	free($1); free($3);
    }
  | expression '-' expression {
	if (semantic_get_type($1) != TYPE_INT || semantic_get_type($3) != TYPE_INT) {
            printf("Erro semântico (linha %d): Operação '-' requer inteiros.\n", yylineno);
            semantic_set_error();
            $$ = TYPE_VOID;
        } else {
            $$ = tac_new_temp();
            tac_create(TAC_OP_SUB, $$, $1, $3);
        }
        free($1); free($3);
    }
  | NUM { 
	char buffer[32];
        sprintf(buffer, "%d", $1);
        $$ = strdup(buffer);
    }
  | IDENTIFIER {
        if (semantic_check_var($1, yylineno)) {
            $$ = $1;
        } else {
            $$ = NULL;
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
    tac_init();

    if (yyparse() == 0 && result == 0 && !semantic_had_error()) 
    {
        printf("\nSintatico e semantico OK\n");
    } else 
    {
        printf("\nErro sintatico ou semantico.\n");
    }

    if (yyin != stdin) fclose(yyin);
    tac_free();
    return result;
}
