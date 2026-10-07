{Realizar un programa que permita:

a) Crear un archivo binario a partir de la información almacenada en un archivo de texto. El
nombre del archivo de texto es: “novelas.txt”. La información en el archivo de texto
consiste en: código de novela, nombre, género y precio de diferentes novelas argentinas.
Los datos de cada novela se almacenan en dos líneas en el archivo de texto. La primera
línea contendrá la siguiente información: código novela, precio y género, y la segunda
línea almacenará el nombre de la novela.

b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una
novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado }
program ej7p1;
const
	ruta_txt= 'novelas.txt';
type
	cadena = string[15];
	novela = record
			cod:integer; //Criterio de busqueda
			nombre, genero: cadena;
			precio: real;
	end;
	archivo = file of novela;

//a) Crear y cargar archivo binario con txt dispuesto
procedure Cargar(var a:archivo; var carga: Text);
var dato: novela; 
espacio: char;//pa cargar ignorando el espacio previo del txt en Strings
begin
	reset(carga);
	rewrite(a);
	while(not eof(carga))do begin
		readln(carga, dato.cod, dato.precio, espacio, dato.genero);
		readln(carga, dato.nombre);
		write(a, dato);
	end;
	close(a);
	close(carga);
	writeln('--> El archivo fue creado y cargado exitosamente');
end;

{b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una
novela y modificar una existente. Las búsquedas se realizan por código de novela.}
procedure Leer(var dato: novela);
begin
	writeln('--- INGRESE NUEVOS DATOS ---');
	with dato do begin
		write('- Codigo: ');readln(cod);
		write('- Precio: ');readln(precio);
		write('- Genero: ');readln(genero);
		write('- Nombre: ');readln(nombre);
	end;
end;

procedure Actualizacion(var a: archivo);
var dato: novela; encontre: boolean; nombre: cadena;
begin
	writeln('------- AGREGANDO NUEVA NOVELA -------');
	encontre:= false;
	reset(a);
	//agregar nueva novela
	seek(a, filesize(a));//ubicando al final
	Leer(dato);//agregando datos
	write(a, dato);//cargo datos
	writeln('--> Se agrego una novela correctamente');
	
	writeln('------- MODIFICANDO NOVELA -------');
	//actualizar datos de una novela existente
	seek(a, 0);
	write('Ingrese nombre de la novela a modificar: '); readln(nombre);
	while(not eof(a))and(not encontre)do begin
		read(a, dato);
		if(dato.nombre = nombre)then begin
			encontre:= true;
			seek(a, filepos(a)-1);//me posiciono correctamente
			Leer(dato);//modifico dato
			write(a, dato);//cargo actualizacion
		end;
	end;
	close(a);
	if(not encontre)then writeln('--> No se encontro una novela con dicho nombre')
	else writeln('--> Archivo actualizado');
end;

//imprimiendo contenido del binario
procedure Listar(var a:archivo);
var dato: novela;
begin
	reset(a);
	while (not eof(a))do begin
		read(a, dato);
		writeln('.............................');
		with dato do begin
			writeln('- Codigo: ',cod);
			writeln('- Precio: ',precio:0:2);
			writeln('- Genero: ',genero);
			writeln('- Nombre: ',nombre);
		end;
	end;
	close(a);
end;

//programa principal
var
	novelas: Text; 
	arch: archivo; ruta_bin: cadena;
begin
	Assign(novelas, ruta_txt);
	write('Ingresar ruta del archivo binario: '); readln(ruta_bin);
	Assign(arch, ruta_bin);
	
	Cargar(arch, novelas);
	writeln('..... DATOS DEL ARCHIVO ANTIGUO .....'); Listar(arch);
	Actualizacion(arch);
	writeln('..... DATOS DEL ARCHIVO ACTUALIZADO .....'); Listar(arch);
end.

