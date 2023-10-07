% Percorso della cartella 'database'
databaseDir = uigetdir('Seleziona la cartella contenente gli utenti');

% Ottieni un elenco delle sottocartelle
subfolders = dir(databaseDir);
subfolders = subfolders([subfolders.isdir]);
subfolders = subfolders(~ismember({subfolders.name},{'.','..'}));

% Inizializza un dizionario per il mapping e un set per gli hash già usati
mapping = containers.Map();
usedHashes = containers.Map();

% Genera hash per ciascun nome utente e rinomina la cartella
for k = 1:length(subfolders)
    username = subfolders(k).name;
    unique = false;
    while ~unique
        salt = char(randi([33, 126], 1, 8));  % Genera un salt casuale di 8 caratteri ASCII
        combined = [username, salt];
        md = java.security.MessageDigest.getInstance('SHA-256');
        hash = md.digest(double(combined));
        hashedCode = sprintf('%02x', typecast(hash, 'uint8'));
        shortHash = hashedCode(1:8);  % Prendi solo i primi 8 caratteri
        if ~isKey(usedHashes, shortHash)
            unique = true;
            usedHashes(shortHash) = 1;
            movefile(fullfile(databaseDir, username), fullfile(databaseDir, shortHash));
            mapping(username) = shortHash;
        end
    end
end