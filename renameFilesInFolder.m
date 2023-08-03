% Richiedi all'utente di selezionare la cartella contenente i file da rinominare
folderPath = uigetdir('Seleziona la cartella contenente i file da rinominare');

% Controlla se l'utente ha annullato la selezione della cartella
if folderPath == 0
    disp('Selezione della cartella annullata.');
    return;
end

% Richiedi all'utente di inserire l'istante di inizio
startInstant = input('Inserisci l''istante di inizio: ');

% Controlla se l'istante di inizio è valido
if ~isnumeric(startInstant) || ~isscalar(startInstant) || startInstant < 0 || mod(startInstant, 1) ~= 0
    error('L''istante di inizio deve essere un numero intero positivo.');
end

% Ottieni l'elenco dei file nella cartella
filePattern = fullfile(folderPath, 'palmo_*_*');
fileList = dir(filePattern);

% Rinomina i file
for i = 1:length(fileList)
    currentFile = fileList(i).name;
    [~, name, ext] = fileparts(currentFile);

    % Ottieni l'istante attuale dal nome del file
    splitName = strsplit(name, '_');
    currentInstant = str2double(splitName{2});

    % Calcola il nuovo istante di salvataggio
    newInstant = startInstant + i - 1;

    % Rinomina il file con il nuovo istante
    newName = sprintf('palmo_%03d_SliceIQ%s', newInstant, ext);
    movefile(fullfile(folderPath, currentFile), fullfile(folderPath, newName));
end

disp('Rinominazione dei file completata con successo.');


