:- dynamic(user_symptom/1).
:- dynamic(negative_symptom/1).
:- dynamic(age/1).
:- dynamic(symptoms_duration/1).
:- dynamic(disease/2).

disease(malaria, [fever, chills, headache, muscle_aches, tiredness, nausea, vomiting, diarrhea]).
disease(dengue, [fever, rash, headache, pain_behind_eyes, muscle_aches, joint_pains, nausea, vomiting, loss_of_appetite]).
disease(tuberculosis, [weight_loss, fever, night_sweats, cough, chest_pain, coughing_blood, loss_of_appetite, anemia]).
disease(diabetes, [fatigue, numbness, blurry_vision, extreme_thirst, increased_urination, infections, irritability, dry_mouth]).
disease(hiv, [sore_throat, fever, swollen_lymph_nodes, rash, muscle_aches, night_sweats, mouth_ulcers, chills, fatigue]).
disease(typhoid_fever, [fever, fatigue, headache, nausea, abdominal_pain, constipation]).
disease(measles, [fever, runny_nose, cough, watery_eyes, white_spots_inside_cheeks, rash]).
disease(leptospirosis, [fever, headache, chills, muscle_aches, vomiting, jaundice, red_eyes, abdominal_pain, rash]).
% pneumonia and influenza at the bottom

disease(malaria) :-
    symptoms_duration(Duration), Duration >= 7,
    validate(malaria), 
    symptom(fever),
    symptom(chills),
    symptom(headache),
    symptom(muscle_aches),
    symptom(tiredness),
    symptom(nausea),
    symptom(vomiting),
    symptom(diarrhea).
    

disease(dengue) :-
    symptoms_duration(Duration), Duration >= 3,
    validate(dengue),
    symptom(fever),
    symptom(rash),
    symptom(headache),
    symptom(pain_behind_eyes),
    symptom(muscle_aches),
    symptom(nausea),
    symptom(vomiting),
    symptom(tiredness),
    symptom(diarrhea).
    

disease(tuberculosis) :-
    symptoms_duration(Duration), Duration >= 7,
    validate(tuberculosis),
    symptom(weight_loss), 
    symptom(fever), 
    symptom(night_sweats), 
    symptom(cough), 
    symptom(chest_pain),
    symptom(coughing_blood), 
    symptom(loss_of_appetite), 
    symptom(anemia).

disease(pneumonia) :-
    symptoms_duration(Duration), Duration >= 1,
    validate(pneumonia),
    (is_old -> symptom(confusion) ; true),
    symptom(cough),
    symptom(fever),
    symptom(chest_pain),
    symptom(shortness_of_breath),
    symptom(fatigue),
    symptom(loss_of_appetite).
    
disease(diabetes) :-
    symptoms_duration(Duration), Duration >= 3,
    validate(diabetes), 
    symptom(numbness),
    symptom(blurry_vision),
    symptom(extreme_thirst),
    symptom(increased_urination),
    symptom(infections),
    symptom(irritability),
    symptom(dry_mouth).

disease(hiv) :-
    symptoms_duration(Duration), Duration >= 7,
    validate(hiv),
    symptom(sore_throat),
    symptom(fever),
    symptom(swollen_lymph_nodes),
    symptom(rash),
    symptom(muscle_aches),
    symptom(night_sweats),
    symptom(mouth_ulcers),
    symptom(chills),
    symptom(fatigue).

disease(typhoid_fever) :-
    symptoms_duration(Duration), Duration >= 21,
    validate(typhoid_fever),
    symptom(fever),
    symptom(fatigue),
    symptom(headache),
    symptom(nausea),
    symptom(abdominal_pain),
    symptom(constipation).

disease(influenza) :-
    symptoms_duration(Duration), Duration >= 2,
    validate(influenza),
    (is_child -> symptom(vomiting) ; true),
    symptom(fever),
    symptom(cough),
    symptom(sore_throat),
    symptom(runny_nose),
    symptom(muscle_aches),
    symptom(headache).

disease(measles) :-
    symptoms_duration(Duration), Duration >= 3,
    validate(measles),
    symptom(fever),
    symptom(runny_nose),
    symptom(cough),
    symptom(watery_eyes),
    symptom(white_spots_inside_cheeks),
    symptom(rash).

