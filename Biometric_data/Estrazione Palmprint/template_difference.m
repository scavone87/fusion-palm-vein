function [matGrayXY_binary_allung2,matGray] = template_difference(matGraySporco,num,sigmaGauss)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % APPLICO IL FILTRO ARITMETICO ALL'IMMAGINE ORIGINALE %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    w5 = fspecial('average', [num,num]);  %15 ONESTO
    matGraySporcoMediato = medfilt2(matGraySporco, [9,9]);
    matGraySporcoAritmetico = imfilter(matGraySporco,w5);


    conteggio_punti=850; %850
    %%%%%%%%%%%%%%%%%%%%%%%
    %% PROCEDURA PER LE X %
    %%%%%%%%%%%%%%%%%%%%%%%
    matGrayNum=double(matGraySporcoAritmetico); %matGraySporcoAritmetico 3
    dimensione=size(matGrayNum); % CALCOLO RIGA E COLONNE MATRICE
    dimensionerighe=dimensione(1);
    dimensionecolonne=dimensione(2);
    % 1° ALGORITMO
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(j==dimensionecolonne)
                matGrayX(i,j)=matGrayNum(i,j);
            else
                matGrayX(i,j)=matGrayNum(i,j)-matGrayNum(i,j+1);
            end
        end
    end

    % 2° ALGORITMO
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(j==dimensionecolonne)
                matGrayX2(i,j)=255;
            else
                if j~=1
                    if(matGrayX(i,j)==0) && (matGrayX(i,j-1)==0)
                            matGrayX2(i,j)=255; 
                    else
                        if(matGrayX(i,j)>=0) && (matGrayX(i,j+1)<=0 && matGrayX(i,j-1)>0)  % >0 significa che si sta inscurendo
                            matGrayX2(i,j)=0;
                        else
                            matGrayX2(i,j)=255;
                        end
                    end
                else
                    matGrayX2(i,j)=255;
                end
            end
        end
    end

    %binarizzo -> non usato
    matGrayX2_binary=matGrayX2;
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if matGrayX2(i,j)>220
                matGrayX2_binary(i,j)=0;
            else
                matGrayX2_binary(i,j)=1;
            end
        end
    end
    matGrayX2_binary=mat2gray(matGrayX2_binary);



    % 3° ALGORITMO
    k=7;
    matGrayX2_SPOLVERATA=matGrayX2;
    for i=1+k:dimensionerighe-k
        for j=1:dimensionecolonne-k
            flag=0;
            somma=0;
            if matGrayX2(i,j)==0
                for i1=i-2:i+2
                    for j1=j:j+k
                        flag=flag+1;
                        somma=somma+matGrayNum(i1,j1);
                    end
                end
                if matGrayNum(i,j)>(somma/flag)%%STAVA -2
                     matGrayX2_SPOLVERATA(i,j)=255;
                end
            end
        end
    end


    % 4° ALGORITMO
    matGrayX3=matGrayX2_SPOLVERATA;
    k=6; %6
    differenzaX3=1; %0
    contatoreX3=0;
    for i=1:dimensionerighe
            for j=1:dimensionecolonne
                if(matGrayX3(i,j)==0)
                    contatoreX3=contatoreX3+1;
                end
            end
    end
    while(contatoreX3>conteggio_punti) %%PROVARE COSI!!!!
        differenzaX3=differenzaX3+1;
        for i=k+1:dimensionerighe-k
            for j=k+1:dimensionecolonne-k
                flag=0;
                if matGrayX2_SPOLVERATA(i,j)==0
                    for ii=i-k:i+k
                        for jj=j-k:j %+k
                            if flag<226
                                if abs(matGrayX(ii,jj))>differenzaX3
                                    %matGrayX3(i,j)=0;
                                    flag=flag+1;
                                else
                                    %matGrayX3(i,j)=255;
                                end
                            end
                        end
                    end
                    if(flag>1)
                        matGrayX3(i,j)=0;
                    else
                        matGrayX3(i,j)=255;
                    end
                end
            end
        end

        contatoreX3=0;
        for i=1:dimensionerighe
            for j=1:dimensionecolonne
                if(matGrayX3(i,j)==0)
                    contatoreX3=contatoreX3+1;
                end
            end
        end
    end

