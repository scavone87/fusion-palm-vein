ESECUZIONE DEL CODICE

1. generaImmaginiProfondità -> per generare la cartella 'imageGeneratedFrom3D' che contiene le immagini del palmo alle varie profondità a partire dai file .mat delle acquisizioni;

2. generaTemplate2D -> genera i template2D a partire dai file .jpg contenuti nella cartella 'imageGeneratedFrom3D'. I file risultanti vengono salvati nella cartella 'template2D' dove troviamo altre due cartelle: 

	- 'template2Dsovrapposti' in cui vengono salvate, per ogni utente, le immagini del palmo alle varie profondità con la sovrapposizione delle 	linee generate con la funzione 'estrazioneLinee.m';
	
	- 'Template2D' in cui per ogni utente vengono salvati i template2D (ovvero le linee estratte dalla funzione 'estrazioneLinee.m') sia in 	formato '.jpg', che in formato '.dat'. Questi ultimi sono quelli che verranno utilizzati nella funzione 'generaMatriceContenenteTemplate.m' 	per la generazione del template3D;

3. generaTemplate3D -> a cui va passato il path in cui si trova la cartella 'Matfiles' contenente i file.mat per ottenere i nomi delle acquisizioni. Tale script crea la cartella 'Template3DIstanti' in cui vengono salvati i template3D per istanti e richiama poi 'generaTemplate', che a sua volta richiama:
	
	-'generaMatriceContenenteTemplate' che prende i template a varie profondità e li unisce in una sola matrice;

	- 'filtraggioInProfondita' che esegue un processo di filtraggio in profondità su una matrice tridimensionale, utilizzando l'operazione di 	dilatazione morfologica e l'operazione logica AND per applicare il filtraggio. Il risultato del filtraggio viene restituito in 	'matriceOutput', che viene utilizzata da 'profonditaTratti';
	
	- 'profonditaTratti' che effettua il salvataggio per istanti dei template3D nelle rispettive cartelle e salva i template 3D in formato .dat 	nella cartella 'Template3D', all'interno della quale troviamo inoltre i template3D in formato .jpg nell'ulteriore cartella 'Template3DJpg' 	salvati tramite la funzione 'salvaTemplate3D';

4. identificazioneMatching2D/3D_CPUParallel -> esegue il matching 2D/3D tra i vari .dat e restituisce un file .mat contenente i punteggi dei vari confronti;

5. statics_3D -> per estrarre le statistiche dal file.mat generato al passo precedente.

	
