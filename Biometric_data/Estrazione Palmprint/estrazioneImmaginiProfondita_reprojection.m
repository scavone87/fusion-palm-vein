clearvars -except v pixel_length startTime_mainScript

addpath("lib\");

% Imposta il percorso della cartella contenente i file .mat
matFilesFolderPath = fullfile(fileparts(pwd), 'Matfiles');

% Imposta il percorso della cartella contenente le immagini master
masterImagesFolderPath = fullfile(pwd, 'masterImages');

% Ottieni la lista dei file .mat nella cartella
matFiles = dir(fullfile(matFilesFolderPath, '*.mat'));

generaImmagineMaster(matFilesFolderPath, masterImagesFolderPath);

% Verifica se il cluster è già attivo
currentPool = gcp('nocreate');

% Se il cluster non è attivo, avvialo
if isempty(currentPool)
    parpool(); % Inizializza il pool parallelo
end

startTime_generaImmaginiProfondita = tic;

parfor fileIdx = 1:length(matFiles)
    matFileName = matFiles(fileIdx).name;
    fprintf('Elaborazione di: %s\n', matFileName);

    matFilePath = fullfile(matFilesFolderPath, matFileName);
    data = load(matFilePath); % Carica i dati specifici per il file corrente

    % Estrai il nome utente dal nome del file
    username = strtok(matFileName, '_');

    % Carica l'immagine master corrispondente all'utente dal file system
    masterImageFileName = fullfile(pwd, 'masterImages', [matFileName(1:end-7) '000_master.jpg']);
    masterImage = imread(masterImageFileName);

    %PARAMETRI
    tresh=64;   % Intensity threshold for surface detection (0 - 255)
    filter_siz=20;  % Averaging filter

    M = data.M;
    Z = data.Z;
    pixel_length = data.pixel_length;

    sz = size(M);
    FFF = zeros(sz(2), sz(3), sz(1));

    for i = 2:7
        depth = i * pixel_length;
        [surf_filt, FFF] = surface_detection(M, tresh, filter_siz, depth, Z);

        % Utilizza l'immagine master generata nella prima iterazione come riferimento
        slave = im2double(FFF); % Assicurati che le immagini siano in doppia precisione
        if i == 2
            % Esegui la registrazione delle immagini
            [optimizer,metric] = imregconfig('monomodal');
            tform = imregtform(slave, masterImage, 'rigid', optimizer, metric);
        end
        movingRegistered = imwarp(slave, tform, 'OutputView', imref2d(size(masterImage)));

        % Converti l'immagine master in double se non lo è già
        master = im2double(masterImage);

        % Calcola l'Errore Quadratico Medio (MSE)
        mse = immse(movingRegistered, master);

        % Calcola l'Errore Quadratico Medio Normalizzato (NMSE)
        nmse = mse / mean(master(:).^2);

        %fprintf("Errore Quadratico Medio (MSE) per l'immagine %d: %.4f\n", i-1, mse);
        %fprintf("Errore Quadratico Medio Normalizzato (NMSE) per l'immagine %d: %.4f\n", i-1, nmse);

        FileName = strcat('immagine_', num2str(i-1), '_', num2str(depth), '.jpg');
        path = fullfile(pwd, 'imageGeneratedFrom3D', matFileName(1:end-4));
        if ~exist(path, 'dir')
            mkdir(path);

        end
        Name = fullfile(path, FileName);
        imwrite(movingRegistered, Name, 'jpg');
    end

    fprintf('Elaborazione completata per: %s\n', matFileName);
end

endTime_generaImmaginiProfondita = toc(startTime_generaImmaginiProfondita);

fprintf('Tempo di esecuzione dello script generaImmaginiProfondita: %.2f secondi\n', endTime_generaImmaginiProfondita);
