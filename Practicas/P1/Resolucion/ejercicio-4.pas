{ Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado.
Tener en cuenta que no se debe agregar al archivo un empleado con un número de
empleado ya registrado (control de unicidad).

b. Modificar la edad de un empleado dado.

c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.

d. Exportar a un archivo de texto llamado “faltaDNIEmpleado.txt”, los empleados que no
tengan cargado el DNI (DNI en 0).

NOTA: Las búsquedas deben realizarse por número de empleado. }

program ej4p1;
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
	writeln('Nota: Para terminar la carga ingrese "fin" como apellido');
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
//---------------------OPCIONES NUEVAS------------------------------
//CONTROL DE UNICIDAD
procedure Busqueda(var a: archivo; nro_leido: integer; var encontre: boolean);
var dato: empleado;
begin
	encontre:= false;
	while(not eof(a))and(not encontre)do begin //compruebo q no exista en TODO el archivo
		read(a, dato);
		if(dato.nro = nro_leido)then encontre:=true;
	end;
end;

{a. Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado.
Tener en cuenta que no se debe agregar al archivo un empleado con un número de
empleado ya registrado (control de unicidad).}

procedure AgregarAF(var a:archivo);
var repetido:boolean; new: empleado;
begin
	repetido:=false;
	reset(a);
	writeln('-- AGREGANDO DATOS NUEVOS --');
	Leer(new);//leo nuevo dato a agregar
	while(new.apellido <> corte)do begin //corte de lectura
		seek(a, 0);//FUERZO a q siempre busque desde 0; x si agrego mas de 1 dato
		Busqueda(a,new.nro,repetido); //CONTROL DE UNICIDAD
		if(not repetido) then begin //Si paso control cargo al final
			seek(a,filesize(a));//me posiciono al final del archivo
			write(a, new);//cargo dato nuevo
			writeln; writeln('--> Cargo correctamente el nuevo dato <--'); writeln;
		end
		else writeln('--> Ya existe un empleado con dicho nro <--');
		Leer(new);//leo nuevo dato a agregar
	end;
	close(a);
end;

//b. Modificar la edad de un empleado dado (busqueda por nro)
procedure ModificarEdad(var a:archivo);
var
	dato:empleado; encontre:boolean; nro, edad: integer;
begin
	write('Ingrese el nro del empleado a modificar la edad: '); readln(nro);
	reset(a);
	Busqueda(a, nro, encontre);//Busqueda de coincidente
	if(encontre) then begin
		seek(a, filepos(a)-1);//retrocedo una pos posicionando correctamente para leer
		read(a, dato);//guardo el dato completo, xq Busqueda devuelve el puntero pero no el dato
		
		write('Ingrese nueva edad del empleado: ');readln(edad);
		dato.edad:= edad;//actualizo edad de empleado
		
		seek(a, filepos(a)-1);//Posiciono correctamente para cargar
		write(a, dato);//cargo al archivo la actualizacion
		writeln('--> MODIFICACION EXITOSA <--');
	end
	else writeln('--> No se encontro un empleado con el nro buscado <--');
	close(a);
end;

//c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.
procedure CargarAText(var carga: Text; var dato: empleado);
begin
	with dato do begin
		writeln(carga, nro,' ', dni,' ', edad,' ', apellido);
		writeln(carga, nombre);
	end;
end;

procedure ExportarTodo(var a: archivo);
var dato: empleado; carga: Text;
begin
	Assign(carga, 'todos_empleados.txt');//vinculo nombre fisico con nombre logico de arch text
	reset(a);
	rewrite(carga);
	while(not eof(a))do begin
		read(a, dato);
		CargarAText(carga, dato);
	end;
	close(carga);
	close(a);
	writeln('--> EXPORTACION EXITOSA <--');
end;

{d. Exportar a un archivo de texto llamado “faltaDNIEmpleado.txt”, los empleados que no
tengan cargado el DNI (DNI en 0).}
procedure ExportarSinDNI(var a:archivo);
var carga: Text; dato: empleado;
begin
	Assign(carga, 'faltaDNIEmpleado.txt');
	reset(a);
	rewrite(carga);
	while(not eof(a))do begin
		read(a, dato);
		if(dato.dni = 0)then CargarAText(carga, dato);
	end;
	close(carga);
	close(a);
	writeln('--> EXPORTACION EXITOSA <--');
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
		writeln('4) Agregar nuevos empleados');
		writeln('5) Modificar la edad de un empleado');
		writeln('6) Exportar todos los datos a un archivo de texto (todos_empleados.txt)');
		writeln('7) Exportar los datos de los empleados sin DNI (dni 0) a un archivo de texto (faltaDNIEmpleado.txt)');
		writeln('8) Volver al menu principal');
		writeln('--------------------------------------------------------------');
		writeln;
	end;

var opcion1, opcion2: integer;
begin
	repeat
		menu_principal();
		write('>>>> Seleccione una opcion del menu principal: '); readln(opcion1); 
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
							4:AgregarAF(a);
							5:ModificarEdad(a);
							6:ExportarTodo(a);
							7:ExportarSinDNI(a);
							8:writeln('--> Volviste al menu principal <--')
							else writeln('--> Ingrese una opcion valida <--');
						end;
					until(opcion2 = 8);
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



