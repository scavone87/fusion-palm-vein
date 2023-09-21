addpath("lib\");
clear files;

disp('Identificazione CPU Parallelo')

% Verifica se il cluster è già attivo
currentPool = gcp('nocreate');

% Se il cluster non è attivo, avvialo
if isempty(currentPool)
    parpool(); % Inizializza il pool parallelo
end

cartellaTemplate = fullfile(pwd, '\template2D\Template2D\');
dirs = dir(fullfile(cartellaTemplate));

startTime_identificazioneMatching2D = tic;
sp = 1;
tabellaFinale = cell(sp, 3);

numeroCartella = 3;
arrayTemplate = {};
arrayFileName = {};

for i = numeroCartella:length(dirs)
    cartella = fullfile(cartellaTemplate, dirs(i).name, '\');
    files = dir(fullfile(cartella, 'TEMPLATE1.dat'));
    nomeFile = fullfile(cartella, files(1).name);
    utenteCorrente = dirs(i).name;
    utenteParts = strsplit(utenteCorrente, '_');
    nomeUtente = sprintf('%s_%s', utenteParts{end-1:end});
    arrayFileName = [arrayFileName; nomeUtente];
    template = importdata(nomeFile);
    arrayTemplate = [arrayTemplate; template];
end

n = length(arrayTemplate);
score = zeros(n);

for i = 1:n
    tmp1 = arrayTemplate{i};
    fprintf('Valore di i: %d \n', i);
    parfor j = (i + 1):n
        tmp2 = arrayTemplate{j};
        score(i, j) = matching2L(tmp1, tmp2);
    end
end

sp = 1;
for i = 1:n
    temp1 = arrayFileName(i);
    for j = i + 1:n
        temp2 = arrayFileName(j);
        tabellaFinale(sp, 1) = {temp1};
        tabellaFinale(sp, 2) = {temp2};
        tabellaFinale(sp, 3) = {score(i, j)};
        sp = sp + 1;
    end
end

T = cell2table(tabellaFinale, 'VariableNames', {'Utente1', 'Utente2', 'Score'});
save(fullfile(pwd, 'Statistiche2D.mat'), 'T');

endTime_identificazioneMatching2D = toc(startTime_identificazioneMatching2D);
fprintf('Tempo di esecuzione dello script identificazioneMatching2D: %.2f secondi\n', endTime_identificazioneMatching2D);
