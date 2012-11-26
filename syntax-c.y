%{

#include <stdio.h>
#include <node.h>
#include "HashTable.h"
extern int yylex();

TreeNode* AST = NULL;

HashTable* HT = NULL;
HashTable* inUse = NULL;

int count = 0;
void inOrder(TreeNode* aux)
{
        if(aux != NULL){
                inOrder(aux->one);
                inOrder(aux->two);
                inOrder(aux->three);
                inOrder(aux->four);
                if(aux->node_type != -1){
                        printf("%d - ", aux->node_type);
                }
                if(aux->lval_id != NULL){
                        printf("ID %s", aux->lval_id);
                }
                if(aux->lval_tipo != NULL){
                        printf("TIPO %s", aux->lval_tipo);
                }
        }
}
void PrintHT(HashTable* foo)
{
        printf("\n\n\n");
        printf("-----------------");
        printf("\nHashTable: %s", foo->name);
        if(foo != NULL){
                int i;
                for(i = 0; i < PRIME; i++){
                        if(foo->Bucket[i]){
                                printf("\n-----------------");
                                printf("\nidentifier = %s", foo->Bucket[i]->identifier);
                                printf("\ntipo = %s", foo->Bucket[i]->type);
                                printf("\ntipo = %s", foo->Bucket[i]->isArg);
                                printf("\nbucket = %d", i);
                                printf("\n-----------------");
                        }
                }
        }
}

%}

