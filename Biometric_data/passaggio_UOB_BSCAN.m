%% Script di Elaborazione dei Dati Ultrasuoni
% 
% Questo script MATLAB è progettato per elaborare dati provenienti da una scansione a ultrasuoni da una sonda medica. Ecco una panoramica delle operazioni svolte:
% 
%     1. Caricamento dei Dati
%         Il codice inizia pulendo il workspace e la console.
%         Viene mostrata una finestra di dialogo per selezionare un file .uob contenente i dati della scansione.
%         Il percorso e il nome del file vengono memorizzati.
%         I dati vengono caricati in un oggetto DataObj utilizzando una classe di gestione dei dati.
% 
%     2. Estrazione delle Informazioni sull'Acquisizione
%         Diverse informazioni vengono estratte dal file .uob, inclusi le dimensioni dell'immagine 3D e i parametri dell'acquisizione (dimensioni X, Y, Z, profondità di campo, velocità del suono, frequenza di campionamento, ecc.).
% 
%     3. Calcoli per l'Interpolazione
%         Viene creato un oggetto di visualizzazione (v) per eseguire calcoli.
%         Utilizzando la velocità del suono e la frequenza di campionamento, viene calcolata la lunghezza di un pixel nell'immagine.
%         La risoluzione lungo l'asse Y viene calcolata.
%         Viene stimata una nuova dimensione X basata sulla lunghezza della sonda e dei pixel.
%         Le informazioni vengono salvate in un file visualization_info.mat.
% 
%     4. Elaborazione e Conversione
%         Viene richiamato uno script o una funzione chiamata eliminaResidui per un'elaborazione specifica (dettagli mancanti nell'estratto).
%         Successivamente, si richiama convert2bmp per convertire i dati elaborati in immagini BMP (dettagli mancanti nell'estratto).
% 

close all
clear
clc

%% Carico file .uob
[filenameuob, pathnameUOB] = uigetfile({'*.uob'},'SELECT CAPTURE .uob');
fileUOB=strcat(pathnameUOB,filenameuob);
pathnameBS = [pwd '\BSCAN' '\'];
DataObj=DataUlaopBaseBand(fileUOB);

%% Prelevo le informazioni sull'acquisizione
% Dimensioni dell'immagine 3D
dimZ = DataObj.uos.info.blocklength.num;             % Dimensione Z dell'immagine
dimX = DataObj.uop.item0.global.nlines.num;         % Dimensione X dell'immagine
dimY = DataObj.uos.info.nblocks.num / dimX;         % Dimensione Y dell'immagine
RYMIN = DataObj.uop.item0.rxsettings.rymin.num;
RYMAX = DataObj.uop.item0.rxsettings.rymax.num;
profondita_campo = RYMAX - RYMIN;
sound_speed = DataObj.uop.workingset.soundspeed.num;
fs = DataObj.fs;
Ndec = DataObj.uop.item0.rxelab.ndec(3).num;
focus = DataObj.uop.item0.txsettings.tyfocus.num;
PRF = DataObj.uop.ssg.prf.num;
TGCA = DataObj.uop.item0.rxanalog.tgc(1).num;
TGCB = DataObj.uop.item0.rxanalog.tgc(2).num;
Tresh =  DataObj.uop.image1.threshold.num;
Dynamic =  DataObj.uop.image1.dynamic.num;
scansione_meccanica = 38; % dimensione in mm. La sonda si muove lungo y da 16 a 54 mm.
lunghezza_sonda = 38.4; % dimensione in mm.
phys_pitch= 0.2;  % - phys_pitch: Passo fisico della sonda selezionata in millimetri.
repr_pitch = 0.2; % - repr_pitch: Passo di rappresentazione della sonda selezionata in millimetri.

%% Salvo le informazioni per effettuare l'interpolazione
v = visualization;
v = v.calcola_pixel_length(sound_speed,fs);
v = v.calcola_res_y(dimY, scansione_meccanica);
v.new_dimX = floor((dimX * lunghezza_sonda)/(v.pixel_length * (dimX - 1)));
pixel_length = v.pixel_length;
save visualization_info.mat v dimX dimY dimZ profondita_campo scansione_meccanica lunghezza_sonda phys_pitch repr_pitch pixel_length

%% Elimino i residui ed effettuo la conversione in bmp
eliminaResidui;
convert2bmp;