%analogo di carica_database
%clear all;

%clc;
close all;

%database-prova\mat
cartella=uigetdir(pwd,'Seleziona la directory in cui sono salvati i files .mat');

%prendiamo la directory di lavoro corrente con pwd
directory_name=pwd;%J:\Sensori\CodiceNostro
cartella=strcat(cartella,'\');

%fullfile costruisce un percorso da parti di path che gli diamo in input,
%i questo caso credo sia inutile perchè gli diamo sono una parte che e'
%gia' tutto il percorso.
%dir invece ci restituisce la struct che ha le info delle varie cartelle e
%file contenuti nel percorso, più la cartella . e ..
dirs=dir(fullfile(cartella));

for i=3:length(dirs)%length(dirs) mi dice quanti sono gli utenti
   %percorso cartella utente corrente
   path=strcat(cartella,dirs(i).name);
   
   %aggiungo \ al path
   path=strcat(path,'\');
   
   %creo una struttura che contiene tutti file .mat a ciascun istante di
   %acquisizione
   files=dir(fullfile(path,'*.mat'));
   
   %numero di istanti, quindi dimensione della struttura
   elementi=length(files);%size(files,1);
   
   for contatore=1:elementi
     % numero caratteri del nome, mi servirà per prendere solo la stringa
     % del nome senza _00i
     lunghezzaNome = 1:length(files(contatore).name)-4;
     corrente=files(contatore).name(lunghezzaNome);
     
     generaImmaginiProfondita(corrente, path);
   end
end