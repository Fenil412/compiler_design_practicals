%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}
%option noyywrap
%%
[01]+       { yylval.str = strdup(yytext); return BINARY; }
[ \t\r]+    ;
\n          { return '\n'; }
.           { yylval.ch = yytext[0]; return INVALID; }
%%
