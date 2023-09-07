function [path_regioni_connesse, path_dati_elaborati,variabile] = findconncompCiclo(base_path, path_mask_b_scan,tipoBinarizzazione,filtered)
%% procedura che ricerca le componenti connesse selezionando una cartella contentente immagini binarie,
%effettua un tipo di cleaning alla prima immagine e un altro tipo di cleaning alle altre
nomeUtente = split(path_mask_b_scan, '\');
nomeUtente = string(nomeUtente(end));
path_dati_elaborati = fullfile (base_path, 'Dati elaborati');
path_regioni_connesse = fullfile(path_dati_elaborati, 'regioniconnesse b-scan', nomeUtente);
mkdir(path_regioni_connesse);

%percorso cartella
d = dir(path_mask_b_scan);
d(1:2) = [];
variabile = false;
for i = 1:size(d,1)

    %if (i >= 2)
    fileName = d(i).name;
    fileBMP = fullfile(path_mask_b_scan, fileName);
    fileName = erase(fileName, "_mask.bmp"); %elimino la stringa _mask.bmp da ogni nome
    M = imread(fileBMP);
    %M = M(108:216, 216:433);
    % Mlog = im2bw(M); % converto in matrice logica
    % Mcompl = imcomplement(Mlog); %calcolo matrice complementare
    % CC = bwconncomp(Mcompl);
    % S = regionprops(CC, 'Area');
    % L = labelmatrix(CC);
    % BW = ismember(L, find([S.Area] < 1500 & [S.Area] > 40));
    % BW = imfill(BW,'holes');
    % salva = fullfile(path_regioni_connesse, strcat(fileName, '_conncomp.bmp'));
    % imwrite(BW, salva);

    Mcompl = imcomplement(M); %calcolo matrice complementare
    CC = bwconncomp(Mcompl);
    S = regionprops(CC, 'Area');
    L = labelmatrix(CC);
    BW = ismember(L, find([S.Area] < 1300 & [S.Area] > 402));
    BW = imfill(BW,'holes');    

    salva = fullfile(path_regioni_connesse, strcat(fileName, '_conncomp.bmp'));
    imwrite(BW, salva);
    %else
    %     fileName = d(i).name;
    %     fileBMP = fullfile(path_mask_b_scan, fileName);
    %     fileName = erase(fileName, "_mask.bmp");
    %     M = imread(fileBMP);
    %
    %     Mlog = im2bw(M);
    %     Mcompl = imcomplement(Mlog);
    %     CC = bwconncomp(Mcompl);
    %     S = regionprops(CC, 'Area');
    %     L = labelmatrix(CC);
    %     BW = ismember(L, find([S.Area] < 1600 & [S.Area] > 129));
    %     %%verificare se ci sono centroidi
    %     regione = regionprops(BW, 'centroid');
    %     centroids = cat(1, regione.Centroid);
    %     centroids=round(centroids);
    %     if length(centroids) == 0
    %       BW = ismember(L, find([S.Area] < 1500 & [S.Area] > 50));
    %      variabile = true;
    %     end
    %     salva = fullfile(path_regioni_connesse, strcat(fileName, '_conncomp.bmp'));
    %     imwrite(BW, salva);
    % end

end

disp('CLEANING APPLICATO ALLE MASCHERE');
end
