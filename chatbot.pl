main :-
    write('Welcome to your medical diagnostic test.'), nl,
    ask('Would you like to start your examination?', Response),
    (
        Response == 'Y' ->
            write('Okay.');
            % Patient details
            % Chief complaint
            % HPI
        Response == 'N' ->
            write('Thank you for your time.');
        write('Sorry. I do not recognize this input.')
    ).

ask(Question, Response) :-
    write(Question),
    write(' (Y/N)'),
    read(Input), nl,
    (
        (Input == 'Y'; Input == 'y') ->
            Response = 'Y';
        (Input == 'N'; Input == 'n') ->
            Response = 'N';
        Response = unknown
    ).
