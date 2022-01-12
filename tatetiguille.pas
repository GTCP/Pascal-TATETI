program TaTeTiGuille;
uses Crt;
const
    minf=1;
    maxf=3;
    minc=1;
    maxc=3;
type
    tablero=array[minf..maxf,minc..maxc] of char;

procedure mostrartablero (tab:tablero);
{procedimiento encargado de limpiar y mostrar la matriz tablero}
var
    fila,columna:integer;
begin
    clrscr;
    writeln('       1       2       3      ');
    writeln();
    writeln('   +   -   +   -   +   -   +  ');
    writeln();

    for fila:=minf to maxf do
    begin
        write(fila,'  |   ');
        for columna:=minc to maxc do
        begin
            write(tab[fila,columna],'   |   ');
        end;
        writeln();
        writeln();
        writeln('   +   -   +   -   +   -   +  ');
        writeln();
    end;
end;

function comprobarGanador(tab:tablero): boolean;
{funcion que comprueba las formas en las que se puede ganar el juego(8) sin incluir en ese conteo la rendicionvoluntaria del enemigo(0,0)}
var
    gano:boolean;
    fila, columna:integer;
begin
    gano:=false;
{comprobacion de filas}
    for fila:=minf to maxf do
        if((tab[fila,1] = tab[fila,2]) and (tab[fila,1] = tab[fila,3]) and (tab[fila,1] <> ' ')) then
        begin
            gano:=true;
        end;

{comprobacion de columnas}
    for columna:=minc to maxc do
        if((tab[1,columna] = tab[2,columna]) and (tab[1,columna] = tab[3, columna]) and (tab[1,columna] <> ' ')) then
        begin
            gano:=true;
        end;

{comprobacion de diagonales}
    if(
        ((tab[1,1] = tab[2,2]) and (tab[1,1] = tab[3,3]) and (tab[1,1] <> ' ')) or
        ((tab[3,1] = tab[2,2]) and (tab[3,1] = tab[1,3]) and (tab[3,1] <> ' '))
        ) then
    begin
        gano:=true;
    end;

    comprobarGanador := gano;
end;

procedure definirparticipantes(var jugador1,jugador2:string;var inicial1,inicial2:char);
{procedimiento que pide sus respectivos nombres y letras para que los 2 jugadores se puedan identificar a la hora de jugar con su ficha}
begin
    writeln('Jugador 1, ingrese su nick');
    readln(jugador1);
    write(jugador1);
    writeln(' , Ingrese la letra que lo representara');
    readln(inicial1);
    writeln('Jugador 2, ingrese su nick');
    readln(jugador2);
    while (jugador1=jugador2) do
    begin
        writeln(' jugador2 invalido, ingrese uno diferente al jugador1');
        readln(jugador2);
    end;
    write(jugador2);
    writeln(' , Ingrese la letra que lo representara');
    readln(inicial2);
    while (inicial1=inicial2) do
    begin
        writeln('inicial2 invalida, ingrese uno diferente al jugador1');
        readln(inicial2);
    end;

end;

procedure inicializarTablero(var tab:tablero);
{procedimiento que inicializa el tablero en vacio para no tener basura}
var
fila,columna:integer;
begin
    for fila:=minf to maxf do
        for columna:=minc to maxc do
         tab[fila,columna]:= ' ';
end;

function selecciondejugador():integer;
{funcion encargada de que se genere aleatoriamente quien arranca primero a colocar las fichas}
var
    nro:integer;
begin
    randomize();
    nro:=random(2)+1;
    selecciondejugador:=nro;
end;

function obtenerPosiciones(var fila,columna:integer):boolean;
{encontre este error a ultimo minuto y para el tiempo que me llevaba arreglarlo no sabia si llegaba,ya que a esta funcion la llaman 4 veces en todo el programa, lo deje por que compilaba,verifica que no se salgan de la matriz y acepta la ubicacion 0,0 para luego poder rendirse,al tener var se modifican las filas y las columnas ingresadas en al matriz}
begin
    readln(fila,columna);
    while ((((fila<1) or (fila>3)) or ((columna<1) or (columna >3)))  and ((columna<>0) or (fila<>0))) do
    begin
        writeln('Valor invalido reingrese');
        readln(fila,columna);
    end;
    if((columna = 0) and (fila = 0)) 
    then
    begin
        obtenerPosiciones := true;
    end
    else
    begin
        obtenerPosiciones := false;
    end;
end;

