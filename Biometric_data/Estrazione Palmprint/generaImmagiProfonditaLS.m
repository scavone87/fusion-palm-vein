clearvars -except v pixel_length

% % Imposta il percorso della cartella contenente i file .mat
% matFilesFolderPath = uigetdir('Seleziona la cartella contenente i file .mat');

matFilesFolderPath = fullfile(fileparts(pwd), 'Matfiles');

% Ottieni la lista dei file .mat nella cartella
matFiles = dir(fullfile(matFilesFolderPath, '*.mat'));
tic
for fileIdx = 1:length(matFiles)
    matFileName = matFiles(fileIdx).name;
    matFilePath = fullfile(matFilesFolderPath, matFileName);
    fprintf('Elaborazione di: %s\n', matFileName);

    % Imposta il percorso della cartella di output per le immagini generate
    path=strcat(pwd,'\imageGeneratedFrom3D\',matFileName(1:end-4));

    if ~exist(path, 'dir')
        mkdir(path);
    end

    % Carica il file .mat
    load(matFilePath);

    %PARAMETRI
    tresh=64;   % Intensity treshold for surface detection (0 - 255)
    filter_siz=20;  % Averaging filter

    sz = size(M);
    FFFF = zeros(sz(2), sz(3), sz(1));
    depth = 0;
    for i = 2:7
        depth = i * pixel_length;
        surface_detection;
        FileName=strcat( 'immagine_', num2str(i-1), "_",num2str( depth ),'.jpg' );
        Name = fullfile(path, FileName);
        imwrite(FFF, Name, 'jpg');
        FFFF(:,:,i)=FFF;
    end

    fprintf('Elaborazione completata per: %s\n', matFileName);
end

toc