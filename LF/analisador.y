%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE *yyin;
extern FILE *yyout;

/* Função chamada quando ocorre um erro na entrada. 
  Ela imprime a mensagem de erro passada como parâmetro. */
void yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}

%}

/* Declara os tokens */
%token literais_inteiros
%token literais_float
%token igual
%token igualdade
%token diferenca
%token operadores_binarios
%token se 
%token caso_contrario
%token enquanto
%token variavel
%token retorna
%token funcao
%token booleano
%token inteiro
%token ponto_flutuante
%token verdadeiro
%token falso
%token abre_parenteses
%token fecha_parenteses
%token abre_chaves
%token fecha_chaves
%token ponto_virgula
%token virgula
%token dois_pontos
%token identificadores

%%

/*
    Colocamos terminais com iniciais minúsculas
    Variáveis com iniciais maiúsculas

    Para melhorar a visualização e entendimento do código

*/

//Começo da declaração das variáveis

//Declaração de acordo com a passada em sala
//Prints feitos da forma para inscrever no arquivo
Program: Declaracoes {fprintf(yyout,"declaracoes --> program\n");}
;

//Declaração dessa forma para mostrar que o programa pode ser solicitado de forma recursiva
Declaracoes: /* vazio */  {fprintf(yyout,"vazio --> declaracoes\n");}
| Decl Declaracoes     {fprintf(yyout,"decl declaracoes --> declaracoes\n");}
;
//Os dois tipos de declaração de Fato, ou uma função ou declaração de variáveis, mas com a declaração de cima, vemos que eles podem coexistir no mesmo programa
Decl: Funcao {fprintf(yyout,"funcao --> decl\n");}
| Var   {fprintf(yyout,"variavel --> decl\n");}
;
//Primeira declaração das variáveis, mostrando que ela pode ou não ter uma expressão pós sinal de igual
Var: variavel identificadores dois_pontos Tipo igual Exp ponto_virgula {fprintf(yyout,"variavel identificadores dois_pontos Tipo igual Exp ponto_virgula --> Var\n");}  
| variavel identificadores dois_pontos Tipo ponto_virgula {fprintf(yyout,"variavel identificadores dois_pontos Tipo ponto_virgula --> Var\n");}
;
//Declaração de Função, onde precisamos ter todos abre e fechas e Parametros que é uma variável(entrada em detalhes a seguir), Pós declaração dos parametros temos a definição da função em si, seguida de Variavéis e comandos
Funcao: funcao identificadores abre_parenteses Parametros fecha_parenteses dois_pontos Tipo abre_chaves Definicao fecha_chaves ponto_virgula 
{fprintf(yyout,"funcao identificadores abre_parenteses Parametros fecha_parenteses dois_pontos Tipo abre_chaves Definicao fecha_chaves ponto_virgula --> funcao\n");}
;
//Tipos aceitos na gramática
Tipo: booleano {fprintf(yyout,"booleano --> Tipo\n");}
| ponto_flutuante {fprintf(yyout,"ponto_flutuante --> Tipo\n");}
| inteiro {fprintf(yyout,"inteiro --> Tipo\n");}
;
//Parametros feitos de forma em qual podemos não ter nenhum parametro, 1 ou mais, separados por virgulas
Parametros:  /* vazio */  {fprintf(yyout,"vazio --> Parametros\n");}
| identificadores Tipo virgula Parametros {fprintf(yyout,"identificadores Tipo virgula --> Parametros\n");}
| identificadores Tipo {fprintf(yyout,"identificadores Tipo --> Parametros\n");}
;
//Definicao comentada acima, seguida de variáveis ou comandos
Definicao: /* vazio */  {fprintf(yyout,"vazio --> Definicao\n");}
| Variaveis Comandos {fprintf(yyout,"Variaveis Comandos --> Definicao\n");}

;
//Declaração de variáveis mostrando que podemos ter variáveis seguidas na gramatica
Variaveis: /* vazio */  {fprintf(yyout,"vazio --> Variaveis\n");}
| Variaveis Var {fprintf(yyout,"Variaveis Var --> Variaveis\n");}
| Var {fprintf(yyout,"Var --> Variaveis\n");}
;

