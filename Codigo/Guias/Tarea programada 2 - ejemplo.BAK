% Author:  José Enrique Araya Monge
% Date: 29/04/2011

%========= Relaciones que definen el mecanismo genérico de resolución =========

% La relación test_puzzle/2 define un acertijo (puzzle/4) como un cuádruple que consiste de:
%   a) Structure: una estructura con los datos a determinar.
%   b) Clues: una lista de pistas que van instanciando los elementos de la estructura.
%   c) Queries: una lista de consultas a la estructura para responder a las preguntas.
%   d) Solution: una lista con las respuestas del acertijo.

test_puzzle(Name,puzzle(Structure,Clues,Queries,Solution)):-
   structure(Name,Structure),
   clues(Name,Structure,Clues),
   queries(Name,Structure,Queries,Solution).


% La relación solve_puzzle/2 es el mecanismo por el cual se resuelve el acertijo.
% Simplemente se toma un acertijo con sus cuatro componentes. Va instanciando
% la estructura al ir resolviendo las pistas y las consultas.

solve_puzzle(puzzle(Structure, Clues,Queries,Solution),Solution):-
   solve(Clues),solve(Queries).

   
% La relación solve/1 va tomando uno por uno los elementos de las listas
% ya sea de pistas o de consultas y los resuelve.
% Nótese cómo solve toma el car de la lista de entrada y en la parte derecha
% usa ese car como meta a resolver.

solve([Clue|Clues]):-Clue,solve(Clues).
solve([]).


% Para mayor claridad se incluyó una relación que imprime en
% diferentes líneas las entradas de una lista.
% Se usará para mostrar Structure.
mostrar([]).
mostrar([C|Cs]) :- writeln(C),mostrar(Cs).


% Esta es la relación a llamar para resolver un acertijo.
% Ejemplo de uso:
%    ?- resolver(viajes, Struct, Sol).
%    viaje(4,peck,protestas)
%    viaje(5,maddy,olimpiadas)
%    viaje(6,linda,eleccion)
%    viaje(7,tam,boda)
%    Struct = [viaje(4, peck, protestas), viaje(5, maddy, olimpiadas),
%              viaje(6, linda, eleccion), viaje(7, tam, boda)],
%    Sol = [['Las olimpiadas fueron cubiertas por ', maddy]]
%
% La línea "Struct = ..." se formateo para mayor legibilidad.

% resolver/3 recibe el nombre del acertijo y produce la solución; 
% se incluye Structure entre los términos de resolver para que se pueda ver. 
% Si no se incluye, Prolog lo usará internamente pero no lo mostrará.
% Eso haría más difícil la depuración.

resolver(Acertijo, Structure, Solucion) :-
         test_puzzle(Acertijo,Puzzle),    % Primero define el cuádruple usando el nombre.
         Puzzle=puzzle(Structure,_,_,_),  % Se extrae la estructura del cuádruple para poder ver y depurar.
         solve_puzzle(Puzzle,Solucion),   % Aplica las pistas y consultas y obtiene la solución.
         mostrar(Structure).              % Muestra estructura en forma legible.

         
%========= Relaciones específicas para un acertijo dado =========

% structure crea para un acertijo dado una lista con los elementos
% a determinar. Como no se ha resuelto aún todas las partes de los
% elementos están sin instanciar:
%       viaje(Dia,Periodista,Evento)

% A veces es posible instanciar una parte; en este caso es la posición ocupada.
% structure(NombreAcertijo, ListaConElementosADeterminar)

structure(viajes,[viaje(4,_,_),
                  viaje(5,_,_),
                  viaje(6,_,_),
                  viaje(7,_,_)]).


% Implementa las pistas dadas.
% Cada pista es un elemento de una lista. 
% Cada una de ellas es una meta a resolver que va
% instanciando los elementos de la estructura.

clues(
      viajes,   % identifica las pistas como del acertijo "viajes"
      Viajes,   % la estructura del acertijo va atando todo
      
   [ pista1(Viajes),  % resuelve pista1 y va instanciando elementos de Viaje
     pista2(Viajes),  % resuelve pista2 y va instanciando elementos de Viaje
     pista3(Viajes),  % idem
     pista4(Viajes),  % idem
     pista5(Viajes)   % idem
   ]).

% Esta relación hace consultas a la estructura común y luego
% prepara las respuestas del enunciado.
queries(
        viajes, % identifica las pistas como del acertijo "viajes"
        Viajes, % la estructura del acertijo va atando todo
        
        % Preguntas a la estructura
        [ 
          % Preguna ¿Quién cubrió las olimipiadas?
          member(viaje(_,QuienCubrioOlimpiadas,olimpiadas),Viajes)
        ],
        
        % Respuestas pedidas. Usa los valores determinados en la lista anterior.
        [
          ['Las olimpiadas fueron cubiertas por ', QuienCubrioOlimpiadas]
        ]).

% Implementación de las pistas.
% Es mejor que cada pista sea un predicado aparte porque si se unen se debe
% evitar que haya variables comunes entre pistas. Toda conexión debe hacerse
% por medio de la estructura.

% 1. El periodista enviado el 7 de abrir fue a informar sobre la boda real.
pista1(E) :- member(viaje(7,_,boda),E).

% 2. Los cuatro periodistas son:
%      el enviado el 5 de abril
%      Tam Terry
%      la persona que cubrió las protestas masivas
%      el periodista que cubrió la elección.
pista2(E) :- select(viaje(5,_,_),E,E2),
             select(viaje(_,tam,_),E2,E3),
             select(viaje(_,_,protestas),E3,E4),
             select(viaje(_,_,eleccion),E4,_).
             
% 3. Peter Peck salió 2 días antes que el periodista que cubrió la elección.
pista3(E) :- select(viaje(D2,_,eleccion),E,E2),
             select(viaje(D1,peck,_),E2,_),
             D2 is D1+2.

% Incluir la estructura explícitamente en cada pista hace muy laborioso
% cambiarla si se incluye un nuevo campo o si se quita un campo.
% Por eso es mejor usar predicados que accedan al campo de la estructura
% que interesa. Los predicados periodista/1, evento/1  y dia/1 permiten
% modificar la estructura sin que se tenga que cambiar el código de las
% pistas 4 y 5.

% 4. La persona que salió el 6 de abril fue
%        Maddy Moore o el reportero que cubrió la elección.

% maddy salió el 6 de abril
pista4(E) :- periodista(maddy,V1),dia(6,V1),select(V1,E,E2),
             evento(eleccion,V2),member(V2,E2).
             
% el que cubrió la elección salió el 6 de abril
pista4(E) :- evento(eleccion,V1),dia(6,V1),select(V1,E,E2),
             periodista(maddy,V2),member(V2,E2).
             
%5. Linda Lott es una de las periodistas.
pista5(E) :- periodista(linda,V),member(V,E).


% periodista/1, evento/1 y dia/1 extraen o definen;
% esto es: funcionan en ambas direcciones, pueden extraer
% un campo de un viaje dado, o pueden crear un viaje con
% un campo dado.
periodista(P,viaje(_,P,_)).
evento(Ev,viaje(_,_,Ev)).
dia(D,viaje(D,_,_)).

