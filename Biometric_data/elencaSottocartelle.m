%il seguente script permette di selezionare la directory principale in cui
%saranno presenti le sottocartelle di utenti di cui si vuole effettuare la
%conversione da uob a mat. 
%una volta eseguito nel workspace avrò una struttura subFolders contenente
%le informazioni desiderate e sizeSubFolders contenente il numero di
%subFolders

directory = uigetdir(pwd,'Selezionare la directiory contenetne le sottocartelle degli utenti (esempio "ACQUISIZIONI")') ;



% Get a list of all files and folders in this folder.
files = dir(directory);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

% Remove first and second element . & .. that refers to the current
% directiory and the previous one
subFolders(1:2) = [];

sizeSubFolders=size(subFolders,1);

clear files;
clear dirFlags;