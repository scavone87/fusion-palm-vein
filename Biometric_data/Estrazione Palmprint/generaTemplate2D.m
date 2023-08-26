addpath("lib\");

clearvars -except startTime_mainScript

%% aggiungere il path a imageGeneratedFrom3D
elencaSottocartelle;

% Verifica se il cluster è già attivo
currentPool = gcp('nocreate');

% Se il cluster non è attivo, avvialo
if isempty(currentPool)
    parpool(); % Inizializza il pool parallelo
end

%stringa percorso salvataggio nella cartella superiore a directory attuale
parts = strsplit(directory, '\');
DirPart = parts{end-1};
saveDir = [strjoin(parts(1:end-1),'\'), '\', 'template2D\Template2D', '\'];

numFiles = length(subFolders);
wbar = waitbar(0, 'Generazione file .dat e .jpg in corso');

startTime_generaTemplate2D = tic;

for k = 1:numFiles
    subFolderPath = fullfile(directory, subFolders(k).name);
    filesJpg = elencaFileJpg(subFolderPath);
    utenteCorrente = subFolders(k).name;
    
    if ~exist(fullfile(saveDir, utenteCorrente), 'dir')
        mkdir(fullfile(saveDir, utenteCorrente));
    end
    
    parfor i = 1:length(filesJpg)
        profondita = filesJpg(i).name(end-9:end-4);
        nomeUtente = sprintf('%s-%s', utenteCorrente, num2str(profondita));
        % utenteParts = strsplit(utenteCorrente, '_');
        % nomeUtente = sprintf('%s-%s-%s-%s', utenteParts{end-2:end}, num2str(profondita));
        
        fullPathName = fullfile(subFolderPath, filesJpg(i).name);
        [dilatedImageDat, rgbImage] = estrazioneLinee(fullPathName, i, nomeUtente); % Modificato nomeSalv
        
        fileDatName = sprintf('TEMPLATE%d.dat', i);
        imwrite(dilatedImageDat, fullfile(saveDir, utenteCorrente, [fileDatName(1:end-4) '.jpg']));
        dlmwrite(fullfile(saveDir, utenteCorrente, fileDatName), dilatedImageDat);
       
    end
     waitbar(k/length(numFiles), wbar);
end

% Fine tempo di esecuzione dello script principale
endTime_generaTemplate2D = toc(startTime_generaTemplate2D);

fprintf('Tempo di esecuzione dello script generaTemplate2D: %.2f secondi\n', endTime_generaTemplate2D);
close(wbar);
