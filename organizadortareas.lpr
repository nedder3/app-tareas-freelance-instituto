program organizadortareas;

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  SysUtils, Crt;

const
  MAX_TAREAS = 100;

type
  TEstado = (Pendiente, Completo);
  TPrioridad = (Alta, Media, Baja);

  TRegistroTarea = record
    ID: Integer;
    Cliente: string[50];
    TipoTrabajo: string[50];
    Monto: Integer;
    Estado: TEstado;
    Prioridad: TPrioridad;
  end;

  TArregloTareas = array[1..MAX_TAREAS] of TRegistroTarea;

var
  Tareas: TArregloTareas;
  TotalTareas: Integer;

function LeerCadenaNoVacia(Mensaje: string): string;
var
  Entrada: string;
begin
  repeat
    Write(Mensaje);
    Readln(Entrada);
    if Trim(Entrada) = '' then
      Writeln('Error: Este campo no puede estar vacio.')
    else
      Break;
  until False;
  Result := Trim(Entrada);
end;

function LeerMontoPositivo(Mensaje: string): Integer;
var
  Entrada: string;
  Monto: Integer;
begin
  repeat
    Write(Mensaje);
    Readln(Entrada);
    if not TryStrToInt(Entrada, Monto) then
      Writeln('Error: Debe ingresar un numero valido.')
    else if Monto < 0 then
      Writeln('Error: El monto no puede ser negativo.')
    else
      Break;
  until False;
  Result := Monto;
end;

function LeerEstadoValido: TEstado;
var
  Entrada: string;
begin
  repeat
    Write('Estado (pendiente/completo): ');
    Readln(Entrada);
    Entrada := LowerCase(Trim(Entrada));

    if Entrada = 'pendiente' then
    begin
      Result := Pendiente;
      Break;
    end
    else if Entrada = 'completo' then
    begin
      Result := Completo;
      Break;
    end
    else
      Writeln('Error: Estado debe ser "pendiente" o "completo".');
  until False;
end;

function LeerPrioridadValida: TPrioridad;
var
  Entrada: string;
begin
  repeat
    Write('Prioridad (alta/media/baja): ');
    Readln(Entrada);
    Entrada := LowerCase(Trim(Entrada));

    if Entrada = 'alta' then
    begin
      Result := Alta;
      Break;
    end
    else if Entrada = 'media' then
    begin
      Result := Media;
      Break;
    end
    else if Entrada = 'baja' then
    begin
      Result := Baja;
      Break;
    end
    else
      Writeln('Error: Prioridad debe ser "alta", "media" o "baja".');
  until False;
end;

function TareasPendienteCobro: real;
var
  i: integer; total: real;
begin
  total:= 0;
  for i:= 0 to TotalTareas do
      if Tareas[i].Estado = Pendiente then
         total:= (total + Tareas[i].Monto);
  result:= total;
end;//Fin Funcion calcular tareas pendientes de cobro

function TareasCobradas: real;
var
  i: integer; total: real;
begin
  total:=0;
  for i:=0 to TotalTareas do
      if Tareas[i].Estado = Completo then
         total:= (total + Tareas[i].Monto);
  result:= total;
end;//Fin Funcion calcular tareas cobradas

function EstadoToString(Estado: TEstado): string;
begin
  if Estado = Pendiente then
     result:= 'pendiente'
  else
      result:= 'completo'
end;

function PrioridadToString(Prioridad: TPrioridad): string;
begin
  case Prioridad of
    Alta: result:= 'alta';
    Media: result:= 'media';
    Baja: result:= 'baja';
  else
      result:= 'desconocida';
  end;
end;

procedure IngresarTarea;
begin
  if TotalTareas >= MAX_TAREAS then
  begin
    Writeln('Error: No se pueden agregar mas tareas. Limite alcanzado.');
    Exit;
  end;

  Inc(TotalTareas);
  Writeln;
  Writeln('=== INGRESAR NUEVA TAREA ===');

  Tareas[TotalTareas].ID := TotalTareas;
  Tareas[TotalTareas].Cliente := LeerCadenaNoVacia('Cliente: ');
  Tareas[TotalTareas].TipoTrabajo := LeerCadenaNoVacia('Tipo de trabajo: ');
  Tareas[TotalTareas].Monto := LeerMontoPositivo('Monto: ');
  Tareas[TotalTareas].Estado := LeerEstadoValido;
  Tareas[TotalTareas].Prioridad := LeerPrioridadValida;

  Writeln('Tarea registrada exitosamente. ID: ', TotalTareas);
