disease(malaria, [fever, chills, headache, muscle_aches, tiredness, nausea, vomiting, diarrhea]).
disease(dengue, [fever, rash, headache, pain_behind_eyes, muscle_aches, joint_pains, nausea, vomiting, loss_of_appetite]).
disease(tuberculosis, [weight_loss, fever, night_sweats, cough, chest_pain, coughing_blood, loss_of_appetite, anemia]).
disease(pneumonia, [cough, fever, chest_pain, shortness_of_breath, fatigue, loss_of_appetite]).
disease(diabetes, [extreme_thirst, increased_urination, infections, irritability, dry_mouth]).
disease(hiv, [sore_throat, fever, swollen_lymph_nodes, rash, muscle_aches, night_sweats, mouth_ulcers, chills, fatigue]).
disease(typhoid_fever, [fever, fatigue, headache, nausea, abdominal_pain, constipation]).
disease(influenza, [fever, cough, sore_throat, runny_nose, muscle_aches, headache]).
disease(measles, [fever, runny_nose, cough, watery_eyes, white_spots_inside_cheeks, rash]).
disease(leptospirosis, [fever, headache, chills, muscle_aches, vomiting, jaundice, red_eyes, abdominal_pain, rash]).

:- dynamic(user_symptom/1).
:- dynamic(negative_symptom/1).

main :-
    retractall(user_symptom(_)),
    retractall(negative_symptom(_)), nl,

    ask('Would you like to start your examination?', Response),
    (
        Response == 'Y' ->
            % Chief complaint
            write('What is your main concern? '), 
            read(Chief_complaint),
            assertz(user_symptom(Chief_complaint)), nl,

            % HPI
            repeat,
                findall(Symptom, user_symptom(Symptom), User_Symptoms),
                findall(Negative_Symptom, negative_symptom(Negative_Symptom), Negative_Symptoms),
                (
                    (disease(Disease, Symptoms),
                    subset(User_Symptoms, Symptoms),
                    (Negative_Symptoms \= [], \+ member_of_list(Negative_Symptoms, Symptoms) ; Negative_Symptoms = []),

                    check_additional_symptoms(Disease, Symptoms),
                    findall(Symptom, user_symptom(Symptom), User_Symptoms2),same_set(User_Symptoms2, Symptoms))                    
                    ;
                    write('Sorry, we cannot diagnose you based on your symptoms. Please consult a doctor.'), nl, !, fail
                )

            ;

            Response == 'N' ->
            write('Thank you for your time.');
            write('Sorry. I do not recognize this input.')),

    diagnose,
    display_user_symptoms.


% Check if the user has additional symptoms for a disease
check_additional_symptoms(Disease, Symptoms) :-
    findall(Negative_Symptom, negative_symptom(Negative_Symptom), Negative_Symptoms),
    (Negative_Symptoms \= [], \+ member_of_list(Negative_Symptoms, Symptoms) ; Negative_Symptoms = []),

    findall(Symptom, user_symptom(Symptom), User_Symptoms),
    subset(User_Symptoms, Symptoms),
    write('Checking for '), write(Disease), write('...'), nl, 
    findall(Symptom, (
        member(Symptom, Symptoms),
        \+ user_symptom(Symptom),
        \+ negative_symptom(Symptom),
        ask(Symptom, Response),
        ( Response == 'Y' -> assertz(user_symptom(Symptom)), true;
          assertz(negative_symptom(Symptom)), !)
    ), _), !.

% Check if user_symptoms and symptoms of a disease match
diagnose :-
    findall(Symptom, user_symptom(Symptom), User_Symptoms),
    disease(Disease, Disease_Symptoms),
    same_set(User_Symptoms, Disease_Symptoms),
    write('You might have '), write(Disease), write('.'), nl.


% Debugging Code
display_user_symptoms :-
    findall(Symptom, user_symptom(Symptom), User_Symptoms), nl,
    writeln('User Symptoms: '),
    writeln(User_Symptoms), nl.

ask(Question, Response) :-
    write(Question),
    write(' (Y/N) '),
    read(Input), nl,
    (
        (Input == 'Y'; Input == 'y') ->
            Response = 'Y';
        (Input == 'N'; Input == 'n') ->
            Response = 'N';
        (   
    		write('Input invalid. Please input again.'), nl,
        	ask(Question, Response)
    	)
        %Response = unknown;
    ).

% Check if two sets are equal
same_set(Xs, Ys) :- subset(Xs, Ys), subset(Ys, Xs).

% Check if at least one member of a set exists in another set
member_of_list([], _) :- fail.
member_of_list([H|T], List) :-
    member(H, List);
    member_of_list(T, List).