//Comando aceito dentro da função, todos comos variáveis pois serão especificados a seguir
Comando: /* vazio */  {fprintf(yyout,"vazio --> Comando\n");}
|Atribuicao {fprintf(yyout,"Atribuicao --> Comando\n");}
| Condicional          {fprintf(yyout,"Condicional --> Comando\n");}
| Laco              {fprintf(yyout,"Laco --> Comando\n");}
| retorna Exp ponto_virgula {fprintf(yyout,"retorna Exp ponto_virgula --> Comando\n");}
;

//Atribuicao de identificadores recebem uma expressão
Atribuicao: identificadores igual Exp ponto_virgula {fprintf(yyout,"identificadores igual Exp ponto_virgula --> Atribuicao\n");}
;
//Definição de comandos que podem seguir
Comandos: /* vazio */  {fprintf(yyout,"vazio --> Comandos\n");}
| Comandos Comando     {fprintf(yyout,"Variaveis Var --> Comanos\n");}
| Comando              {fprintf(yyout,"Comando --> Comandos\n");}
;

//Definição de todos os tipos qe podem ter de expressões
Exp: identificadores   {fprintf(yyout,"identificadores --> Exp\n");}
| literais_inteiros    {fprintf(yyout,"literais_inteiros --> Exp\n");}
| literais_float       {fprintf(yyout,"literais_float --> Exp\n");}
| verdadeiro           {fprintf(yyout,"verdadeiro --> Exp\n");}
| falso                {fprintf(yyout,"falso --> Exp\n");}
| Exp operadores_binarios Exp {fprintf(yyout,"Exp operadores_binarios Exp --> Exp\n");}
| abre_parenteses Exp fecha_parenteses {fprintf(yyout,"abre_parenteses Exp fecha_parenteses --> Exp\n");}
;
//Condicional IF, que pode ou não receber um else
Condicional: se abre_parenteses Condicao fecha_parenteses abre_chaves Comandos fecha_chaves caso_contrario abre_chaves Comandos fecha_chaves { { fprintf(yyout,"se abre_parenteses Condicao fecha_parenteses abre_chaves Comandos fecha_chaves caso_contrario abre_chave Comandos fecha_chave --> condicional\n"); } }
 | se abre_parenteses Condicao fecha_parenteses abre_chaves Comandos fecha_chaves { fprintf(yyout,"se abre_parenteses Condicao fecha_parenteses abre_chaves Comandos fecha_chaves --> condicional\n"); }
 ;
//Condicao necessária tanto no IF quando no while para comparar expressões, e o verdadeiro caso seja While (TRUE)
Condicao: Exp Comparador Exp            { fprintf(yyout,"exp comparador exp --> Condicao\n"); }
 | verdadeiro                           { fprintf(yyout,"verdadeiro --> Condicao\n"); }
 ;
//Comparacao dentro da condição que pode ser feita com == ou !=
Comparador: igualdade                   { fprintf(yyout,"igualdade --> Comparador\n"); }
 | diferenca                            { fprintf(yyout,"diferenca --> Comparador\n"); }
 ;
//Laço while definido
Laco: enquanto abre_parenteses Condicao fecha_parenteses abre_chaves Comandos fecha_chaves { fprintf(yyout,"enquanto abre_parenteses Condicao fecha_parenteses abre_chave Comandos fecha_chave --> laco\n"); }
;

%%

//Usamos a main somente para ler o arquivo e escrever no arquivo passados na chamada da função
//EX: ./analisa in.txt out.txt
//E ela termina fechando os arquivos
int main(int argc, char *argv[])
{
  FILE *entrada = fopen(argv[1], "r");
  FILE *saida = fopen(argv[2],"w");
  yyin = entrada;
  yyout = saida;
  yyparse();
  fclose(yyin);
  fclose(yyout);
  return 0;
}
