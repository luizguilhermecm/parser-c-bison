%option noyywrap
%{
#include <node.h>
#include <syntax-c.tab.h>

        extern int i;
        extern int chars;
        extern int lines;
%}

%%
[\n] { lines++; chars = 1; } 

"void"    { chars += strlen(yytext); yylval.tipo = strdup(yytext);  return VOID   ;}
"int"     { chars += strlen(yytext); yylval.tipo = strdup(yytext);  return INT    ;}
"char"    { chars += strlen(yytext); yylval.tipo = strdup(yytext);  return CHAR   ;}
"return"  { chars += strlen(yytext); return RETURN ;}
"break"   { chars += strlen(yytext); return BREAK  ;}
"switch"  { chars += strlen(yytext); return SWITCH ;}
"case"    { chars += strlen(yytext); return CASE   ;}
"default" { chars += strlen(yytext); return DEFAUL ;}
"do"      { chars += strlen(yytext); return DO     ;}
"while"   { chars += strlen(yytext); return WHILE  ;}
"for"     { chars += strlen(yytext); return FOR    ;}
"if"      { chars += strlen(yytext); return IF     ;}
"else"    { chars += strlen(yytext); return ELSE   ;}
"printf"  { chars += strlen(yytext); return PRINTF ;}
"scanf"   { chars += strlen(yytext); return SCANF  ;}
"define"  { chars += strlen(yytext); return DEFINE ;}
"exit"    { chars += strlen(yytext); return EXIT   ;}

  /*comentários*/
[/][*]([^*]|[*]+[^/])*[*]+[/] {i=0; while(i<strlen(yytext)){if (yytext[i]=='\n'){ lines++; chars=0; };chars++; i++;};}
[/][/].*                      

  /*tab e white*/
[ \t]     { chars += strlen(yytext); } 

0(X|x){1}[0-9A-Fa-f]+    { chars += strlen(yytext) ; return NUM_HEXA    ;}
0[1-7][0-7]*             { chars += strlen(yytext) ; return NUM_OCTAL   ;}
[0-9]+                   { chars += strlen(yytext) ; return NUM_INTEGER ;}

\'([^\']|\\.)?\'         { chars += strlen(yytext) ; return CARACTER ;}
\"(\\.|\"\"|[^"\n])*\"   { chars += strlen(yytext) ; return STRING ;}
[a-zA-Z_][a-zA-Z0-9_]*   { chars += strlen(yytext); yylval.id = strdup(yytext); return IDENTIFIER ;}

"+"  { chars += strlen(yytext); return PLUS                ;}
"-"  { chars += strlen(yytext); return MINUS               ;}
"*"  { chars += strlen(yytext); return MULTIPLY            ;}
"%"  { chars += strlen(yytext); return REMAINDER           ;}
"++" { chars += strlen(yytext); return INC                 ;}
"--" { chars += strlen(yytext); return DEC                 ;}
"&"  { chars += strlen(yytext); return BITWISE_AND         ;}
"|"  { chars += strlen(yytext); return BITWISE_OR          ;}
"~"  { chars += strlen(yytext); return BITWISE_NOT         ;}
"^"  { chars += strlen(yytext); return BITWISE_XOR         ;}
"!"  { chars += strlen(yytext); return NOT                 ;}
"&&" { chars += strlen(yytext); return LOGICAL_AND         ;}
"||" { chars += strlen(yytext); return LOGICAL_OR          ;}
"==" { chars += strlen(yytext); return EQUAL               ;}
"!=" { chars += strlen(yytext); return NOT_EQUAL           ;}
"<"  { chars += strlen(yytext); return LESS_THAN           ;}
">"  { chars += strlen(yytext); return GREATER_THAN        ;}
"<=" { chars += strlen(yytext); return LESS_EQUAL          ;}
">=" { chars += strlen(yytext); return GREATER_EQUAL       ;}
">>" { chars += strlen(yytext); return R_SHIFT             ;}
"<<" { chars += strlen(yytext); return L_SHIFT             ;}
"="  { chars += strlen(yytext); return ASSIGN              ;}
"+=" { chars += strlen(yytext); return ADD_ASSIGN          ;}
"-=" { chars += strlen(yytext); return MINUS_ASSIGN        ;}
","  { chars += strlen(yytext); return COMMA               ;}
":"  { chars += strlen(yytext); return COLON               ;}
"("  { chars += strlen(yytext); return L_PAREN             ;}
")"  { chars += strlen(yytext); return R_PAREN             ;}
"{"  { chars += strlen(yytext); return L_CURLY_BRACKET     ;}
"}"  { chars += strlen(yytext); return R_BRACE_BRACKET     ;}
"?"  { chars += strlen(yytext); return TERNARY_CONDITIONAL ;}
"#"  { chars += strlen(yytext); return NUMBER_SIGN         ;}
";"  { chars += strlen(yytext); return SEMICOLON           ;}

  /* erro genérico */
.  { printf("ERRO: LINHA: %d,COLUNA:%d\n",lines, chars);} /* qualquer outro caracter */
%%
