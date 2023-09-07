clear all;
clc;
%disp('Identificazione CPU Parallelo')
% parpool('local',4);

% Verifica se il cluster è già attivo
currentPool = gcp('nocreate');

% Se il cluster non è attivo, avvialo
if isempty(currentPool)
    parpool(); % Inizializza il pool parallelo
end

cartellaTemplate=fullfile(pwd, 'Dati elaborati\template3D', '*.mat');
% dir = fullfile(cartellaTemplate)
files=dir(cartellaTemplate);

sp=1;
tabellaFinale=cell(sp,3);
[nomestructmat, pathstructmat]=uiputfile(pwd, 'Nome File', '3D.mat');

arrayFileName = cellstr(' ');
template = cell(1);
%cd .. %aggiunto
%% codice per caricare i template
k = 0;

for i=1:length(files)
    k = k + 1;
    arrayFileName = [arrayFileName; cellstr(files(i).name)];
    nomeFile = fullfile(files(i).folder, files(i).name);
    template = [template; importdata(nomeFile)];
end

%tolgo il primo componente
arrayTemplate = template(2:end);
arrayFileName = arrayFileName(2:end);

n = length(arrayTemplate);%size(arrayTemplate,1);
score = zeros(n);

for i=1:n
    %tmp1 = cell2mat(arrayTemplate(i));
    tmp1 = arrayTemplate{i,1};
    fprintf('Valore di i: %0.f \n', i);
    parfor j=(i+1):n
        % fprintf('Valore di j: %0.f \n', j);
        % tmp2 = cell2mat(arrayTemplate(j));
        tmp2 = arrayTemplate{j,1};
        score(i,j) = matching3D(tmp1, tmp2);
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
