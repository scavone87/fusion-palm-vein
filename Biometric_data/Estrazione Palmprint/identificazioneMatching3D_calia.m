clear all;
clc;

cartellaTemplate=uigetdir(pwd,'Seleziona la directory con i template generati');
%cartellaTemplate='C:\Users\Admin\Desktop\10UtentiCalia\';
dirs=dir(fullfile(cartellaTemplate));

sp=1;
tabellaFinale=cell(sp,3);
[nomestructmat, pathstructmat]=uiputfile('.mat','Save struct .mat');
numeroCartella=3;
numeroRisultato=1;

for i=numeroCartella:length(dirs) 
   s = [cartellaTemplate '\'];
   cartella=strcat(s,dirs(i).name,'\.dat\');
   files=dir(fullfile(cartella,'*.dat'));
   elementi=size(files,1);
   numeroFile=0;
   for contatore=1:elementi
     numeroFile=numeroFile+1;
     corrente=files(contatore).name(1:length(files(contatore).name)-4);
     primoTemplate=importdata(strcat(cartella,files(contatore).name));
     
     cartellaDaTestare=cartellaTemplate;
     
     dirsDaTestare=dir(fullfile(cartellaDaTestare));
     for j=numeroCartella:length(dirsDaTestare)
        ss = [cartellaDaTestare '\'];
        sottocartelleDaTestare=strcat(ss,dirsDaTestare(j).name,'\.dat\');
        if(strcmp(cartella,sottocartelleDaTestare)==1)
            filesDaTestare=dir(fullfile(sottocartelleDaTestare,'*.dat'));
            elementiDaTestare=size(filesDaTestare,1);
            if(numeroFile<elementiDaTestare)
                for contatoreDaTestare=(numeroFile+1):elementiDaTestare
                    correnteFileDaTestare=files(contatoreDaTestare).name(1:length(files(contatoreDaTestare).name)-4);
                    secondoTemplate=importdata(strcat(sottocartelleDaTestare,files(contatoreDaTestare).name));

                    [score] = matching(primoTemplate,secondoTemplate);
                    strcat(corrente, '-', correnteFileDaTestare, ' : ', num2str(score(1)))
                    
                    tabellaFinale(sp,1)={corrente};
                    tabellaFinale(sp,2)={correnteFileDaTestare};
                    tabellaFinale(sp,3)={score(1)};
                    sp=sp+1;
                    numeroRisultato=numeroRisultato+1;
                end
            end
        else

            filesDaTestare=dir(fullfile(sottocartelleDaTestare,'*.dat'));
            elementiDaTestare=size(filesDaTestare,1);
            for contDaTestare=1:elementiDaTestare
                corrFileDaTestare=filesDaTestare(contDaTestare).name(1:length(filesDaTestare(contDaTestare).name)-4);
                secondoTemplate=importdata(strcat(sottocartelleDaTestare,filesDaTestare(contDaTestare).name));

                [score] = matching(primoTemplate,secondoTemplate);
                strcat(corrente, '-', corrFileDaTestare, ' : ', num2str(score(1)));
                
                tabellaFinale(sp,1)={corrente};
                tabellaFinale(sp,2)={corrFileDaTestare};
                tabellaFinale(sp,3)={score(1)};
                sp=sp+1;
                numeroRisultato=numeroRisultato+1;
            end 
        end
     end
   end
   numeroCartella=numeroCartella+1;
end

T = cell2table(tabellaFinale, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
save([pathstructmat nomestructmat],'T');

