% Interaktywna instrukcja dla modelarstwa
%
% Tematyka:
% Ten program jest interaktywn¹ instrukcj¹ krok po kroku do budowy modelu.
% Zawiera sekwencjê kroków oraz szczegó³owe opisy dzia³añ do wykonania
% na ka¿dym etapie budowy modelu.
%
% Cel:
% Program ma na celu pomóc u¿ytkownikowi w budowie modelu poprzez
% prowadzenie go przez ka¿dy
% krok procesu. Umo¿liwia u¿ytkownikowi
% nawigacjê miêdzy krokami, zapisywanie i wczytywanie postêpów, oraz
% otrzymywanie pomocy dotycz¹cej dostêpnych komend.
%
% Zastosowanie:
% Program jest u¿yteczny dla hobbystów modelarstwa, którzy chc¹ mieæ
% przewodnik krok po krok u przy budowie swoich modeli. Mo¿e byæ u¿ywany
% zarówno przez pocz¹tkuj¹cych, jak i doœwiadczonych modelarzy.
%
% Problem, który rozwi¹zuje:
% Program pomaga w zorganizowaniu procesu budowy modelu, zmniejsza ryzyko pominiêcia kroków,
% oraz zapewnia u¿ytkownikowi ³atwy dostêp do informacji o bie¿¹cym i nadchodz¹cych krokach.


% Definicja kroków budowy przyk³adowego modelu
step(1, 'Przygotowanie czêœci').
step(2, 'Malowanie czêœci').
step(3, 'Sklejanie kad³uba').
step(4, 'Sklejanie skrzyde³').
step(5, 'Monta¿ skrzyde³ do kad³uba').
step(6, 'Dodanie detali').
step(7, 'Malowanie finalne').
step(8, 'Nak³adanie kalkomanii').
step(9, 'Lakierowanie').
step(10, 'Finalny monta¿ i inspekcja').

% Opisy kroków
description(1, 'Upewnij siê, ¿e wszystkie czêœci s¹ na miejscu i oczyœæ je z nadmiarowych elementów.').
description(2, 'Pomaluj czêœci zgodnie z instrukcj¹, u¿ywaj¹c odpowiednich farb.').
description(3, 'Sklej kad³ub zgodnie z instrukcj¹, upewniaj¹c siê, ¿e czêœci s¹ dobrze dopasowane.').
description(4, 'Sklej skrzyd³a, upewniaj¹c siê, ¿e wszystkie czêœci s¹ dobrze dopasowane.').
description(5, 'Przymocuj skrzyd³a do kad³uba zgodnie z instrukcj¹.').
description(6, 'Dodaj drobne detale, takie jak ko³a, karabiny czy inne elementy modelu.').
description(7, 'Pomaluj ca³y model, aby uzyskaæ ostateczny wygl¹d.').
description(8, 'Na³ó¿ kalkomanie zgodnie z instrukcj¹. Upewnij siê, ¿e s¹ dobrze umiejscowione.').
description(9, 'Zabezpiecz model lakierem, aby chroniæ farbê i kalkomanie.').
description(10, 'SprawdŸ ca³y model i dokonaj ewentualnych poprawek. Twój model jest gotowy!').
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

% Predykaty sprawdzaj¹ce, czy krok jest poprawny
next_step(CurrentStep, NextStep) :-
    NextStep is CurrentStep + 1,
    step(NextStep, _).
previous_step(CurrentStep, PreviousStep) :-
    PreviousStep is CurrentStep - 1,
    step(PreviousStep, _).
show_all_steps :-
    forall(step(Number, Name),
           (format('Krok ~w: ~w~n', [Number, Name]))).
