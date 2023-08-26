clearvars -except v pixel_length startTime_mainScript

addpath("lib\");

% Imposta il percorso della cartella contenente i file .mat
matFilesFolderPath = fullfile(fileparts(pwd), 'Matfiles');

% Ottieni la lista dei file .mat nella cartella
matFiles = dir(fullfile(matFilesFolderPath, '*.mat'));

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

    %PARAMETRI
    tresh=64;   % Intensity treshold for surface detection (0 - 255)
    filter_siz=20;  % Averaging filter

    M = data.M;
    Z = data.Z;
    pixel_length = data.pixel_length;

    sz = size(M);
    FFF = zeros(sz(2), sz(3), sz(1));
    for i = 2:7
        depth = i * pixel_length;
        [surf_filt, FFF] = surface_detection(M, tresh, filter_siz, depth, Z);
        FileName = strcat('immagine_', num2str(i-1), '_', num2str(depth), '.jpg');
        path = fullfile(pwd, 'imageGeneratedFrom3D', matFileName(1:end-4));
        if ~exist(path, 'dir')
            mkdir(path);

        end
        Name = fullfile(path, FileName);
        imwrite(FFF, Name, 'jpg');
    end

    fprintf('Elaborazione completata per: %s\n', matFileName);
end

endTime_generaImmaginiProfondita = toc(startTime_generaImmaginiProfondita);

fprintf('Tempo di esecuzione dello script generaImmaginiProfondita: %.2f secondi\n', endTime_generaImmaginiProfondita);