%     figure()
%     imagesc(matGrayX);
%     colorbar
%     colormap('hsv')

    matGrayX32=matGrayX3-matGrayX2; %mostro tutte le linee eliminate nel precedente filtraggio
    
    
    % 5° ALGORITMO
    %binarizzo X3
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if matGrayX3(i,j)==0
                matGrayX3_binary(i,j)=1;
            else
                matGrayX3_binary(i,j)=0;
            end
        end
    end
    
    matGrayX3_binary=bwmorph(matGrayX3_binary,'skel');
    matGrayX3_end=bwmorph(matGrayX3_binary,'endpoints');
    
    for i=8:dimensionerighe-7
        for j=8:dimensionecolonne-7
            if(matGrayX3_end(i,j)==1) %vuol dire che siamo su un estremo della linea
                flag=0;
                if(matGrayX3_binary(i+1,j-1)==1 || matGrayX3_binary(i+1,j)==1 || matGrayX3_binary(i+1,j+1)==1) %è un punto estremo superiore -> cerchiamo sopra
                    riga=i;
                    colonna=j;
                    while(flag==0)
                        flag=1;
                        if(riga-1>=1 && colonna-1>=1 && colonna+1<=dimensionecolonne)
                            if(matGrayX2_SPOLVERATA(riga-1,colonna-1)==0) % 0|255|255
                                matGrayX3_binary(riga-1,colonna-1)=1;
                                riga=riga-1;
                                colonna=colonna-1;
                                flag=0;
                            elseif(matGrayX2_SPOLVERATA(riga-1,colonna)==0) % 0|1|0
                                matGrayX3_binary(riga-1,colonna)=1;
                                riga=riga-1;
                                colonna=colonna;
                                flag=0;
                            elseif(matGrayX2_SPOLVERATA(riga-1,colonna+1)==0) % 0|0|1
                                matGrayX3_binary(riga-1,colonna+1)=1;
                                riga=riga-1;
                                colonna=colonna+1;
                                flag=0;
                            end
                        end
                    end
                end
                flag=0;
                if(matGrayX3_binary(i-1,j-1)==1 || matGrayX3_binary(i-1,j)==1 || matGrayX3_binary(i-1,j+1)==1) %è un punto estremo inferiore
                    riga=i;
                    colonna=j;
                    while(flag==0)
                        flag=1;
                        if(riga+1<=dimensionerighe && colonna-1>=1 && colonna+1<=dimensionecolonne)
                            if(matGrayX2_SPOLVERATA(riga+1,colonna-1)==0) % 1|0|0
                                matGrayX3_binary(riga+1,colonna-1)=1;
                                riga=riga+1;
                                colonna=colonna-1;
                                flag=0;
                            elseif(matGrayX2_SPOLVERATA(riga+1,colonna)==0) % 0|1|0
                                matGrayX3_binary(riga+1,colonna)=1;
                                riga=riga+1;
                                colonna=colonna;
                                flag=0;
                            elseif(matGrayX2_SPOLVERATA(riga+1,colonna+1)==0) % 0|0|1
                                matGrayX3_binary(riga+1,colonna+1)=1;
                                riga=riga+1;
                                colonna=colonna+1;
                                flag=0;
                            end
                        end
                    end
                end
            end
        end
     end


    %%%%%%%%%%%%%%%%%%%%%
    % INVERTIAMO LA MATRICE DELLE DIFFERENZE PER CERCARE LE LINEE ANCHE DA
    % DESTRA VERSO SINISTRA
    j=1;
    for i=dimensionecolonne:-1:1
        matGraySporcoAritmetico_invertita2(:,j)=matGraySporcoAritmetico(:,i);
        j=j+1;
    end

    matGraySporcoAritmetico_invertita2=double(matGraySporcoAritmetico_invertita2);

    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(j==dimensionecolonne)
                matGrayX_2(i,j)=matGraySporcoAritmetico_invertita2(i,j);
            else
                matGrayX_2(i,j)=matGraySporcoAritmetico_invertita2(i,j)-matGraySporcoAritmetico_invertita2(i,j+1);
            end
        end
    end

    matGrayX_2=double(matGrayX_2);

    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(j==dimensionecolonne)
                matGrayX22(i,j)=255;
            else
                if j~=1
                    if(matGrayX_2(i,j)==0) && (matGrayX_2(i,j-1)==0)
                            matGrayX22(i,j)=255; 
                    else
                        if(matGrayX_2(i,j)>=0) && (matGrayX_2(i,j+1)<=0 && matGrayX_2(i,j-1)>0)  % >0 significa che si sta inscurendo
                            matGrayX22(i,j)=0;
                        else
                            matGrayX22(i,j)=255;
                        end
                    end
                else
                    matGrayX22(i,j)=255;
                end
            end
        end
    end

    k=7;
    matGrayX22_SPOLVERATA=matGrayX22;
    for i=1+k:dimensionerighe-k
        for j=1:dimensionecolonne-k
            flag=0;
            somma=0;
            if matGrayX22(i,j)==0
                for i1=i-2:i+2
                    for j1=j:j+k
                        flag=flag+1;
                        somma=somma+matGraySporcoAritmetico_invertita2(i1,j1);
                    end
                end
                if matGraySporcoAritmetico_invertita2(i,j)>(somma/flag)
                     matGrayX22_SPOLVERATA(i,j)=255;
                end
            end
        end
    end


    contatoreX33=0;
    matGrayX33=matGrayX22_SPOLVERATA;
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(matGrayX33(i,j)==0)
                contatoreX33=contatoreX33+1;
            end
        end
    end
    k=6;
    differenzaX33=1;
    while(contatoreX33>conteggio_punti)
        differenzaX33=differenzaX33+1;
        for i=k+1:dimensionerighe-k
            for j=k+1:dimensionecolonne-k
                flag=0;
                if matGrayX22_SPOLVERATA(i,j)==0
                    for ii=i-k:i+k
                        for jj=j:j+k %-k
                            if flag<226
                                if abs(matGrayX_2(ii,jj))>differenzaX33
                                    %matGrayX33(i,j)=0;
                                    flag=flag+1;
                                else
                                    %matGrayX33(i,j)=255;
                                end
                            end
                        end
                    end
                    if(flag>1)
                        matGrayX33(i,j)=0;
                    else
                        matGrayX33(i,j)=255;
                    end
                end
            end
        end

            contatoreX33=0;
        for i=1:dimensionerighe
            for j=1:dimensionecolonne
                if(matGrayX33(i,j)==0)
                    contatoreX33=contatoreX33+1;
                end
            end
        end
    end
    
    
    
    %binarizzo Y2
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if matGrayX33(i,j)==0
                matGrayX33_binary(i,j)=1;
            else
                matGrayX33_binary(i,j)=0;
            end
        end
    end
    
    matGrayX33_binary=bwmorph(matGrayX33_binary,'skel');
    matGrayX33_end=bwmorph(matGrayX33_binary,'endpoints');
    
    for i=8:dimensionerighe-7
        for j=8:dimensionecolonne-7
            if(matGrayX33_end(i,j)==1) %vuol dire che siamo su un estremo della linea
                flag=0;
                if(matGrayX33_binary(i+1,j-1)==1 || matGrayX33_binary(i+1,j)==1 || matGrayX33_binary(i+1,j+1)==1) %è un punto estremo superiore -> cerchiamo sopra
                    riga=i;
                    colonna=j;
                    while(flag==0)
                        flag=1;
                        if(riga-1>=1 && colonna-1>=1 && colonna+1<=dimensionecolonne)
                            if(matGrayX22_SPOLVERATA(riga-1,colonna-1)==0) % 0|255|255
                                matGrayX33_binary(riga-1,colonna-1)=1;
                                riga=riga-1;
                                colonna=colonna-1;
                                flag=0;
                            elseif(matGrayX22_SPOLVERATA(riga-1,colonna)==0) % 0|1|0
                                matGrayX33_binary(riga-1,colonna)=1;
                                riga=riga-1;
                                colonna=colonna;
                                flag=0;
                            elseif(matGrayX22_SPOLVERATA(riga-1,colonna+1)==0) % 0|0|1
                                matGrayX33_binary(riga-1,colonna+1)=1;
                                riga=riga-1;
                                colonna=colonna+1;
                                flag=0;
                            end
                        end
                    end
                end
                flag=0;
                if(matGrayX33_binary(i-1,j-1)==1 || matGrayX33_binary(i-1,j)==1 || matGrayX33_binary(i-1,j+1)==1) %è un punto estremo inferiore
                    riga=i;
                    colonna=j;
                    while(flag==0)
                        flag=1;
                        if(riga+1<=dimensionerighe && colonna-1>=1 && colonna+1<=dimensionecolonne)
                            if(matGrayX22_SPOLVERATA(riga+1,colonna-1)==0) % 1|0|0
                                matGrayX33_binary(riga+1,colonna-1)=1;
                                riga=riga+1;
                                colonna=colonna-1;
                                flag=0;
                            elseif(matGrayX22_SPOLVERATA(riga+1,colonna)==0) % 0|1|0
                                matGrayX33_binary(riga+1,colonna)=1;
                                riga=riga+1;
                                colonna=colonna;
                                flag=0;
                            elseif(matGrayX22_SPOLVERATA(riga+1,colonna+1)==0) % 0|0|1
                                matGrayX33_binary(riga+1,colonna+1)=1;
                                riga=riga+1;
                                colonna=colonna+1;
                                flag=0;
                            end
                        end
                    end
                end
            end
        end
     end
    

    j=1;
    for i=dimensionecolonne:-1:1
        matGrayX33_girata(:,j)=matGrayX33(:,i);
        j=j+1;
    end
    
        j=1;
    for i=dimensionecolonne:-1:1
        matGrayX33_binary_girata(:,j)=matGrayX33_binary(:,i);
        j=j+1;
    end



    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(matGrayX3(i,j)+matGrayX33_girata(i,j)==0)
                matGrayXTot(i,j)=0;
            end
            if(matGrayX3(i,j)+matGrayX33_girata(i,j)==255)
                matGrayXTot(i,j)=70;
            end
            if(matGrayX3(i,j)+matGrayX33_girata(i,j)==510)
                matGrayXTot(i,j)=255;
            end
        end
    end

    matGrayX_lines=uint8(matGrayXTot);
    

    matGrayX_lines_allung=matGrayX3_binary+matGrayX33_binary_girata;



    %%%%%%%%%%%%%%%%%%%%%%%
    %% PROCEDURA PER LE Y %
    %%%%%%%%%%%%%%%%%%%%%%%
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(i==dimensionerighe)
                matGrayY(i,j)=matGrayNum(i,j);
            else
                matGrayY(i,j)=matGrayNum(i,j)-matGrayNum(i+1,j);
            end
        end
    end

    for i=1:dimensionerighe          %prende la linea quando passa da bianco a nero --> scandisce da sopra verso sotto  
        for j=1:dimensionecolonne
            if(i==dimensionerighe)
                matGrayY2(i,j)=255;
            else
                if i~=1
                    if(matGrayY(i,j)==0) && (matGrayY(i-1,j)==0)
                            matGrayY2(i,j)=255; 
                    else
                        if(matGrayY(i,j)>=0) && (matGrayY(i+1,j)<=0 && matGrayY(i-1,j)>0)
                            matGrayY2(i,j)=0;
                        else
                            matGrayY2(i,j)=255;
                        end
                    end
                else
                    matGrayY2(i,j)=255;
                end
            end
        end
    end

    %binarizzo
    matGrayY2_binary=matGrayY2;
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if matGrayY2(i,j)>220
                matGrayY2_binary(i,j)=0;
            else
                matGrayY2_binary(i,j)=1;
            end
        end
    end
    matGrayY2_binary=mat2gray(matGrayY2_binary);
    B = strel('square', 2);
    matGrayY2_binary = imdilate(matGrayY2_binary,B);



    k=7;
    matGrayY2_SPOLVERATA=matGrayY2;
    for i=1:dimensionerighe-k
        for j=1+k:dimensionecolonne-k
            flag=0;
            somma=0;
            if matGrayY2(i,j)==0
                for i1=i:i+k
                    for j1=j-2:j+2
                        flag=flag+1;
                        somma=somma+matGrayNum(i1,j1);
                    end
                end
                if matGrayNum(i,j)>(somma/flag)
                     matGrayY2_SPOLVERATA(i,j)=255;
                end
            end
        end
    end

    contatoreY3=0;
    matGrayY3=matGrayY2_SPOLVERATA;
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(matGrayY3(i,j)==0)
                contatoreY3=contatoreY3+1;
            end
        end
    end
    k=6;
    differenzaY3=1;
    while(contatoreY3>conteggio_punti)
        differenzaY3=differenzaY3+1;
        for i=k+1:dimensionerighe-k
            for j=k+1:dimensionecolonne-k
                flag=0;
                if matGrayY2_SPOLVERATA(i,j)==0
                    for ii=i-k:i %+k
                        for jj=j-k:j+k
                            if flag<226
                                if matGrayY(ii,jj)>differenzaY3
                                    %matGrayY3(i,j)=0;
                                    flag=flag+1;
                                else
                                    %matGrayY3(i,j)=255;
                                end
                            end
                        end
                    end
                    if(flag>1)
                        matGrayY3(i,j)=0;
                    else
                        matGrayY3(i,j)=255;
                    end
                end
            end
        end

        contatoreY3=0;
        for i=1:dimensionerighe
            for j=1:dimensionecolonne
                if(matGrayY3(i,j)==0)
                    contatoreY3=contatoreY3+1;
                end
            end
        end
    end
    matGrayY32=matGrayY3-matGrayY2; %mostro tutte le linee eliminate nel precedente filtraggio
    
    
    
    %binarizzo Y2
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if matGrayY3(i,j)==0
                matGrayY3_binary(i,j)=1;
            else
                matGrayY3_binary(i,j)=0;
            end
        end
    end
    
    matGrayY3_binary=bwmorph(matGrayY3_binary,'skel');
    matGrayY3_end=bwmorph(matGrayY3_binary,'endpoints');
    
    for i=8:dimensionerighe-7
        for j=8:dimensionecolonne-7
            if(matGrayY3_end(i,j)==1) %vuol dire che siamo su un estremo della linea
                flag=0;
                if(matGrayY3_binary(i-1,j+1)==1 || matGrayY3_binary(i,j+1)==1 || matGrayY3_binary(i+1,j+1)==1) %è un punto estremo sinistra -> cerchiamo a sinistra
                    riga=i;
                    colonna=j;
                    while(flag==0)
                        flag=1;
                        if(riga-1>=1 && colonna-1>=1 && riga+1<=dimensionerighe)
                            if(matGrayY2_SPOLVERATA(riga-1,colonna-1)==0) % 0|255|255
                                matGrayY3_binary(riga-1,colonna-1)=1;
                                riga=riga-1;
                                colonna=colonna-1;
                                flag=0;
                            elseif(matGrayY2_SPOLVERATA(riga,colonna-1)==0) % 0|1|0
                                matGrayY3_binary(riga,colonna-1)=1;
                                riga=riga;
                                colonna=colonna-1;
                                flag=0;
                            elseif(matGrayY2_SPOLVERATA(riga+1,colonna-1)==0) % 0|0|1
                                matGrayY3_binary(riga+1,colonna-1)=1;
                                riga=riga+1;
                                colonna=colonna-1;
                                flag=0;
                            end
                        end
                    end
                end
                flag=0;
                if(matGrayY3_binary(i-1,j-1)==1 || matGrayY3_binary(i,j-1)==1 || matGrayY3_binary(i+1,j-1)==1) %è un punto estremo destro
                    riga=i;
                    colonna=j;
                    while(flag==0)
                        flag=1;
                        if(riga-1>=1 && colonna+1<=dimensionecolonne && riga+1<=dimensionerighe)
                            if(matGrayY2_SPOLVERATA(riga-1,colonna+1)==0) % 1|0|0
                                matGrayY3_binary(riga-1,colonna+1)=1;
                                riga=riga-1;
                                colonna=colonna+1;
                                flag=0;
                            elseif(matGrayY2_SPOLVERATA(riga,colonna+1)==0) % 0|1|0
                                matGrayY3_binary(riga,colonna+1)=1;
                                riga=riga;
                                colonna=colonna+1;
                                flag=0;
                            elseif(matGrayY2_SPOLVERATA(riga+1,colonna+1)==0) % 0|0|1
                                matGrayY3_binary(riga+1,colonna+1)=1;
                                riga=riga+1;
                                colonna=colonna+1;
                                flag=0;
                            end
                        end
                    end
                end
            end
        end
     end


    % %%%%%%%%%%%%%%%%%%%%%
    % % INVERTIAMO LA MATRICE DELLE DIFFERENZE PER CERCARE LE LINEE ANCHE DAL
    % % BASSO VERSO L'ALTO
    j=1;
    for i=dimensionerighe:-1:1
        matGraySporcoAritmetico_invertita(j,:)=matGraySporcoAritmetico(i,:);
        j=j+1;
    end

    matGraySporcoAritmetico_invertita=double(matGraySporcoAritmetico_invertita);

    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(i==dimensionerighe)
                matGrayY_2(i,j)=matGraySporcoAritmetico_invertita(i,j);
            else
                matGrayY_2(i,j)=matGraySporcoAritmetico_invertita(i,j)-matGraySporcoAritmetico_invertita(i+1,j);
            end
        end
    end

    matGrayY_2=double(matGrayY_2);

    for i=1:dimensionerighe          %prende la linea quando passa da bianco a nero --> scandisce da sopra verso sotto  
        for j=1:dimensionecolonne
            if(i==dimensionerighe)
                matGrayY22(i,j)=255;
            else
                if i~=1
                    if(matGrayY_2(i,j)==0) && (matGrayY_2(i-1,j)==0)
                            matGrayY22(i,j)=255; 
                    else
                        if(matGrayY_2(i,j)>=0) && (matGrayY_2(i+1,j)<=0 && matGrayY_2(i-1,j)>0)
                            matGrayY22(i,j)=0;
                        else
                            matGrayY22(i,j)=255;
                        end
                    end
                else
                    matGrayY22(i,j)=255;
                end
            end
        end
    end

    k=7;
    matGrayY22_SPOLVERATA=matGrayY22;
    for i=1:dimensionerighe-k
        for j=1+k:dimensionecolonne-k
            flag=0;
            somma=0;
            if matGrayY22(i,j)==0
                for i1=i:i+k
                    for j1=j-2:j+2
                        flag=flag+1;
                        somma=somma+matGraySporcoAritmetico_invertita(i1,j1);
                    end
                end
                if matGraySporcoAritmetico_invertita(i,j)>(somma/flag)
                     matGrayY22_SPOLVERATA(i,j)=255;
                end
            end
        end
    end


    contatoreY33=0;
    matGrayY33=matGrayY22_SPOLVERATA;
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(matGrayY33(i,j)==0)
                contatoreY33=contatoreY33+1;
            end
        end
    end
    k=6;
    differenzaY33=1;
    while(contatoreY33>conteggio_punti)
        differenzaY33=differenzaY33+1;
        for i=k+1:dimensionerighe-k
            for j=k+1:dimensionecolonne-k
                flag=0;
                if matGrayY22_SPOLVERATA(i,j)==0
                    for ii=i:i+k %-k
                        for jj=j-k:j+k
                            if flag<226
                                if abs(matGrayY_2(ii,jj))>differenzaY33
                                    %matGrayY33(i,j)=0;
                                    flag=flag+1;
                                else
                                    %matGrayY33(i,j)=255;
                                end
                            end
                        end
                    end
                    if(flag>1)
                        matGrayY33(i,j)=0;
                    else
                        matGrayY33(i,j)=255;
                    end
                end
            end
        end

        contatoreY33=0;
        for i=1:dimensionerighe
            for j=1:dimensionecolonne
                if(matGrayY33(i,j)==0)
                    contatoreY33=contatoreY33+1;
                end
            end
        end
    end    
    
    
    
        %binarizzo Y2
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if matGrayY33(i,j)==0
                matGrayY33_binary(i,j)=1;
            else
                matGrayY33_binary(i,j)=0;
            end
        end
    end
    
    matGrayY33_binary=bwmorph(matGrayY33_binary,'skel');
    matGrayY33_end=bwmorph(matGrayY33_binary,'endpoints');
    
    for i=8:dimensionerighe-7
        for j=8:dimensionecolonne-7
            if(matGrayY33_end(i,j)==1) %vuol dire che siamo su un estremo della linea
                flag=0;
                if(matGrayY33_binary(i-1,j+1)==1 || matGrayY33_binary(i,j+1)==1 || matGrayY33_binary(i+1,j+1)==1) %è un punto estremo sinistra -> cerchiamo a sinistra
                    riga=i;
                    colonna=j;
                    while(flag==0)
                        flag=1;
                        if(riga-1>=1 && colonna-1>=1 && riga+1<=dimensionerighe)
                            if(matGrayY22_SPOLVERATA(riga-1,colonna-1)==0) % 0|255|255
                                matGrayY33_binary(riga-1,colonna-1)=1;
                                riga=riga-1;
                                colonna=colonna-1;
                                flag=0;
                            elseif(matGrayY22_SPOLVERATA(riga,colonna-1)==0) % 0|1|0
                                matGrayY33_binary(riga,colonna-1)=1;
                                riga=riga;
                                colonna=colonna-1;
                                flag=0;
                            elseif(matGrayY22_SPOLVERATA(riga+1,colonna-1)==0) % 0|0|1
                                matGrayY33_binary(riga+1,colonna-1)=1;
                                riga=riga+1;
                                colonna=colonna-1;
                                flag=0;
                            end
                        end
                    end
                end
                flag=0;
                if(matGrayY33_binary(i-1,j-1)==1 || matGrayY33_binary(i,j-1)==1 || matGrayY33_binary(i+1,j-1)==1) %è un punto estremo destro
                    riga=i;
                    colonna=j;
                    while(flag==0)
                        flag=1;
                        if(riga-1>=1 && colonna+1<=dimensionecolonne && riga+1<=dimensionerighe)
                            if(matGrayY22_SPOLVERATA(riga-1,colonna+1)==0) % 1|0|0
                                matGrayY33_binary(riga-1,colonna+1)=1;
                                riga=riga-1;
                                colonna=colonna+1;
                                flag=0;
                            elseif(matGrayY22_SPOLVERATA(riga,colonna+1)==0) % 0|1|0
                                matGrayY33_binary(riga,colonna+1)=1;
                                riga=riga;
                                colonna=colonna+1;
                                flag=0;
                            elseif(matGrayY22_SPOLVERATA(riga+1,colonna+1)==0) % 0|0|1
                                matGrayY33_binary(riga+1,colonna+1)=1;
                                riga=riga+1;
                                colonna=colonna+1;
                                flag=0;
                            end
                        end
                    end
                end
            end
        end
     end
    
    

    j=1;
    for i=dimensionerighe:-1:1
        matGrayY33_girata(j,:)=matGrayY33(i,:);
        j=j+1;
    end
    
    j=1;
    for i=dimensionerighe:-1:1
        matGrayY33_binary_girata(j,:)=matGrayY33_binary(i,:);
        j=j+1;
    end




    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(matGrayY3(i,j)+matGrayY33_girata(i,j)==0)
                matGrayYTot(i,j)=0;
            end
            if(matGrayY3(i,j)+matGrayY33_girata(i,j)==255)
                matGrayYTot(i,j)=70;
            end
            if(matGrayY3(i,j)+matGrayY33_girata(i,j)==510)
                matGrayYTot(i,j)=255;
            end
        end
    end

    matGrayY_lines=uint8(matGrayYTot);
    
    matGrayY_lines_allung=matGrayY3_binary+matGrayY33_binary_girata;






    matGrayYTot=double(matGrayYTot);
    matGrayXTot=double(matGrayXTot);

    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(matGrayXTot(i,j)+matGrayYTot(i,j)==0)
                matGrayXY(i,j)=0;
            end
            if(matGrayXTot(i,j)+matGrayYTot(i,j)==70)
                matGrayXY(i,j)=30;
            end
            if(matGrayXTot(i,j)+matGrayYTot(i,j)==140)
                matGrayXY(i,j)=70;
            end
            if(matGrayXTot(i,j)+matGrayYTot(i,j)==255)
                matGrayXY(i,j)=100;
            end
            if(matGrayXTot(i,j)+matGrayYTot(i,j)==325)
                matGrayXY(i,j)=140;
            end
            if(matGrayXTot(i,j)+matGrayYTot(i,j)==510)
                matGrayXY(i,j)=255;
            end
        end
    end

    matGrayXY=uint8(matGrayXY);


    %Binarizzo le linee trovate di X e Y
    matGrayX_binary=matGrayX_lines;
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(matGrayX_lines(i,j)<255)
                matGrayX_binary(i,j)=1;
            else
                matGrayX_binary(i,j)=0;
            end
        end
    end
    matGrayX_binary=mat2gray(matGrayX_binary);

    matGrayY_binary=matGrayY_lines;
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if(matGrayY_lines(i,j)<255)
                matGrayY_binary(i,j)=1;
            else
                matGrayY_binary(i,j)=0;
            end
        end
    end
    matGrayY_binary=mat2gray(matGrayY_binary);

    matGrayXY_binary=matGrayXY;
    for i=1:dimensionerighe
        for j=1:dimensionecolonne
            if matGrayXY(i,j)>220
                matGrayXY_binary(i,j)=0;
            else
                matGrayXY_binary(i,j)=1;
            end
        end
    end
    matGrayXY_binary=mat2gray(matGrayXY_binary);
    
    
    matGrayXY_binary_allung=matGrayY_lines_allung+matGrayX_lines_allung;
    matGrayXY_binary_allung1 = bwmorph(matGrayXY_binary_allung,'close');
    matGrayXY_binary_allung2 = bwmorph(matGrayXY_binary_allung1,'thin',Inf);
