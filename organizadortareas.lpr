program organizadortareas;

//{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  SysUtils, CRT;

const
  MAX_TAREAS = 100;

type
  TEstado = (epPendiente, epCompleto);
  TPrioridad = (epAlta, epMedia, epBaja);

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
      Result := epPendiente;
      Break;
    end
    else if Entrada = 'completo' then
    begin
      Result := epCompleto;
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
      Result := epAlta;
      Break;
    end
    else if Entrada = 'media' then
    begin
      Result := epMedia;
      Break;
    end
    else if Entrada = 'baja' then
    begin
      Result := epBaja;
      Break;
    end
    else
      Writeln('Error: Prioridad debe ser "alta", "media" o "baja".');
  until False;
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

procedure MostrarListaTareas(Tareas: array of TRegistroTarea; cant: integer);
var i:integer;
begin
  //i:= 0;
  if cant= 0 then
  begin
    writeln('No hay tareas registradas.');
    exit;
  end; // verificar que haya tareas registras para mostrar
  for i :=1 to cant do
      // corchetes ASCII: 'Alt+91', 'Alt+93'
  begin
    writeln('--- Tarea ', Tareas[i].ID,' ---');
    writeln('Cliente: ', Tareas[i].Cliente);
    writeln('Tipo de trabajo: ', Tareas[i].TipoTrabajo);
    writeln('Valor: $', Tareas[i].Monto);
    writeln('Estado: ', Tareas[i].Estado);
    writeln('Prioridad: ', Tareas[i].Prioridad);
  end;
end;

procedure BuscarTareasClientes(Tareas: array of TRegistroTarea);
var
  clienteBuscado: string;
  i: integer;
  encontrado: boolean;
begin
  writeln('Ingrese nombre del cliente a buscar:');
  readln(clienteBuscado);
  encontrado:= false;
  for i :=1 to TotalTareas do // variable global TotalTareas, tareas registradas
    begin
      if Tareas[i].Cliente = clienteBuscado then
      begin
           writeln('Busqueda exitosa !!');
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
     writeln('Cliente no registrado. No se han encontrado tareas.');
end;

procedure MostrarMenu;
var
  Opcion: Char;
begin
  repeat
    ClrScr;
    Writeln('=== ORGANIZADOR DE TAREAS ===');
    Writeln('1. Ingresar nueva tarea');
    Writeln('2. Salir');
    Writeln;
    Write('Seleccione opcion: ');

    Opcion := ReadKey;
    Writeln;

    case Opcion of
      '1': IngresarTarea;
      '2': Exit;
    else
      Writeln('Opcion no valida.');
    end;

    if Opcion <> '2' then
    begin
      Writeln;
      Write('Presione cualquier tecla para continuar...');
      ReadKey;
    end;
  until Opcion = '2';
end;

// Programa principal !!
begin
  ClrScr;
  TotalTareas := 0;
  MostrarMenu;
  Writeln('Programa finalizado.');

end.
