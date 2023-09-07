clear all;
clc;
%disp('Identificazione CPU Parallelo')
parpool('local',4);
cartellaTemplate=uigetdir(pwd, 'Seleziona cartella dati da confrontare');
cd(cartellaTemplate);
files=dir('*.mat');

sp=1;
tabellaFinale=cell(sp,3);
[nomestructmat, pathstructmat]=uiputfile('.mat','Save struct .mat');

arrayFileName = cellstr(' ');
template = cell(1);
%cd .. %aggiunto
%% codice per caricare i template
k = 0;

for i=1:length(files)
    k = k + 1;
    arrayFileName = [arrayFileName; cellstr(files(i).name)];
    nomeFile = char(arrayFileName(k+1));
    template = [template; importdata(nomeFile)];
end

%tolgo il primo componente
template = template(2:end);
arrayFileName = arrayFileName(2:end);

tic
n = size(template,1);
%% confronti
score = zeros(n);
cd ..
cd ..
for i=1:n
   tmp1 = cell2mat(template(i)); 
   parfor j=(i+1):n %era parfor
        tmp2 = cell2mat(template(j)); 
        score(i,j) = matching3D_ultimo3(tmp1, tmp2); 
  end
   
    completamento = [num2str(i*100/n) '%']
end

toc

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
delete(gcp);
