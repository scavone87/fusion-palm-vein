function  generaImmagineMaster(matFilesFolderPath, masterImagesFolderPath)
%UNTITLED2 Summary of this function goes here
% Imposta il percorso della cartella contenente i file .mat

% Ottieni la lista dei file .mat nella cartella
matFiles = dir(fullfile(matFilesFolderPath, '*.mat'));

% Crea una cartella per le immagini master se non esiste
if ~exist(masterImagesFolderPath, 'dir')
    mkdir(masterImagesFolderPath);
end

currentUser = '';

for fileIdx = 1:length(matFiles)
    matFileName = matFiles(fileIdx).name;

    user = split(matFileName, '_');
    user = string(user(end-1));

    if currentUser ~= user
        fprintf('Generazione immagine master per: %s\n', user);

        matFilePath = fullfile(matFilesFolderPath, matFileName);
        data = load(matFilePath); % Carica i dati specifici per il file corrente

        %PARAMETRI
        tresh=64;   % Intensity threshold for surface detection (0 - 255)
        filter_siz=20;  % Averaging filter

        M = data.M;
        Z = data.Z;
        pixel_length = data.pixel_length;

        % Genera l'immagine master
        depth = 2 * pixel_length; % Imposta la profondità per l'immagine master
        [~, masterImage] = surface_detection(M, tresh, filter_siz, depth, Z);

        % Salva l'immagine master in una directory specifica
        masterImageFileName = fullfile(masterImagesFolderPath, [matFileName(1:end-4) '_master.jpg']);
        imwrite(masterImage, masterImageFileName, 'jpg');

        currentUser = user;

    end


end
end