%{
#include "y.tab.h"
#include <stdio.h>
%}
%option yylineno noyywrap
%%
"class"             { return CLASS; }
"public"            { return PUBLIC; }
"static"            { return STATIC; }
"void"              { return VOID; }
"main"              { return MAIN; }
"String"            { return STRING; }
"int"               { return INT; }
"if"                { return IF; }
"else"              { return ELSE; }
"for"               { return FOR; }
"//".*              ;
[ \t\r]+            ;
\n                  ;
[0-9]+              { return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { return ID; }
"=="|"!="|"<="|">=" { return RELOP; }
"<"                 { return '<'; }
">"                 { return '>'; }
"+"                 { return '+'; }
"*"                 { return '*'; }
"="                 { return '='; }
";"                 { return ';'; }
","                 { return ','; }
"."                 { return '.'; }
"("                 { return '('; }
")"                 { return ')'; }
"{"                 { return '{'; }
"}"                 { return '}'; }
"["                 { return '['; }
"]"                 { return ']'; }
.                   { fprintf(stderr, "Lexical error at line %d: invalid character '%s'\\n", yylineno, yytext); return INVALID; }
%%
