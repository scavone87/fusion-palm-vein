% CARICA IL FILE .MAT E RESTITUISCE L'IMMAGINE DEL PALMO
function [] = generaImmaginiProfondita(matFile,percorso)
    load (strcat(percorso,matFile,'.mat'));

    %PARAMETRI
    tresh=64;   % Intensity treshold for surface detection (0 - 255)
    filter_siz=20;  % Averaging filter
    
    FFFF=zeros(542,814,11);
    
    %estraggo la cartella del database
    k = strfind(percorso,'mat\');
    dirPart = percorso(1:k-1);
    path=strcat(dirPart,'imageGeneratedFrom3D\',matFile);
    
    if ~exist(path, 'dir')
        mkdir(path);

        for i=1:6
            depth=i*0.05;
            surface_detection;
            %[FileName, PathName] = uiputfile('*.jpg','Salva immagine: ');
            FileName=strcat( 'immagine', num2str( depth ),'.jpg' )
            Name = fullfile(path, FileName);
            %Name = fullfile(PathName, FileName);
            imwrite(FFF, Name, 'jpg');
            FFFF(:,:,i)=FFF;
        end
    end

end