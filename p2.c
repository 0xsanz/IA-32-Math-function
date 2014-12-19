/*
Práctica de Arquitectura y Organización de Compuntadoras
2ºCurso,Grado en Ingeniería Informática
@author Pablo García Sanz
*/
#include <stdio.h>
void calculo();
float x;
float y;

int main(){
	printf("Práctica 2 de Arquitectura y Organización de Computadoras \n");
	printf("Introduzca el valor de x: ");
	scanf("%f",&x);

	//Llamada a la función calculo (calculo.asm)
	calculo();

	//Mostramos el resultado de la operación calculo
	printf("El valor de f(x) es : %f \n",y);
	
	return 0;
}
