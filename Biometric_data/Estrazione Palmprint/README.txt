L'analisi 2D parte richiamando la funzione analisi2D, che prende in input un valore per la scelta della strategia da utilizzare

Viene richiesta la directory contenente i file delle acquisizioni e la directory in cui memorizzare i risultati, nel nostro caso 'database-prova/image2D' e
'database-prova/risultati', rispettivamente.
Durante l'elaborazione viene creata una cartella con il nome della strategia e all'interno le cartelle con file .jpg e .dat.

Viene eseguito il matching. in questa fase si richiede la directory in cui sono salvati i template .dat (es. 'database-prova/risultati/DiBello/.dat'), poi viene 
richiesto il nome del file in cui salvare la tabella di matching.

Nell'ultima fase si chiede di caricare il file dei risultati di matching e viene creata una cartella in 'Statistiche' con il nome del file .mat utilizzato e la data
e l'ora in cui viene effettuato il calcolo delle statistiche (es. 'Statistiche/RisultatiDOG/04-oct-2018 16-26-41') in cui ci sono i file che memorizzano 
il vettore del FAR, dell'FRR e dell'EER.

_______
Nella cartella corrente si trova anche un README più dettagliato con gli screenshot dei vari passaggi e un esempio