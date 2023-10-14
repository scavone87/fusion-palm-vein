function score = matching2D(R, Q)
    % Calcola il numero totale di valori non zero nelle matrici R e Q
    MR = sum(sum(R > 0));
    MQ = sum(sum(Q > 0));
    
    % Calcola il numero di corrispondenze (posizioni in cui entrambe le matrici hanno valori non zero)
    matching = sum(sum((R > 0) & (Q > 0)));
    
    % Calcola la misura di similarità
    score = (2 * matching) / (MR + MQ);
end