end;

procedure MostrarListaTareas;
var i:integer;
begin
  if TotalTareas = 0 then
  begin
    writeln('No hay tareas registradas.');
    exit;
  end; // verificar que haya tareas registras para mostrar
  for i :=1 to TotalTareas do
  begin
    writeln('--- Tarea ', Tareas[i].ID,' ---'); // corchetes ASCII: 'Alt+91', 'Alt+93'
    writeln('Cliente: ', Tareas[i].Cliente);
    writeln('Tipo de trabajo: ', Tareas[i].TipoTrabajo);
    writeln('Valor: $', Tareas[i].Monto);
    writeln('Estado: ', Tareas[i].Estado);
    writeln('Prioridad: ', Tareas[i].Prioridad);
    writeln('');
  end;
  {No esta mostrando todas las tareas, solo muestra las ultimas 3
  y la tarea '0', la cual no tiene registros, salvo que muestra por pantalla
  Estado: Pendiente y Prioridad: Alta
  }
end;

procedure BuscarTareasClientes;
var
  clienteBuscado: string;
  i: integer;
  encontrado: boolean;
begin
  clienteBuscado := LeerCadenaNoVacia('Cliente a buscar: ');
  encontrado:= false;
  for i :=1 to TotalTareas do // variable global TotalTareas, tareas registradas
    begin
      if Tareas[i].Cliente = clienteBuscado then
      begin
           writeln('--- Tarea ', Tareas[i].ID,' ---');
           writeln('Cliente: ', Tareas[i].Cliente);
           writeln('Tipo de trabajo: ', Tareas[i].TipoTrabajo);
           writeln('Valor: $', Tareas[i].Monto);
           writeln('Estado: ', Tareas[i].Estado);
           writeln('Prioridad: ', Tareas[i].Prioridad);
           writeln;
           encontrado:= true;
      end;
    end;
  if not encontrado then
     writeln('El cliente no posee registro activo.');
end;

procedure BuscarTareasTipo;
var
  tipoBuscado: string;
  i: integer;
  encontrado: boolean;
begin
  {writeln('Ingrese el tipo de trabajo que necesita buscar:');
  readln(tipoBuscado);}
  tipoBuscado:= LeerCadenaNoVacia('Ingrese el tipo de trabajo a buscar:');
  encontrado:= false;
  for i :=1 to TotalTareas do // variable global TotalTareas, tareas registradas
    begin
      if Tareas[i].TipoTrabajo = tipoBuscado then
      begin
           //writeln('Busqueda exitosa !!');
           writeln('');
           writeln('--- Tarea ', Tareas[i].ID,' ---');
           writeln('Cliente: ', Tareas[i].Cliente);
           writeln('Tipo de trabajo: ', Tareas[i].TipoTrabajo);
           writeln('Valor: $', Tareas[i].Monto);
           writeln('Estado: ', Tareas[i].Estado);
           writeln('Prioridad: ', Tareas[i].Prioridad);
           encontrado:= true;
      end;
    end;
  if encontrado = false then
     writeln('No se ha encontrado el trabajo solicitado.');
end;

procedure MostrarMenu;
var
  Opcion: Char;
begin
  repeat
    ClrScr;
    Writeln('=== ORGANIZADOR DE TAREAS ===');
    Writeln('1. Ingresar nueva tarea');
    writeln('2. Mostrar lista de tareas');
    writeln('3. Buscar tareas por cliente');
    writeln('4. Buscar tareas por tipo de trabajo');
    writeln('5. Monto total cobrado');
    writeln('6. Monto total pendiente de cobro');
    Writeln('0. Salir');
    Writeln;
    Write('Seleccione opcion: ');
    Readln(Opcion);
    //Opcion := ReadKey;
    Writeln;

    case Opcion of
      '1': IngresarTarea;
      '2': MostrarListaTareas;//(Tareas, TotalTareas);
      '3': BuscarTareasClientes;//(Tareas);
      '4': BuscarTareasTipo;//(Tareas);
      '5': writeln('Monto total cobrado: $', TareasCobradas:0:2);
      '6': writeln('Monto total pendiente de cobro: $', TareasPendienteCobro:0:2);
      '0': Exit;
    else
      Writeln('Opcion no valida.');
    end;

    if Opcion <> '0' then
    begin
      Writeln;
      Write('Presione cualquier tecla para continuar...');
      ReadKey;
    end;
  until Opcion = '0';
end;

