clearvars -except v pixel_length startTime_mainScript

addpath("lib\");

% Imposta il percorso della cartella contenente i file .mat
matFilesFolderPath = fullfile(fileparts(pwd), 'Matfiles_dbRidotto');

% Imposta il percorso della cartella contenente le immagini master
masterImagesFolderPath = fullfile(pwd, 'masterImages_nardielloNoFill_repro40');

% Ottieni la lista dei file .mat nella cartella
matFiles = dir(fullfile(matFilesFolderPath, '*.mat'));

% Crea una cartella per le immagini master se non esiste
if ~exist(masterImagesFolderPath, 'dir')
    mkdir(masterImagesFolderPath);
end

% Crea un dizionario per raggruppare i file per utente
userFileMap = containers.Map('KeyType', 'char', 'ValueType', 'any');

for fileIdx = 1:length(matFiles)
    matFileName = matFiles(fileIdx).name;
    user = split(matFileName, '_');
    user = string(user(end-1));
    user = char(user);

    if isKey(userFileMap, user)
        userFileMap(user) = [userFileMap(user), fileIdx];
    else
        userFileMap(user) = fileIdx;
    end
end

users = keys(userFileMap);

% Inizializza un pool di lavoratori se necessario
if isempty(gcp('nocreate'))
    parpool;
end

% Usa parfor per iterare sugli utenti
parfor i = 1:length(users)
    user = users{i};
    fileIndices = userFileMap(user);

    matFileName = matFiles(fileIndices(6)).name;
    matFilePath = fullfile(matFilesFolderPath, matFileName);
    data = load(matFilePath);

    %PARAMETRI
    tresh=64;
    filter_siz=40;

    M = data.M;
    Z = data.Z;
    pixel_length = data.pixel_length;

    % Genera l'immagine master una volta per utente
    depth = 2 * pixel_length;
    [~, masterImage] = surface_detection(M, tresh, filter_siz, depth, Z);
    masterImageFileName = fullfile(masterImagesFolderPath, [matFileName(1:end-4) '_master.jpg']);
    imwrite(masterImage, masterImageFileName, 'jpg');

    fprintf('Generazione immagine master per: %s\n', user);

    for fileIdx = fileIndices
        matFileName = matFiles(fileIdx).name;
        matFilePath = fullfile(matFilesFolderPath, matFileName);
        data = load(matFilePath);

        M = data.M;
        Z = data.Z;
        pixel_length = data.pixel_length;

        for j = 2:7
            depth = j * pixel_length;
            [surf_filt, slave] = surface_detection(M, tresh, filter_siz, depth, Z);

            if j == 2
                [optimizer,metric] = imregconfig('monomodal');
                tform = imregtform(slave, masterImage, 'rigid', optimizer, metric);
            end

            movingRegistered = imwarp(slave, tform, 'OutputView', imref2d(size(masterImage)));

            FileName = strcat('immagine_', num2str(j-1), '_', num2str(depth), '.jpg');
            path = fullfile(pwd, 'imageGeneratedFrom3D', matFileName(1:end-4));
            if ~exist(path, 'dir')
                mkdir(path);
            end
            Name = fullfile(path, FileName);
            imwrite(movingRegistered, Name, 'jpg');
        end
        fprintf('Elaborazione completata per: %s\n', matFileName);
    end
end
