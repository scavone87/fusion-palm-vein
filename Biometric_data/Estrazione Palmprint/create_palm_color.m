%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%In questo script viene creata un'immagine JPG %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [FF2,map] = imread(strcat(pathname,filename{1}));
% [FF3,map] = imread(strcat(pathname,filename{2}));


    w1 = fspecial('average', [9,9]);   %9 migliore
    arit5x5_2 = imfilter(FF2,w1);
    arit5x5_3 = imfilter(FF3,w1);

    dimensione = size(arit5x5_2); % CALCOLO RIGA E COLONNE MATRICE
    dimensionerighe = dimensione(1);
    dimensionecolonne= dimensione(2);

    matriceFinale=zeros(dimensionerighe,dimensionecolonne);

    arit5x5_2 = double(arit5x5_2);
    arit5x5_3 = double(arit5x5_3);

    dimensione = size(arit5x5_2); % CALCOLO RIGA E COLONNE MATRICE
    dimensionerighe = dimensione(1);
    dimensionecolonne= dimensione(2);


    for i=1:dimensionerighe    %notando che la 0.03 è la migliore, allora tolgo le parti che cambiano molto dalla 0.03
        for j=1:dimensionecolonne
            if(arit5x5_2(i,j)-arit5x5_3(i,j)<0)
                matriceFinale(i,j)=arit5x5_3(i,j);
            else
                matriceFinale(i,j)=arit5x5_2(i,j);
            end
                
        end
    end

    matriceFinale=uint8(matriceFinale);

% [FileName, PathName] = uiputfile('*.jpg','Salva immagine finale da elaborare: ');
% FileName = strcat(filename{1},filename{2});
% Name = fullfile(pathname, FileName)
% imwrite(matriceFinale, Name, 'jpg');