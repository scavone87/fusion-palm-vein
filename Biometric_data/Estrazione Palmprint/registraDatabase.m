clear all;
close all;
warning off;
clc;

%cartellaFileMat='C:\Users\Admin\Desktop\CondivisioneReteLaboratorio\';
%cartellaFileMat='C:\Users\Admin\Desktop\Nuova cartella\';
cartellaFileMat=uigetdir(pwd,'Seleziona la directory con i file .mat');%'C:\Users\Admin\Desktop\AcquisizioniGel\elaborazioneAcquisizioni\Ciliberto\';
directory_name=pwd;
dirs=dir(fullfile(cartellaFileMat));

directorySaveAll = uigetdir(pwd,'Selezionare la directory principale in cui verrà salvata la cartella .dat template e merge (risultati)') ;

k=1;
for i=3:length(dirs)
   s = [cartellaFileMat '\'];
   path=strcat(s,dirs(i).name);
   path=strcat(path,'\');
   files=dir(fullfile(path,'*.mat'));
   Dimensione=size(files,1);
   elementi=Dimensione;
   for contatore=1:elementi
     corrente=files(contatore).name(1:length(files(contatore).name)-4);
     generaImmaginiProfondita_calia(corrente,path, directorySaveAll);
     generaTemplate_calia(corrente, directorySaveAll);
   end
end
