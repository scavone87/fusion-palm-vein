%converte tutti i jpg di una data cartella suddivisi per utente, salvando i
%risultati in una nuova cartella suddivisi per istante
%clear
%clc
%folderSaveName = 'TemplateDoG';

s = 'Selezionare la directory contenente le sottocartelle contenenti le immagini jpg (imageGeneratedFrom3D)';
elencaSottocartelle;

%Dialog box
choice = questdlg('Scegli il tipo di filtro', 'Scegli filtro','Frost','SRAD','DoG','Frost');
switch choice
    case 'SRAD'
           folderSaveName = 'TemplateSRAD';
    case 'Frost'
           folderSaveName = 'TemplateFrost';
    case 'DoG'
           folderSaveName = 'TemplateDoG';
    otherwise 
           errordlg('Non hai selezionato alcun filtro','Errore')
           return 
end

%waitbar
[files,folders,size] = rdir(directory);
numFiles = length(files);
wbar=waitbar(0,'Generazione file .dat e .jpg in corso');
step=0;

%stringa percorso salvataggio nella cartella superiore a directory attuale
parts = strsplit(directory, '\');
DirPart = parts{end-1};
saveDir = [strjoin(parts(1:end-1),'\'), '\', 'risultati', '\'];

%controlla se esiste la cartella con il nome, altrimenti la crea
if ~exist(folderSaveName, 'dir') 
    mkdir(saveDir, folderSaveName); 
end


tic
for k=1:sizeSubFolders
    pathNameSubDirectory=[directory '\' subFolders(k).name];
    [filesJpg, sizeFilesJpg] = elencaFileJpg(pathNameSubDirectory);
    utenteCorrente = subFolders(k).name;
    nomeSalv = 0; % variabile per il solo salvataggio dei template2D sovrapposti
    for i=1:sizeFilesJpg %salto le prime due a profondità 0.05 e 0.1 perche' le ho fuse nella 3.5
        nomeSalv = nomeSalv+1;
        num_istante=num2str(filesJpg(i).name(end-5 : end-4));
        if ~exist([saveDir '/' folderSaveName '/' utenteCorrente],'dir')
            mkdir([saveDir '/' folderSaveName '/' utenteCorrente]);
        end
        fullPathName=[pathNameSubDirectory '\' filesJpg(i).name];
        switch choice
            case 'SRAD'
            [fileDat, outputImage]=templateSRAD(fullPathName, nomeSalv);
            case 'Frost'
            [fileDat,outputImage]=templateFrost(fullPathName);%, fullPathName); 
            case 'DoG'
            [fileDat,outputImage]= DoGfilterLS(fullPathName, nomeSalv);

            otherwise 
                errordlg('Non hai selezionato alcun filtro','Errore')
                close(wbar);
                return 
        end
        
        dlmwrite([saveDir '\' folderSaveName '/' utenteCorrente '\'  'TEMPLATE', num2str( i ), '.dat'],fileDat);
%         imwrite(outputImage,[saveDir '\' folderSaveName '/' utenteCorrente '\' 'TEMPLATE', num2str( i+1 ), '.jpg']);
        imwrite(fileDat,[saveDir '\' folderSaveName '/' utenteCorrente '\' 'TEMPLATE', num2str( i ), '.jpg']);
        step=step+1;
        waitbar(step/numFiles);
    end
end

toc
close(wbar);
