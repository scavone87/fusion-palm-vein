% Come prima cosa le strutture .mat (che arrivano dalla conversione uob-mat
% devono essere trasformati in jpg)
% clear all;

%dobbiamo fare il controllo se la cartella esiste gia' non facciamo la
%conversione
warning off;
analysisType = 3; %indica il 3D
disp('Conversione mat-jpg in corso...');
convertiMatJpg
disp('Conversione mat-jpg effettuata.');

%estraiamo l'immagine ad una certa profonda' (non sono sicura)
disp('Fusione delle immagini a profondita'' 0.05 e 0.1 in corso...');
mergeUtentiCartella
disp('Fusione delle immagini a profondita'' 0.05 e 0.1 effettuata.');

%carichiamo le immagini jpg, per l'analisi 2D e 3D lo script deve essere
%diverso perchè le cartelle sono strutturate in modo diverso
disp('Generazione dei template 2D in corso...');
templateUtentiCartella
disp('Generazione dei template 2D effettuata.');

%a questo punto ho i template alle varie profondita'. ora devo generare il
%template 3D
disp('Generazione dei template 3D in corso...');
generaTemplate3D
disp('Generazione dei template 3D effettuata.');

%generiamo la tabella finale con gli score dei confronti
disp('Matching in corso...');
identificazioneMatching3D_CPUParallel
disp('Matching effettuato.');

%per ottenere i grafici dei genuini e impostori e per ottenere il FAR e FRR
%e EER
disp('Estrazione delle statistiche in corso...');
statics_3D
disp('Estrazione delle statistiche effettuata');

%disegnamo la DET
disp('Creazione delle curve DET in corso...');
drawDETcurve
disp('Creazione delle curve DET effettuata.');

