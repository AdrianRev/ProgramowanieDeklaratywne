% Interaktywna instrukcja dla modelarstwa
%
% Tematyka:
% Ten program jest interaktywn� instrukcj� krok po kroku do budowy modelu.
% Zawiera sekwencj� krok�w oraz szczeg�owe opisy dzia�a� do wykonania
% na ka�dym etapie budowy modelu.
%
% Cel:
% Program ma na celu pom�c u�ytkownikowi w budowie modelu poprzez
% prowadzenie go przez ka�dy
% krok procesu. Umo�liwia u�ytkownikowi
% nawigacj� mi�dzy krokami, zapisywanie i wczytywanie post�p�w, oraz
% otrzymywanie pomocy dotycz�cej dost�pnych komend.
%
% Zastosowanie:
% Program jest u�yteczny dla hobbyst�w modelarstwa, kt�rzy chc� mie�
% przewodnik krok po krok u przy budowie swoich modeli. Mo�e by� u�ywany
% zar�wno przez pocz�tkuj�cych, jak i do�wiadczonych modelarzy.
%
% Problem, kt�ry rozwi�zuje:
% Program pomaga w zorganizowaniu procesu budowy modelu, zmniejsza ryzyko pomini�cia krok�w,
% oraz zapewnia u�ytkownikowi �atwy dost�p do informacji o bie��cym i nadchodz�cych krokach.


% Definicja krok�w budowy przyk�adowego modelu
step(1, 'Przygotowanie cz�ci').
step(2, 'Malowanie cz�ci').
step(3, 'Sklejanie kad�uba').
step(4, 'Sklejanie skrzyde�').
step(5, 'Monta� skrzyde� do kad�uba').
step(6, 'Dodanie detali').
step(7, 'Malowanie finalne').
step(8, 'Nak�adanie kalkomanii').
step(9, 'Lakierowanie').
step(10, 'Finalny monta� i inspekcja').

% Opisy krok�w
description(1, 'Upewnij si�, �e wszystkie cz�ci s� na miejscu i oczy�� je z nadmiarowych element�w.').
description(2, 'Pomaluj cz�ci zgodnie z instrukcj�, u�ywaj�c odpowiednich farb.').
description(3, 'Sklej kad�ub zgodnie z instrukcj�, upewniaj�c si�, �e cz�ci s� dobrze dopasowane.').
description(4, 'Sklej skrzyd�a, upewniaj�c si�, �e wszystkie cz�ci s� dobrze dopasowane.').
description(5, 'Przymocuj skrzyd�a do kad�uba zgodnie z instrukcj�.').
description(6, 'Dodaj drobne detale, takie jak ko�a, karabiny czy inne elementy modelu.').
description(7, 'Pomaluj ca�y model, aby uzyska� ostateczny wygl�d.').
description(8, 'Na�� kalkomanie zgodnie z instrukcj�. Upewnij si�, �e s� dobrze umiejscowione.').
description(9, 'Zabezpiecz model lakierem, aby chroni� farb� i kalkomanie.').
description(10, 'Sprawd� ca�y model i dokonaj ewentualnych poprawek. Tw�j model jest gotowy!').
% Lista poprawnych komend
command(start).
command(next).
command(previous).
command(steps).
command(restart).
command(save).
command(load).
command(help).
command(jump(_)).
command(quit).

% Predykaty sprawdzaj�ce, czy krok jest poprawny
next_step(CurrentStep, NextStep) :-
    NextStep is CurrentStep + 1,
    step(NextStep, _).
previous_step(CurrentStep, PreviousStep) :-
    PreviousStep is CurrentStep - 1,
    step(PreviousStep, _).
show_all_steps :-
    forall(step(Number, Name),
           (format('Krok ~w: ~w~n', [Number, Name]))).