disease(leptospirosis) :-
    symptoms_duration(Duration), Duration >= 3,
    validate(leptospirosis), 
    symptom(fever),
    symptom(headache),
    symptom(chills),
    symptom(muscle_aches),
    symptom(vomiting),
    symptom(jaundice),
    symptom(red_eyes),
    symptom(abdominal_pain),
    symptom(rash).

main :-
    retractall(user_symptom(_)),
    retractall(negative_symptom(_)),
    retractall(age(_)),
    retractall(symptoms_duration(_)),

    ask('Would you like to start your examination?', Response),
    (
        Response == 'Y' ->
            age_input,
            
            % Chief complaint
            write('What is your main concern? '),
            read(Chief_complaint),
            assertz(user_symptom(Chief_complaint)), nl,

            symptoms_duration_input,
            % HPI
            ((disease(X), write('You might have '), write(X), write('.'), nl) ; 
             write('Sorry, we cannot diagnose you based on your symptoms. Please consult a doctor.'))
            ;
                
        Response == 'N' ->
        write('Thank you for your time.');
        write('Sorry. I do not recognize this input.')
        
    ),
    retractall(user_symptom(_)),
    retractall(negative_symptom(_)),
    retractall(age(_)),
    retractall(symptoms_duration(_)),
    retractall(disease(_,_)),


    nl, write('Please enter a period ''.'' to exit'),
    read(_),
    halt.



symptom(Symptom) :-
    \+ negative_symptom(Symptom),
    (
    user_symptom(Symptom) -> true ;
    ask_symptom(Symptom)
    ).

ask_symptom(Symptom) :-
    write(Symptom),
    write(' (Y/N) '),

    read(Input), nl,
    (
        (Input == 'Y'; Input == 'y') ->
            assertz(user_symptom(Symptom));
        (Input == 'N'; Input == 'n') ->
            assertz(negative_symptom(Symptom)), fail;
        (   
    		write('Input invalid. Please input again.'), nl,
        	ask_symptom(Symptom)
    	)
    ).

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
    ).

is_child :-
    age(Age),
    Age < 18.

is_old :-
    age(Age),
    Age >= 60.

validate(Disease) :- 
    disease(Disease, Symptoms),
    findall(Symptom, user_symptom(Symptom), User_Symptoms),
    findall(Negative_Symptom, negative_symptom(Negative_Symptom), Negative_Symptoms),

    findall(Negative_Symptom, negative_symptom(Negative_Symptom), Negative_Symptoms),
    (Negative_Symptoms \= [], \+ member_of_list(Negative_Symptoms, Symptoms) ; Negative_Symptoms = []),

    findall(Symptom, user_symptom(Symptom), User_Symptoms),
    subset(User_Symptoms, Symptoms),
    write('Checking for '), write(Disease), write('...'), nl.
    
% Check if at least one member of a set exists in another set
member_of_list([], _) :- fail.
member_of_list([H|T], List) :-
    member(H, List);
    member_of_list(T, List).

age_input :-
    write('Please enter your age '),
    read(Age),
    (integer(Age), Age > 0, Age =< 120) ->
        (assertz(age(Age)), nl,
            (Age >= 60) ->
                assertz(disease(pneumonia, [cough, fever, chest_pain, shortness_of_breath, fatigue, loss_of_appetite, confusion])),
                assertz(disease(influenza, [fever, cough, sore_throat, runny_nose, muscle_aches, headache]))
            ;
            (Age < 18) ->
                assertz(disease(influenza, [fever, cough, sore_throat, runny_nose, muscle_aches, headache, vomiting])),
                assertz(disease(pneumonia, [cough, fever, chest_pain, shortness_of_breath, fatigue, loss_of_appetite]))
            ;
                assertz(disease(pneumonia, [cough, fever, chest_pain, shortness_of_breath, fatigue, loss_of_appetite])),
                assertz(disease(influenza, [fever, cough, sore_throat, runny_nose, muscle_aches, headache]))
                
        )
    ;
        write('Invalid age. Please enter a valid age.'), nl,
        age_input.

symptoms_duration_input :-
    write('How many days have you been experiencing symptoms? '),
    read(Duration),
    (integer(Duration), Duration > 0, Duration =< 120) ->
        assertz(symptoms_duration(Duration)), nl
    ;
        write('Invalid input. Please enter a valid number.'), nl,
        symptoms_duration_input.