procedure colocarficha(var tab:tablero;inicial:char;fila,columna:integer);
{procedimiento encargado de colocar la inicial y luego mostrarla el tablero}
begin
    tab[fila,columna]:=inicial;
    mostrartablero(tab);
end;

procedure colocaciones(var cerrar, ganador:boolean;var jugadoractual:integer;var tab:tablero;inicial1,inicial2:char;jugador1,jugador2:string);
{procedimiento que se asegura que pida 6 veces colocar las letras en representacion de fichas mientras no se termine y no haya ganador ademas de que no se puedan pisar entre si, en todo momento muestra el tablero,y te va guiando en la interfaz de como proceder}
var
    fila,columna,repe:integer;
    vacio: boolean;
begin
    repe:=0;
    cerrar:=false;
    ganador:=false;
    while ((repe < 6) and (not cerrar) and (ganador = false)) do
    begin
        vacio := false;
        if (jugadoractual=1) 
        then
        begin
            mostrartablero(tab);
            while((vacio = false) and (not cerrar)) do
            begin
                writeln('Es el turno de ',jugador1,' ponga la fila,enter y luego coloque la columna de su ficha,presione enter al finalizar');
                cerrar := obtenerPosiciones(fila,columna);
                if (not cerrar) then
                begin
                    if(tab[fila][columna] = ' ') 
                    then
                    begin
                        colocarficha(tab,inicial1,fila,columna);
                        vacio := true;
                    end;
                end;
            end;
            jugadoractual := 2;
        end
        else 
        begin
            mostrartablero(tab);
            while((vacio = false) and (not cerrar)) do
            begin
                writeln('Es el turno de ',jugador2,' ponga la fila,pulse enter y luego coloque la columna de su ficha,presione enter al finalizar');
                cerrar := obtenerPosiciones(fila,columna);
                if (not cerrar) then
                begin
                    if(tab[fila][columna] = ' ') 
                    then
                    begin
                        colocarficha(tab,inicial2,fila,columna);
                        vacio := true;
                    end;
                end;
            end;
            jugadoractual := 1;
        end;
        repe:=repe+1;
        if(cerrar = false) then begin
            ganador := comprobarGanador(tab);
        end;
    end;
end;

function rangovalido(fila, filaDestino, columna, columnaDestino:integer):boolean;
{funcion encargada de verificar el rango permitido por las reglas de tres en raya de 1 casillero por jugada y limitar los movimientos desde los 4 lugares que no pueden mover de forma diagonal}
var 
    distanciaFila, distanciaColumna: integer;
begin
    distanciaFila := fila-filaDestino;
    distanciaColumna := columna-columnaDestino;
    if((distanciaFila >= -1) and (distanciaFila <= 1) and
        (distanciaColumna >= -1) and (distanciaColumna <= 1)) 
        then
    begin
        if((distanciaColumna <> 0) AND (distanciaFila<>0)) 
        then
        begin
            if(
                ((fila=2) and (columna = 1)) or
                ((fila=1) and (columna = 2)) or
                ((fila=3) and (columna = 2)) or
                ((fila=2) and (columna = 3))  )
            then
            begin
                rangoValido := false;
            end
            else
            begin
                rangoValido := true;
            end;
        end 
        else 
        begin
            rangoValido := true;
        end;
    end 
    else 
    begin
        rangoValido := false;
    end;
end;

procedure realizarMovimiento(var tab:tablero; jugador:string; inicial:char; var cerrar:boolean);
{procedimiento que muestra por pantalla quien es el jugador que le toca mover,elija si ficha,verifica su rango de movimiento osea 1 casillero y los que correspondientes que puedan lo mismo de manera adyacente tambien,mueven siempre sino termino,cerro,y esta libre la ubicacion, en todo momento el tablero esta mostrandose actualizado}
var
    fila,columna, filadestino, columnadestino:integer;
    movi:boolean;
