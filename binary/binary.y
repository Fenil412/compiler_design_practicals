%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
void yyerror(const char *s);
%}
%union { char *str; char ch; }
%token <str> BINARY
%token <ch> INVALID
%%
input
 : BINARY '\n' { convert($1); free($1); }
 | BINARY      { convert($1); free($1); }
 | INVALID '\n' { printf("Invalid binary character: '%c'\n", $1); }
 | INVALID      { printf("Invalid binary character: '%c'\n", $1); }
 ;
%%
void convert(const char *s) {
    unsigned long long value = 0;
    size_t i;
    for (i = 0; s[i]; i++) {
        if (value > (unsigned long long)(-1) / 2) {
            printf("Binary value is too large for this build.\n");
            return;
        }
        value = value * 2 + (unsigned long long)(s[i] - '0');
    }
    printf("Valid binary number. Decimal value = %llu\n", value);
}
void yyerror(const char *s) { (void)s; printf("Invalid binary input\n"); }
int main(void) {
    printf("Enter a binary number: ");
    yyparse();
    return 0;
}
