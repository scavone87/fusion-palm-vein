function [scoreFinale, matriceGrandeB, matFinaleB, matMatchARotFinale, angoloScore, rigaScore, colonnaScore] = matching2D(mat1, mat2)
tic

% DEFINIAMO I TEMPLATE DA CONFRONTARE
matMatchA = mat1;
matMatchB = mat2;

B = strel('disk', 6);
matMatchA = imdilate(matMatchA, B);
dimens = size(matMatchA);
rigaMatchA = dimens(1);
colonnaMatchA = dimens(2);

matriceGrandeB = padarray(matMatchB, [rigaMatchA - 1, 0], 0, 'post'); % Aggiunta di zeri sotto matMatchB
matAppoggioTraslata = zeros(rigaMatchA, colonnaMatchA);
matFinaleB = matMatchB;
maxScore = 0;
punteggioScore = 0;
denom = sum(mat1(:) > 0) + sum(matFinaleB(:) > 0); % Inizializzazione di denom
for i = 0 : 34
    if i + 1 <= size(matriceGrandeB, 2) - colonnaMatchA + 1
        matAppoggioTraslata = matriceGrandeB([1:rigaMatchA], [i + 1:colonnaMatchA + i]);
        punteggioScore = sum(sum(matMatchA & matAppoggioTraslata)); % (A==B & A~=0 & B~=0)
        if punteggioScore >= maxScore
            maxScore = punteggioScore;
            matFinaleB = matAppoggioTraslata;
            matMatchARotFinale = matMatchA;
            denom = sum(mat1(:) > 0) + sum(matFinaleB(:) > 0);
            rigaScore = i;
            colonnaScore = i + 1;
        end
    end
end

scoreFinale = (maxScore / denom) * 2;
toc
end
