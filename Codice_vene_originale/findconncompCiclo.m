function [path_regioni_connesse, path_dati_elaborati,variabile] = findconncompCiclo(base_path, path_mask_b_scan,tipoBinarizzazione,filtered)
%% procedura che ricerca le componenti connesse selezionando una cartella contentente immagini binarie,
    %effettua un tipo di cleaning alla prima immagine e un altro tipo di cleaning alle altre
    path_dati_elaborati = strcat (base_path, 'Dati elaborati/');
    path_regioni_connesse = strcat(path_dati_elaborati, 'regioniconnesse b-scan/');
    cd(path_dati_elaborati);
    
    %percorso cartella
    d = dir(path_mask_b_scan);
    d(1:2) = [];
    variabile = false;
    for i = 1:length(d)

        if (i >= 2)
            fileName = d(i).name;
            fileBMP = strcat(path_mask_b_scan, fileName);
            fileName = erase(fileName, "_mask.bmp"); %elimino la stringa _mask.bmp da ogni nome
            M = imread(fileBMP);      
            cd ..; %
            cd ..; %
            Mlog = im2bw(M); % converto in matrice logica
            Mcompl = imcomplement(Mlog); %calcolo matrice complementare
            CC = bwconncomp(Mcompl);
            S = regionprops(CC, 'Area');
            L = labelmatrix(CC);
            BW = ismember(L, find([S.Area] < 1500 & [S.Area] > 40)); 
            BW = imfill(BW,'holes');
            cd(path_regioni_connesse); %percorso in cui vengono salvate le immagini
            imwrite(BW, strcat(fileName, '_conncomp.bmp'));
        else
            fileName = d(i).name;
            fileBMP = strcat(path_mask_b_scan, fileName);
            fileName = erase(fileName, "_mask.bmp");
            M = imread(fileBMP);
            cd ..; %
            Mlog = im2bw(M);
            Mcompl = imcomplement(Mlog);
            CC = bwconncomp(Mcompl);
            S = regionprops(CC, 'Area');
            L = labelmatrix(CC);
            BW = ismember(L, find([S.Area] < 1600 & [S.Area] > 129));
            %%verificare se ci sono centroidi
            regione = regionprops(BW, 'centroid');
            centroids = cat(1, regione.Centroid);
            centroids=round(centroids);
            if length(centroids) == 0
              BW = ismember(L, find([S.Area] < 1500 & [S.Area] > 50)); 
             variabile = true;            
            end
            cd(path_regioni_connesse);
            imwrite(BW, strcat(fileName, '_conncomp.bmp'));
        end

    end

    disp('CLEANING APPLICATO ALLE MASCHERE');
    cd(path_dati_elaborati);
end
