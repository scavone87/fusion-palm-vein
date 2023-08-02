function [] = generaTemplate_calia( matFile, directorySaveAll )
    ss = [directorySaveAll '\TemplateGeneratiCalia\', matFile, '\.dat\'];
    mkdir(ss);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SETTAGGIO PARAMETRI IMMAGINE ULTRASONICHE %
      sigmaGauss = 0.5;                          
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % LE IMMAGINI SONO A BASSA RISOLUZIONE 72 DPI

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SOGLIE IN SCALA DI GRIGIO USATE PER FILTRARE %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sogliaMedia3x3 = 175;
    sogliaMedia7x7 = 160;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CARICO L'IMMAGINE ORIGINALE %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % directory_name_save1 = uigetdir(pwd,'Seleziona la directory dove salvare i template:')   
    %path_name=strcat(matFile,'/Template');


    %for p=2:13
        
         p=1;
             %nomeTemplate=strcat( 'template', num2str( p ) );
             s = [directorySaveAll '\TemplateGeneratiCalia\', matFile, '\template\'];
             mkdir(s);
             Name1=strcat(s,matFile,'_',num2str( 1 ),'.jpg');
             Name2=strcat(s,matFile,'_',num2str( 2 ),'.jpg');
             im11 = imread(Name1);
             im12 = imread(Name2);

            %FILTRO PRESO DA CREATE_PALM_COLOR TOGLIENDO DOPPIA IMMAGINE MA
            %LASCIANDO IL FILTRO
            w1 = fspecial('average', [9,9]);   %9 migliore
            im11 = imfilter(im11,w1);
            im12 = imfilter(im12,w1);

            dimensione = size(im11); % CALCOLO RIGA E COLONNE MATRICE
            dimensionerighe = dimensione(1);
            dimensionecolonne= dimensione(2);

            matriceFinale=zeros(dimensionerighe,dimensionecolonne);

            im11 = double(im11);
            im12 = double(im12);

            for i=1:dimensionerighe    %notando che la 0.03 è la migliore, allora tolgo le parti che cambiano molto dalla 0.03
                for j=1:dimensionecolonne
                    if(im11(i,j)-im12(i,j)<0)
                        matriceFinale(i,j)=im12(i,j);
                    else
                        matriceFinale(i,j)=im11(i,j);
                    end

                end
            end
            matriceFinale=uint8(matriceFinale);
            im11=matriceFinale;


%         else
% 
%             nomeTemplate=strcat( 'template', num2str( p ) );  
%             
%             Name=strcat(pwd,'\TemplateGenerati\',matFile,'\Immagini\','template',num2str( p ),'.jpg');
%             im11 = imread(Name);
% 
%             %FILTRO PRESO DA CREATE_PALM_COLOR TOGLIENDO DOPPIA IMMAGINE MA
%             %LASCIANDO IL FILTRO
%              w1 = fspecial('average', [9,9]);   %9 migliore
%             im11 = imfilter(im11,w1);

        %end


        %delete(Name); cancella anche in automatico l'immagine di cui genera il
        %tempalte..valutare se decommentarlo o no


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RIDIMENSIONO LA GRANDEZZA DELL'IMMAGINE %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        im2=imresize(im11, [122 118], 'bicubic'); % imposto la grandezza dell'immagine
        app = size(im2);
        col = app(2);
        % resize = 349.44/col;
        % resize = 200/col; MIGLIORE
        resize = 200/col;
        im1=imresize(im2, resize,'bicubic'); % la scala della dimensione ricercata ovvero 349 colonne


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % TRASFORMO L'IMMAGINE IN SCALA DI GRIGI AD 8 BIT %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        immagine2 = im2uint8(im1);
        if(ndims(immagine2)>2) %significa che l'immagine è RGB
            matGraySporco = rgb2gray(immagine2);
        else
            matGraySporco = immagine2;
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % EFFETTUO VARI FILTRAGGI PER REALIZZARE LE LINEE %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        num=3;
        mat3=template_difference(matGraySporco,num,sigmaGauss);
        num=5;
        mat5=template_difference(matGraySporco,num,sigmaGauss);
        num=7;
        mat7=template_difference(matGraySporco,num,sigmaGauss);
        num=9;
        mat9=template_difference(matGraySporco,num,sigmaGauss);
        num=11;
        mat11=template_difference(matGraySporco,num,sigmaGauss);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % VISIONO I PUNTI DI TUTTE LE MATRICI CALCOLATE %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dimensione=size(mat3);
        dimensionerighe=dimensione(1);
        dimensionecolonne=dimensione(2);
        mat3_17=zeros(dimensionerighe,dimensionecolonne);
        k=1; %grandezza della matrice di scansionamento -- k=1 --> 3x3
        for i=1+k:dimensionerighe-k
            for j=1+k:dimensionecolonne-k
                somma_pixel=0;
                for i1=i-k:i+k
                    for j1=j-k:j+k
                          somma_pixel=somma_pixel+mat9(i1,j1)+mat11(i1,j1)+mat7(i1,j1)+mat5(i1,j1); %dal 5 al 15
                    end
                end
                mat3_17(i,j)=somma_pixel;
            end
        end

        %bisogna provare a fare gli score e smanettare su quali matrici usare e la
        %soglia

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FILTRO LA MATRICE APPENA CALCOLATA %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        soglia_filtro=6; %era 5
        mat3_17_filtrata=mat3_17;
        for i=1+k:dimensionerighe-k
            for j=1+k:dimensionecolonne-k
                if(mat3_17(i,j)<=soglia_filtro)
                    mat3_17_filtrata(i,j)=0;
                end
            end
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ELIMINIAMO IL CONTORNO DELLA MATRICE %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        matGrayXY_binary1=mat3_17_filtrata([8:dimensionerighe-7],[8:dimensionecolonne-7]); %ne eliminiamo 7

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CANCELLO I PIXEL DAL CONTORNO %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        mat3_17_filtrata2=mat3_17_filtrata;
        for i=1:dimensionerighe
            for j=1:dimensionecolonne
                if(i<=7 || i>=dimensionerighe-7)
                    mat3_17_filtrata2(i,j)=0;
                end
                if(j<=7 || j>=dimensionecolonne-7)
                    mat3_17_filtrata2(i,j)=0;
             end
            end
        end


        matGraySporco2=matGraySporco([8:dimensionerighe-7],[8:dimensionecolonne-7]);




        % %senza contorni
        matGrayXY_binary3 = bwmorph(matGrayXY_binary1,'close');
        matGrayXY_binary4 = bwmorph(matGrayXY_binary3,'thin',Inf);


        %%%%%%%%%%%%%%%%%%%%%%%%
        % RICOSTRUIAMO I BORDI %
        %%%%%%%%%%%%%%%%%%%%%%%%
        % matGrayXY_binary_6_rebuild=rebuild_edge(matGrayXY_binary6,matGrayXY_binary4);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ELIMINO I TRATTI PIU CORTI %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % matriceXY_delete=delete_small_lines(matGrayXY_binary_6_rebuild);
        matriceXY_delete1=delete_small_lines(matGrayXY_binary4);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ELIMINO I TRATTI ISOLATI %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        matriceXY_delete = bwmorph(matriceXY_delete1,'clean',Inf);

        B = strel('disk', 2);
        matriceXY_delete2 = imdilate(matriceXY_delete,B);
        matriceXY_delete3 = bwmorph(matriceXY_delete2,'close');
        matriceXY_delete4 = bwmorph(matriceXY_delete3,'thin',Inf);


        %%%%%%%%%%%%%%%%%%%%%%%%
        % TEMPLATE DELLE LINEE %
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        
%         figure('name','LINES TEMPLATE');
%         imshow(matGraySporco2);
%         hold on;
%         spy(matriceXY_delete4,1,'red');
%         
%         figure();
%         spy(matriceXY_delete4,1,'red');
%         set(gcf,'color','w');



        % copia buona
        nomeTemplate=matFile;%strcat( 'TEMPLATE', num2str( p ) );
        %strcat(pwd,'\',matFile,'\Template\','TEMPLATE',num2str( p ),'.dat')



      %  filenameTemplate=strcat(nomeTemplate,'.dat');
        save(strcat(ss,matFile,'.dat'),'matriceXY_delete');   
               
    %end
    %close all

  
%     profonditaTratti(filtraggioInProfondita(generaMatriceContenenteTemplate(matFile),4),matFile);  

end

