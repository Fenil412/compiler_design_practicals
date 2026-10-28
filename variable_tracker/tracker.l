%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}
%option yylineno noyywrap
%%
"//".*                  ;
"#".*                   ;
[ \t\r]+                ;
\n                      ;
[0-9]+                  { yylval.num = atoi(yytext); return NUMBER; }
[A-Za-z_][A-Za-z0-9_]*  { yylval.str = strdup(yytext); return ID; }
"="                     { return '='; }
"+"|"-"|"*"|"/"|"%"     { return OP; }
"("|")"                 { return yytext[0]; }
";"                     { return ';'; }
.                       { return OTHER; }
%%
