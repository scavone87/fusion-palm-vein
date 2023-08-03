function [filesJpg, sizeFilesJpg ] = elencaFileJpg( pathDirectory )
%Il seguente script permette di selezionare la directory principale in cui
%saranno presenti le sottocartelle di utenti


filesJpg=dir(fullfile(pathDirectory,'*.jpg'));   %# list all *.jpg files
sizeFilesJpg=size(filesJpg,1);



end

