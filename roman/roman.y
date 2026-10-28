%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);
extern int roman_lex_error;

int roman_to_int(const char *s) {
    int total = 0, i;
    for (i = 0; s[i]; i++) {
        int a = 0, b = 0;
        switch (s[i]) {
            case 'I': a=1; break; case 'V': a=5; break;
            case 'X': a=10; break; case 'L': a=50; break;
            case 'C': a=100; break; case 'D': a=500; break;
            case 'M': a=1000; break;
            default: return -1;
        }
        if (s[i+1]) {
            switch (s[i+1]) {
                case 'I': b=1; break; case 'V': b=5; break;
                case 'X': b=10; break; case 'L': b=50; break;
                case 'C': b=100; break; case 'D': b=500; break;
                case 'M': b=1000; break;
            }
        }
        total += (a < b) ? -a : a;
    }
    return total;
}

/* Re-encode and compare to enforce the standard canonical spelling. */
void to_roman(int n, char *out) {
    const int values[] = {1000,900,500,400,100,90,50,40,10,9,5,4,1};
    const char *symbols[] = {"M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"};
    int i;
    out[0] = '\0';
    for (i = 0; i < 13; i++) {
        while (n >= values[i]) {
            strcat(out, symbols[i]);
            n -= values[i];
        }
    }
}

int is_valid_roman(const char *s, int *value) {
    char upper[128], canonical[128];
    size_t i, len = strlen(s);
    if (len == 0 || len >= sizeof(upper)) return 0;
    for (i = 0; i < len; i++) {
        if (s[i] < 'A' || s[i] > 'Z') return 0;
        upper[i] = s[i];
    }
    upper[len] = '\0';
    *value = roman_to_int(upper);
    if (*value < 1 || *value > 3999) return 0;
    to_roman(*value, canonical);
    return strcmp(upper, canonical) == 0;
}
%}

%union {
    char *str;
    char ch;
}
%token <str> ROMAN
%token <ch> INVALID
%start input

%%
input
    : ROMAN '\n' {
          int value = 0;
          if (is_valid_roman($1, &value))
              printf("Valid Roman numeral. Decimal value = %d\n", value);
          else
              printf("Invalid Roman numeral\n");
          free($1);
      }
    | ROMAN {
          int value = 0;
          if (is_valid_roman($1, &value))
              printf("Valid Roman numeral. Decimal value = %d\n", value);
          else
              printf("Invalid Roman numeral\n");
          free($1);
      }
    | INVALID '\n' { printf("Invalid input character: '%c'\n", $1); }
    | INVALID { printf("Invalid input character: '%c'\n", $1); }
    | '\n' { printf("Please enter a Roman numeral.\n"); }
    ;

%%
void yyerror(const char *s) {
    (void)s;
    printf("Invalid Roman numeral\n");
}
int main(void) {
    printf("Enter a Roman numeral (1-3999): ");
    yyparse();
    return 0;
}
