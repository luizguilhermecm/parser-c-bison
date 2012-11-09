%{

#include <stdio.h>

extern int yylex();

%}

%union{
}


%%

%%

yyerror(char *s)
{
        fprintf(stderr, "error: %s \n", s);
}

int main(int argc, char **argv)
{
        printf("%d", yyparse());
}