% Predykat wy�wietlaj�cy dost�pne komendy
show_help :-
    write('Dost�pne komendy:'), nl,
    write('start - Rozpocznij/wy�wietl bie��cy krok'), nl,
    write('next - Przejd� do nast�pnego kroku'), nl,
    write('previous - Przejd� do poprzedniego kroku'), nl,
    write('steps - Wy�wietl wszystkie kroki'), nl,
    write('jump(N) - Przejd� do kroku N'), nl,
    write('save - Zapisz post�p'), nl,
    write('load - Wczytaj zapisany post�p'), nl,
    write('restart - Zrestartuj instrukcj� do pierwszego kroku'), nl,
    write('help - Wy�wietl t� pomoc'), nl,
    write('quit - Zako�cz instrukcj�'), nl.
% Predykat startowy
start :-
    write('Witamy w interaktywnej instrukcji budowy modelu!'), nl,
    write('Dost�pne komendy: start, next, previous, steps, jump(N), save, load, restart, help, quit'), nl,
    init_state,
    process_command.
% Inicjalizacja stanu - ustawienie pocz�tkowego kroku i wyczyszczenie zapisanego stanu
init_state :-
    retractall(current_step(_)),
    assert(current_step(1)),
    retractall(saved_step(_)).
% Predykat przetwarzaj�cy komendy u�ytkownika w p�tli
process_command :-
    repeat,
    write('> '),
    read(Command),
    (   Command == quit
    ->  write('Koniec instrukcji.'), nl, !
    ;   (command(Command)
        -> handle_command(Command)
        ;  write('Nieznana komenda. Spr�buj jeszcze raz.'), nl),
        fail
    ).
% Obs�uga komendy 'start' - wy�wietlenie bie��cego kroku
handle_command(start) :-
    current_step(Step),
    show_step(Step).
% Obs�uga komendy 'next' - przej�cie do nast�pnego kroku
handle_command(next) :-
    current_step(CurrentStep),
    (   next_step(CurrentStep, NextStep)
    ->  retract(current_step(CurrentStep)),
        assert(current_step(NextStep)),
        show_step(NextStep)
    ;   write('Jeste� na ostatnim kroku.'), nl
    ).
% Obs�uga komendy 'previous' - przej�cie do poprzedniego kroku
handle_command(previous) :-
    current_step(CurrentStep),
    (   previous_step(CurrentStep, PreviousStep)
    ->  retract(current_step(CurrentStep)),
        assert(current_step(PreviousStep)),
        show_step(PreviousStep)
    ;   write('Jeste� na pierwszym kroku.'), nl
    ).
% Obs�uga komendy 'steps' - wy�wietlenie wszystkich krok�w
handle_command(steps) :-
    show_all_steps.
% Obs�uga komendy 'restart' - zresetowanie instrukcji do pierwszego kroku
handle_command(restart) :-
    init_state,
    write('Instrukcja zosta�a zrestartowana.'), nl,
    current_step(Step),
    show_step(Step).
% Obs�uga komendy 'save' - zapisanie bie��cego post�pu
handle_command(save) :-
    current_step(Step),
    retractall(saved_step(_)),
    assert(saved_step(Step)),
    write('Post�p zapisany.'), nl.
% Obs�uga komendy 'load' - wczytanie zapisanego post�pu
handle_command(load) :-
    (   saved_step(Step)
    ->  retractall(current_step(_)),
        assert(current_step(Step)),
        write('Post�p wczytany.'), nl,
        show_step(Step)
    ;   write('Brak zapisanego post�pu.'), nl
    ).
% Obs�uga komendy 'help' - wy�wietlenie dost�pnych komend
handle_command(help) :-
    show_help.

% Obs�uga komendy 'jump(N)' - przej�cie do konkretnego kroku
handle_command(jump(N)) :-
    integer(N),
    (   step(N, _)
    ->  retractall(current_step(_)),
        assert(current_step(N)),
        show_step(N)
    ;   write('Nieprawid�owy numer kroku.'), nl
    ).
% Predykat wy�wietlaj�cy szczeg�y konkretnego kroku
show_step(Step) :-
    step(Step, StepName),
    description(Step, StepDescription),
    format('Krok ~w: ~w~n', [Step, StepName]),
    format('Opis: ~w~n', [StepDescription]).
