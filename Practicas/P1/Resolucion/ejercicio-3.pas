{ Realizar un programa que presente un menú con opciones para:

a. Crear un archivo binario de registros no ordenados de empleados y completarlo con datos ingresados
	desde teclado. De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI.
	Algunos empleados pueden ingresan el DNI con valor 0, lo que significa que al momento de la 
	carga puede no tenerlo. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y...

i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, 
	el cual se proporciona desde el teclado.

ii. Listar en pantalla los empleados de a uno por línea.

iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario  }

program ej3p1;
const
	corte = 'fin';
	parametro = 70;
type
	cadena = string[20];
	empleado = record
			nro, edad, dni: integer;
			apellido, nombre: cadena;
	end;
	
	archivo = file of empleado;

procedure Leer(var dato:empleado);
begin
	writeln('-- INGRESE DATOS DEL EMPLEADO --');
	 with dato do begin
		write('- Apellido: '); readln(apellido);
		if(apellido <> corte)then begin
			write('- Nombre: ');readln(nombre);
			write('- DNI: ');readln(dni);
			write('- Edad: ');readln(edad);
			write('- Nro: ');readln(nro);
		end;
	 end;
end;

procedure Cargar(var a: archivo);
var dato: empleado; 
begin
	rewrite(a);
	writeln('--> CARGANDO ARCHIVO');
	Leer(dato);
	while (dato.apellido <> corte) do begin
		write(a, dato);//Cargo dato en archivo
		Leer(dato);
	end;
	close(a);
	writeln('--> ARCHIVO CREADO Y CARGADO CORRECTAMENTE');
end;

{i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, 
	el cual se proporciona desde el teclado.}
procedure imprimir_empleado(dato: empleado);
begin
	with dato do begin
		writeln('- Nro: ',nro);
		writeln('- Nombre completo: ', nombre, ' ', apellido);
		writeln('- DNI: ',dni);
		writeln('- Edad: ',edad);
	end;
end;

procedure imprimir_buscado(var a:archivo);
var dato: empleado; buscado: cadena; encontre:boolean;
begin
	encontre:=false;
	reset(a);
	writeln;
	write('Ingrese el nombre o apellido del empleado a listar sus datos: '); readln(buscado);
	while(not eof(a))do begin //recorro todo el archivo x si encontre mas de una coincidencia
		read(a, dato);
		if(dato.apellido = buscado)or(dato.nombre = buscado)then begin
			encontre:= true;
			writeln('--> LISTADO DE DATOS DEL EMPLEADO BUSCADO <--');
			imprimir_empleado(dato);
		end;
	end;
	close(a);
	if(not encontre)then writeln('--> NO SE ENCONTRO AL EMPLEADO BUSCADO <--');
end;

//ii. Listar en pantalla los empleados de a uno por línea.
procedure imprimir_en_linea(var a: archivo);
var dato:empleado;
begin
	reset(a);
	writeln('--> DATOS DE LOS EMPLEADOS DE A UNO X LINEA <--');
	while(not eof(a))do begin
		read(a, dato);
		with dato do 
			writeln('-> Nro: ',nro,' | nombre completo: ',nombre,' ',apellido,' | DNI: ',dni,' | edad: ',edad); 
	end;
	close(a);
end;

//iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
procedure imprimir_mayores(var a:archivo);
var dato: empleado; encontre: boolean;
begin
	encontre:=false;
	writeln('--> LISTADO DE EMPLEADOS PROXIMOS A JUBILARSE <--');
	reset(a);
	while(not eof(a))do begin
		read(a, dato);
		if(dato.edad > parametro)then begin
			encontre:= true;
			imprimir_empleado(dato);
			writeln('________________________________');
		end;
	end;
	close(a);
	if(not encontre)then writeln('--> No hay empleados proximos a jubilarse <--');
end;

//MENU
procedure Menu(var a:archivo);

	procedure menu_principal();
	begin
		writeln;
		writeln('-------------------- MENU PRINCIPAL --------------------------');
		writeln('1) Crear y cargar archivo de empleados');
		writeln('2) + Opciones para el archivo anteriormente creado');
		writeln('3) Cerrar menu');
		writeln('--------------------------------------------------------------');
		writeln;
	end;
	procedure menu_secundario();
	begin
		writeln;
		writeln('------------------- MENU SECUNDARIO -------------------------');
		writeln('1) Listar datos de los empleados con apellido o nombre buscado');
		writeln('2) Listar datos de todos los empleados de a uno por linea');
		writeln('3) Listar datos de los empleados proximos a jubilarse');
		writeln('4) Volver al menu principal');
		writeln('--------------------------------------------------------------');
		writeln;
	end;

var opcion1, opcion2: integer;
begin
	repeat
		menu_principal();
		write('>>>> Seleccione una opcion del menu principal: '); read(opcion1); 
		case opcion1 of
			1: Cargar(a);
			2: //abro archivo creado y entro al menu secundario 
				begin
					repeat 
						menu_secundario();
						write('>>>> Seleccione una opcion del menu secundario: '); readln(opcion2);
						case opcion2 of
							1:imprimir_buscado(a);
							2:imprimir_en_linea(a);
							3:imprimir_mayores(a);
							4:writeln('--> Volviste al menu principal <--')
							else writeln('--> Ingrese una opcion valida <--');
						end;
					until(opcion2 = 4);
				end;
			3: writeln('--> Se cerro el menu principal <--')
			else writeln('--> Ingrese una opcion valida <--');
		end;
	until(opcion1 = 3);
end;

//programa principal
var
	a: archivo; ruta: cadena;
begin
	write('Ingrese la ruta del archivo: ');readln(ruta);
	Assign(a, ruta);
	Menu(a);
end.

