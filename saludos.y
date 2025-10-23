/* saludos.y */
%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char* s);
int yylex(void);
extern int yylineno;
%}

%union {
    char* str;
}

%token <str> GREETING
%token <str> FAREWELL
%token WORD

%%

input
    : /* vacío */
    | input line
    ;

line
    : tokens '\n'
    | '\n'
    ;

tokens
    : token
    | tokens token
    ;

token
    : GREETING   { printf("Saludo detectado: %s\n", $1); free($1); }
    | FAREWELL   { printf("Despedida detectada: %s\n", $1); free($1); }
    | WORD
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error de sintaxis en la línea %d: %s\n", yylineno, s);
}

int main(void) {
    return yyparse();
}