/*
Przyk�adowe dzia�anie programu.
> |: start.
Krok 1: Przygotowanie cz�ci
Opis: Upewnij si�, �e wszystkie cz�ci s� na miejscu i oczy�� je z nadmiarowych element�w.
> |: next.
Krok 2: Malowanie cz�ci
Opis: Pomaluj cz�ci zgodnie z instrukcj�, u�ywaj�c odpowiednich farb.
> |: previous.
Krok 1: Przygotowanie cz�ci
Opis: Upewnij si�, �e wszystkie cz�ci s� na miejscu i oczy�� je z nadmiarowych element�w.
> |: steps.
Krok 1: Przygotowanie cz�ci
Krok 2: Malowanie cz�ci
Krok 3: Sklejanie kad�uba
Krok 4: Sklejanie skrzyde�
Krok 5: Monta� skrzyde� do kad�uba
Krok 6: Dodanie detali
Krok 7: Malowanie finalne
Krok 8: Nak�adanie kalkomanii
Krok 9: Lakierowanie
Krok 10: Finalny monta� i inspekcja
> |: restart.
Instrukcja zosta�a zrestartowana.
Krok 1: Przygotowanie cz�ci
Opis: Upewnij si�, �e wszystkie cz�ci s� na miejscu i oczy�� je z nadmiarowych element�w.
> |: save
|: .
Post�p zapisany.
> |: load.
Post�p wczytany.
Krok 1: Przygotowanie cz�ci
Opis: Upewnij si�, �e wszystkie cz�ci s� na miejscu i oczy�� je z nadmiarowych element�w.
> |: help.
Dost�pne komendy:
start - Rozpocznij/wy�wietl bie��cy krok
next - Przejd� do nast�pnego kroku
previous - Przejd� do poprzedniego kroku
steps - Wy�wietl wszystkie kroki
jump(N) - Przejd� do kroku N
save - Zapisz post�p
load - Wczytaj zapisany post�p
restart - Zrestartuj instrukcj� do pierwszego kroku
help - Wy�wietl t� pomoc
quit - Zako�cz instrukcj�
> |: jump(2).
Krok 2: Malowanie cz�ci
Opis: Pomaluj cz�ci zgodnie z instrukcj�, u�ywaj�c odpowiednich farb.
> |: quit.
Koniec instrukcji.
true.
*/


/*
Informacje o budowie programu:
Program sk�ada si� z 47 klauzul.
Program zawiera 12 definicji relacji. S� to relacje:step/2,
description/2, command/1, next step/2, previous_step/2,
show_all_steps/0, show_help/0, start/0, init_state/0, process_command/0,
handle_command/1, show_step/1

Definicja relacji step/2 sk�ada si� z 10 klauzul, kt�re s� faktami.

Definicja relacji description/2 sk�ada si� z 10 klauzul, kt�re s� faktami.

Definicja relacji command/1 sk�ada si� z 10 klauzul, kt�re s� faktami.

Definicja relacji next_step/2 sk�ada si� z 1 klauzuli, kt�ra jest regu��.

Definicja relacji previous_step/2 sk�ada si� z 1 klauzuli, kt�ra jest regu��.

Definicja relacji show_all_steps/0 sk�ada si� z 1 klauzuli, kt�ra jest regu��.

Definicja relacji show_help/0 sk�ada si� z 1 klauzuli, kt�ra jest regu��.

Definicja relacji start/0 sk�ada si� z 1 klauzuli, kt�ra jest regu��.

Definicja relacji init_state/0 sk�ada si� z 1 klauzuli, kt�ra jest regu��.

Definicja relacji process_command/0 sk�ada si� z 1 klauzuli, kt�ra jest regu��.

Definicja relacji handle_command/1 sk�ada si� z 9 klauzul, kt�re s�
regu�ami.

Definicja relacji show_step/1 sk�ada si� z 1 klauzuli, kt�ra jest regu��.
*/