% Predykat wyœwietlaj¹cy dostêpne komendy
show_help :-
    write('Dostêpne komendy:'), nl,
    write('start - Rozpocznij/wyœwietl bie¿¹cy krok'), nl,
    write('next - PrzejdŸ do nastêpnego kroku'), nl,
    write('previous - PrzejdŸ do poprzedniego kroku'), nl,
    write('steps - Wyœwietl wszystkie kroki'), nl,
    write('jump(N) - PrzejdŸ do kroku N'), nl,
    write('save - Zapisz postêp'), nl,
    write('load - Wczytaj zapisany postêp'), nl,
    write('restart - Zrestartuj instrukcjê do pierwszego kroku'), nl,
    write('help - Wyœwietl tê pomoc'), nl,
    write('quit - Zakoñcz instrukcjê'), nl.
% Predykat startowy
start :-
    write('Witamy w interaktywnej instrukcji budowy modelu!'), nl,
    write('Dostêpne komendy: start, next, previous, steps, jump(N), save, load, restart, help, quit'), nl,
    init_state,
    process_command.
% Inicjalizacja stanu - ustawienie pocz¹tkowego kroku i wyczyszczenie zapisanego stanu
init_state :-
    retractall(current_step(_)),
    assert(current_step(1)),
    retractall(saved_step(_)).
% Predykat przetwarzaj¹cy komendy u¿ytkownika w pêtli
process_command :-
    repeat,
    write('> '),
    read(Command),
    (   Command == quit
    ->  write('Koniec instrukcji.'), nl, !
    ;   (command(Command)
        -> handle_command(Command)
        ;  write('Nieznana komenda. Spróbuj jeszcze raz.'), nl),
        fail
    ).
% Obs³uga komendy 'start' - wyœwietlenie bie¿¹cego kroku
handle_command(start) :-
    current_step(Step),
    show_step(Step).
% Obs³uga komendy 'next' - przejœcie do nastêpnego kroku
handle_command(next) :-
    current_step(CurrentStep),
    (   next_step(CurrentStep, NextStep)
    ->  retract(current_step(CurrentStep)),
        assert(current_step(NextStep)),
        show_step(NextStep)
    ;   write('Jesteœ na ostatnim kroku.'), nl
    ).
% Obs³uga komendy 'previous' - przejœcie do poprzedniego kroku
handle_command(previous) :-
    current_step(CurrentStep),
    (   previous_step(CurrentStep, PreviousStep)
    ->  retract(current_step(CurrentStep)),
        assert(current_step(PreviousStep)),
        show_step(PreviousStep)
    ;   write('Jesteœ na pierwszym kroku.'), nl
    ).
% Obs³uga komendy 'steps' - wyœwietlenie wszystkich kroków
handle_command(steps) :-
    show_all_steps.
% Obs³uga komendy 'restart' - zresetowanie instrukcji do pierwszego kroku
handle_command(restart) :-
    init_state,
    write('Instrukcja zosta³a zrestartowana.'), nl,
    current_step(Step),
    show_step(Step).
% Obs³uga komendy 'save' - zapisanie bie¿¹cego postêpu
handle_command(save) :-
    current_step(Step),
    retractall(saved_step(_)),
    assert(saved_step(Step)),
    write('Postêp zapisany.'), nl.
% Obs³uga komendy 'load' - wczytanie zapisanego postêpu
handle_command(load) :-
    (   saved_step(Step)
    ->  retractall(current_step(_)),
        assert(current_step(Step)),
        write('Postêp wczytany.'), nl,
        show_step(Step)
    ;   write('Brak zapisanego postêpu.'), nl
    ).
% Obs³uga komendy 'help' - wyœwietlenie dostêpnych komend
handle_command(help) :-
    show_help.

% Obs³uga komendy 'jump(N)' - przejœcie do konkretnego kroku
handle_command(jump(N)) :-
    integer(N),
    (   step(N, _)
    ->  retractall(current_step(_)),
        assert(current_step(N)),
        show_step(N)
    ;   write('Nieprawid³owy numer kroku.'), nl
    ).
% Predykat wyœwietlaj¹cy szczegó³y konkretnego kroku
show_step(Step) :-
    step(Step, StepName),
    description(Step, StepDescription),
    format('Krok ~w: ~w~n', [Step, StepName]),
    format('Opis: ~w~n', [StepDescription]).
