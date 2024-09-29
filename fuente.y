%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void); 
extern void yyerror(const char*); 
void finalizarPrograma(int);
void validarLongitudDelID(char*); 
%} 
  
%union{
    char* nombre;
    int numero;
}

%token INICIO FIN LEER ESCRIBIR PARENIZQUIERDO PARENDERECHO PUNTOYCOMA COMA ASIGNACION SUMA RESTA MULTIPLICACION DIVISION FDT PALABRA 
%token <nombre> ID
%token <tipo> NUMEROS   
 
%start programa   
 
%%
/* noterminal: TERMINAL */ 




programa: INICIO listaSentencias FIN {finalizarPrograma(1);} 
;

listaSentencias: listaSentencias sentencia 
| sentencia 
; 
 
// Sentencia = linea o instrucción del código que tiene expresiones; 
sentencia: ID { validarLongitudDelID($1); } ASIGNACION expresion PUNTOYCOMA
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
| MULTIPLICACION
| DIVISION
;

primaria: ID 
| NUMEROS 
| expresion  
;

%% 
/* Por si se quiere utilizar por linea de comando, se descomenta esto /*

/* 
int main(){ 
    printf("Iniciando análisis ascendente recursivo...\n");
 
        yyparse(); 

    printf("Finalizando análisis ascendente recursivo...\n");
    return 1;
}
*/

int yywrap(){
    return 1;
}
  
void yyerror (const char* s) 
{ 
    printf("\nError: %s\n", s);
}

void validarLongitudDelID(char* id){
    if (strlen(id) > 32) {
        yyerror("Identificador supera la longitud máxima de 32 caracteres");
        finalizarPrograma(0);
    } 
} 
  
void finalizarPrograma(int estado){
    if(estado) {
        printf("\nEl programa ha compilado correctamente... :)");
    } else {
        printf("\nEl programa ha fallado.... :(");
    }
    exit(1);
}