procedure TareasPrecargadas;
begin
  if TotalTareas <> 0 then exit; //Evita la carga
  TotalTareas := 25;

  Tareas[1].ID:= 1;
  Tareas[1].Cliente:= 'Gonzalez Perez';
  Tareas[1].TipoTrabajo:= 'Desarrollo web';
  Tareas[1].Monto:= 200000;
  Tareas[1].Estado:= Pendiente;
  Tareas[1].Prioridad:= Alta;

  Tareas[2].ID:= 2;
  Tareas[2].Cliente:= 'Gonzalez Perez';
  Tareas[2].TipoTrabajo:= 'Mantenimiento';
  Tareas[2].Monto:= 50000;
  Tareas[2].Estado:= Pendiente;
  Tareas[2].Prioridad:= Baja;

  Tareas[3].ID:= 3;
  Tareas[3].Cliente:= 'Gonzalez Perez';
  Tareas[3].TipoTrabajo:='Analisis';
  Tareas[3].Monto:= 200000;
  Tareas[3].Estado:= Pendiente;
  Tareas[3].Prioridad:= Alta;

  Tareas[4].ID:= 4;
  Tareas[4].Cliente:= 'Gonzalez Perez';
  Tareas[4].TipoTrabajo:= 'Pruebas';
  Tareas[4].Monto:= 75000;
  Tareas[4].Estado:= Completo;
  Tareas[4].Prioridad:= Media;

  Tareas[5].ID:= 5;
  Tareas[5].Cliente:= 'Gonzalez Perez';
  Tareas[5].TipoTrabajo:= 'Planificacion';
  Tareas[5].Monto:= 500000;
  Tareas[5].Estado:= Completo;
  Tareas[5].Prioridad:= Alta;
  //5TareasCargardas --- Gonzalez Perez;

  Tareas[6].ID:= 6;
  Tareas[6].Cliente:='Perez Garcia';
  Tareas[6].TipoTrabajo:= 'Planificacion';
  Tareas[6].Monto:= 85000;
  Tareas[6].Estado:= Pendiente;
  Tareas[6].Prioridad:= Media;

  Tareas[7].ID:= 7;
  Tareas[7].Cliente:= 'Perez Garcia';
  Tareas[7].TipoTrabajo:= 'Analisis';
  Tareas[7].Monto:= 56230;
  Tareas[7].Estado:= Pendiente;
  Tareas[7].Prioridad:= Baja;

  Tareas[8].ID:= 8;
  Tareas[8].Cliente:= 'Perez Garcia';
  Tareas[8].TipoTrabajo:= 'Desarrollo web';
  Tareas[8].Monto:= 500000;
  Tareas[8].Estado:= Completo;
  Tareas[8].Prioridad:= Alta;

  Tareas[9].ID:= 9;
  Tareas[9].Cliente:= 'Perez Garcia';
  Tareas[9].TipoTrabajo:= 'Mantenimiento';
  Tareas[9].Monto:= 35000;
  Tareas[9].Estado:= Pendiente;
  Tareas[9].Prioridad:= Media;

  Tareas[10].ID:= 10;
  Tareas[10].Cliente:= 'Perez Garcia';
  Tareas[10].TipoTrabajo:= 'Pruebas';
  Tareas[10].Monto:= 20000;
  Tareas[10].Estado:= Completo;
  Tareas[10].Prioridad:= Baja;
  //10TareasCargadas --- Perez Garcia;

  Tareas[11].ID:= 11;
  Tareas[11].Cliente:=' Perez Gonzalez';
  Tareas[11].TipoTrabajo:= 'Mantenimiento';
  Tareas[11].Monto:= 150000;
  Tareas[11].Estado:= Pendiente;
  Tareas[11].Prioridad:= Media;

  Tareas[12].ID:= 12;
  Tareas[12].Cliente:= 'Perez Gonzalez';
  Tareas[12].TipoTrabajo:= 'Desarrollo web';
  Tareas[12].Monto:= 850000;
  Tareas[12].Estado:= Pendiente;
  Tareas[12].Prioridad:= Alta;

  Tareas[13].ID:= 13;
  Tareas[13].Cliente:= 'Perez Gonzalez';
  Tareas[13].TipoTrabajo:= 'Analisis';
  Tareas[13].Monto:= 65400;
  Tareas[13].Estado:= Completo;
  Tareas[13].Prioridad:= Media;

  Tareas[14].ID:= 14;
  Tareas[14].Cliente:= 'Perez Gonzalez';
  Tareas[14].TipoTrabajo:= 'Planificacion';
  Tareas[14].Monto:= 958000;
  Tareas[14].Estado:= Completo;
  Tareas[14].Prioridad:= Baja;

  Tareas[15].ID:= 15;
  Tareas[15].Cliente:= 'Perez Gonzalez';
  Tareas[15].TipoTrabajo:= 'Pruebas';
  Tareas[15].Monto:= 95000;
  Tareas[15].Estado:= Completo;
  Tareas[15].Prioridad:= Media;
  //15TareasCargadas --- Perez Gonzalez;

  Tareas[16].ID:= 16;
  Tareas[16].Cliente:= 'Gonzalez Garcia';
  Tareas[16].TipoTrabajo:= 'Analisis';
  Tareas[16].Monto:= 95000;
  Tareas[16].Estado:= Completo;
  Tareas[16].Prioridad:= Baja;

  Tareas[17].ID:= 17;
  Tareas[17].Cliente:= 'Gonzalez Garcia';
  Tareas[17].TipoTrabajo:= 'Desarrollo web';
  Tareas[17].Monto:= 850000;
  Tareas[17].Estado:= Pendiente;
  Tareas[17].Prioridad:= ALta;

  Tareas[18].ID:= 18;
  Tareas[18].Cliente:= 'Gonzalez Garcia';
  Tareas[18].TipoTrabajo:= 'Mantenimiento';
  Tareas[18].Monto:= 65000;
  Tareas[18].Estado:= Pendiente;
  Tareas[18].Prioridad:= Media;

  Tareas[19].ID:= 19;
  Tareas[19].Cliente:= 'Gonzalez Garcia';
  Tareas[19].TipoTrabajo:= 'Pruebas';
  Tareas[19].Monto:= 56800;
  Tareas[19].Estado:= Completo;
  Tareas[19].Prioridad:= Baja;

  Tareas[20].ID:= 20;
  Tareas[20].Cliente:= 'Gonzalez Garcia';
  Tareas[20].TipoTrabajo:= 'Planificacion';
  Tareas[20].Estado:= Completo;
  Tareas[20].Monto:= 256421;
  Tareas[20].Prioridad:= Media;
  //20TareasCargadas --- Gonzalez Garcia;

  Tareas[21].ID:= 21;
  Tareas[21].Cliente:= 'Garcia Gonzalez';
  Tareas[21].TipoTrabajo:= 'Pruebas';
  Tareas[21].Monto:= 56231;
  Tareas[21].Estado:= Pendiente;
  Tareas[21].Prioridad:= Baja;

  Tareas[22].ID:= 22;
  Tareas[22].Cliente:= 'Garcia Gonzalez';
  Tareas[22].TipoTrabajo:= 'Analisis';
  Tareas[22].Monto:= 869874;
  Tareas[22].Estado:= Pendiente;
  Tareas[22].Prioridad:= ALta;

  Tareas[23].ID:= 23;
  Tareas[23].Cliente:= 'Garcia Gonzalez';
  Tareas[23].TipoTrabajo:= 'Planificacion';
  Tareas[23].Monto:= 789641;
  Tareas[23].Estado:= Pendiente;
  Tareas[23].Prioridad:= Alta;

  Tareas[24].ID:= 24;
  Tareas[24].Cliente:= 'Garcia Gonzalez';
  Tareas[24].TipoTrabajo:= 'Desarrollo web';
  Tareas[24].Monto:= 456321;
  Tareas[24].Estado:= Pendiente;
  Tareas[24].Prioridad:= Media;

  Tareas[25].ID:= 25;
  Tareas[25].Cliente:= 'Garcia Gonzalez';
  Tareas[25].TipoTrabajo:= 'Mantenimiento';
  Tareas[25].Monto:= 52300;
  Tareas[25].Estado:= Pendiente;
  Tareas[25].Prioridad:= Baja;
  //25TareasCargadas ---Garcia Gonzalez;
{Cargar TRegistroTarea - con 25 tareas predeterminadas
Clientes -> Gonzalez Perez; Perez Garcia; Perez Gonzalez; Gonzalez Garcia; Garcia Gonzalez;
TipoTrabajo -> Planificación; Análisis; Desarrollo web; Pruebas; Mantenimiento.
}
end; //Fin de Precarga


// Programa principal !!
begin
  ClrScr;
  TotalTareas := 0;

  TareasPrecargadas;
  MostrarMenu;
  Writeln('Programa finalizado.');
  readln();
end.