%union{
        TreeNode* ast;
        char* id;
        char* tipo;
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

%type <id> IDENTIFIER
%type <tipo> INT
%type <tipo> VOID
%type <tipo> CHAR
%type <ast> programa
%type <ast> declaracoes
%type <ast> funcao
%type <ast> foo_funcao
%type <ast> declaracao_variaveis
%type <ast> foo_declaracao_variaveis
%type <ast> bar_declaracao_variaveis
%type <ast> declaracao_prototipos
%type <ast> parametros
%type <ast> foo_parametros
%type <ast> tipo
%type <ast> comandos
%type <ast> bloco
%type <ast> lista_comandos
%type <ast> foo_for
%type <ast> bar_for
%type <ast> foo_else
%type <ast> foo_printf
%type <ast> expressao
%type <ast> foo_expressao
%type <ast> expressao_condicional
%type <ast> expressao_or_logico
%type <ast> foo_expressao_or_logico
%type <ast> expressao_and_logico
%type <ast> expressao_or
%type <ast> foo_expressao_or
%type <ast> expressao_xor
%type <ast> foo_expressao_xor
%type <ast> expressao_and
%type <ast> foo_expressao_and
%type <ast> expressao_igualdade
%type <ast> foo_expressao_igualdade
%type <ast> foo_expressao_and_logico
%type <ast> expressao_relacional
%type <ast> foo_expressao_relacional
%type <ast> expressao_shift
%type <ast> foo_expressao_shift
%type <ast> expressao_aditiva
%type <ast> foo_expressao_aditiva
%type <ast> expressao_multiplicativa
%type <ast> foo_expressao_multiplicativa
%type <ast> expressao_unaria
%type <ast> foo_expressao_unaria
%type <ast> numero


%start first

%%
first:
     programa { 
                AST = $1;

                if(AST){
                        inOrder(AST);
                }
                else 
                        printf("erro");

                if(HT){
                        PrintHT(HT);
                        HashTable * print = HT;
                        while(print->FuncList){
                                print = print->FuncList;
                                PrintHT(print);
                        }

                }
                
        }
     ;

programa:
        declaracoes {
                        $$ = $1;
                        
                }
        | funcao {
                        $$ = $1;
                }
        | declaracoes programa {
                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                        $$ = aux;
                        
                }
        | funcao programa {
                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                        $$ = aux;
                        
                }
        ;

declaracoes: 
           NUMBER_SIGN DEFINE IDENTIFIER expressao {
                        TreeNode* aux = newNode($4, NULL, NULL, NULL);
                        setType(aux, DEFINE);
                        setId(aux, $3);
                        $$ = aux;
                        inUse = HT;
                        newHashNode(inUse,"DEFINE",$3,NULL);
                }
           | declaracao_variaveis {
                        $$ = $1;
                        
                }
           | declaracao_prototipos {
                        $$ = $1;
                        
                }
           ;

funcao:
      tipo IDENTIFIER parametros L_CURLY_BRACKET comandos R_BRACE_BRACKET {
                        TreeNode* aux = newNode($1,$3,$5,NULL);
                        setTipo(aux,getTipo($1));
                        setId(aux,$2);
                        $$ = aux;
                        inUse = newFunc(inUse,getTipo($1),$2);
                        inUse = HT;
                }
      | tipo IDENTIFIER parametros L_CURLY_BRACKET foo_funcao comandos R_BRACE_BRACKET {
                        TreeNode* aux = newNode($1,$3,$5,$6);
                        setId(aux,$2);
                        setTipo(aux,getTipo($1));
                        $$ = aux;
                        inUse = newFunc(inUse,getTipo($1),$2);
                        inUse = HT;
                }
      ; 
 
foo_funcao:
          declaracao_variaveis {$$ = $1}
          | declaracao_variaveis foo_funcao{
                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
          ;

declaracao_variaveis:
                    tipo foo_declaracao_variaveis {
                                TreeNode* aux = newNode($1,$2,NULL,NULL);
                                setTipo(aux,getTipo($1));
                                $$ = aux;
                                newHashNode(inUse,getTipo($1),getId($2),"VAR");
                        }
                    ;

foo_declaracao_variaveis:
                        IDENTIFIER bar_declaracao_variaveis{
                                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                        setId(aux,$1);
                                        $$ = aux;
                                }
                        | IDENTIFIER ASSIGN expressao bar_declaracao_variaveis{
                                        TreeNode* aux = newNode($3,$4,NULL,NULL);
                                        setId(aux,$1);
                                        $$ = aux;
                                }
                        ;

bar_declaracao_variaveis:
                         COMMA foo_declaracao_variaveis{
                                        $$ = $2;
                                        newHashNode(inUse,getTipo($2),getId($2),"VAR");
                                }
                        | SEMICOLON{$$ = NULL}
                        ;

declaracao_prototipos:
                   tipo IDENTIFIER parametros SEMICOLON{
                                TreeNode* aux = newNode($1,$3,NULL,NULL);
                                setId(aux,$2);
                                $$ = aux;
                                inUse = newFunc(HT,getTipo($1),$2);
                        }
                   ;

parametros:
          L_PAREN R_PAREN{$$ = NULL}
          | L_PAREN foo_parametros R_PAREN{$$ = $2}
          ;

foo_parametros:
              tipo IDENTIFIER{
                        TreeNode* aux = newNode($1,NULL,NULL,NULL);
                        setId(aux,$2);
                        $$ = aux;
                        newHashNode(inUse->FuncList,getTipo($1),$2, "ARG");
                }
              | tipo IDENTIFIER COMMA foo_parametros{
                        TreeNode* aux = newNode($1,$4,NULL,NULL);
                        setId(aux,$2);
                        $$ = aux;
                        newHashNode(inUse->FuncList,getTipo($1),$2, "ARG");
                }
              ;

tipo:
    INT {
                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                setTipo(aux,$1);
                $$ = aux;
        }
    | CHAR {
                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                setTipo(aux,$1);
                $$ = aux;
        }
    | VOID {
                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                setTipo(aux,$1);
                $$ = aux;
        }
    ;

comandos:
        lista_comandos{$$ = $1}
        | lista_comandos comandos {
                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
        ;

bloco:
     L_CURLY_BRACKET comandos R_BRACE_BRACKET {
                $$ = $2;
                        
        }
     ;

lista_comandos:
                 DO bloco WHILE L_PAREN expressao R_PAREN SEMICOLON {
                                TreeNode* aux = newNode($2,$5,NULL,NULL);
                                setType(aux,DO);
                                $$ = aux;
                        }
                 | IF L_PAREN expressao R_PAREN bloco ELSE foo_else {
                                TreeNode* aux = newNode($3,$5,$7,NULL);
                                setType(aux,IF);
                                $$ = aux;
                        }
                 | IF L_PAREN expressao R_PAREN bloco {
                                TreeNode* aux = newNode($3,$5,NULL,NULL);
                                setType(aux,IF);
                                $$ = aux;
                        }
                 | WHILE L_PAREN expressao R_PAREN bloco {
                                TreeNode* aux = newNode($3,$5,NULL,NULL);
                                setType(aux,WHILE);
                                $$ = aux;
                        }
                 | FOR L_PAREN foo_for foo_for bar_for bloco {
                                TreeNode* aux = newNode($3,$4,$5,$6);
                                setType(aux,FOR);
                                $$ = aux;
                        }
                 | PRINTF L_PAREN STRING foo_printf R_PAREN SEMICOLON{
                                TreeNode* aux = newNode($4,NULL,NULL,NULL);
                                setType(aux,PRINTF);
                                $$ = aux;
                        }
                 | SCANF L_PAREN STRING COMMA BITWISE_AND IDENTIFIER R_PAREN SEMICOLON {
                                TreeNode *aux = newNode(NULL,NULL,NULL,NULL);
                                setType(aux,SCANF);
                                $$ = aux;
                        }
                 | EXIT L_PAREN expressao R_PAREN SEMICOLON {
                                TreeNode *aux = newNode($3,NULL,NULL,NULL);
                                setType(aux,EXIT);
                                $$ = aux;
                        }
                 | RETURN SEMICOLON {
                                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                                setType(aux,RETURN);
                                $$ = aux;
                        }
                 | RETURN L_PAREN expressao R_PAREN SEMICOLON {
                                TreeNode* aux = newNode($3,NULL,NULL,NULL);
                                setType(aux,RETURN);
                                $$ = aux;
                        }
                 | expressao SEMICOLON {$$ = $1}
                 | SEMICOLON {$$ = NULL}
                 | bloco {$$ = $1}
                 ;

foo_for:
       expressao SEMICOLON {$$ = $1}
       | SEMICOLON {$$ = NULL}
       ;

bar_for:
       expressao R_PAREN{$$ = $1}
       | R_PAREN {$$ = NULL}
       ;

foo_else:
        bloco {$$ = $1}
        | L_CURLY_BRACKET R_BRACE_BRACKET {$$ = NULL}
        ;

foo_printf:
          COMMA expressao {$$ = $2}
          | COMMA expressao foo_printf {
                        TreeNode* aux = newNode($2,$3,NULL,NULL);
                        $$ = aux;
                }
          ;

expressao:
         expressao_condicional {$$ = $1}
         | expressao_condicional foo_expressao {
                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
         ;

foo_expressao:
             ASSIGN expressao {
                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                        setType(aux,ASSIGN);
                        $$ = aux;
                }
             | ADD_ASSIGN expressao {
                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                        setType(aux,ADD_ASSIGN);
                        $$ = aux;
                }
             | MINUS_ASSIGN expressao {
                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                        setType(aux,MINUS_ASSIGN);
                        $$ = aux;
                }
             ;

expressao_condicional:
                     expressao_or_logico {$$ = $1}
                     | TERNARY_CONDITIONAL expressao_or_logico COLON expressao_or_logico {
                                TreeNode* aux = newNode($2,$4,NULL,NULL);
                                setType(aux,TERNARY_CONDITIONAL);
                                $$ = aux;
                        }
                     ;

expressao_or_logico:
                   expressao_and_logico {$$ = $1}
                   | expressao_and_logico foo_expressao_or_logico {
                                TreeNode* aux = newNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                   ;

foo_expressao_or_logico:
                       LOGICAL_OR expressao_or_logico {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,LOGICAL_OR);
                                $$ = aux;
                        }
                       ;

expressao_and_logico:
                    expressao_or {$$ = $1}
                    | expressao_or foo_expressao_and_logico {
                                TreeNode* aux = newNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                    ;

foo_expressao_and_logico:
                        LOGICAL_AND expressao_and_logico {
                                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                        setType(aux,LOGICAL_AND);
                                        $$ = aux;
                                }
                        ;

expressao_or:
            expressao_xor {$$ = $1}
            | expressao_xor foo_expressao_or {
                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
            ;

foo_expressao_or:
                BITWISE_OR expressao_or {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,BITWISE_OR);
                                $$ = aux;
                        }
                ;

expressao_xor:
             expressao_and {$$ = $1}
             | expressao_and foo_expressao_xor {
                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
             ;

foo_expressao_xor:
                 BITWISE_XOR expressao_xor {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,BITWISE_XOR);
                                $$ = aux;
                        }
                 ;

expressao_and:
             expressao_igualdade {$$ = $1}
             | expressao_igualdade foo_expressao_and {
                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
             ;

foo_expressao_and:
                 BITWISE_AND expressao_and {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,BITWISE_AND);
                                $$ = aux;
                        }
                 ;

expressao_igualdade:
                   expressao_relacional {$$ = $1}
                   | expressao_relacional foo_expressao_igualdade {
                                TreeNode* aux = newNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                   ;

foo_expressao_igualdade:
                       EQUAL expressao_igualdade {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,EQUAL);
                                $$ = aux;
                        }
                       | NOT_EQUAL expressao_igualdade {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,NOT_EQUAL);
                                $$ = aux;
                        }
                       ;

expressao_relacional:
                    expressao_shift {$$ = $1}
                    | expressao_shift foo_expressao_relacional {
                                TreeNode* aux = newNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                    ;

foo_expressao_relacional:
                        LESS_THAN expressao_relacional {
                                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                        setType(aux,LESS_THAN);
                                        $$ = aux;
                                }
                        | LESS_EQUAL expressao_relacional {
                                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                        setType(aux,LESS_EQUAL);
                                        $$ = aux;
                                }
                        | GREATER_THAN expressao_relacional {
                                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                        setType(aux,GREATER_THAN);
                                        $$ = aux;
                                }
                        | GREATER_EQUAL expressao_relacional {
                                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                        setType(aux,GREATER_EQUAL);
                                        $$ = aux;
                                }
                        ;

expressao_shift:
               expressao_aditiva {$$ = $1}
               | expressao_aditiva foo_expressao_shift {
                                TreeNode* aux = newNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
               ;

foo_expressao_shift:
                   R_SHIFT expressao_shift {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,R_SHIFT);
                                $$ = aux;
                        }
                   | L_SHIFT expressao_shift {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,L_SHIFT);
                                $$ = aux;
                        }
                   ;

expressao_aditiva:
                 expressao_multiplicativa {$$ = $1}
                 | expressao_multiplicativa foo_expressao_aditiva {
                                TreeNode* aux = newNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                 ;

foo_expressao_aditiva:
                     PLUS expressao_aditiva {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,PLUS);
                                $$ = aux;
                        }
                     | MINUS expressao_aditiva {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,MINUS);
                                $$ = aux;
                        }
                     ;

expressao_multiplicativa:
                        expressao_unaria {$$ = $1}
                        | expressao_unaria foo_expressao_multiplicativa {
                                        TreeNode* aux = newNode($1,$2,NULL,NULL);
                                        $$ = aux;
                                }
                        ;

foo_expressao_multiplicativa:
                            REMAINDER expressao_multiplicativa {
                                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                        setType(aux,REMAINDER);
                                        $$ = aux;
                                }
                            | MULTIPLY expressao_multiplicativa {
                                        TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                        setType(aux,MULTIPLY);
                                        $$ = aux;
                                }
                            ;

expressao_unaria:
                IDENTIFIER INC {
                                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                                setType(aux,INC);
                                $$ = aux;
                        }
                | IDENTIFIER {$$ = NULL}
                | IDENTIFIER DEC {
                                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                                setType(aux,DEC);
                                $$ = aux;
                        }
                | numero {$$ = $1}
                | CARACTER {
                                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                                setType(aux,CARACTER);
                                $$ = aux;
                        }
                | IDENTIFIER L_PAREN foo_expressao_unaria R_PAREN {$$ = $3}
                | L_PAREN expressao R_PAREN {$$ = $2}
                | NOT expressao_unaria {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,NOT);
                                $$ = aux;
                        }
                | BITWISE_NOT expressao_unaria {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,BITWISE_NOT);
                                $$ = aux;
                        }
                | MINUS expressao_unaria {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,MINUS);
                                $$ = aux;
                        }
                | PLUS expressao_unaria {
                                TreeNode* aux = newNode($2,NULL,NULL,NULL);
                                setType(aux,PLUS);
                                $$ = aux;
                        }
                ;

foo_expressao_unaria:
                    expressao {$$ = $1}
                    | expressao COMMA foo_expressao_unaria {
                                TreeNode* aux = newNode($1,$3,NULL,NULL);
                                $$ = aux;
                        }
                    ;

numero:
      NUM_INTEGER {
                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                setType(aux,NUM_INTEGER);
                $$ = aux;
        }
      | NUM_HEXA {
                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                setType(aux,NUM_HEXA);
                $$ = aux;
        }
      | NUM_OCTAL {
                TreeNode* aux = newNode(NULL,NULL,NULL,NULL);
                setType(aux,NUM_OCTAL);
                $$ = aux;
        }
      ;

%%

yyerror(char *s)
{
        fprintf(stderr, "error: %s \n", s);
}

int main(int argc, char **argv)
{
        HT = newHashTable("GLOBAL");
        inUse = HT;
        
        printf("%d", yyparse());

        HashTable* teste = HT;
        while (teste){
                printf("%s -- ", teste->name);
                teste = teste->FuncList;
        }
}


