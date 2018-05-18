% Autor: Jos� Navarro Acu�a
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
         test_puzzle(Acertijo,Puzzle),    % Primero define el cu�druple usando el nombre.
         Puzzle=puzzle(Structure,_,_,_),  % Se extrae la estructura del cu�druple para poder ver y depurar.
         solve_puzzle(Puzzle,Solucion),   % Aplica las pistas y consultas y obtiene la soluci�n.
         mostrar(Structure).              % Muestra estructura en forma legible.


structure(smoothies, [orden(6, _, _, _),
                      orden(7, _, _, _),
                      orden(8, _, _, _),
                      orden(9, _, _, _),
                      orden(10, _, _, _)
                      ]). % orden(Precio, Cliente, SuperAlimento, Fruta)

structure(cruceros, [viaje(_,_,_,1983),
                     viaje(_,_,_,1984),
                     viaje(_,_,_,1985),
                     viaje(_,_,_,1986),
                     viaje(_,_,_,1987),
                     viaje(_,_,_,1988),
                     viaje(_,_,_,1989)
                     ]). % viaje(Viajero, Crucero, Destino, A�o)

clues(
      smoothies,   % identifica las pistas como del acertijo "smoothies"
      Smoothies,   % la estructura del acertijo va atando todo

   [ pista1(Smoothies),
     pista2(Smoothies),
     pista3(Smoothies),
     pista4(Smoothies),
     pista5(Smoothies),
     pista6(Smoothies),
     pista7(Smoothies),
     pista8(Smoothies),
     pista9(Smoothies),
     pista10(Smoothies)
     % Pregunta: 11.    �Qui�n pidi� mandarina?
   ]).
   
