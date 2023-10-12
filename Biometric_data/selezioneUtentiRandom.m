% Definizione del tempo totale disponibile in secondi
tempo_totale_secondi = 18000; %5h

% Definizione del tasso di confronti al secondo
tasso_confronti_sec = 3;

% Calcolo del numero massimo di confronti che possono essere fatti
numero_massimo_confronti = tempo_totale_secondi * tasso_confronti_sec;

% Definizione del numero di acquisizioni per persona
acquisizioni_per_persona = 20;

% Risoluzione dell'equazione per determinare il numero di acquisizioni massime
% Utilizziamo la formula n(n-1)/2 = numero_massimo_confronti
% Risolviamo l'equazione quadratica
syms n
eqn = n*(n-1)/2 == numero_massimo_confronti;
sol = solve(eqn, n);

% Calcolo del numero di persone per il database ridotto
numero_persone_database_ridotto = ceil(sol / acquisizioni_per_persona);

% Visualizzazione del risultato
disp(['Il numero di persone per il database ridotto è: ', sim2str(numero_persone_database_ridotto(2,1))]);

% Definizione del numero di persone per il database ridotto
numero_persone_database_ridotto = double(numero_persone_database_ridotto(2, 1)); % Sostituisci con il valore calcolato precedentemente

% Percorso della cartella "database" (assicurati che esista)
cartella_database = uigetdir('Seleziona il database completo')

% Percorso della cartella "database_ridotto" (assicurati che esista o creala)
folderDBRidotto = 'databaseRidotto';
if ~exist(folderDBRidotto, 'dir')
    mkdir(pwd, folderDBRidotto); 
end
cartella_database_ridotto = fullfile(pwd, folderDBRidotto, '\');

% Otteniamo un elenco delle cartelle nella cartella "database"
elenco_cartelle_database = dir(cartella_database);

% Rimuoviamo le voci che non sono cartelle (ad esempio, "." e "..")
elenco_cartelle_database = elenco_cartelle_database([elenco_cartelle_database.isdir]);

% Assicuriamoci che il numero_persone_database_ridotto non sia maggiore dell'elenco delle cartelle
if numero_persone_database_ridotto > numel(elenco_cartelle_database)
    disp('Errore: Il numero richiesto di persone per il database ridotto è maggiore del numero di cartelle nel database.');
else
    % Generiamo un vettore di indici casuali unici
    indici_casuali = randperm(numel(elenco_cartelle_database), numero_persone_database_ridotto);
    
    % % Creiamo la cartella "database_ridotto" se non esiste
    % if ~exist(cartella_database_ridotto, 'dir')
    %     mkdir(cartella_database_ridotto);
    % end
    
    % Copiamo le cartelle selezionate casualmente nella cartella "database_ridotto"
    for i = 1:numel(indici_casuali)
        cartella_selezionata = elenco_cartelle_database(indici_casuali(i)).name;
        origine = fullfile(cartella_database, cartella_selezionata);
        destinazione = fullfile(cartella_database_ridotto, cartella_selezionata);
        copyfile(origine, destinazione);
    end
    
    disp(['Copiate con successo ', num2str(numero_persone_database_ridotto), ' cartelle nel database ridotto.']);
end