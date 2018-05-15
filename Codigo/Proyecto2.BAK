% Autor: José Navarro Acuña
% Fecha: 13/5/2018

test_puzzle(Name,puzzle(Structure,Clues,Queries,Solution)):-
   structure(Name,Structure),
   clues(Name,Structure,Clues),
   queries(Name,Structure,Queries,Solution).
   
solve_puzzle(puzzle(Structure, Clues,Queries,Solution),Solution):-
   solve(Clues),solve(Queries).
   
solve([Clue|Clues]):-Clue,solve(Clues).
solve([]).

mostrar([]).
mostrar([C|Cs]) :- writeln(C),mostrar(Cs).

resolver(Acertijo, Structure, Solucion) :-
         test_puzzle(Acertijo,Puzzle),    % Primero define el cuádruple usando el nombre.
         Puzzle=puzzle(Structure,_,_,_),  % Se extrae la estructura del cuádruple para poder ver y depurar.
         solve_puzzle(Puzzle,Solucion),   % Aplica las pistas y consultas y obtiene la solución.
         mostrar(Structure).              % Muestra estructura en forma legible.


structure(smoothies, [orden(5, _, _, _),
                      orden(6, _, _, _),
                      orden(7, _, _, _),
                      orden(8, _, _, _),
                      orden(9, _, _, _),
                      orden(10, _, _, _)]). % orden(Precio, Cliente, SuperAlimento)
                  
clues(
      smoothies,   % identifica las pistas como del acertijo "smoothies"
      Smoothies,   % la estructura del acertijo va atando todo

   [
     pista4(Smoothies)
     % Pregunta: 11.    ¿Quién pidió mandarina?
   ]).
   
queries(
        smoothies, % identifica las pistas como del acertijo "smoothies"
        Smoothies, % la estructura del acertijo va atando todo

        % Preguntas a la estructura
        [
          member(orden(_,QuienPidioMadarina, _, mandarina),Smoothies)
        ],

        % Respuestas pedidas. Usa los valores determinados en la lista anterior.
        [
          ['La persona que pidio mandarina fue ', QuienPidioMadarina]
        ]).

%
% Cliente: amelia, mercedes, paulette, isabel, otis
% Super alimento: pasto de trigo, semilla de lino, gengibre, semillas de chia, quinoa
% Fruta: frambuesas, arándanos, bananos, naranjas, mandarinas
%

% 1. El cliente que pagó $6 no pidió arándanos.
pista1(E):-precio(6,V1), select(V1,E,E2),
           fruta(arandanos,V2), member(V2,E2).
% obtengo la orden con un pago de $6, obtengo la lista de ordenes sin esa
% orden de $6, luego obtengo la orden de arandanos y hago match con las ordenes
% restantes (sin contar la de $6)


% 2. El cliente que ordenó semilla de lino pagó más que la persona que ordenó pasto de trigo.
pista2(E):-superAlimento(semillaDeLino,V1). % PrecioPagado is obtener precio de la semillaDeLino
% NO SE


% 3. Isabel pidió semillas de chia.
pista3(E):-cliente(isabel,V1),superAlimento(semillasDeChia,V1),member(V1,E).

% 4. El cliente que solicitó gengibre es Paulette o es la persona que pagó $10.
  % - El cliente que solicitó gengibre es Paulette
pista4(E):- cliente(paulette,V1),superAlimento(gengibre,V1),member(V1,E).

% - ó El cliente que solicitó gengibre es la persona que pagó $10.
pista4(E):-superAlimento(gengibre,V1),precio(10,V1),select(V1,E,E2),
           cliente(paulette,V2),member(V2,E2).

% 5. Paulette, el cliente que pidió arándanos y la persona que pidió naranjas, son tres personas distintas.


% 6. El cliente que pidió naranjas pagó 1 dólar más que la persona que pidió bananos.

% 7. Otis, o pagó $6 o pagó $10.
 % - Otis pagó $6
pista7(E):-cliente(otis,V1),precio(6,V1),member(V1,E).

 % - u Otis pagó 10
pista7(E):-cliente(otis,V1),precio(10,V1),member(V1,E).

% 8. La persona que pidió quinoa pagó $3 más que Mercedes.
pista8(E):-superAlimento(quinoa,V1), cliente(mercedes,V2),
           precio(W,V2), precio(Q,V1), (W + 3) = Q, member(V1,E).
% NO ESTOY SEGURO.

% 9. Sobre Paulette y la persona que ordenó frambuesas: una pidió pasto de trigo y la otra persona pagó $8.

% 10. Isabel pagó 3 dólares menos que Amelia.



cliente(Cliente,orden(_,Cliente,_,_)).
superAlimento(SuperAlimento,orden(_,_,SuperAlimento,_)).
fruta(Fruta,orden(_,_,_,Fruta)).
precio(Precio,orden(Precio,_,_,_)).