begin
    movi := false;
    while((movi = false) and (not cerrar)) do
    begin
        writeln('Es el turno de ',jugador,' ponga la fila toque enter y la columna de la ficha que quiere mover');
        cerrar := obtenerPosiciones(fila,columna);
        if(cerrar = false) 
        then
        begin
            if((tab[fila][columna] = inicial) and (not cerrar)) 
            then
            begin
                writeln('Ponga la fila toque enter y la columna de la nueva ubicacion');
                cerrar := obtenerPosiciones(filadestino,columnadestino);
                if(cerrar = false) 
                then
                begin
                    if(rangoValido(fila, filadestino, columna, columnadestino)) then
                    begin
                        if((tab[filadestino][columnadestino] = ' ') and (not cerrar)) then
                        begin
                            tab[fila][columna] := ' ';
                            tab[filadestino][columnadestino] := inicial;
                            movi := true;
                            mostrartablero(tab);
                        end 
                        else 
                        begin
                            mostrartablero(tab);
                            writeln('Ubicacion ocupada por: [',tab[filadestino][columnadestino],']');
                        end;
                    end 
                    else 
                    begin
                        mostrartablero(tab);
                        writeln('Movimiento invalido');
                    end;
                end;
            end else begin
                mostrartablero(tab);
                writeln('Esta no es su ficha');
            end;
        end;
    end;

end;

procedure movimientos(var cerrar:boolean;var tab:tablero;var jugadoractual:integer; inicial1,inicial2:char;jugador1,jugador2:string);
{procedimiento en el cual el jugador luego de pasar las verificaciones de que el juego no termino y no hubo ganador dependiendo el jugador que sea movera su ficha,si el juego sigue sin terminar vuelve a comprobar ganadores}
var
    ganador:boolean;
begin
    cerrar := false;
    ganador:= false;
    while((cerrar = false) and (not ganador)) do
    begin
        if (jugadoractual=1) then
        begin
            realizarMovimiento(tab, jugador1, inicial1, cerrar);
            jugadoractual := 2;
        end
        else
        begin
            realizarMovimiento(tab, jugador2, inicial2, cerrar);
            jugadoractual := 1;
        end;
        if(cerrar = false) 
        then 
        begin
            ganador := comprobarGanador(tab);
        end;
    end;
end;

procedure rendicionVoluntaria(jugadoractual:integer; jugador1,jugador2:string);
{procedimiento encargado de mostrar por pantalla cual de los 2 jugadores dependiendo quien sea el jugadoractual quien se rindio,perdio.}
begin
    if(jugadoractual=2)
    then
    begin
        writeln('Jugador se rinde, pierde el juego: ', jugador1);
    end 
    else 
    begin
        writeln('Jugador se rinde, pierde el juego: ', jugador2);
    end;
end;

procedure mostrarGanador(jugadoractual:integer; jugador1,jugador2:string);
{procedimiento encargado de mostrar por pantalla cual de los 2 jugadores dependiendo quien sea el jugadoractual quien es el winner}
begin
    if(jugadoractual=2) 
    then
    begin
        writeln('Ganador: ', jugador1);
    end 
    else 
    begin
        writeln('Ganador: ', jugador2);
    end;
end;

Procedure Jugar;
{procedimiento encargado de tener todas las variables que utilizaran los demas procedimientos y funciones,invoca lo siguiente para:limpiar la pantalla,inicializarla,define los nombres,letras,que empiece aleatorio,mostrar la matriz en todo momento,coloca las fichas,verifica que esten bien colocadas,por limitacion,por ocupe o por si se quiere rendir al mismo tiempo, si alguien gano.Luego las mueve y verifica lo anterior ademas de que solo se puedan mover de a 1 casillero y las correspondientes en forma adyacente} 
Var
    Tab:Tablero;
    Jugador1,Jugador2:String;
    Inicial1,Inicial2:Char;
    Jugadoractual:Integer;
    Cerrar,Ganador:Boolean;
Begin
    Clrscr;
    InicializarTablero(Tab);
    Definirparticipantes(Jugador1,Jugador2,Inicial1,Inicial2);
    Jugadoractual:=Selecciondejugador;
    Colocaciones(Cerrar,Ganador,Jugadoractual,Tab,Inicial1,Inicial2,Jugador1,Jugador2);
    If(Ganador=False) 
    Then
    Begin
        If(Cerrar=False) 
        Then
        Begin 
            Movimientos(Cerrar,Tab,Jugadoractual,Inicial1,Inicial2,Jugador1,Jugador2);
            If(cerrar) 
            Then
            Begin
                RendicionVoluntaria(Jugadoractual,Jugador1,Jugador2);
            End;
        End 
        Else
        Begin
            RendicionVoluntaria(Jugadoractual,Jugador1,Jugador2);
        End;
    End;

    If (Cerrar=False) 
    Then
    Begin
        MostrarGanador(Jugadoractual,Jugador1,Jugador2);
    End;
    
End;

Begin 
{programa,solo ejecuta al procedimiento principal}
    Jugar;
End.