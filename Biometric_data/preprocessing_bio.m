%% Carica le informazioni per l'interpolazione

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

% Inizializzazione dei dati di scansione
[filelist, cartella] = init_bio();                                      % Inizializzazione della lista dei file e della cartella
[M, X, Y1, Z] = data_bio(filelist, v.pixel_length, v.resY, phys_pitch, repr_pitch, dimY);   % Caricamento e inizializzazione dei dati di scansione
[M, Y] = interp_bio(M, Y1, Z, repr_pitch, phys_pitch, v.pixel_length);      % Interpolazione dei dati

%% Salvataggio dei dati
folderMatfiles = 'Matfiles';
if ~exist(folderMatfiles, 'dir')
    mkdir(pwd, folderMatfiles); 
end
matFolder = fullfile(pwd, folderMatfiles, '\');
out=regexp(pathnameUOB,'\','split')
nomeAcquisizione = strcat(string(out(end)), filenameuob(6:9), ".mat"); % per lo script di creazione automatica del database dei .mat

% nomeAcquisizione = strcat(string(out(end-1)), filenameuob(6:9), ".mat"); % per la creazione dei singoli .mat
matFile = strcat(matFolder, nomeAcquisizione);
save(matFile,"M","X","Y","Z","pixel_length");
% save file.mat M X Y Z    