clues(
      viajes,   % identifica las pistas como del acertijo "smoothies"
      Viajes,   % la estructura del acertijo va atando todo

   [ pista1(Viajes),
     pista2(Viajes),
     pista3(Viajes),
     pista4(Viajes),
     pista5(Viajes),
     pista6(Viajes),
     pista7(Viajes),
     pista8(Viajes),
     pista9(Viajes),
     pista10(Viajes),
     pista11(Viajes),
     pista12(Viajes),
     pista13(Viajes),
     pista14(Viajes),
     pista15(Viajes),
     pista16(Viajes)
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



% CASO 1: Smoothies
%
% Cliente: amelia, mercedes, paulette, isabel, otis
% Super alimento: pasto de trigo, semilla de lino, gengibre, semillas de chia, quinoa
% Fruta: frambuesas, ar�ndanos, bananos, naranjas, mandarinas
%
% resolver(smoothies, Struct, Sol).
%

% 1. El cliente que pag� $6 no pidi� ar�ndanos.
pista1(E):-precio(6,V1), select(V1,E,E2),
           fruta(arandanos,V2), member(V2,E2).
% obtengo la orden con un pago de $6, obtengo la lista de ordenes sin esa
% orden de $6, luego obtengo la orden de arandanos y hago match con las ordenes
% restantes (sin contar la de $6)


% 2. El cliente que orden� semilla de lino pag� m�s que la persona que orden� pasto de trigo.
pista2(E):-superAlimento(semillaDeLino,V1), precio(PrecioSemillaDeLino,V1),
           member(V1,E), select(V1,E,E2),
           superAlimento(pastoDeTrigo,V2), precio(PrecioPastoDeTrigo,V2),
           member(V2,E2), select(V2,E2,_),
           PrecioSemillaDeLino > PrecioPastoDeTrigo.

% 3. Isabel pidi� semillas de chia.
pista3(E):-cliente(isabel,V1),superAlimento(semillasDeChia,V1),member(V1,E).

% 4. El cliente que solicit� gengibre es Paulette o es la persona que pag� $10.
  % - El cliente que solicit� gengibre es Paulette
pista4(E):-cliente(paulette,V1), superAlimento(gengibre,V1), select(V1,E,E2),
           precio(10,V2), member(V2,E2).

  % - � El cliente que solicit� gengibre es la persona que pag� $10.
pista4(E):-superAlimento(gengibre,V1), precio(10,V1), select(V1,E,E2),
           cliente(paulette,V2), member(V2,E2).

% 5. Paulette, el cliente que pidi� ar�ndanos y la persona que pidi� naranjas, son tres personas distintas.
pista5(E):-fruta(arandanos,V1), select(V1,E,E2),
           fruta(naranjas,V2), select(V2,E2,E3),
           cliente(paulette,V3), member(V3,E3).

% 6. El cliente que pidi� naranjas pag� 1 d�lar m�s que la persona que pidi� bananos.
pista6(E):-fruta(naranjas,V1), precio(PrecioNaranjas,V1),
           member(V1,E), select(V1,E,E2),
           fruta(bananos,V2), precio(PrecioBananos,V2),
           member(V2,E2), select(V2,E2,_),
           PrecioNaranjas is (PrecioBananos + 1).

% 7. Otis, o pag� $6 o pag� $10.
 % - Otis pag� $6
pista7(E):-cliente(otis,V1), precio(6,V1), member(V1,E).

 % - u Otis pag� 10
pista7(E):-cliente(otis,V1), precio(10,V1), member(V1,E).

% 8. La persona que pidi� quinoa pag� $3 m�s que Mercedes.
pista8(E):-superAlimento(quinoa,V1), precio(PrecioQuinoa,V1),
           member(V1,E), select(V1,E,E2),
           cliente(mercedes,V2), precio(W,V2),
           member(V2,E2), select(V2,E2,_),
           PrecioQuinoa is (W + 3).

% 9. Sobre Paulette y la persona que orden� frambuesas: una pidi� pasto de trigo y la otra persona pag� $8.
pista9(E):-cliente(paulette,V1), superAlimento(pastoDeTrigo,V1),
           member(V1,E), select(V1,E,E2),
           fruta(frambuesas,V2), precio(8,V2),
           member(V2,E2), select(V2,E2,_).
           
pista9(E):-cliente(paulette,V3), precio(8,V3),
           member(V3,E), select(V3,E,E2),
           fruta(frambuesas,V4), superAlimento(pastoDeTrigo,V4),
           member(V4,E2), select(V4,E2,_).


% 10. Isabel pag� 3 d�lares menos que Amelia.
pista10(E):-cliente(amelia,V1), precio(Q,V1),
            member(V1,E), select(V1,E,E2),
            cliente(isabel,V2), precio(P,V2),
            member(V2,E2), select(V2,E2,_),
            P is (Q - 3). % mas que Amelia: P is (Q + 3).

cliente(Cliente, orden(_,Cliente,_,_)).
superAlimento(SuperAlimento, orden(_,_,SuperAlimento,_)).
fruta(Fruta, orden(_,_,_,Fruta)).
precio(Precio, orden(Precio,_,_,_)).

% structure(smoothies,E), pista1(E).



% CASO 2: Viajes
%
% Viajeros: bradley, eugene, francis, greg, kathy, lee, natasha
% Crucero: azureSeas, baroness, caprica, farralon, neptunia, silverShores, trinity
% Destino: barbados, grenada, jamaica, martinique, puertoRico, saintLucia, trinidad
%
% resolver(viajes, Struct, Sol).
%

% 1. Eugene no viaj� en el crucero Azure Seas.
pista1(E):-viajero(eugene,V1), select(V1,E,E2),
          crucero(azureSeas,V2), member(V2,E2).

% 2. La persona que fue a Trinidad zarp� 1 a�o antes que Lee.
pista2(E):-destino(trinidad,V1), anio(AnioTrinidad,V1),
           member(V1,E), select(V1,E,E2),
           viajero(lee,V2), anio(AnioLee,V2),
           member(V2,E2), select(V2,E2,_),
           AnioTrinidad is (AnioLee - 1).

% 3. La persona que se embarc� en el crucero Silver Shores es Francis o es quien viaj� en 1984.
pista3(E):-crucero(silverShores,V1), viajero(francis,V1), select(V1,E,E2),
           anio(1984,V2), member(V2,E2).

pista3(E):-crucero(silverShores,V1), anio(1984,V1), select(V1,E,E2),
           viajero(francis,V2), member(V2,E2).
           

% 4. Los siete viajeros son: la persona que fue a Saint Lucia, Greg, la persona que se
%    embarc� en el crucero Neptunia, la persona que viaj� en 1987, la persona que tom� el crucero Trinity,
%    la persona que se embarc� en el crucero Baroness y la persona que tom� un crucero en 1986.
pista4(E):-destino(saintLucia,V1), select(V1,E,E2),
           viajero(greg,V2), select(V2,E2,E3),
           crucero(neptunia,V3), select(V3,E3,E4),
           anio(1987,V4), select(V4,E4,E5),
           crucero(trinity,V5), select(V5,E5,E6),
           crucero(baroness,V6), select(V6,E6,E7),
           anio(1986,V7), select(V7,E7,_).

% 5. Sobre los que tomaron el crucero Farralon y el crucero Caprica, uno es Greg y el otro fue a Martinique.
pista5(E):-crucero(farralon,V1), viajero(greg,V1),
           member(V1,E), select(V1,E,E2),
           crucero(caprica,V2), destino(martinique,V2),
           member(V2,E2), select(V2,E2,_).
           
pista5(E):-crucero(farralon,V1), destino(martinique,V1),
           member(V1,E), select(V1,E,E2),
           crucero(caprica,V2), viajero(greg,V2),
           member(V2,E2), select(V2,E2,_).

% 6. La persona que fue a Puerto Rico viaj� 1 a�o despu�s de la persona que tom� el crucero Silver Shores.
pista6(E):-destino(puertoRico,V1), anio(AnioPuertoRico,V1),
           member(V1,E), select(V1,E,E2),
           crucero(silverShores,V2), anio(AnioSilverShores,V2),
           member(V2,E2), select(V2,E2_),
           AnioSilverShores is (AnioPuertoRico + 1).

% 7. Kathy no viaj� en el crucero Azure Seas.
pista7(E):- crucero(azureSeas,V1), select(V1,E,E2),
            viajero(kathy,V2), member(V2,E2).


% 8. Natasha viaj� ya sea en el crucero Baroness o en el crucero de 1985.
pista8(E):-viajero(natalia,V1), crucero(baroness,V1), member(V1,E).
pista8(E):-viajero(natalia,V1), anio(1985,V1), member(V1,E).

% 9. La persona que fue a Martinique est� entre Eugene y la persona que tom� el crucero Caprica.


% 10. La persona que tom� el crucero de 1987 no fue la misma que viaj� en el crucero Caprica.


% 11. Sobre Francis y la persona que fue a Trinidad: uno estuvo en el crucero de 1983 y el otro tom� el crucero Neptunia.


% 12. Bradley, o fue a Jamaica o m�s bien tom� el crucero de 1987.
pista12(E):-viajero(bradley,V1), destino(jamaica,V1), member(V1,E).
pista12(E):-viajero(bradley,V2), anio(1987,V2), member(V2,E).

% 13. La persona que fue a Grenada viaj� 2 a�os despu�s que Kathy.


% 14. La persona que tom� el crucero Neptunia lo hizo 1 year a�o despu�s de que qui�n tom� el crucero Silver Shores.


% 15. La persona que viaj� en el crucero Trinity zarp� 1 a�o despu�s de quien tom� el crucero Baroness.


% 16. Uno de los viajeros fue a Barbados.
pista16(E):-destino(barbados,V1), member(V1,E).



viajero(Viajero, viaje(Viajero,_,_,_)).
crucero(Crucero, viaje(_,Crucero,_,_)).
destino(Destino, viaje(_,_,Destino,_)).
anio(Anio, viaje(_,_,_,Anio)).

% structure(viajes,E), pista1(E).
