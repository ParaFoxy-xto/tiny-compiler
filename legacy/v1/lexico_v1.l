%{
#include <stdio.h>
%}
digit [0-9]
number [-+]?[1-9]{digit}*
id	[a-z][a-z0-9]*
comment "/*"[^("*/")]*"*/"
whitespace [ \t\n]+
%%
":="      {printf("ATRIBUICAO\n");}
"+"       {printf("OPERADOR DE SOMA\n");}
"-"       {printf("OPERADOR DE SUBTRACAO\n");}
"*"       {printf("OPERADOR DE MULTIPLICACAO\n");}
"/"       {printf("OPERADOR DE DIVISAO\n");}
"^"       {printf("NAO IGUAL\n");}
"="       {printf("IGUAL\n");}
"<"       {printf("MENOR QUE\n");}
">"       {printf("MAIOR QUE\n");}
"("       {printf("ABRE PARENTESES\n");}
")"       {printf("FECHA PARENTESES\n");}
do        {printf("PALAVRA RESERVADA (DO)\n");}
else      {printf("PALAVRA RESERVADA (ELSE)\n");}
end       {printf("PALAVRA RESERVADA (END)\n");}
fi        {printf("PALAVRA RESERVADA (FI)\n");}
if        {printf("PALAVRA RESERVADA (IF)\n");}
in        {printf("PALAVRA RESERVADA (IN)\n");}
integer   {printf("PALAVRA RESERVADA (INTEGER)\n");}
let       {printf("PALAVRA RESERVADA (LET)\n");}
read      {printf("PALAVRA RESERVADA (READ)\n");}
skip      {printf("PALAVRA RESERVADA (SKIP)\n");}
then      {printf("PALAVRA RESERVADA (THEN)\n");}
while     {printf("PALAVRA RESERVADA (WHILE)\n");}
write     {printf("PALAVRA RESERVADA (WRITE)\n");}

{digit}		        {printf("DIGITO\n");}
{number}          {printf("NUMERO\n");}
{comment}	        {printf("COMENTARIO\n");}
{id}	        	  {printf("IDENTIFICADOR\n");}
{whitespace}      /*{printf("-----\n");}*/
%%
/* recomendavel declarar sempre
   funcao yywrap() */
int yywrap ();

/* programa principal */
main() {
  printf("Digite lexemas para Simple.\n");
  yylex(); /* scanner gerado por Flex */
}

int yywrap() {
 return 1;
}
