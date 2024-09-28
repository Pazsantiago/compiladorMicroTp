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
fdt            "\0"
numeros        [0-9][0-9]*
palabra        [a-zA-Z_]
id             {palabra}({palabra}|{numeros})* 
 

%%

{inicio}         { return INICIO; }  
{fin}            { return FIN; } 
{leer}           { return LEER; }
{escribir}       { return ESCRIBIR; }
{parenizquierdo} { return PARENIZQUIERDO; }
{parenderecho}   { return PARENDERECHO; }
{puntoycoma}     { return PUNTOYCOMA; }
{coma}           { return COMA; }
{asignacion}     { return ASIGNACION; }
{suma}           { return SUMA; }
{resta}          { return RESTA; }
{fdt}            { return FDT; }
{id}             { yylval.nombre = strdup(yytext); return ID; } 
{numeros}        { yylval.numero = atoi(yytext); return NUMEROS; }


%%

// Esto es necesario por si se analiza el código de micro en un archivo por separado
int main(int argc, char* argv[]){
    int l;
    // Apertura de archivo fuente
    if( (yyin = fopen(argv[1], "rt")) == NULL ){
        printf("\nNo se ha podido abrir el archivo: %s\n", argv[1]);
        return 1;
    }
    
    printf("\nArchivo abierto exitosamente");
   
    yyparse();

    fclose(yyin);
    return 0;
}