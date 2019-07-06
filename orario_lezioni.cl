%*
generazione  del  calendario  settimanale  delle  lezioni  di  una scuola   media   che   aderisce   al   progetto   “Pellico”:   ad   ogni insegnamento   è   associata   un’aula   o   un   laboratorio,   e   gli studenti  si  spostano  nell’aula  della  lezione  prevista  in  stile campus universitario. In particolare:

- ci   sono   otto   aule:   lettere   (2   aule),   matematica, tecnologia, musica, inglese, spagnolo, religione;
- ci  sono  tre  laboratori:  arte,  scienze,  educazione  fisica (palestra);
- ci   sono   due   docenti   per   ciascuno   dei   seguenti insegnamenti: lettere, matematica, scienze;
- vi è un unico docente per tutti gli altri insegnamenti;
- ci sono due classi per ogni anno di corso, una a regime “tempo prolungato” ed una a regime “tempo normale”. Si assuma  che  l’unica  differenza  riguarda  la  frequenza  di attività  extra-scolastiche  e  la  partecipazione  alla  mensa scolastica, mentre non vi è alcuna differenza per quanto riguarda   il   calendario   delle   lezioni,   di   30   ore complessive,  da  distribuire  in  5  giorni  (da  lunedì  a venerdì),  6  ore  al  giorno.  Per  convenzione,  si  assuma che la sezione A sia tempo prolungato e che la sezione B  sia  tempo  normale:  le  classi  sono,  pertanto:  1A,  1B, 2A, 2B, 3A, 3B;
- ogni  docente  insegna  una  ed  una  sola  materia,  con l’eccezione  di  matematica  e  scienze,  ossia  un  docente 
incaricato   di   insegnare   matematica   risulterà   anche insegnante   di   scienze   (non   necessariamente   per   la stessa classe);
- per  ogni  classe,  sono  previste  10  ore  di  lettere,  4  di matematica,  2  di  scienze,  3  di  inglese,  2  di  spagnolo,  2 di  musica,  2  di  tecnologia,  2  di  arte,  2  di  educazione fisica, 1 di religione.
*%

%*
Note that there are three important issues about the correct usage of conditions:
1. All predicates of atoms on the right-hand side of a condition must be either do-
main predicates,i.e., predicates that can be completely evaluated during ground-
ing, or built-in, which is due to the fact that conditions are evaluated during
grounding.
2. Any variable occurring within a condition is considered as local, that is, a con-
dition cannot be used to bind variables outside the condition. In turn, variables
outside conditions are global, and each variable within an atom in front of a
condition must occur on the right-hand side or be global.
3. Global variables take priority over local ones, that is, they are instantiated first. ---> !!!!!  (*1*)
As a consequence, a local variable that also occurs globally is substituted by
a term before the ground instances of a condition are determined. Hence, the
names of local variables must be chosen with care, making sure that they do not
accidentally match the names of global variables.
*% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------- DOMINIO ----------

aula(1..11).
docente(1..11).
materia(let;mat;tec;mus;ing;spa;rel;art;sci;edf;inf;pit;edc;fil).
materia_extra(inf;pit;edc;fil).
classe(1..6).
giorno(lun;mar;mer;gio;ven).
ora_standard(1..6).
ora(1..10).
ore_al_giorno(10).

% Le classi dispari sono a tempo prolungato
tempo_prolungato(C) :- classe(C), (C \ 2) == 1.

% -------- ASSOCIAZIONI MATERIE-DOCENTI  -----------

%*
% Ogni docente insegna al più due materie (sia standard che extra)
1 { insegna(D,M) : materia(M) } 2 :- docente(D).

% Se non insegna mat e non insegna materie extra, insegna una ed una sola una materia 
1 { insegna(D,M) : materia(M) } 1 :- docente(D), not insegna(D,mat), not docente_extra(D).

% Al contrario, se insegna mat, allora insegna anche sci e viceversa (insegna mat se e solo se insegna sci)
insegna(D,sci) :- insegna(D,mat).
insegna(D,mat) :- insegna(D,sci).

% Ogni materia è insegnata al più da due docenti
1 { insegna(D,M) : docente(D) } 2 :- materia(M).

% Ma nel caso non si tratti di let, mat o sci, allora vi è solo un docente per quella materia
1 { insegna(D,M) : docente(D) } 1 :- materia(M), M != let, M != mat, M != sci.
*%

insegna(D,inf) :- insegna(D,tec).
insegna(D,pit) :- insegna(D,art).
insegna(D,edc) :- insegna(D,edf).
insegna(D,fil) :- insegna(D,mus).

