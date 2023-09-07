function [scoreFinale, matFinaleB] = matching3D_mod(mat1, mat2, dilatazioneRaggio, spostamentoPercentuale)
    % matching3D - Effettua il matching tra due immagini 3D utilizzando correlazione incrociata.
    % 
    % Parametri:
    %   - mat1: Il primo template da confrontare (immagine 3D).
    %   - mat2: Il secondo template da confrontare (immagine 3D).
    %   - dilatazioneRaggio: Il raggio per la dilatazione dei template.
    %   - spostamentoPercentuale: La percentuale di spostamento iniziale.
    %
    % Output:
    %   - scoreFinale: Lo score di matching tra i template (compreso tra 0 e 1).
    %   - matFinaleB: Il template finale dopo il matching.
    
    % Dilatazione dei template con un elemento strutturale di raggio specifico
    se = strel('disk', dilatazioneRaggio);

    % Dilatazione dei template
    matMatchA = imdilate(mat1, se);
    matMatchB = imdilate(mat2, se);

    % Calcolo delle dimensioni dei template
    [rigaMatchA, colonnaMatchA, profondita] = size(matMatchA);

    % Trova coordinate dei punti non nulli nei template
    [x1, ~, ~] = find(matMatchA);
    [x2, ~, ~] = find(matMatchB);

    % Calcola il massimo spostamento consentito come percentuale della larghezza
    maxSpostamento = spostamentoPercentuale * colonnaMatchA;

    % Trova il punto iniziale di spostamento per il template B
    diff = x2(1) - x1(1);
    if abs(diff) < maxSpostamento
        b = x2(1);
        a = x1(1);
    elseif diff > 0
        b = x2(1) - maxSpostamento;
        a = x1(1);
    else
        b = x2(1) + maxSpostamento;
        a = x1(1);
    end

    riga = 20;
    % Prealloca la matrice per il confronto finale
    matriceGrandeB = cat(2, matMatchB, zeros(rigaMatchA, riga, profondita));
    matriceGrandeB = cat(2, zeros(rigaMatchA, riga, profondita), matriceGrandeB);
    matriceGrandeB = cat(3, zeros(rigaMatchA, colonnaMatchA + 2 * riga, 0), matriceGrandeB);
    matriceGrandeB = cat(3, matriceGrandeB, zeros(rigaMatchA, colonnaMatchA + 2 * riga, 0));

    % Inizializzazione delle variabili per il punteggio massimo
    matFinaleB = matMatchB;
    maxScore = 0;

    % Confronto tra i template con diverse traslazioni
    for k = 0:2 * riga
        matAppoggioTraslata = matriceGrandeB([b], [k + 1 : colonnaMatchA + k], [1:profondita]);
        punteggioScore = sum(sum(sum(matMatchA([a],:,:) & matAppoggioTraslata)));
        if punteggioScore > maxScore
            maxScore = punteggioScore;
            matFinaleB = matAppoggioTraslata;
        end
    end

    % Calcolo del punteggio finale di matching
    denom = sum(sum(sum(matMatchA(a,:,:)>0)))+sum(sum(sum(matFinaleB>0)));
    scoreFinale = (maxScore / denom) * 2;
end
