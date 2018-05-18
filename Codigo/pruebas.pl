% Autor:
% Fecha: 18/5/2018


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


structure(viajes, [viaje(_,_,_,1983),
                     viaje(_,_,_,1984),
                     viaje(_,_,_,1985),
                     viaje(_,_,_,1986),
                     viaje(_,_,_,1987),
                     viaje(_,_,_,1988),
                     viaje(_,_,_,1989)
                     ]). % viaje(Viajero, Crucero, Destino, Año)

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
   
% queries(
%         viajes, % identifica las pistas como del acertijo "smoothies"
%         Viajes, % la estructura del acertijo va atando todo
% 
%         % Preguntas a la estructura
%         [
%           member(viaje(_,X, _, 1987),Viajes)
%         ],
% 
%         % Respuestas pedidas. Usa los valores determinados en la lista anterior.
%         [
%           ['La persona ', X]
%         ]).

% CASO 2: Viajes
%
% Viajeros: bradley, eugene, francis, greg, kathy, lee, natasha
% Crucero: azureSeas, baroness, caprica, farralon, neptunia, silverShores, trinity
% Destino: barbados, grenada, jamaica, martinique, puertoRico, saintLucia, trinidad
%
% resolver(viajes, Struct, Sol).
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
           AnioSilverShores is (AnioPuertoRico + 1).

% 7. Kathy no viajó en el crucero Azure Seas.
pista7_V(E):- crucero(azureSeas,V1), select(V1,E,E2),
            viajero(kathy,V2), member(V2,E2).


% 8. Natasha viajó ya sea en el crucero Baroness o en el crucero de 1985.
pista8_V(E):-viajero(natalia,V1), crucero(baroness,V1), member(V1,E).
pista8_V(E):-viajero(natalia,V1), anio(1985,V1), member(V1,E).

% 9. La persona que fue a Martinique está entre Eugene y la persona que tomó el crucero Caprica.
% pista9(E):-destino(martinique,V1), viajero(eugene,V1), member(V1,E).
% pista9(E):-destino(martinique,V2), crucero(caprica,V2), member(V2,E).

pista9_V(E):-viajero(eugene,V1), anio(AnioEugene,V1),
           select(V1,E,E2),
           crucero(caprica,V2), anio(AnioCaprica,V2),
           select(V1,E2,E3),
           destino(martinica,V3), anio(AnioMartinica,V3),
           AnioMartinica < AnioEugene, AnioMartinica > AnioCaprica, select(V3,E3,_).

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
            destino(trinidad,V2), anio(1983,V1),
            member(V2,E2), select(V2,E2,_).

% 12. Bradley, o fue a Jamaica o más bien tomó el crucero de 1987.
pista12_V(E):-viajero(bradley,V1), destino(jamaica,V1), member(V1,E).
pista12_V(E):-viajero(bradley,V2), anio(1987,V2), member(V2,E).

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

% structure(viajes,E), pista1_V(E).