/*
Przyk³adowe dzia³anie programu.
> |: start.
Krok 1: Przygotowanie czêœci
Opis: Upewnij siê, ¿e wszystkie czêœci s¹ na miejscu i oczyœæ je z nadmiarowych elementów.
> |: next.
Krok 2: Malowanie czêœci
Opis: Pomaluj czêœci zgodnie z instrukcj¹, u¿ywaj¹c odpowiednich farb.
> |: previous.
Krok 1: Przygotowanie czêœci
Opis: Upewnij siê, ¿e wszystkie czêœci s¹ na miejscu i oczyœæ je z nadmiarowych elementów.
> |: steps.
Krok 1: Przygotowanie czêœci
Krok 2: Malowanie czêœci
Krok 3: Sklejanie kad³uba
Krok 4: Sklejanie skrzyde³
Krok 5: Monta¿ skrzyde³ do kad³uba
Krok 6: Dodanie detali
Krok 7: Malowanie finalne
Krok 8: Nak³adanie kalkomanii
Krok 9: Lakierowanie
Krok 10: Finalny monta¿ i inspekcja
> |: restart.
Instrukcja zosta³a zrestartowana.
Krok 1: Przygotowanie czêœci
Opis: Upewnij siê, ¿e wszystkie czêœci s¹ na miejscu i oczyœæ je z nadmiarowych elementów.
> |: save
|: .
Postêp zapisany.
> |: load.
Postêp wczytany.
Krok 1: Przygotowanie czêœci
Opis: Upewnij siê, ¿e wszystkie czêœci s¹ na miejscu i oczyœæ je z nadmiarowych elementów.
> |: help.
Dostêpne komendy:
start - Rozpocznij/wyœwietl bie¿¹cy krok
next - PrzejdŸ do nastêpnego kroku
previous - PrzejdŸ do poprzedniego kroku
steps - Wyœwietl wszystkie kroki
jump(N) - PrzejdŸ do kroku N
save - Zapisz postêp
load - Wczytaj zapisany postêp
restart - Zrestartuj instrukcjê do pierwszego kroku
help - Wyœwietl tê pomoc
quit - Zakoñcz instrukcjê
> |: jump(2).
Krok 2: Malowanie czêœci
Opis: Pomaluj czêœci zgodnie z instrukcj¹, u¿ywaj¹c odpowiednich farb.
> |: quit.
Koniec instrukcji.
true.
*/


/*
Informacje o budowie programu:
Program sk³ada siê z 47 klauzul.
Program zawiera 12 definicji relacji. S¹ to relacje:step/2,
description/2, command/1, next step/2, previous_step/2,
show_all_steps/0, show_help/0, start/0, init_state/0, process_command/0,
handle_command/1, show_step/1

Definicja relacji step/2 sk³ada siê z 10 klauzul, które s¹ faktami.

Definicja relacji description/2 sk³ada siê z 10 klauzul, które s¹ faktami.

Definicja relacji command/1 sk³ada siê z 10 klauzul, które s¹ faktami.

Definicja relacji next_step/2 sk³ada siê z 1 klauzuli, która jest regu³¹.

Definicja relacji previous_step/2 sk³ada siê z 1 klauzuli, która jest regu³¹.

Definicja relacji show_all_steps/0 sk³ada siê z 1 klauzuli, która jest regu³¹.

Definicja relacji show_help/0 sk³ada siê z 1 klauzuli, która jest regu³¹.

Definicja relacji start/0 sk³ada siê z 1 klauzuli, która jest regu³¹.

Definicja relacji init_state/0 sk³ada siê z 1 klauzuli, która jest regu³¹.

Definicja relacji process_command/0 sk³ada siê z 1 klauzuli, która jest regu³¹.

Definicja relacji handle_command/1 sk³ada siê z 9 klauzul, które s¹
regu³ami.

Definicja relacji show_step/1 sk³ada siê z 1 klauzuli, która jest regu³¹.
*/
