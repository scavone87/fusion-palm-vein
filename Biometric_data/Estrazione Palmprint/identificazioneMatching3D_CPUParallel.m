saveDir = saveDirRisultati;
%clear all;
clear files;
%clc;

disp('Identificazione CPU Parallelo')

switch choice
    case 'SRAD'
        folderName = 'Template3DSRAD';
    case 'Frost'
        folderName = 'Template3DFrost';
    case 'DoG'
        folderName = 'Template3DDoG';
    otherwise 
        errordlg('Non hai selezionato alcun filtro','Errore')
        return 
end

parpool('local', 8); %prima era 8
%Stiamo facendo analisi 3D quindi prendiamo i template contenuti nella
%cartella template 3D
% if analysisType == 3
%     scelta='Template3D';
% end

cartellaTemplate=strcat(saveDir,folderName,'\');
%cartellaTemplate=strcat(saveDirRisultati,'Template3D','\') % inserire la cartella contenente i templates 
dirs=dir(fullfile(cartellaTemplate));

sp=1;
tabellaFinale=cell(sp,3);
[nomestructmat, pathstructmat]=uiputfile('.mat','Save struct .mat');
numeroCartella=3;
numeroRisultato=1;

arrayFileName = cellstr(' '); 
template = cell(1); 

%% codice per caricare i template
k = 0; 

for i=numeroCartella:length(dirs)
   cartella=strcat(cartellaTemplate,dirs(i).name,'/');
   files =  dir(fullfile(cartella,'*.dat'));
   
   for j = 1:length(files)%size(files,1)
       k = k + 1;
       arrayFileName = [arrayFileName; cellstr(files(j).name)];
       nomeFile = char(strcat(cartella,arrayFileName(k+1)));
       template = [template; importdata(nomeFile)];
   end 
   
   numeroFile=0;
   numeroCartella=numeroCartella+1;
end

%tolgo il primo componente
arrayTemplate = template(2:end); 
arrayFileName = arrayFileName(2:end); 

tic 
n = length(arrayTemplate);%size(arrayTemplate,1); 
score = zeros(n); 

for i=1:n
    %tmp1 = cell2mat(arrayTemplate(i));
     tmp1 = arrayTemplate{i,1};
    parfor j=(i+1):n
       %tmp2 = cell2mat(arrayTemplate(j));
      tmp2 = arrayTemplate{j,1};
        score(i,j) = matching13L(tmp1, tmp2); 
        disp(['confronto ' num2str(i) '.' num2str(j) ' effettuato']);
    end
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
