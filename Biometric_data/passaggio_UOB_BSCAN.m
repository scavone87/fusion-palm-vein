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