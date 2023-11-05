function score = matching3D(R, Q, alpha)
    % R e Q sono le due matrici (template) da confrontare.
    % OR e OQ rappresentano le trasformazioni o caratteristiche di R e Q.
    % alpha è la soglia per la differenza tra OR e OQ.
    if size(R) ~= size(Q)
        error('Le dimensioni di mat1 e mat2 devono essere uguali per un confronto diretto.');
    end
    OR = R;
    OQ = Q;

    % Calcolo il numero totale di punti attivi in R e Q.
    MR = sum(sum(R > 0));
    MQ = sum(sum(Q > 0));

    % Calcolo la somiglianza basata sulla corrispondenza binaria e sulla differenza tra OR e OQ.
    binaryMatch = R & Q; % corrispondenza binaria
    valueDifference = abs(OR - OQ) < alpha; % verifica la differenza tra i valori
    combinedMatch = binaryMatch .* valueDifference; % combina le due verifiche

    % Calcola il punteggio finale.
    score = (2 * sum(sum(combinedMatch))) / (MR + MQ);
end



