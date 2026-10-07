{ Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”,
con aquellos celulares que tengan stock 0.

NOTA: Las búsquedas deben realizarse por nombre de celular. }

program ej6p1;
const
	ruta_txt = 'celulares.txt';
	corte = 'fin';//no me lo dan lo usare como corte de nombre
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

//NUEVOS INCISOS
//a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
procedure AgregarCelulares(var a: archivo);
	procedure Leer(var dato:celular);
	begin
		with dato do begin
			writeln('............................');
			write('- Nombre: ');readln(nombre);
			if(nombre <> corte)then begin
				write('- Codigo: ');readln(cod);
				write('- Precio: ');readln(precio);
				write('- Marca: ');readln(marca);
				write('- Stock: ');readln(stock);
				write('- Minimo Stock: ');readln(min_stock);
				write('- Descripcion: ');readln(descripcion);
			end;
		end;
	end;
var dato: celular; 
begin
	reset(a);
	seek(a, filesize(a));//me  posiciono al final del archivo
	writeln('----AGREGANDO NUEVOS CELULARES-----');
	writeln('NOTA: Para finalizar la carga ingrese "fin" como nombre');
	Leer(dato);
	while(dato.nombre <> corte)do begin
		write(a, dato);
		Leer(dato);
	end;
	close(a);
	writeln;
end;
//b. Modificar el stock de un celular dado ; se busca x nombre
procedure ModificarStock(var a:archivo);
var dato: celular; nombre: cadena; stock:integer; encontre:boolean;
begin
	encontre:=false;
	reset(a);
	writeln;
	write('Ingresar el nombre del celular a modificar stock: ');readln(nombre);
	while(not eof(a))and(not encontre)do begin
		read(a, dato);
		if(dato.nombre = nombre)then begin
			encontre:=true;
			seek(a, filepos(a)-1);//posiciono correctamente
			write('Ingrese nuevo stock: ');readln(stock);
			dato.stock:= stock;//actualizo stock
			write(a, dato);//cargo actualizacion
			writeln('--> Stock actualizado <--');
		end;
	end;
	close(a);
	if(not encontre)then writeln('--> No se encontro un celular con dicho nombre <--');
end;
//c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
procedure ExportarSinStock(var a:archivo);
var carga:text; dato:celular;
begin
	Assign(carga, 'SinStock.txt');
	reset(a);
	rewrite(carga);
	while(not eof(a))do begin
		read(a, dato);
		if(dato.stock = 0)then begin
			with dato do begin
				writeln(carga, cod,' ',precio:0:2,' ',marca);
				writeln(carga, stock,' ',min_stock,' ',descripcion);
				writeln(carga, nombre);
			end;
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
		writeln('5) Agregar nuevos celulares');
		writeln('6) Actualizar stock de un celular con nombre dado');
		writeln('7) Exportar datos de los celulares con stock 0 a un archivo de texto (SinStock.txt)');
		writeln('8) Cerrar menu');
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
			5: AgregarCelulares(a);
			6: ModificarStock(a);
			7: ExportarSinStock(a);
			8: writeln('--> Menu cerrado <--');
			else writeln('--> OPCION INVALIDA <--');
		end;
	until(opcion = 8);
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

