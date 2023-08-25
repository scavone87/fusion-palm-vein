function [ matriceOutput ] = profonditaTratti( matrice, matFile, template3DDir, template3DIstantiDir )

% profonditaTratti - Calcola e salva la profondità dei tratti da una matrice
%
%   Questa funzione calcola la profondità dei tratti da una matrice fornita
%   e salva i risultati in file .dat corrispondenti agli istanti specificati.
%
% Parametri:
%   matrice - Matrice di input contenente i dati dei tratti
%   matFile - Nome del file da utilizzare per il salvataggio dei risultati
%
% Output:
%   matriceOutput - Matrice contenente i risultati della profondità dei tratti
%
% Esempio di utilizzo:
%   matriceInput = ...; % Inserisci la tua matrice di input
%   nomeFile = 'dati_tratti';
%   risultato = profonditaTratti(matriceInput, nomeFile);
%

% Inizializza la matrice delle profondità
matriceProfondita = zeros(size(matrice, 2), size(matrice, 3));

% Calcola la somma delle matrici dei tratti
for i = 1:size(matrice, 1)
    matriceProfondita = matriceProfondita + squeeze(matrice(i, :, :));
end

% Assegna la matrice delle profondità al risultato di output
matriceOutput = matriceProfondita;

% Crea la directory per il template 3D
template3DDirPath = fullfile(pwd, template3DDir, matFile, '');
if ~exist(template3DDirPath, 'dir')
    mkdir(template3DDirPath);
end

% Salva la matriceOutput in formato .dat
save(fullfile(template3DDirPath, [matFile, '.dat']), 'matriceOutput');

% Salva la matriceOutput in base all'istante specificato
istante = str2num(matFile(end));
istanteDir = fullfile(template3DIstantiDir, ['istante', sprintf('%03d', istante)]);
if ~exist(istanteDir, 'dir')
    mkdir(istanteDir);
end
save(fullfile(istanteDir, [matFile, '.dat']), 'matriceOutput');

% Ridimensiona la matriceOutput per la visualizzazione o il salvataggio
matriceOutput = imresize(matriceOutput, 4);

% Salva la matriceOutput utilizzando la funzione salvaTemplate3D
salvaTemplate3D(matriceOutput, matFile);

end

