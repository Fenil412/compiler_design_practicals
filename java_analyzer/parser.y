%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *s);
extern int yylineno;
int had_error = 0;
%}
%token CLASS PUBLIC STATIC VOID MAIN STRING INT IF ELSE FOR
%token ID NUMBER RELOP INVALID
%left '+'
%left '*'
%%
program
 : CLASS ID '{' PUBLIC STATIC VOID MAIN '(' STRING '[' ']' ID ')' '{' statements '}' '}'
 ;
statements
 : /* empty */
 | statements statement
 ;
statement
 : declaration
 | assignment ';'
 | if_statement
 | for_statement
 | block
 ;
declaration
 : INT ID '=' expression ';'
 | INT ID ';'
 ;
assignment
 : ID '=' expression
 ;
if_statement
 : IF '(' condition ')' block
 | IF '(' condition ')' block ELSE block
 ;
for_statement
 : FOR '(' for_init ';' condition ';' assignment ')' block
 ;
for_init
 : INT ID '=' expression
 | assignment
 | /* empty */
 ;
block : '{' statements '}' ;
condition
 : expression '<' expression
 | expression '>' expression
 | expression RELOP expression
 ;
expression
 : expression '+' expression
 | expression '*' expression
 | ID
 | NUMBER
 | '(' expression ')'
 ;
%%
void yyerror(const char *s) {
    if (!had_error) fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, s);
    had_error = 1;
}
int main(void) {
    int result = yyparse();
    if (result == 0 && !had_error) {
        printf("Valid syntax\n");
        return 0;
    }
    printf("Invalid program\n");
    return 1;
}
