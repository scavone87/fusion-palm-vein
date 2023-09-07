function [scoreFinale, matriceGrandeB, matFinaleB, matMatchARotFinale, angoloScore, rigaScore, colonnaScore] = matching2D(mat1,mat2)
    tic

    %DEFINIAMO I TEMPLATE DA CONFRONTARE
    matMatchA = mat1;
    matMatchB = mat2;

    B = strel('disk', 6);    
    matMatchA = imdilate(matMatchA,B); 
    dimens=size(matMatchA);
    rigaMatchA=dimens(1);
    colonnaMatchA=dimens(2);

    matAppoggioTraslata=zeros(rigaMatchA,colonnaMatchA);
    matFinaleB=matMatchB;
    maxScore=0;
    punteggioScore=0;
    for i=0:34
        matAppoggioTraslata=matriceGrandeB([1:rigaMatchA],[i+1:colonnaMatchA+i]);
        punteggioScore=sum(sum(matMatchA & matAppoggioTraslata)); %(A==B & A~=0 & B~=0)
        if(punteggioScore>=maxScore)
            maxScore=punteggioScore;
            matFinaleB=matAppoggioTraslata;
            matMatchARotFinale=matMatchA;
            denom = sum(sum(mat1>0))+sum(sum(matFinaleB>0));
            rigaScore=i;
        end
    end
    scoreFinale=(maxScore/denom)*2;
toc
end