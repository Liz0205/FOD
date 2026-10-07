{ Realizar un programa para una tienda de celulares, que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados
desde un archivo de texto denominado “celulares.txt”. Los registros correspondientes a
los celulares deben contener: código de celular, nombre, descripción, marca, precio,
stock mínimo y stock disponible. El formato del archivo de texto de carga se especifica en
la NOTA 2 ubicada al final del ejercicio.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock
mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de
caracteres proporcionada por el usuario.

d. Exportar el archivo binario creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado podría ser
utilizado en un futuro como archivo de carga (ver inciso a), por lo que debería respetar el
formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres
líneas consecutivas. En la primera se especifica: código de celular, el precio y marca, en la
segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden.
Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.

Ejemplo de Archivo

101 250000 Samsung
15 5 Galaxy A15 128GB
Galaxy A15
102 320000 Motorola
3 6 Moto G84 256GB color azulMoto G84
104 950000 Apple
2 4 iPhone 15 256GB negro
iPhone 15  }

program ej5p1;
const
	ruta_txt = 'celulares.txt';
type
	cadena = string[20];
	celular = record
		cod, min_stock, stock: integer;
		nombre, descripcion, marca: cadena;
		precio: real;
	end;
	archivo = file of celular;

//INCISO A
procedure Cargar(var binario: archivo; var carga: Text);
var 
dato: celular; 
{NOTA: Pascal comienza un dato String inmediatamente despues del final de otro tipo de dato
por lo q al tener el formato ' ',marca ese espacio antecesor se toma como parte del String
para evitar esto descarto dicho espacio saltandolo en la importacion: readln(carga, espacio, marca)
Sin esto cada vez q cargue se guardaria mis String con un espacio en blanco por delante (marca: Samsung)}
espacio: char;
begin
	reset(carga);
	rewrite(binario);
	while(not eof(carga))do begin
		with dato do begin //obtengo datos de texto respetando el formato de 3 lineas x dato
			readln(carga, cod, precio, espacio, marca);
			readln(carga, stock, min_stock, espacio, descripcion);//antepongo espacio pa q lo ignore al cargarlo de txt
			readln(carga, nombre);
		end;
		write(binario, dato);//cargo archivo
	end;
	close(binario);
	close(carga);
	writeln('--> ARCHIVO CARGADO CORRECTAMENTE <--');
end;

procedure Imprimir(celu: celular);
begin
	writeln('...........Listado de datos..............');
	with celu do begin
		writeln('- COD: ',cod);
		writeln('- Nombre: ',nombre);
		writeln('- Descripcion: ',descripcion);
		writeln('- Marca: ', marca);
		writeln('- Precio: ', precio:0:2);
		writeln('- Stock minimo: ',min_stock);
		writeln('- Stock actual: ',stock);
	end;
end;

//INCISO B
procedure ListarStockMenor(var a:archivo);
var dato:celular; 
begin
	reset(a);
	while(not eof(a)) do begin
		read(a, dato);
		if(dato.stock < dato.min_stock)then begin
			writeln('..Celular con stock menor al minimo..');
			Imprimir(dato);
		end;
	end;
	close(a);
end;

//INCISO C
procedure ListarDescripcionIgual(var a:archivo);
var dato:celular; leido: cadena; ok: boolean;
begin
	ok:=false;
	write('Ingresar descripcion del celular a listar los datos: ');readln(leido);
	reset(a);
	while(not eof(a)) do begin
		read(a, dato);
		if(dato.descripcion = leido)then begin 
			ok:= true;
			writeln('..Celular con descripcion coincidente..');
			Imprimir(dato);
		end;
	end;
	close(a);
	if(not ok)then writeln('--> No se encontraron celulares con dicha descripcion <--');
end;
//INCISO D
procedure ExportarTodo(var a:archivo; var carga: text);
var dato: celular;
begin
	reset(a);
	rewrite(carga);
	while(not eof(a))do begin
		read(a, dato);
		with dato do begin
			writeln(carga, cod,' ',precio:0:2,' ',marca);
			writeln(carga, stock,' ',min_stock,' ',descripcion);
			writeln(carga, nombre);
		end;
	end;
	close(carga);
	close(a);
	writeln('--> EXPORTACION EXITOSA <--');
end;
//MENU

procedure Menu(var a:archivo; var carga:text);
	procedure MostrarOpc;
	begin
		writeln('------MENU------');
		writeln('1) Crear archivo con datos del archivo de texto a disposicion');
		writeln('2) Listar datos de los celulares con stock menor al minimo');
		writeln('3) Listar datos de los celulares con la descripcion ingresada');
		writeln('4) Exportar todos los datos a un archivo de texto (celulares.txt)');
		writeln('5) Cerrar menu');
		writeln('-----------------');
	end;

var opcion: integer;
begin
	repeat
		MostrarOpc;
		write('Ingrese una opcion: ');readln(opcion);
		case opcion of
			1: Cargar(a, carga);
			2: ListarStockMenor(a);
			3: ListarDescripcionIgual(a);
			4: ExportarTodo(a, carga);
			5: writeln('--> Menu cerrado <--');
			else writeln('--> OPCION INVALIDA <--');
		end;
	until(opcion = 5);
end;
//programa principal
var
	ruta_binario: cadena; a: archivo; carga: Text;
begin
	Assign(carga, ruta_txt);
	write('Ingrese donde guardara el archivo: '); readln(ruta_binario);
	Assign(a, ruta_binario);
	Menu(a, carga);
end.
