%option noyywrap
%{
#include <node.h>
#include <syntax-c.tab.h>

        int i = 0;
        int chars = 1;
        int lines = 1;
%}

%%
[\n] { lines++; chars = 1; } 

"void"    { printf("VOID\n")    ;  chars += strlen(yytext); yylval.tipo = strdup(yytext);  return VOID   ;}
"int"     { printf("INT\n")     ;  chars += strlen(yytext); yylval.tipo = strdup(yytext);  return INT    ;}
"char"    { printf("CHAR\n")    ;  chars += strlen(yytext); yylval.tipo = strdup(yytext);  return CHAR   ;}
"return"  { printf("RETURN\n")  ;  chars += strlen(yytext); return RETURN ;}
"break"   { printf("BREAK\n")   ;  chars += strlen(yytext); return BREAK  ;}
"switch"  { printf("SWITCH\n")  ;  chars += strlen(yytext); return SWITCH ;}
"case"    { printf("CASE\n")    ;  chars += strlen(yytext); return CASE   ;}
"default" { printf("DEFAULT\n") ;  chars += strlen(yytext); return DEFAUL ;}
"do"      { printf("DO\n")      ;  chars += strlen(yytext); return DO     ;}
"while"   { printf("WHILE\n")   ;  chars += strlen(yytext); return WHILE  ;}
"for"     { printf("FOR\n")     ;  chars += strlen(yytext); return FOR    ;}
"if"      { printf("IF\n")      ;  chars += strlen(yytext); return IF     ;}
"else"    { printf("ELSE\n")    ;  chars += strlen(yytext); return ELSE   ;}
"printf"  { printf("PRINTF\n")  ;  chars += strlen(yytext); return PRINTF ;}
"scanf"   { printf("SCANF\n")   ;  chars += strlen(yytext); return SCANF  ;}
"define"  { printf("DEFINE\n")  ;  chars += strlen(yytext); return DEFINE ;}
"exit"    { printf("EXIT\n")    ;  chars += strlen(yytext); return EXIT   ;}

  /*comentários*/
[/][*]([^*]|[*]+[^/])*[*]+[/] {i=0; while(i<strlen(yytext)){if (yytext[i]=='\n'){ lines++; chars=0; };chars++; i++;};}
[/][/].*                      

  /*tab e white*/
[ \t]     { chars += strlen(yytext); } 

0(X|x){1}[0-9A-Fa-f]+    { printf("NUM_HEXA(%s)\n",yytext)    ; chars += strlen(yytext) ; return NUM_HEXA    ;}
0[1-7][0-7]*             { printf ("NUM_OCTAL(%s)\n",yytext)  ; chars += strlen(yytext) ; return NUM_OCTAL   ;}
[0-9]+                   { printf("NUM_INTEGER(%s)\n",yytext) ; chars += strlen(yytext) ; return NUM_INTEGER ;}

\'([^\']|\\.)?\'         { printf("CARACTER(%s)\n",yytext)    ; chars += strlen(yytext) ; return CARACTER ;}
\"(\\.|\"\"|[^"\n])*\"   { printf("STRING(%s)\n",yytext)      ; chars += strlen(yytext) ; return STRING ;}
[a-zA-Z_][a-zA-Z0-9_]*   { printf("IDENTIFIER(%s)\n",yytext)  ; chars += strlen(yytext); yylval.id = strdup(yytext); return IDENTIFIER ;}

"+"  { printf("PLUS\n")                ;  chars += strlen(yytext); return PLUS                ;}
"-"  { printf("MINUS\n")               ;  chars += strlen(yytext); return MINUS               ;}
"*"  { printf("MULTIPLY\n")            ;  chars += strlen(yytext); return MULTIPLY            ;}
"%"  { printf("REMAINDER\n")           ;  chars += strlen(yytext); return REMAINDER           ;}
"++" { printf("INC\n")                 ;  chars += strlen(yytext); return INC                 ;}
"--" { printf("DEC\n")                 ;  chars += strlen(yytext); return DEC                 ;}
"&"  { printf("BITWISE_AND\n")         ;  chars += strlen(yytext); return BITWISE_AND         ;}
"|"  { printf("BITWISE_OR\n")          ;  chars += strlen(yytext); return BITWISE_OR          ;}
"~"  { printf("BITWISE_NOT\n")         ;  chars += strlen(yytext); return BITWISE_NOT         ;}
"^"  { printf("BITWISE_XOR\n")         ;  chars += strlen(yytext); return BITWISE_XOR         ;}
"!"  { printf("NOT\n")                 ;  chars += strlen(yytext); return NOT                 ;}
"&&" { printf("LOGICAL_AND\n")         ;  chars += strlen(yytext); return LOGICAL_AND         ;}
"||" { printf("LOGICAL_OR\n")          ;  chars += strlen(yytext); return LOGICAL_OR          ;}
"==" { printf("EQUAL\n")               ;  chars += strlen(yytext); return EQUAL               ;}
"!=" { printf("NOT_EQUAL\n")           ;  chars += strlen(yytext); return NOT_EQUAL           ;}
"<"  { printf("LESS_THAN\n")           ;  chars += strlen(yytext); return LESS_THAN           ;}
">"  { printf("GREATER_THAN\n")        ;  chars += strlen(yytext); return GREATER_THAN        ;}
"<=" { printf("LESS_EQUAL\n")          ;  chars += strlen(yytext); return LESS_EQUAL          ;}
">=" { printf("GREATER_EQUAL\n")       ;  chars += strlen(yytext); return GREATER_EQUAL       ;}
">>" { printf("R_SHIFT\n")             ;  chars += strlen(yytext); return R_SHIFT             ;}
"<<" { printf("L_SHIFT\n")             ;  chars += strlen(yytext); return L_SHIFT             ;}
"="  { printf("ASSIGN\n")              ;  chars += strlen(yytext); return ASSIGN              ;}
"+=" { printf("ADD_ASSIGN\n")          ;  chars += strlen(yytext); return ADD_ASSIGN          ;}
"-=" { printf("MINUS_ASSIGN\n")        ;  chars += strlen(yytext); return MINUS_ASSIGN        ;}
","  { printf("COMMA\n")               ;  chars += strlen(yytext); return COMMA               ;}
":"  { printf("COLON\n")               ;  chars += strlen(yytext); return COLON               ;}
"("  { printf("L_PAREN\n")             ;  chars += strlen(yytext); return L_PAREN             ;}
")"  { printf("R_PAREN\n")             ;  chars += strlen(yytext); return R_PAREN             ;}
"{"  { printf("L_CURLY_BRACKET\n")     ;  chars += strlen(yytext); return L_CURLY_BRACKET     ;}
"}"  { printf("R_BRACE_BRACKET\n")     ;  chars += strlen(yytext); return R_BRACE_BRACKET     ;}
"?"  { printf("TERNARY_CONDITIONAL\n") ;  chars += strlen(yytext); return TERNARY_CONDITIONAL ;}
"#"  { printf("NUMBER_SIGN\n")         ;  chars += strlen(yytext); return NUMBER_SIGN         ;}
";"  { printf("SEMICOLON\n")           ;  chars += strlen(yytext); return SEMICOLON           ;}

  /* erro genérico */
.  { printf("ERRO: LINHA: %d,COLUNA:%d\n",lines, chars);} /* qualquer outro caracter */
%%
