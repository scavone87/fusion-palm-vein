function analisi2D(sceltaRadioButton)
warning off;
clc
disp(['Strategia scelta: ' sceltaRadioButton]);
close all
choice = '';
% richiamo l'immagine ottenuta con carica data a prof 0.0462 e chiama la procedura esterna del filtro di frost posizionato nella stessa cartella di "prof1.jpg" 

%come esempio: database-prova/image
directory = uigetdir(pwd,'Selezionare la directory contenente le sottocartelle delle immagini degli utenti (image2D)') ;
%come esempio: database-prova/risultati
directorySaveAll = uigetdir(pwd,'Selezionare la directory principale in cui verrà salvata la cartella .dat template e merge (risultati)') ;
directorySave = strcat(directorySaveAll, '\.dat');
directorySaveTemplateImg = strcat(directorySaveAll, '\template');
directorySaveMerge = strcat(directorySaveAll, '\merge');

files = dir(directory); % struct che contiene nella proprietà name l'elenco dei nomi degli utenti 
numCampioni=size(files,1); %numero utenti

for i=3:numCampioni % parte da 3 perchè nella struct ci sono le voci '.' e '..'

nomeUtente=files(i).name;
Render2D=strcat(directory,'\',nomeUtente);
immaginiUtente = dir(Render2D); %struct contiene le immagini dell'utente

    for k = 3 : size(immaginiUtente,1) %numero delle immagini per ogni utente
        tic
        nomeImmagine = immaginiUtente(k).name; %prende il nome dell'immagine
        istante = nomeImmagine(end-4:end-4); %prende solo i valori numerici dal nome che indicano l'istante

%         %crea la stringa concatenando 3 stringhe
%         %indica che vogliamo creare le cartelle con l'istante nelle cartelle
%         %.dat, template e merge
%         cartellaIstanteDiSalvataggio = [directorySave '\istante' istante];
%         cartellaIstanteDiSalvataggioMerge = [directorySaveMerge '\istante' istante];
%         cartellaIstanteDiSalvataggioTemplateImg = [directorySaveTemplateImg '\istante' istante];

        %si prende il percorso dell'immagine corrente
        immagineDaElaborare = [Render2D '\' nomeImmagine];
    
        %dopo aver caricato l'immagine faccio le varie analisi
        switch sceltaRadioButton
            case 'DiBello'                
                cartellaIstanteDiSalvataggio = [strcat(directorySaveAll, '\DiBello\.dat') '\istante' istante];
                cartellaIstanteDiSalvataggioMerge = [strcat(directorySaveAll, '\DiBello\merge') '\istante' istante];
                cartellaIstanteDiSalvataggioTemplateImg = [strcat(directorySaveAll, '\DiBello\template') '\istante' istante];
                
                [template, merge] = metodo_estrazione_linee(immagineDaElaborare);
            case 'Restaino'
                [I, im2] = initRestaino(immagineDaElaborare);
                                
                cartellaIstanteDiSalvataggio = [strcat(directorySaveAll, '\Restaino\.dat') '\istante' istante];
                cartellaIstanteDiSalvataggioMerge = '';
                cartellaIstanteDiSalvataggioTemplateImg = [strcat(directorySaveAll, '\Restaino\template') '\istante' istante];
                
                mkdir(cartellaIstanteDiSalvataggioTemplateImg);
                [template] = generaTemplate(I,im2,cartellaIstanteDiSalvataggioTemplateImg,immaginiUtente(k).name);
            
            case 'Dionisio'
                cartellaIstanteDiSalvataggioMerge = '';
                cartellaIstanteDiSalvataggio = [strcat(directorySaveAll, '\Dionisio\.dat') '\istante' istante];
                cartellaIstanteDiSalvataggioTemplateImg = [strcat(directorySaveAll, '\Dionisio\template') '\istante' istante];
                
                [template, outputImage]=templateWavelet2(immagineDaElaborare);  

                % Ridimensioniamo l'immagine
                template_r = imresize(template, 0.25 ,'bicubic'); % la dimensione è ridotta del 75%
                clear template;
                template = template_r;     
                
            case 'Gugliotta'
                
                cartellaIstanteDiSalvataggioMerge = '';
                cartellaIstanteDiSalvataggio = [strcat(directorySaveAll, '\Gugliotta\.dat') '\istante_' istante];
                cartellaIstanteDiSalvataggioTemplateImg = [strcat(directorySaveAll, '\Gugliotta\template') '\istante' istante];
                
                [template, outputImage]=templateFrost(immagineDaElaborare); 

                % Ridimensioniamo l'immagine
                template_r = imresize(template, 0.25 ,'bicubic'); % la dimensione è ridotta del 75%
                clear template;
                template = template_r;
                
            case 'Marino'
                cartellaIstanteDiSalvataggio = [strcat(directorySaveAll, '\Marino\.dat') '\istante_' istante];
                cartellaIstanteDiSalvataggioMerge = '';
                cartellaIstanteDiSalvataggioTemplateImg = [strcat(directorySaveAll, '\Marino\template') '\istante' istante];
                
                [template]= DoGfilter(immagineDaElaborare);
                
            case 'Micucci'
                
                cartellaIstanteDiSalvataggio = [strcat(directorySaveAll, '\Micucci\.dat') '\istante' istante];
                cartellaIstanteDiSalvataggioMerge = '';
                cartellaIstanteDiSalvataggioTemplateImg = [strcat(directorySaveAll, '\Micucci\template') '\istante' istante];
                
                [template, outputImage]=templateSRAD(immagineDaElaborare);

                % Ridimensioniamo l'immagine
                template_r = imresize(template, 0.25 ,'bicubic'); % la dimensione è ridotta del 75%
                clear template;
                template = template_r;
        end        
        
        if ~strcmp(cartellaIstanteDiSalvataggio,'')
            mkdir(cartellaIstanteDiSalvataggio)
            %crea il nome del file .dat, es. CarciaVincenzo_000.dat
            nomeTemplateDat=[nomeUtente '_' istante '.dat'];
            %memorizza la variabile del workspace template con il percorso
            %specificato come primo argomento
            save([cartellaIstanteDiSalvataggio '\' nomeTemplateDat], 'template');
            disp([cartellaIstanteDiSalvataggio '\' nomeTemplateDat]);
        end

        if ~strcmp(cartellaIstanteDiSalvataggioTemplateImg,'')
            mkdir(cartellaIstanteDiSalvataggioTemplateImg)
            nomeTemplateImg=[nomeUtente '_' istante '.jpg'];
            %scrive l'immagine specificata in template nel persorso specificato
            %come secondo argomento, nel formato jpg
            imwrite(template, [cartellaIstanteDiSalvataggioTemplateImg '\' nomeTemplateImg], 'jpg');
            disp([cartellaIstanteDiSalvataggioTemplateImg '\' nomeTemplateImg]);
        end

        if ~strcmp(cartellaIstanteDiSalvataggioMerge,'')
            mkdir(cartellaIstanteDiSalvataggioMerge)
            nomeTemplateMerge=[nomeUtente '_' istante '.jpg'];
            %scrive l'immagine specificata in merge nel persorso specificato
            %come secondo argomento, nel formato jpg
            imwrite(merge, [cartellaIstanteDiSalvataggioMerge '\' nomeTemplateMerge], 'jpg');
            disp([cartellaIstanteDiSalvataggioMerge '\' nomeTemplateMerge]);
        end

        toc
    
    end
    
end
    
disp('Analisi completata');

%faccio il matching
disp('Matching in corso...');
% saveDirRisultati = directorySaveAll;
identificazioneMatching2D_CPUParallel
disp('Matching effettuato.');
    
%calcolo le statistiche
disp('Estrazione delle statistiche in corso...');
statics_3D
disp('Estrazione delle statistiche effettuata');

%disegnamo la DET
disp('Creazione delle curve DET in corso...');
drawDETcurve
disp('Creazione delle curve DET effettuata.');
end