%{
#include <stdio.h>
#include "simple.tab.h"
#include <string.h>
%}
digit [0-9]
number ([-+]?[1-9]{digit}*)|{digit}
id	[a-z][a-z0-9]*
whitespace [ \t\n]+

%x comment

%%
"/*"          {BEGIN(comment);}
<comment>"*/" {BEGIN(INITIAL);}
<comment>\n   {}
<comment>.    {}

":="      {return ASSGNOP;}
do        {return DO;}
else      {return ELSE;}
end       {return END;}
fi        {return FI;}
if        {return IF;}
in        {return IN;}
integer   {return INTEGER;}
let       {return LET;}
read      {return READ;}
skip      {return SKIP;}
then      {return THEN;}
while     {return WHILE;}
write     {return WRITE;}

{number}          {return NUM;}
{id}              { yylval.sval = strdup(yytext); return IDENTIFIER; }
{whitespace}      {;}
\n        { yylineno++; return '\n'; }
.         { return yytext[0]; }
%%
int yywrap() {
  return 1;
}
