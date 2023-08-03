%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERAZIONE DEL TEMPLATE DEL PALMO DELLA MANO A PARTIRE DA UN'IMMAGINE %
% ACQUISITA TRAMITE SENSORE OTTICO E/O AD ULTRASUONI                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
warning off


% % cerca_registrazione
% % init_palm
% % %carica_data
% % 
% % create_palm_color
% % template_palm
% % save_palm

%provare 5-11 con soglia 6 e provare 5-9 con soglia 6

%CODICE NUOVO -----
%come esempio: database-prova/image2D
directory = uigetdir(pwd,'Selezionare la directory contenente le sottocartelle delle immagini degli utenti (image2D)') ;
%come esempio: database-prova/risultati
directorySaveAll = uigetdir(pwd,'Selezionare la directory principale in cui verrà salvata la cartella .dat template e merge (risultati)') ;
files = dir(directory);
numCampioni=size(files,1);
for i=3:numCampioni
    tic
    
    nomeUtente=files(i).name;
    Render2D=strcat(directory,'\',nomeUtente);
    %struct con le immagini
    immaginiUtente = dir(Render2D);
    %prendo le prime due immagini di quell'utente;
    str = [directory '\' nomeUtente '\'];
    [FF2,~] = imread(strcat(str,immaginiUtente(3).name));
    [FF3,~] = imread(strcat(str,immaginiUtente(4).name));
    create_palm_color
    
    cartellaIstanteDiSalvataggio = [strcat(directorySaveAll, '\Calia\.dat\') nomeUtente];
    cartellaIstanteDiSalvataggioTemplateImg = [strcat(directorySaveAll, '\Calia\template\') nomeUtente];
    
    FileName = strcat(immaginiUtente(3).name,immaginiUtente(4).name);
    Name = fullfile(directorySaveAll, FileName);
    imwrite(matriceFinale, Name, 'jpg');
    
    template_palm
    
    template = matriceXY_delete4;
    
    if ~strcmp(cartellaIstanteDiSalvataggio,'')
        mkdir(cartellaIstanteDiSalvataggio)
        nomeTemplateDat=[nomeUtente '.dat'];
        %memorizza la variabile del workspace template con il percorso
        %specificato come primo argomento
        save([cartellaIstanteDiSalvataggio '\' nomeTemplateDat], 'template');
        disp([cartellaIstanteDiSalvataggio '\' nomeTemplateDat]);
    end

    if ~strcmp(cartellaIstanteDiSalvataggioTemplateImg,'')
        mkdir(cartellaIstanteDiSalvataggioTemplateImg)
        nomeTemplateImg=[nomeUtente '.jpg'];
        %scrive l'immagine specificata in template nel persorso specificato
        %come secondo argomento, nel formato jpg
        imwrite(template, [cartellaIstanteDiSalvataggioTemplateImg '\' nomeTemplateImg], 'jpg');
        disp([cartellaIstanteDiSalvataggioTemplateImg '\' nomeTemplateImg]);
    end
    toc
end

