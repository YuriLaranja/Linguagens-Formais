%option noyywrap

/* Alunos: João Vitor Alvenga; Yuri Laranja 
   /* Esse programa é um analisador léxico, feito em Lex '
   Ele define um conjunto de expressões regulares que são usadas para corresponder a cada tipo de token de uma entrada
   E esses tokens são utilizados por um analisador sintático para analisar a estrutura de entrada.
   */
%{
    /* Inclui o arquivo header gerado pelo Bison */
    #include "analisador.tab.h"

int comentarios = 0; 

%}

%x  comentario
/* Define a expressões regulares para cada token */
LITERAIS_INTEIROS			[1-9][0-9]*|[0] 
LITERAIS_FLOAT 				[-]?([0-9]*[.])?[0-9]+ 
IGUAL                       "="
IGUALDADE                   "=="
DIFERENCA                   "!="
OPERADORES_BINARIOS 		[+]|[-]
COMENTARIOS 				([/][/][^\n]*[\n])|([/][*][^*/]*[*][/])
IF                          "if"|"IF"
ELSE                        "else"|"ELSE"
WHILE					 	"WHILE"|"while"
VAR                         "VAR"|"var"
RETURN                      "return"|"RETURN"
FN                          "FN"|"fn"
BOOL					 	"bool"|"BOOL"
INT					 		"INT"|"int"
FLOAT                       "FLOAT"|"float"
TRUE                        "TRUE"|"true"
FALSE                       "FALSE"|"false"
ABRE_PARENTESES             "("
FECHA_PARENTESES            ")"
ABRE_CHAVE                  "{"
FECHA_CHAVE                 "}"
PONTO_VIRGULA               ";"
VIRGULA                     ","
DOIS_PONTOS                 ":"
ESPACO                      " "
IDENTIFICADORES			    [a-zA-Z_][a-zA-Z0-9_]*


%%

"/*"             { BEGIN(comentario); }
<comentario>{
  "/*"           { ++comentarios; }
  "*"+"/"        { if (comentarios) --comentarios;
                   else BEGIN(INITIAL);
                 } 
  [^\/\*\n]+     {} 
  "*"+           {}
  [\/]           {} 
  \n             {}
}


{LITERAIS_INTEIROS}			{ return literais_inteiros; }
{LITERAIS_FLOAT}			{ return literais_float; }
{IGUAL}						{ return igual; }
{IGUALDADE}                 { return igualdade; } 
{DIFERENCA}                 { return diferenca; }  
{OPERADORES_BINARIOS}		{ return operadores_binarios; }
{COMENTARIOS}				{}
{IF}						{ return se; }
{ELSE}						{ return caso_contrario; }
{WHILE}						{ return enquanto; }
{VAR}						{ return variavel; }
{RETURN}					{ return retorna; }
{FN}						{ return funcao; }
{BOOL}						{ return booleano; }
{INT}						{ return inteiro; }
{FLOAT}						{ return ponto_flutuante; }
{TRUE}						{ return verdadeiro; }
{FALSE}						{ return falso; }
{ABRE_PARENTESES}			{ return abre_parenteses; }
{FECHA_PARENTESES}			{ return fecha_parenteses; }
{ABRE_CHAVE}				{ return abre_chaves; }
{FECHA_CHAVE}				{ return fecha_chaves; }
{PONTO_VIRGULA}			    { return ponto_virgula; }
{VIRGULA}					{ return virgula; }
{DOIS_PONTOS}				{ return dois_pontos; }
{ESPACO}					{}
{IDENTIFICADORES}			{ return identificadores; }


%%