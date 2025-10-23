/* saludos.l */
%{
#include "saludos.tab.h"
#include <string.h>
#include <stdlib.h>

static char* dupstr(const char* s) {
    size_t n = strlen(s);
    char* r = (char*)malloc(n + 1);
    if (r) memcpy(r, s, n + 1);
    return r;
}
%}

%option noyywrap
%option nounput noinput
%option yylineno

/* Reconocimiento case-insensitive con `flex -i` */

/* Saludo y despedida */
GREETING   (hola|buenos[[:space:]]+dias|buenas[[:space:]]+tardes|buenas[[:space:]]+noches|saludos|que[[:space:]]+tal|qu[eé][[:space:]]+tal|hey|hi|hello)
FAREWELL   (ad[ií]os|bye|chao|hasta[[:space:]]+luego|nos[[:space:]]+vemos|see[[:space:]]+you)

%%

{GREETING}([!.?]+)?   { yylval.str = dupstr(yytext); return GREETING; }
{FAREWELL}([!.?]+)?   { yylval.str = dupstr(yytext); return FAREWELL; }

[[:alpha:]]+          { return WORD; }
[ \t\r]+              { /* skip */ }
\n                    { return '\n'; }
.                     { /* skip */ }

%%