docente_extra(D) :- materia_extra(M), insegna(D,M).

% -------- ASSOCIAZIONI AULE-MATERIE -----------

%*
% Ogni materia ha una ed una sola aula dedicata, se non si tratta di let
1 { aula_dedicata(A,M) : aula(A) } 1 :- materia(M), M != let.

% Altrimenti, ha esattamente due aule dedicate
2 { aula_dedicata(A,let) : aula(A) } 2 .

% Ogni aula è dedicata ad al più due materie
1 { aula_dedicata(A,M) : materia(M) } 2 :- aula(A).

% Ma se non si tratta di un'aula extra, è dedicata ad una ed una sola materia
1 { aula_dedicata(A,M) : materia(M) } 1 :- aula(A), not aula_extra(A).
*%

% L'aula dedicata a tecnologia è anche dedicata a informatica ecc.
aula_dedicata(A,inf) :- aula_dedicata(A,tec).
aula_dedicata(A,pit) :- aula_dedicata(A,art).
aula_dedicata(A,fil) :- aula_dedicata(A,mus).
aula_dedicata(A,edc) :- aula_dedicata(A,rel).

aula_extra(A) :- materia_extra(M), aula_dedicata(A,M).

% -------- ASSOCIAZIONI MATERIE-DOCENTI E AULE-MATERIE (HARD CODED) ---------

insegna(1,let).
insegna(2,let).
insegna(3,mat).
insegna(3,sci).
insegna(4,mat).
insegna(4,sci).
insegna(5,ing).
insegna(6,spa).
insegna(7,mus).
insegna(8,tec).
insegna(9,art).
insegna(10,edf).
insegna(11,rel).

aula_dedicata(1,let).
aula_dedicata(2,let).
aula_dedicata(3,mat).
aula_dedicata(4,sci).
aula_dedicata(5,ing).
aula_dedicata(6,spa).
aula_dedicata(7,mus).
aula_dedicata(8,tec).
aula_dedicata(9,art).
aula_dedicata(10,edf).
aula_dedicata(11,rel).


% --------- MONTE ORE  -----------

