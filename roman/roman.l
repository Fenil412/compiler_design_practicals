%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>

int roman_lex_error = 0;
%}

%option noyywrap

%%
[IVXLCDMivxlcdm]+   { yylval.str = strdup(yytext); return ROMAN; }
[ \t\r]+            ;
\n                  { return '\n'; }
.                   { roman_lex_error = 1; yylval.ch = yytext[0]; return INVALID; }
%%

