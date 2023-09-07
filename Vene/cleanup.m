function cleanup(basepath, filtered)
% CLEANUP Elimina i file generati dai passaggi intermedi

% Costruisci i percorsi completi alle cartelle di interesse
elaboratedPath = fullfile(basepath, 'Dati elaborati', 'b-scan estratti');
maskPath = fullfile(basepath, 'Dati elaborati', 'mask b-scan');
connectedPath = fullfile(basepath, 'Dati elaborati', 'regioniconnesse b-scan');
sradFilteredPath = fullfile(basepath, 'Dati elaborati', 'srad filtered b-scan');
gaborFilteredPath = fullfile(basepath, 'Dati elaborati', 'gabor filtered b-scan');

% Ottieni la lista di file/cartelle all'interno di 'b-scan estratti'
dirData = dir(elaboratedPath);
dirList = dirData([dirData.isdir]);
dirList = dirList(~ismember({dirList.name}, {'.', '..'}));

% Elimina le cartelle all'interno di 'b-scan estratti'
for iDir = 1:numel(dirList)
    dirPath = fullfile(elaboratedPath, dirList(iDir).name);
    rmdir(dirPath, 's');
end

% Elimina i file all'interno di 'mask b-scan'
delete(fullfile(maskPath, '*.*'));

% % Elimina i file all'interno di 'regioniconnesse b-scan'
% delete(fullfile(connectedPath, '*.*'));

% Elimina i file all'interno di 'srad filtered b-scan' se necessario
if filtered == 1
    delete(fullfile(sradFilteredPath, '*.*'));
end

% Elimina i file all'interno di 'gabor filtered b-scan' se necessario
if filtered == 2
    delete(fullfile(gaborFilteredPath, '*.*'));
end
end

