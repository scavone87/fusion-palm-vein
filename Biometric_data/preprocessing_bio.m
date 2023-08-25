%% Script di Interpolazione e Salvataggio dei Dati

% Questo script esegue l'interpolazione dei dati di scansione e salva i risultati in un file .mat.

%% Caricamento delle Informazioni

% Questa sezione controlla se la variabile 'v' è presente nello workspace. Se non lo è,
% carica i dati dal file .mat 'visualization_info.mat'.

% Verifica se la variabile è presente nel workspace
 if exist('v','var') == 1
    disp('La variabile è presente nel workspace.');
else
    % Carica il file .mat contenente la variabile
    nomeFile = 'visualization_info.mat';
    load(nomeFile);
    disp('Il file .mat è stato caricato.');
end

%% Esegue l'interpolazione

% In questa sezione, i dati di scansione vengono inizializzati e interpolati.

% Inizializzazione dei dati di scansione
[filelist, cartella] = init_bio();                                      % Inizializzazione della lista dei file e della cartella
[M, X, Y1, Z] = data_bio(filelist, v.pixel_length, v.resY, phys_pitch, repr_pitch, dimY);   % Caricamento e inizializzazione dei dati di scansione
[M, Y] = interp_bio(M, Y1, Z, repr_pitch, phys_pitch, v.pixel_length);      % Interpolazione dei dati

%% Salvataggio dei dati

% Questa sezione gestisce il salvataggio dei dati interpolati in un file .mat.
% Creazione della cartella se non esiste
folderMatfiles = 'Matfiles';
if ~exist(folderMatfiles, 'dir')
    mkdir(pwd, folderMatfiles); 
end
matFolder = fullfile(pwd, folderMatfiles, '\');

% Generazione del nome del file di acquisizione per il salvataggio
out=regexp(pathnameUOB,'\','split');
nomeAcquisizione = strcat(string(out(end-1)), '_', string(out(end)), filenameuob(6:9), ".mat"); % per lo script di creazione automatica del database dei .mat
% nomeAcquisizione = strcat(string(out(end)), filenameuob(6:9), ".mat") % Nome senza data

% nomeAcquisizione = strcat(string(out(end-1)), filenameuob(6:9), ".mat"); % per la creazione dei singoli .mat
matFile = strcat(matFolder, nomeAcquisizione);
% Salvataggio dei dati interpolati nel file .mat
save(matFile,"M","X","Y","Z","pixel_length");
disp('Dati interpolati salvati in un file .mat.');
% save file.mat M X Y Z    