% Monte ore materie standard
10 { ora_dedicata(let,C,G,O) : giorno(G) , ora(O) } 10 :- classe(C).
4 { ora_dedicata(mat,C,G,O) : giorno(G) , ora(O) } 4 :- classe(C).
2 { ora_dedicata(sci,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C).
3 { ora_dedicata(ing,C,G,O) : giorno(G) , ora(O) } 3 :- classe(C).
2 { ora_dedicata(spa,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C).
2 { ora_dedicata(mus,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C).
2 { ora_dedicata(tec,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C).
2 { ora_dedicata(art,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C).
2 { ora_dedicata(edf,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C).
1 { ora_dedicata(rel,C,G,O) : giorno(G) , ora(O) } 1 :- classe(C).

% Monte ore materie extra
4 { ora_dedicata(inf,C,G,O) : giorno(G) , ora(O) } 4 :- classe(C), tempo_prolungato(C).
2 { ora_dedicata(pit,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C), tempo_prolungato(C).
2 { ora_dedicata(fil,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C), tempo_prolungato(C).
2 { ora_dedicata(edc,C,G,O) : giorno(G) , ora(O) } 2 :- classe(C), tempo_prolungato(C).


% --------- DEFINIZIONE RUOLO DEI DOCENTI --------------

% Fisso una materia (standard), fisso una classe. Tra tutti i docenti che insegnano suddetta materia, solo uno
% risulta -di ruolo- per la data classe. Funziona grazie a (*1*)
1 { ruolo(D,M,C) : insegna(D,M) } 1 :- materia(M), not materia_extra(M), classe(C). 

% Definizione dei ruoli per le materie extra
ruolo(D,inf,C) :- ruolo(D,tec,C), tempo_prolungato(C). 
ruolo(D,pit,C) :- ruolo(D,art,C), tempo_prolungato(C). 
ruolo(D,edc,C) :- ruolo(D,edf,C), tempo_prolungato(C). 
ruolo(D,fil,C) :- ruolo(D,mus,C), tempo_prolungato(C). 

% Un docente deve risultare di ruolo (data una materia che insegna) almeno per 3 classi distinte:
% serve per assicurare che i docenti di let, mat e sci si distribuiscano il carico
3 { ruolo(D,M,C) : classe(C) } :- docente(D), insegna(D,M).


% --------- DEFINIZIONE DI AULA OCCUPATA --------------

% Quando una classe segue una materia, solo una delle aule dedicate a tale materia deve risultare occupata da suddetta classe
1 { aula_occupata(A,C,G,O) : aula_dedicata(A,M) } 1 :- ora_dedicata(M,C,G,O).


% --------- DEFINIZIONE DI DOCENTE IMPEGNATO -------------

docente_impegnato(D,M,C,G,O) :- ora_dedicata(M,C,G,O), ruolo(D,M,C).  % bound della materia direttamente in docente_impegnato...


% ---------- DEFINIZIONE DI LEZIONE -------------

lezione(A,D,M,C,G,O) :- docente_impegnato(D,M,C,G,O), aula_occupata(A,C,G,O).  % ...quindi non devo disambiguare la materia M 


% ---------- INTEGRITY COSTRAINTS E VINCOLI AGGIUNTIVI ------------

%*
%%%%%%%%%%%%%%%%%%%
% ORE CONSECUTIVE (OLD VERSIONS)  ---> non fungono con orario esteso

% Forza a fare due ore consecutive di una materia; le ultime due ore non hanno tale vincolo per gestire materie con monte ore dispari (rel e ing) - versione a.
% :- ora_dedicata(M1,C,G,O1), ora_dedicata(M2,C,G,O1+1), (O1 \ 2) == 1, not ore_al_giorno(O1+1), M1 != M2.

% Forza a fare due ore consecutive di una materia, escludendo solo religione (meglio) - versione b.
% il controllo sul modulo è essenziale, altrimenti prova a metterle in sequenza (O,O+1,O+2,...) e fallisce.
% :- ora_dedicata(M1,C,G,O), ora_dedicata(M2,C,G,O+1), (O \ 2) == 1, M1 != M2, M2 != rel.
%%%%%%%%%%%%%%%%%%%
*%  

% Non è obbligatorio per la correttezza della soluzione, ma evita
% che vengano definiti docenti di ruolo extra per quelle classi che non le frequentano
:- ruolo(_,M,C), materia_extra(M), not tempo_prolungato(C).  

% Le classi che non sono a tempo prolungato frequentano solo le prime 6 ore di ogni giornata
:- ora_dedicata(_,C,_,O), O > 6, not tempo_prolungato(C).

% Data un'ora, se tale ora è fra le prime 6 deve esservi lezione qualsiasi sia il giorno e la classe
:- ora(O), giorno(G), classe(C), not ora_dedicata(_,C,G,O), O <= 6.

% Non è possibile avere ore buca:
% data un'ora O1, non può NON esservi lezione se durante un'ora successiva O2 c'è lezione
:- ora(O1), not ora_dedicata(_,C,G,O1), ora_dedicata(_,C,G,O2), O1 < O2. 

% Non è possibile cambiare aula a cavallo di una lezione (di fatto solo per letteratura).
% Qui il modulo non è strettamente necessario ma velocizza la ricerca di soluzioni.
:- lezione(A1,D,M,C,G,O), lezione(A2,D,M,C,G,O+1),  A1 != A2, (O \ 2) == 1.

% Limita a due il massimo numero giornaliero di ore per una data materia 
{ ora_dedicata(M,C,G,O) : ora(O) } 2 :- classe(C), materia(M), giorno(G).

% Un docente non può insegnare a due classi contemporaneamente
:- docente_impegnato(D,_,C1,G,O), docente_impegnato(D,_,C2,G,O), C1 != C2. 

% Una classe non può seguire due lezioni contemporaneamente
:- ora_dedicata(M1,C,G,O), ora_dedicata(M2,C,G,O), M1 != M2.

% Un'aula non può ospitare due classi conteporaneamente
:- aula_occupata(A,C1,G,O), aula_occupata(A,C2,G,O), C1 != C2.

% Una classe non può occupare due aule contemporaneamente
:- aula_occupata(A1,C,G,O), aula_occupata(A2,C,G,O), A1 != A2.


% Due ore consecutive della stessa materia quando possibile (NEW VERSION)
ora_dedicata(M,C,G,O+1) :- ora_dedicata(M,C,G,O), (O \ 2) == 1, M != rel.



% --------- SHOW ---------

%#show aula_dedicata/2.
%#show insegna/2.

% I predicati che seguono sono quelli di cui necessita il checker automatico
#show ruolo/3.
#show lezione/6.

%%%#show(A,D,M,O) :  lezione(A,D,M,1,lun,O).  %??????

