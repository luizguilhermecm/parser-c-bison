%{

#include <stdio.h>

extern int yylex();

%}

%union{
}

%token VOID
%token INT
%token CHAR
%token RETURN
%token BREAK
%token SWITCH
%token CASE
%token DEFAUL
%token DO
%token WHILE
%token FOR
%token IF
%token ELSE
%token PRINTF
%token SCANF
%token DEFINE
%token EXIT
%token DIV
%token PLUS
%token MINUS
%token MULTIPLY
%token REMAINDER
%token INC
%token DEC
%token BITWISE_AND
%token BITWISE_OR
%token BITWISE_NOT
%token BITWISE_XOR
%token NOT
%token LOGICAL_AND
%token LOGICAL_OR
%token EQUAL
%token NOT_EQUAL
%token LESS_THAN
%token GREATER_THAN
%token LESS_EQUAL
%token GREATER_EQUAL
%token R_SHIFT
%token L_SHIFT
%token ASSIGN
%token ADD_ASSIGN
%token MINUS_ASSIGN
%token COMMA
%token COLON
%token L_PAREN
%token R_PAREN
%token L_CURLY_BRACKET
%token R_BRACE_BRACKET
%token TERNARY_CONDITIONAL
%token NUMBER_SIGN
%token SEMICOLON
%token NUM_HEXA
%token NUM_OCTAL
%token NUM_INTEGER
%token CARACTER
%token STRING
%token IDENTIFIER

%start programa

%%
programa:
        declaracoes
        | funcao
        | declaracoes programa
        | funcao programa
        ;

declaracoes: 
           NUMBER_SIGN DEFINE IDENTIFIER expressao
           | declaracao_variaveis
           | declaracao_prototipos
           ;

funcao:
      tipo IDENTIFIER parametros L_CURLY_BRACKET comandos R_BRACE_BRACKET
      | tipo IDENTIFIER parametros L_CURLY_BRACKET foo_funcao comandos R_BRACE_BRACKET
      ;

foo_funcao:
          declaracao_variaveis
          | declaracao_variaveis foo_funcao
          ;

declaracao_variaveis:
                    tipo foo_declaracao_variaveis
                    ;

foo_declaracao_variaveis:
                        IDENTIFIER bar_declaracao_variaveis
                        | IDENTIFIER ASSIGN expressao bar_declaracao_variaveis
                        ;

bar_declaracao_variaveis:
                         COMMA foo_declaracao_variaveis
                        | SEMICOLON
                        ;

declaracao_prototipos:
                   tipo IDENTIFIER parametros SEMICOLON
                   ;

parametros:
          L_PAREN R_PAREN
          | L_PAREN foo_parametros R_PAREN
          ;

foo_parametros:
              tipo IDENTIFIER
              | tipo IDENTIFIER COMMA foo_parametros
              ;

tipo:
    INT
    | CHAR
    | VOID
    ;

comandos:
        lista_comandos
        | lista_comandos comandos
        ;

bloco:
     L_CURLY_BRACKET comandos R_BRACE_BRACKET
     ;

lista_comandos:
                 DO bloco WHILE L_PAREN expressao R_PAREN SEMICOLON
                 | IF L_PAREN expressao R_PAREN bloco ELSE foo_else
                 | IF L_PAREN expressao R_PAREN bloco 
                 | WHILE L_PAREN expressao R_PAREN bloco
                 | FOR L_PAREN foo_for foo_for bar_for bloco
                 | PRINTF L_PAREN STRING foo_printf R_PAREN SEMICOLON
                 | SCANF L_PAREN STRING COMMA BITWISE_AND IDENTIFIER R_PAREN SEMICOLON
                 | EXIT L_PAREN expressao R_PAREN SEMICOLON
                 | RETURN SEMICOLON
                 | RETURN L_PAREN expressao R_PAREN SEMICOLON
                 | expressao SEMICOLON
                 | SEMICOLON
                 | bloco
                 ;