%  matGrayXY_binary_allung2=matGrayXY_binary_allung;

    % SE=[ 1 1 1 ; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1];
    % 
    % %binarizzo X2
    % matGrayX2_binary=matGrayX2;
    % for i=1:dimensionerighe
    %     for j=1:dimensionecolonne
    %         if matGrayX2(i,j)==0
    %             matGrayX2_binary(i,j)=1;
    %         else
    %             matGrayX2_binary(i,j)=0;
    %         end
    %     end
    % end
    % for i=1:dimensionerighe
    %     for j=1:dimensionecolonne
    %         if matGrayX3(i,j)==0
    %             matGrayX3_binary(i,j)=1;
    %         else
    %             matGrayX3_binary(i,j)=0;
    %         end
    %     end
    % end
    % %binarizzo X22
    % for i=1:dimensionerighe
    %     for j=1:dimensionecolonne
    %         if matGrayX22(i,j)==0
    %             matGrayX22_binary1(i,j)=1;
    %         else
    %             matGrayX22_binary1(i,j)=0;
    %         end
    %     end
    % end
    % j=1;
    % for i=dimensionecolonne:-1:1
    %     matGrayX22_binary(:,j)=matGrayX22_binary1(:,i);
    %     j=j+1;
    % end
    % for i=1:dimensionerighe
    %     for j=1:dimensionecolonne
    %         if matGrayX33_girata(i,j)==0
    %             matGrayX33_binary(i,j)=1;
    %         else
    %             matGrayX33_binary(i,j)=0;
    %         end
    %     end
    % end
    % %binarizzo Y2
    % for i=1:dimensionerighe
    %     for j=1:dimensionecolonne
    %         if matGrayY2(i,j)==0
    %             matGrayY2_binary(i,j)=1;
    %         else
    %             matGrayY2_binary(i,j)=0;
    %         end
    %     end
    % end
    % %binarizzo Y22
    % for i=1:dimensionerighe
    %     for j=1:dimensionecolonne
    %         if matGrayY22(i,j)==0
    %             matGrayY22_binary1(i,j)=1;
    %         else
    %             matGrayY22_binary1(i,j)=0;
    %         end
    %     end
    % end
    % j=1;
    % for i=dimensionerighe:-1:1
    %     matGrayY22_binary(j,:)=matGrayY22_binary1(i,:);
    %     j=j+1;
    % end

    % matrice_DifferenzaXY=abs(matGrayX2_binary+matGrayX22_binary-matGrayXY_binary);
    matGrayXY_binary = bwmorph(matGrayXY_binary,'close');
    matGrayXY_binary = bwmorph(matGrayXY_binary,'thin',Inf);
    matGrayXY_binary_num=matGrayXY_binary;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    

end