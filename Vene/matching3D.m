function [scoreFinale, matriceGrandeB, matFinaleB] = matching3D(mat1,mat2)

    %DEFINIAMO I TEMPLATE DA CONFRONTARE

    matMatchA = mat1;
    matMatchB = mat2;

    % dilato entrambi i templati con disk di raggio 30
    se=strel('disk',10);

    dimens=size(matMatchA);
    profondita=dimens(3);
    colonnaMatchA=dimens(2);
    rigaMatchA=dimens(1);

    [x1,y1,z1]=find(matMatchA(:,:,:));
    [x2,y2,z2]=find(matMatchB(:,:,:));    
    diff=max(abs(x2(2:end)-x1(2:end)));
    a = 0;
    b = 0;
    
    % percentualeSpostamento rappresenta la percentuale della larghezza dell'immagine (colonnaMatchA) 
    % che vuoi utilizzare come spostamento iniziale tra i due template
    percentualeSpostamento = 10;
    if diff < percentualeSpostamento * colonnaMatchA
       b=x2(2);
       a=x1(2);
    elseif x2(2) > x1(2)
       b=x2(2)-percentualeSpostamento * colonnaMatchA;
       a=x1(2);
    elseif x2(2) < x1(2)
        b=x2(2)+percentualeSpostamento * colonnaMatchA;
       a=x1(2);
    end
     riga=20;
     matMatchA=imdilate(matMatchA,se);
     matMatchB=imdilate(matMatchB,se);

    matriceGrandeB=matMatchB;
    matriceGrandeB=cat(2,matriceGrandeB,zeros(rigaMatchA,riga,profondita)); % colonne aggiunte destra
    matriceGrandeB=cat(2,zeros(rigaMatchA,riga,profondita),matriceGrandeB); % colonne aggiunte sinistra
    matriceGrandeB=cat(3,zeros(rigaMatchA, colonnaMatchA+2*riga,0),matriceGrandeB); % profondita aggiunta davanti
    matriceGrandeB=cat(3,matriceGrandeB,zeros(rigaMatchA,colonnaMatchA+2*riga,0)); % profondita aggiunta dietro

    %CONFRONTO IL TEMPLATE A CON QUELLO B, MUOVENDO B NELLE TRE DIREZIONI IN MODO TALE DA
    %TROVARE IL MASSIMO MATCHING
    matFinaleB=matMatchB;
    maxScore=0;
    tic
    for k =0:2*riga
        matAppoggioTraslata=matriceGrandeB([b],[k+1:colonnaMatchA+k],[1:profondita]);
        punteggioScore = sum(sum(sum(matMatchA([a],:,:) & matAppoggioTraslata)));
        if(punteggioScore>maxScore)
            maxScore=punteggioScore;
            matFinaleB=matAppoggioTraslata;
        end
    end
    denom = sum(sum(sum(matMatchA(a,:,:)>0)))+sum(sum(sum(matFinaleB>0)));

    %CALCOLO IL PUNTEGGIO MASSIMO DEL MATCHING
    scoreFinale=(maxScore/denom)*2;

    toc

end

