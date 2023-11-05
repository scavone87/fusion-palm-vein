addpath("lib\");

%clear all;
clear files;
%clc;

disp('Identificazione CPU Parallelo')

% Verifica se il cluster è già attivo
currentPool = gcp('nocreate');

% Se il cluster non è attivo, avvialo
if isempty(currentPool)
    parpool(); % Inizializza il pool parallelo
end

cartellaTemplate = fullfile(pwd, '\template3D\Template3D\');
dirs=dir(fullfile(cartellaTemplate));

startTime_identificazioneMatching3D = tic;
sp=1;
tabellaFinale=cell(sp,3);
% [nomestructmat, pathstructmat]=uiputfile('.mat','Save struct .mat');
nomestructmat = "Statistiche3D_dbCompleto_NardielloNoFill.mat";
pathstructmat = fullfile(pwd, '\');
numeroCartella=3;
numeroRisultato=1;

arrayFileName = cellstr(' ');
template = cell(1);

%% codice per caricare i template
k = 0;

for i=numeroCartella:length(dirs)
    cartella= strcat(cartellaTemplate,dirs(i).name,'\');
    files = dir(fullfile(cartella,'*.dat'));

    for j = 1:length(files)%size(files,1)
        k = k + 1;
        utenteCorrente = files(j).name;
        utenteParts = strsplit(utenteCorrente, '_');
        nomeUtente = sprintf('%s_%s', utenteParts{end-1:end});
        arrayFileName = [arrayFileName; nomeUtente];
        nomeFile = char(strcat(cartella,arrayFileName(k+1)));
        template = [template; importdata(fullfile(files(j).folder, utenteCorrente))];
    end

    numeroFile=0;
    numeroCartella=numeroCartella+1;
end

%tolgo il primo componente
arrayTemplate = template(2:end);
arrayFileName = arrayFileName(2:end);

n = length(arrayTemplate);
score = zeros(n);

for i=1:n
    tmp1 = arrayTemplate{i,1};
    fprintf('Valore di i: %0.f \n', i);
    parfor j=(i+1):n
        tmp2 = arrayTemplate{j,1};
%         score(i,j) = matching3D(tmp1, tmp2, 3);
        score(i,j) = matching13L(tmp1, tmp2);
        % disp(['confronto ' num2str(i) '.' num2str(j) ' effettuato']);
    end
end

sp = 1;
for i=1:n
    temp1 = arrayFileName(i);
    for j=i+1:n
        temp2 = arrayFileName(j);
        tabellaFinale(sp,1)={temp1};
        tabellaFinale(sp,2)={temp2};
        tabellaFinale(sp,3)={score(i,j)};
        sp = sp+1;
    end
end

T=cell2table(tabellaFinale, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
save(strcat(pathstructmat,nomestructmat), 'T');

endTime_identificazioneMatching3D = toc(startTime_identificazioneMatching3D);

fprintf('Tempo di esecuzione dello script identificazioneMatching3D: %.2f secondi\n', endTime_identificazioneMatching3D);