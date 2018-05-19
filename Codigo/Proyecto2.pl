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


structure(smoothies, [orden(6, _, _, _),
                      orden(7, _, _, _),
                      orden(8, _, _, _),
                      orden(9, _, _, _),
                      orden(10, _, _, _)
                      ]). % orden(Precio, Cliente, SuperAlimento, Fruta)

structure(viajes, [viaje(_,_,_,1983),
                     viaje(_,_,_,1984),
                     viaje(_,_,_,1985),
                     viaje(_,_,_,1986),
                     viaje(_,_,_,1987),
                     viaje(_,_,_,1988),
                     viaje(_,_,_,1989)
                     ]). % viaje(Viajero, Crucero, Destino, Año)

clues(
      smoothies,   % identifica las pistas como del acertijo "smoothies"
      Smoothies,   % la estructura del acertijo va atando todo

   [ pista1_S(Smoothies),
     pista2_S(Smoothies),
     pista3_S(Smoothies),
     pista4_S(Smoothies),
     pista5_S(Smoothies),
     pista6_S(Smoothies),
     pista7_S(Smoothies),
     pista8_S(Smoothies),
     pista9_S(Smoothies),
     pista10_S(Smoothies)
     % Pregunta: 11.    ¿Quién pidió mandarina?
   ]).

