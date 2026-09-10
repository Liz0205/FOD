{ P1 - EJ1
Realizar un algoritmo que cree un archivo binario de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde el teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del archivo
debe ser proporcionado por el usuario desde el teclado.   
}

program ej1;
const 
	corte = 30000;
type
	cadena = string[15];
	archivo = file of integer;
VAR
	a: archivo; dato: integer; ruta: cadena;
BEGIN
	write('Ingresar ruta del archivo a crear: ');readln(ruta);
	Assign(a, ruta);//vinculo nombre logico con nombre fisico
	rewrite(a);//creo y abro el archivo
	write('Ingrese nro a cargar en el archivo: '); readln(dato);
	while (dato <> corte) do begin
		write(a, dato);//escribo en el archivo el nro ingresado
		write('Ingrese nro a cargar en el archivo: '); readln(dato);
	end;
	close(a);//cierro el archivo
END.

