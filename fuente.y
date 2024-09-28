%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void); 
extern void yyerror(const char*); 
extern void finalizarPrograma(void);

%} 
  
%union{
    char* nombre;
    int num;
}

%token INICIO FIN LEER ESCRIBIR PARENIZQUIERDO PARENDERECHO PUNTOYCOMA COMA ASIGNACION SUMA RESTA FDT PALABRA 
%token <nombre> ID
%token <num> NUMEROS   
 
%start programa   
 
%%
/* noterminal: TERMINAL */ 




programa: INICIO listaSentencias FIN {finalizarPrograma();} 
;

listaSentencias: listaSentencias sentencia 
| sentencia 
; 
 
// Sentencia = linea o instrucción del código que tiene expresiones; 
sentencia: ID {printf("La long es de: %d", yyleng); if(yyleng > 4) yyerror("Superaste el limite de 32 bits");} ASIGNACION expresion PUNTOYCOMA
| LEER listaIdentificadores PUNTOYCOMA
| ESCRIBIR listaExpresiones PUNTOYCOMA
;

listaIdentificadores: ID COMA ID 
;

listaExpresiones: listaExpresiones COMA expresion
| expresion
;


expresion: primaria 
| PARENIZQUIERDO primaria operador primaria PARENDERECHO
;

operador: SUMA  
| RESTA
;

primaria: ID 
| NUMEROS 
| expresion  
;

%% 



int yywrap(){
    return 1;
}
  
void yyerror (const char* s) 
{ 
    printf("\n Error: %s \n", s);
}
 
void finalizarPrograma(){
    printf("El programa ha compilado correctamente... :)");
    exit(1);
}

