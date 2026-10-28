%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
extern int yylineno;
int yylex(void);
void yyerror(const char *s);

#define MAX_VARS 500
typedef struct {
    char name[128];
    int defs[100], uses[200];
    int ndefs, nuses;
} Variable;
Variable vars[MAX_VARS];
int nvars = 0;
int current_line = 1;

int find_var(const char *name) {
    int i;
    for (i=0; i<nvars; i++) if (!strcmp(vars[i].name, name)) return i;
    return -1;
}
int ensure_var(const char *name) {
    int k = find_var(name);
    if (k >= 0) return k;
    if (nvars >= MAX_VARS) return -1;
    k = nvars++;
    snprintf(vars[k].name, sizeof(vars[k].name), "%s", name);
    vars[k].ndefs = vars[k].nuses = 0;
    return k;
}
void add_def(const char *name, int line) {
    int k=ensure_var(name);
    if (k >= 0 && vars[k].ndefs < 100) vars[k].defs[vars[k].ndefs++] = line;
}
void add_use(const char *name, int line) {
    int k=ensure_var(name);
    if (k >= 0 && vars[k].nuses < 200) vars[k].uses[vars[k].nuses++] = line;
}
void print_list(const char *label, int *a, int n) {
    int i;
    printf("  %s: ", label);
    if (!n) { printf("None"); }
    for (i=0; i<n; i++) printf("%s%d", i ? ", " : "", a[i]);
    printf("\n");
}
void report(void) {
    int i;
    printf("\nVariable Definition and Usage Report\n");
    printf("------------------------------------\n");
    for (i=0; i<nvars; i++) {
        printf("%s\n", vars[i].name);
        print_list("Definition lines", vars[i].defs, vars[i].ndefs);
        print_list("Usage lines", vars[i].uses, vars[i].nuses);
    }
}
%}
%union { char *str; int num; }
%token <str> ID
%token <num> NUMBER
%token OP OTHER
%left OP
%%
program : lines { report(); } ;
lines : /* empty */
      | lines line
      ;
line : ID '=' rhs ';' { add_def($1, yylineno); free($1); }
     | ID '=' rhs    { add_def($1, yylineno); free($1); }
     | rhs ';'
     | rhs
     | OTHER
     ;
rhs : atom
    | rhs OP atom
    ;
atom : ID { add_use($1, yylineno); free($1); }
    | NUMBER
    | '(' rhs ')'
    ;
%%
void yyerror(const char *s) { fprintf(stderr, "Parse note at line %d: %s\n", yylineno, s); }
int main(void) { yyparse(); return 0; }
