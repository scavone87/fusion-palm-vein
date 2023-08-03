warning off;
clc
close all
clear all

directoryTemplate1 = uigetdir(pwd,'Selezionare la directory contenente i template .dat del db1 (risultati/Nome/.dat)');
cartellaTemplate1 = [directoryTemplate1 '\'];
%cartellaTemplate=strcat(saveDirRisultati,'Template3D','\') % inserire la cartella contenente i templates 
dirs1=dir(fullfile(cartellaTemplate1));

numTempDb1 = length(dirs1);
%carico tutti i template db1
sp=1;
tabellaFinale=cell(sp,3);
numeroCartella=3;
numeroRisultato1=1;

arrayFileName1 = cellstr(' '); 
template1 = cell(1); 

%% codice per caricare i template
k = 0; 

for i=numeroCartella:length(dirs1)
   cartella1= strcat(cartellaTemplate1,dirs1(i).name,'/');
   files1 = dir(fullfile(cartella1,'*.dat'));
   
   for j = 1:length(files1)%size(files,1)
       k = k + 1;
       arrayFileName1 = [arrayFileName1; cellstr(files1(j).name)];
       nomeFile = char(strcat(cartella1,arrayFileName1(k+1)));
       nomeFile
       template1 = [template1; importdata(nomeFile)];
   end 
   
   numeroFile=0;
   numeroCartella=numeroCartella+1;
end

arrayTemplate1 = template1(2:end); 
arrayFileName1 = arrayFileName1(2:end);


%% 

directoryTemplate2 = uigetdir(pwd,'Selezionare la directory contenente i template .dat del db2 (risultati/Nome/.dat)');
cartellaTemplate2 = [directoryTemplate2 '\'];
%cartellaTemplate=strcat(saveDirRisultati,'Template3D','\') % inserire la cartella contenente i templates 
dirs2=dir(fullfile(cartellaTemplate2));

numTempDb2 = length(dirs2);

%carico tutti i template db2
numeroCartella=3;
numeroRisultato2=1;

arrayFileName2 = cellstr(' '); 
template2 = cell(1); 

%% codice per caricare i template
k = 0; 

for i=numeroCartella:length(dirs2)
   cartella2= strcat(cartellaTemplate2,dirs2(i).name,'/');
   files2 = dir(fullfile(cartella2,'*.dat'));
   
   for j = 1:length(files2)%size(files,1)
       k = k + 1;
       arrayFileName2 = [arrayFileName2; cellstr(files2(j).name)];
       nomeFile = char(strcat(cartella2,arrayFileName2(k+1)));
       nomeFile
       template2 = [template2; importdata(nomeFile)];
   end 
   
   numeroFile=0;
   numeroCartella=numeroCartella+1;
end

arrayTemplate2 = template2(2:end); 
arrayFileName2 = arrayFileName2(2:end); 

parpool('local', 8); %prima era 8
%calcolo i matching incrociati
for i=1:length(arrayTemplate1)
     tmp1 = arrayTemplate1{i,1};
    parfor j=1:length(arrayTemplate2)
        tmp2 = arrayTemplate2{j,1};
        score(i,j) = matching2L(tmp1, tmp2); 
%         score(i,j) = matching(tmp1, tmp2);
        disp(['confronto ' num2str(i) '.' num2str(j) ' effettuato']);
    end
end

sp = 1;
for i=1:length(arrayFileName1)
    temp1 = arrayFileName1(i); 
    for j=1:length(arrayFileName2)
        temp2 = arrayFileName2(j); 
        tabellaFinale(sp,1)={temp1};
        tabellaFinale(sp,2)={temp2};
        tabellaFinale(sp,3)={score(i,j)};
        sp = sp+1;
    end
end

T=cell2table(tabellaFinale, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
[nomestructmat, pathstructmat]=uiputfile('.mat','Save struct .mat');
save(strcat(pathstructmat,nomestructmat), 'T');
delete(gcp);

