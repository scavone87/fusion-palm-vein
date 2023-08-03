function [filesUob, sizeFilesUob ] = elencaFileUobb( pathDirectory )
%il seguente script permette di selezionare la directory principale in cui
%saranno presenti le sottocartelle di utenti di cui si vuole effettuare la
%conversione da uob a mat. 


filesUob=dir(fullfile(pathDirectory,'*.uob'));   %# list all *.mat files
sizeFilesUob=size(filesUob,1);



end