clues(
      viajes,   % identifica las pistas como del acertijo "smoothies"
      Viajes,   % la estructura del acertijo va atando todo

   [ pista1_V(Viajes),
     pista2_V(Viajes),
     pista3_V(Viajes),
     pista4_V(Viajes),
     pista5_V(Viajes),
     pista6_V(Viajes),
     pista7_V(Viajes),
     pista8_V(Viajes),
     pista9_V(Viajes),
     pista10_V(Viajes),
     pista11_V(Viajes),
     pista12_V(Viajes),
     pista13_V(Viajes),
     pista14_V(Viajes),
     pista15_V(Viajes),
     pista16_V(Viajes)
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


queries(
        viajes, % identifica las pistas como del acertijo "viajes"
        Viajes, % la estructura del acertijo va atando todo

        % Preguntas a la estructura
        [
          member(viaje(X,_,_,1983),Viajes)
        ],

        % Respuestas pedidas. Usa los valores determinados en la lista anterior.
        [
          ['Caso sin preguntas ', X]
        ]).


% CASO 1: Smoothies
%
% Cliente: amelia, mercedes, paulette, isabel, otis
% Super alimento: pasto de trigo, semilla de lino, gengibre, semillas de chia, quinoa
% Fruta: frambuesas, arándanos, bananos, naranjas, mandarinas
%
% resolver(smoothies, Struct, Sol).
% structure(smoothies,E), pista1_S(E).
%


% 1. El cliente que pagó $6 no pidió arándanos.
pista1_S(E):-precio(6,V1), select(V1,E,E2),
           fruta(arandanos,V2), member(V2,E2).
% obtengo la orden con un pago de $6, obtengo la lista de ordenes sin esa
% orden de $6, luego obtengo la orden de arandanos y hago match con las ordenes
% restantes (sin contar la de $6)


% 2. El cliente que ordenó semilla de lino pagó más que la persona que ordenó pasto de trigo.
pista2_S(E):-superAlimento(semillaDeLino,V1), precio(PrecioSemillaDeLino,V1),
           member(V1,E), select(V1,E,E2),
           superAlimento(pastoDeTrigo,V2), precio(PrecioPastoDeTrigo,V2),
           member(V2,E2), select(V2,E2,_),
           PrecioSemillaDeLino > PrecioPastoDeTrigo.

% 3. Isabel pidió semillas de chia.
pista3_S(E):-cliente(isabel,V1),superAlimento(semillasDeChia,V1),member(V1,E).

% 4. El cliente que solicitó gengibre es Paulette o es la persona que pagó $10.
  % - El cliente que solicitó gengibre es Paulette
pista4_S(E):-cliente(paulette,V1), superAlimento(gengibre,V1), select(V1,E,E2),
           precio(10,V2), member(V2,E2).

  % - ó El cliente que solicitó gengibre es la persona que pagó $10.
pista4_S(E):-superAlimento(gengibre,V1), precio(10,V1), select(V1,E,E2),
           cliente(paulette,V2), member(V2,E2).

% 5. Paulette, el cliente que pidió arándanos y la persona que pidió naranjas, son tres personas distintas.
pista5_S(E):-fruta(arandanos,V1), select(V1,E,E2),
           fruta(naranjas,V2), select(V2,E2,E3),
           cliente(paulette,V3), member(V3,E3).

% 6. El cliente que pidió naranjas pagó 1 dólar más que la persona que pidió bananos.
pista6_S(E):-fruta(naranjas,V1), precio(PrecioNaranjas,V1),
           member(V1,E), select(V1,E,E2),
           fruta(bananos,V2), precio(PrecioBananos,V2),
           member(V2,E2), select(V2,E2,_),
           PrecioNaranjas is (PrecioBananos + 1).

% 7. Otis, o pagó $6 o pagó $10.
 % - Otis pagó $6
pista7_S(E):-cliente(otis,V1), precio(6,V1), member(V1,E).

 % - u Otis pagó 10
pista7_S(E):-cliente(otis,V1), precio(10,V1), member(V1,E).

% 8. La persona que pidió quinoa pagó $3 más que Mercedes.
pista8_S(E):-superAlimento(quinoa,V1), precio(PrecioQuinoa,V1),
           member(V1,E), select(V1,E,E2),
           cliente(mercedes,V2), precio(W,V2),
           member(V2,E2), select(V2,E2,_),
           PrecioQuinoa is (W + 3).

% 9. Sobre Paulette y la persona que ordenó frambuesas: una pidió pasto de trigo y la otra persona pagó $8.
pista9_S(E):-cliente(paulette,V1), superAlimento(pastoDeTrigo,V1),
           member(V1,E), select(V1,E,E2),
           fruta(frambuesas,V2), precio(8,V2),
           member(V2,E2), select(V2,E2,_).
           
pista9_S(E):-cliente(paulette,V3), precio(8,V3),
           member(V3,E), select(V3,E,E2),
           fruta(frambuesas,V4), superAlimento(pastoDeTrigo,V4),
           member(V4,E2), select(V4,E2,_).


% 10. Isabel pagó 3 dólares menos que Amelia.
pista10_S(E):-cliente(amelia,V1), precio(Q,V1),
            member(V1,E), select(V1,E,E2),
            cliente(isabel,V2), precio(P,V2),
            member(V2,E2), select(V2,E2,_),
            P is (Q - 3). % mas que Amelia: P is (Q + 3).

cliente(Cliente, orden(_,Cliente,_,_)).
superAlimento(SuperAlimento, orden(_,_,SuperAlimento,_)).
fruta(Fruta, orden(_,_,_,Fruta)).
precio(Precio, orden(Precio,_,_,_)).





% CASO 2: Viajes
%
% Viajeros: bradley, eugene, francis, greg, kathy, lee, natasha
% Crucero: azureSeas, baroness, caprica, farralon, neptunia, silverShores, trinity
% Destino: barbados, grenada, jamaica, martinique, puertoRico, saintLucia, trinidad
%
% resolver(viajes, Struct, Sol).
% structure(viajes,E), pista1_V(E).
%


% 1. Eugene no viajó en el crucero Azure Seas.
pista1_V(E):-viajero(eugene,V1), select(V1,E,E2),
             crucero(azureSeas,V2), member(V2,E2).

% 2. La persona que fue a Trinidad zarpó 1 año antes que Lee.
pista2_V(E):-destino(trinidad,V1), anio(AnioTrinidad,V1),
           member(V1,E), select(V1,E,E2),
           viajero(lee,V2), anio(AnioLee,V2),
           member(V2,E2), select(V2,E2,_),
           AnioTrinidad is (AnioLee - 1).

% 3. La persona que se embarcó en el crucero Silver Shores es Francis o es quien viajó en 1984.
pista3_V(E):-crucero(silverShores,V1), viajero(francis,V1), select(V1,E,E2),
           anio(1984,V2), member(V2,E2).

pista3_V(E):-crucero(silverShores,V1), anio(1984,V1), select(V1,E,E2),
           viajero(francis,V2), member(V2,E2).


% 4. Los siete viajeros son: la persona que fue a Saint Lucia, Greg, la persona que se
%    embarcó en el crucero Neptunia, la persona que viajó en 1987, la persona que tomó el crucero Trinity,
%    la persona que se embarcó en el crucero Baroness y la persona que tomó un crucero en 1986.
pista4_V(E):-destino(saintLucia,V1), select(V1,E,E2),
           viajero(greg,V2), select(V2,E2,E3),
           crucero(neptunia,V3), select(V3,E3,E4),
           anio(1987,V4), select(V4,E4,E5),
           crucero(trinity,V5), select(V5,E5,E6),
           crucero(baroness,V6), select(V6,E6,E7),
           anio(1986,V7), select(V7,E7,_).

% 5. Sobre los que tomaron el crucero Farralon y el crucero Caprica, uno es Greg y el otro fue a Martinique.
pista5_V(E):-crucero(farralon,V1), viajero(greg,V1),
           member(V1,E), select(V1,E,E2),
           crucero(caprica,V2), destino(martinique,V2),
           member(V2,E2), select(V2,E2,_).

pista5_V(E):-crucero(farralon,V1), destino(martinique,V1),
           member(V1,E), select(V1,E,E2),
           crucero(caprica,V2), viajero(greg,V2),
           member(V2,E2), select(V2,E2,_).

% 6. La persona que fue a Puerto Rico viajó 1 año después de la persona que tomó el crucero Silver Shores.
pista6_V(E):-destino(puertoRico,V1), anio(AnioPuertoRico,V1),
           member(V1,E), select(V1,E,E2),
           crucero(silverShores,V2), anio(AnioSilverShores,V2),
           member(V2,E2), select(V2,E2,_),
           AnioPuertoRico is (AnioSilverShores + 1).

% 7. Kathy no viajó en el crucero Azure Seas.
pista7_V(E):- crucero(azureSeas,V1), select(V1,E,E2),
            viajero(kathy,V2), member(V2,E2).


% 8. Natasha viajó ya sea en el crucero Baroness o en el crucero de 1985.
pista8_V(E):-viajero(natalia,V1), crucero(baroness,V1), select(V1,E,E2),
             anio(1985,V2), member(V2,E2).
             
pista8_V(E):-viajero(natalia,V3), anio(1985,V3), select(V3,E,E3),
             crucero(baroness,V4), member(V4,E3).


% 9. La persona que fue a Martinique está entre Eugene y la persona que tomó el crucero Caprica.
pista9_V(E):-destino(martinique,V1),viajero(eugene,V1),
              select(V1,E,E2),
              crucero(caprica,V2),
              select(V2,E2,_).

pista9_V(E):-destino(martinique,V1),crucero(caprica,V1),
              select(V1,E,E2),
              viajero(eugene,V2),
              select(V2,E2,_).

% pista9_V(E):-viajero(eugene,V1), anio(AnioEugene,V1),
%            select(V1,E,E2),
%            crucero(caprica,V2), anio(AnioCaprica,V2),
%            select(V2,E2,E3),
%            destino(martinique,V3), anio(AnioMartinique,V3),
%            select(V3,E3,_),
%            AnioEugene < AnioMartinique, AnioMartinique < AnioCaprica.

% 10. La persona que tomó el crucero de 1987 no fue la misma que viajó en el crucero Caprica.
pista10_V(E):-anio(1987,V1), select(V1,E,E2),
            crucero(caprica,V2), member(V2,E2).

% 11. Sobre Francis y la persona que fue a Trinidad: uno estuvo en el crucero de 1983 y el otro tomó el crucero Neptunia.
pista11_V(E):-viajero(francis,V1), anio(1983,V1),
            member(V1,E), select(V1,E,E2),
            destino(trinidad,V2), crucero(neptunia,V2),
            member(V2,E2), select(V2,E2,_).

pista11_V(E):-viajero(francis,V1), crucero(neptunia,V1),
            member(V1,E), select(V1,E,E2),
            destino(trinidad,V2), anio(1983,V2),
            member(V2,E2), select(V2,E2,_).

% 12. Bradley, o fue a Jamaica o más bien tomó el crucero de 1987.
pista12_V(E):-viajero(bradley,V1), destino(jamaica,V1), select(V1,E,E2),
              anio(1987,V2), member(V2,E2).
              
pista12_V(E):-viajero(bradley,V1), anio(1987,V1), select(V1,E,E2),
              destino(jamaica,V2), member(V2,E2).

% 13. La persona que fue a Grenada viajó 2 años después que Kathy.
pista13_V(E):-destino(grenada,V1), anio(AnioGrenada,V1),
            member(V1,E), select(V1,E,E2),
            viajero(kathy,V2), anio(AnioKathy,V2),
            member(V2,E2), select(V2,E2,_),
            AnioGrenada is (AnioKathy + 2).

% 14. La persona que tomó el crucero Neptunia lo hizo 1 year año después de que quién tomó el crucero Silver Shores.
pista14_V(E):-crucero(neptunia,V1), anio(AnioNeptunia,V1),
            member(V1,E), select(V1,E,E2),
            crucero(silverShores,V2), anio(AnioSilverShores,V2),
            member(V2,E2), select(V2,E2,_),
            AnioNeptunia is (AnioSilverShores + 1).

% 15. La persona que viajó en el crucero Trinity zarpó 1 año después de quien tomó el crucero Baroness.
pista15_V(E):-crucero(trinity,V1), anio(AnioTrinity,V1),
            member(V1,E), select(V1,E,E2),
            crucero(baroness,V2), anio(AnioBaroness,V2),
            member(V2,E2), select(V2,E2,_),
            AnioTrinity is (AnioBaroness + 1).

% 16. Uno de los viajeros fue a Barbados.
pista16_V(E):-destino(barbados,V1), member(V1,E).


viajero(Viajero, viaje(Viajero,_,_,_)).
crucero(Crucero, viaje(_,Crucero,_,_)).
destino(Destino, viaje(_,_,Destino,_)).
anio(Anio, viaje(_,_,_,Anio)).
