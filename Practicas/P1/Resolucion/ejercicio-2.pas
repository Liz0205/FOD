{ Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creado en el
ejercicio 1, informe por pantalla cantidad de números menores a 15000 y el promedio de los
números ingresados. El nombre del archivo a procesar debe ser proporcionado por el usuario
una única vez. Además, el algoritmo deberá listar el contenido del archivo en pantalla. Resolver
el ejercicio realizando un único recorrido del archivo.   }

program ej2p1;
const
	parametro = 15000;
type
	cadena = string[15];
	archivo = file of integer;

procedure recorrer(var a: archivo);
var leidos, menores, dato: integer;
begin
	leidos:= 0; menores:= 0; suma:=0;
	reset(a);//abro archivo
	writeln('--- DATOS DEL ARCHIVO ---');
	while (not eof(a)) do begin
		read(a, dato);//Obtengo un valor del archivo
		leidos:= leidos + 1;//contabilizo datos obtenidos
		suma:= suma + dato;
		if(dato < parametro)then menores:= menores + 1;//contabilizo < parametro
		write(' | ', dato);//imprimo contenido de archivo
	end;
	close(a);//cierro archivo
	writeln('El promedio de datos general es: ',(suma / leidos):0:2);
end;

//Programa principal
var
	a: archivo; ruta: cadena;
begin
	write('Ingresar ruta del archivo del ej1: ');readln(ruta);
	Assign(a, ruta);
	recorrer(a);
end.

