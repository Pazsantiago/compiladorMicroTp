%{

#include <stdio.h>
#include <string.h>
extern int yyparse(void);
#include "y.tab.h"
extern FILE *yyin;
%}
 
/* Esto le indica a flex que lea solo un fichero o archivo de entrada */
%option noyywrap


inicio         "inicio"  
fin            "fin" 
leer           "leer"
escribir       "escribir"
parenizquierdo "("
parenderecho   ")"
puntoycoma     ";"
coma           ","
asignacion     ":="
suma           "+"
resta          "-"
multiplicacion "*"
division       "/"
fdt            "\0"
numeros        [0-9][0-9]*
palabra        [a-zA-Z_]
id             {palabra}({palabra}|{numeros})* 
 

%%

{inicio}         { mostrarToken("inicio"); return INICIO; }  
{fin}            { mostrarToken("fin"); return FIN; } 
{leer}           { mostrarToken("leer"); return LEER; }
{escribir}       { mostrarToken("escribir"); return ESCRIBIR; }
{parenizquierdo} { mostrarToken("parentesis izquierdo"); return PARENIZQUIERDO; }
{parenderecho}   { mostrarToken("parentesis derecho"); return PARENDERECHO; }
{puntoycoma}     { mostrarToken("punto y coma"); return PUNTOYCOMA; }
{coma}           { mostrarToken("coma"); return COMA; }
{asignacion}     { mostrarToken("asignacion"); return ASIGNACION; }
{suma}           { mostrarToken("suma"); return SUMA; }
{multiplicacion} { mostrarToken("multiplicacion"); return MULTIPLICACION; }
{division}       { mostrarToken("division"); return DIVISION; }
{fdt}            { mostrarToken("fin de texto"); return FDT; }
{id}             { mostrarToken("identificador"); yylval.nombre = strdup(yytext); return ID; } 
{numeros}        { mostrarToken("numeros"); yylval.numero = atoi(yytext); return NUMEROS; }


%%

// Esto es necesario por si se analiza el código de micro en un archivo por separado, sino comentarlo.
int main(int argc, char* argv[]){
    int l;
    // Apertura de archivo fuente
    if( (yyin = fopen(argv[1], "rt")) == NULL ){
        printf("\nNo se ha podido abrir el archivo: %s\n", argv[1]);
        return 1;
    }
    
    printf("\nArchivo abierto exitosamente\n");
   
    yyparse();

    fclose(yyin);
    return 0;
}

void mostrarToken(char* token){
    printf("\nSe ha insertado un token de: %s", token);
}