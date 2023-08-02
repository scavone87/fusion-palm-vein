function [] = generaImmaginiProfondita_calia( matFile,percorsoDoveSiTrova, directorySaveAll)
    pathname=percorsoDoveSiTrova;
    load (strcat(pathname,matFile,'.mat'));

    
    %PARAMETRI
    tresh=64;   % Intensity treshold for surface detection (0 - 255)
    filter_siz=20;  % Averaging filter
    
    FFFF=zeros(542,814,7);
    path = [directorySaveAll '\TemplateGeneratiCalia\', matFile, '\template\'];
%     path=strcat('TemplateGenerati/',matFile,'/Immagini');
    
    mkdir(path)
    
    for i=1:2

        depth=i*0.0462;

        surface_detection_calia;
        
        immagine = imagesc(X,Y,FFF',[0 255]);
        colormap(gray(256));
        set(gca,'ActivePositionProperty','position');
        set(gca,'DataAspectRatio',[1 1 1]);

        FileName=strcat( matFile,'_', num2str( i ),'.jpg' );
        Name = fullfile(path, FileName);
        imwrite(FFF', Name, 'jpg');
        FFFF(:,:,i)=FFF;
        close;
    end


end

