close all;
clear all;
clc;

elencaSottocartelle;

for k=1:sizeSubFolders
    pathNameSubDirectory=[directory '\' subFolders(k).name];
    [filesUob, sizeFilesUob]=elencaFileUob(pathNameSubDirectory);
    utenteCorrente=subFolders(k).name;
    for i=1:sizeFilesUob
        tic;
        num_istante=num2str(filesUob(i).name(7:length(filesUob(i).name)-12));
        fullPathName=[pathNameSubDirectory '\' filesUob(i).name];
        fullPathSave=[pathNameSubDirectory '\' [utenteCorrente '_' num_istante]];
        convertiUob([utenteCorrente '_' num_istante],fullPathName,fullPathSave);
        disp(['il file ' utenteCorrente '_' num_istante ' è stato salvato correttamente'])
        toc
    end
end

