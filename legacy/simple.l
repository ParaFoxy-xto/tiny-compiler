%{
#include <stdio.h>
#include "simple.tab.h"
%}

digit       [0-9]
number      ([-+]?[1-9]{digit}*)|{digit} 
id	        [a-zA-Z_][a-zA-Z0-9_]*
whitespace  [ \t\n]+

%x comment

%%
"/*"              {BEGIN(comment);}
<comment>"*/"     {BEGIN(INITIAL);}
<comment>\n       {}
<comment>.        {}

while             {return WHILE;}
do                {return DO;}
end               {return END;}

{number}          {return NUM;}
{id}	        	  {return IDENTIFIER;}
{whitespace}      {;}
.|\n				      {return yytext[0];}

%%

int yywrap ();

/* void main() {
  printf("\nSimple\n------------\n");
  yylex(); 
} */

int yywrap() {
 return 1;
}