function [scoreFinale matFinaleB angoloScore rigaScore colonnaScore] = matching(mat1,mat2)

    % MATCHING %
%     mat1=mat1.ans;
%     mat2=mat2.ans;
    
    %DEFINIAMO I TEMPLATE DA CONFRONTARE
    matMatchA = mat1;
    matMatchB = mat2;
    
    %CALCOLO IL DENOMINATORE DELLA FORMULA CHE SERVE PER CALCOLARE IL
    %MATCHING
    %denom = sum(sum(matMatchA))+sum(sum(matMatchB));
    
    %DILATIAMO IL TEMPLATE A
    B = strel('square', 4); %9
    matMatchA = imdilate(matMatchA,B);
    %matMatchB = bwmorph(BW3,'spur',10);

    dimens=size(matMatchA);
    rigaMatchA=dimens(1);
    colonnaMatchA=dimens(2);

%     %AGGIUNGIAMO 8 RIGHE E 8 COLONNE SOPRA, SOTTO, DESTRA E SINISTRA AL
%     %TEMPLATE B
%     matriceGrandeB=matMatchB;
%     matriceGrandeB=[ zeros(8,colonnaMatchA); matriceGrandeB(:,:)]; % righe aggiunte sopra
%     matriceGrandeB=[ matriceGrandeB(:,:); zeros(8,colonnaMatchA)]; % righe aggiunte sotto
%     matriceGrandeB=[ zeros(rigaMatchA+16,8), matriceGrandeB(:,:)]; % colonne aggiunte sinistra
%     matriceGrandeB=[ matriceGrandeB(:,:), zeros(rigaMatchA+16,8)]; % colonne aggiunte destra
    
    
    %AGGIUNGIAMO 50 RIGHE E 50 COLONNE SOPRA, SOTTO, DESTRA E SINISTRA AL
    %TEMPLATE B
    matriceGrandeB=matMatchB;
    matriceGrandeB=[ zeros(25,colonnaMatchA); matriceGrandeB(:,:)]; % righe aggiunte sopra
    matriceGrandeB=[ matriceGrandeB(:,:); zeros(25,colonnaMatchA)]; % righe aggiunte sotto
    matriceGrandeB=[ zeros(rigaMatchA+50,25), matriceGrandeB(:,:)]; % colonne aggiunte sinistra
    matriceGrandeB=[ matriceGrandeB(:,:), zeros(rigaMatchA+50,25)]; % colonne aggiunte destra


    %CONFRONTO IL TEMPLATE A CON QUELLO B, MUOVENDO B IN MODO TALE DA
    %TROVARE IL MASSIMO MATCHING
    matAppoggioTraslata=zeros(rigaMatchA,colonnaMatchA);
    matFinaleB=matMatchB;
    maxScore=0;
    punteggioScore=0;
      
    denom = 1;
    for angle=-5:5
        matMatchARot=imrotate(matMatchA,angle,'bilinear','crop');
        for i=0:50 %(riga+16-riga+1)
            for j=0:50
                matAppoggioTraslata=matriceGrandeB([i+1:rigaMatchA+i],[j+1:colonnaMatchA+j]);
                punteggioScore=sum(sum(matMatchARot & matAppoggioTraslata));
                if(punteggioScore>maxScore)
                    maxScore=punteggioScore;
                    matFinaleB=matAppoggioTraslata;
                    angoloScore=angle;
                    matMatchARotFinale=matMatchARot;
                    denom = sum(sum(mat1))+sum(sum(matFinaleB));
                    rigaScore=i;
                    colonnaScore=j;
                end
            end
        end
    end    

    %CALCOLO IL PUNTEGGIO MASSIMO DEL MATCHING
    scoreFinale=(maxScore/denom)*2;

    
    %VISUALIZZO I TEMPLATE A E B SOVRAPPOSTI
%     B = strel('square', 2);
%     matMatchB = imdilate(matFinaleB,B);    
% 
%     
%     matMatchA=matMatchARotFinale;
%     RGBmatB = cat(3, matMatchB * 1, matMatchB * 1, matMatchB * 0);
%     RGBmatA = cat(3, matMatchA * 1, matMatchA * 1, matMatchA * 1);
%     
% 
%     po=abs(RGBmatA-RGBmatB);
%     for i=1:rigaMatchA
%         for j=1:colonnaMatchA
%             if(po(i,j,3)==1 && po(i,j,2)~=1)
%                 po(i,j,2)=0;
%                 po(i,j,1)=1;
%                 po(i,j,2)=0;
%                 po(i,j,3)=0;
%             end
%         end
%     end
%     
%     figure();
%     imshow(po);
%     
%     figure();
%     imshow(matMatchA&matFinaleB);
end