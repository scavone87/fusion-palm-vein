% Questo script genera file .dat e .jpg dai file immagine JPG presenti nelle sottocartelle di una directory.
% I file generati rappresentano template 2D estratti dalle immagini JPG.
%
% Prima di eseguire lo script, assicurarsi di avere una struttura di cartelle con le immagini JPG nelle sottocartelle.
%
% Note:
% - Assicurarsi che la variabile 'directory' sia impostata correttamente con il percorso della directory radice.
% - La funzione 'elencaSottocartelle' deve essere definita per elencare le sottocartelle nella directory radice.
% - La funzione 'elencaFileJpg' deve essere definita per elencare i file JPG all'interno di una sottocartella.
% - La funzione 'estrazioneLinee' viene utilizzata per estrarre le linee dai file immagine e restituisce un file .dat e un'immagine.
%
% Autore: Luongo Antonio, Scavone Rocco
% Data: Agosto 2023
%

addpath("lib\");

clear
clc

%% aggiungere il path a imageGeneratedFrom3D
elencaSottocartelle;

folderSaveName = 'Template2D';

%waitbar
[files,folders,size] = rdir(directory);
numFiles = length(files);
wbar=waitbar(0,'Generazione file .dat e .jpg in corso');
step=0;

%stringa percorso salvataggio nella cartella superiore a directory attuale
parts = strsplit(directory, '\');
DirPart = parts{end-1};
saveDir = [strjoin(parts(1:end-1),'\'), '\', 'template2D', '\'];

tic
for k=1:sizeSubFolders
    pathNameSubDirectory=[directory '\' subFolders(k).name];
    [filesJpg, sizeFilesJpg] = elencaFileJpg(pathNameSubDirectory);
    utenteCorrente = subFolders(k).name;
    nomeSalv = 0; % variabile per il solo salvataggio dei template2D sovrapposti
    for i=1:sizeFilesJpg %salto le prime due a profondità 0.05 e 0.1 perche' le ho fuse nella 3.5
        nomeSalv = nomeSalv+1;
        num_istante=num2str(filesJpg(i).name(end-9:end-4));
        out = split(utenteCorrente, '_');
        nomeUtente = strcat(string(out(end-2)), '-', string(out(end-1)), '-', string(out(end)), '-', string(num_istante));
        if ~exist([saveDir '/' folderSaveName '/' utenteCorrente],'dir')
            mkdir([saveDir '/' folderSaveName '/' utenteCorrente]);
        end
        fullPathName=[pathNameSubDirectory '\' filesJpg(i).name];

        [fileDat,outputImage]= estrazioneLinee(fullPathName, nomeSalv, nomeUtente);
        
        dlmwrite([saveDir '\' folderSaveName '/' utenteCorrente '\'  'TEMPLATE', num2str( i ), '.dat'],fileDat);
%         imwrite(outputImage,[saveDir '\' folderSaveName '/' utenteCorrente '\' 'TEMPLATE', num2str( i+1 ), '.jpg']);
        imwrite(fileDat,[saveDir '\' folderSaveName '/' utenteCorrente '\' 'TEMPLATE', num2str( i ), '.jpg']);
        step=step+1;
        waitbar(step/numFiles, wbar);
    end
end

toc
close(wbar);