foo_for:
       expressao SEMICOLON
       | SEMICOLON
       ;

bar_for:
       expressao R_PAREN
       | R_PAREN
       ;

foo_else:
        bloco
        | L_CURLY_BRACKET R_BRACE_BRACKET
        ;

foo_printf:
          COMMA expressao
          | COMMA expressao foo_printf
          ;

expressao:
         expressao_condicional
         | expressao_condicional foo_expressao
         ;

foo_expressao:
             ASSIGN expressao
             | ADD_ASSIGN expressao
             | MINUS_ASSIGN expressao
             ;

expressao_condicional:
                     expressao_or_logico
                     | TERNARY_CONDITIONAL expressao_or_logico COLON expressao_or_logico
                     ;

expressao_or_logico:
                   expressao_and_logico
                   | expressao_and_logico foo_expressao_or_logico
                   ;

foo_expressao_or_logico:
                       LOGICAL_OR expressao_or_logico
                       ;

expressao_and_logico:
                    expressao_or 
                    | expressao_or foo_expressao_and_logico
                    ;

foo_expressao_and_logico:
                        LOGICAL_AND expressao_and_logico
                        ;

expressao_or:
            expressao_xor
            | expressao_xor foo_expressao_or
            ;

foo_expressao_or:
                BITWISE_OR expressao_or
                ;

expressao_xor:
             expressao_and 
             | expressao_and foo_expressao_xor
             ;

foo_expressao_xor:
                 BITWISE_XOR expressao_xor
                 ;

expressao_and:
             expressao_igualdade
             | expressao_igualdade foo_expressao_and
             ;

foo_expressao_and:
                 BITWISE_AND expressao_and 
                 ;

expressao_igualdade:
                   expressao_relacional
                   | expressao_relacional foo_expressao_igualdade
                   ;

foo_expressao_igualdade:
                       EQUAL expressao_igualdade 
                       | NOT_EQUAL expressao_igualdade
                       ;

expressao_relacional:
                    expressao_shift
                    | expressao_shift foo_expressao_relacional
                    ;

foo_expressao_relacional:
                        LESS_THAN expressao_relacional
                        | LESS_EQUAL expressao_relacional
                        | GREATER_THAN expressao_relacional
                        | GREATER_EQUAL expressao_relacional
                        ;

expressao_shift:
               expressao_aditiva
               | expressao_aditiva foo_expressao_shift
               ;

foo_expressao_shift:
                   R_SHIFT expressao_shift 
                   | L_SHIFT expressao_shift
                   ;

expressao_aditiva:
                 expressao_multiplicativa
                 | expressao_multiplicativa foo_expressao_aditiva
                 ;

foo_expressao_aditiva:
                     PLUS expressao_aditiva
                     | MINUS expressao_aditiva
                     ;

expressao_multiplicativa:
                        expressao_unaria
                        | expressao_unaria foo_expressao_multiplicativa
                        ;

foo_expressao_multiplicativa:
                            REMAINDER expressao_multiplicativa
                            | DIV expressao_multiplicativa
                            | MULTIPLY expressao_multiplicativa
                            ;

expressao_unaria:
                IDENTIFIER INC 
                | IDENTIFIER
                | IDENTIFIER DEC 
                | numero
                | CARACTER
                | IDENTIFIER L_PAREN foo_expressao_unaria R_PAREN
                | L_PAREN expressao R_PAREN
                | NOT expressao_unaria
                | BITWISE_NOT expressao_unaria
                | MINUS expressao_unaria
                | PLUS expressao_unaria
                ;

foo_expressao_unaria:
                    expressao 
                    | expressao COMMA foo_expressao_unaria


numero:
      NUM_INTEGER
      | NUM_HEXA
      | NUM_OCTAL
      ;

%%

yyerror(char *s)
{
        fprintf(stderr, "error: %s \n", s);
}

int main(int argc, char **argv)
{
        printf("%d", yyparse());
}


