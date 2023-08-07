% Pulizia dell'acqua dagli spot luminosi nei B-scan

% Definizione della forma della struttura per operazioni morfologiche
h = ones(9);
h([1 9],[1:3 7:9]) = 0;
h([1:3 7:9],1) = 0;

% Inizializzazione della matrice logica 3D S
S = ones(dimZ, dimX, dimY, 'logical');

% Inizializzazione della matrice K per lo spessore dell'acqua
K = zeros(dimX, dimY);

% Ciclo su dimY (sezioni orizzontali dell'immagine)
for i = 1:dimY
    disp(i)
    
    % Lettura dei dati dalla variabile DataObj
    Read(DataObj, 'firstPri', dimX*(i-1)+1, 'npri', dimX);
    x = DataObj.LastReadData;
    
    % Elaborazione dei dati acquisiti
    
    % Calcolo del valore assoluto dei dati acquisiti
    x = abs(x);
    
    % Normalizzazione dei dati sulla scala decibel
    x=20*log10(x/max(max(x)));
    
    % Limitazione dei valori a -50 dB
    x(x < -50) = -50;
    
    % Applicazione del filtro mediano bidimensionale per ridurre il rumore
    m = medfilt2(x, [3 2]);
    
    % Erosione dei dati utilizzando la forma h
    e = imerode(m, h);
    
    % Dilatazione dei dati erosi utilizzando la forma h
    d = imdilate(e, h);
    
    % Ciclo su dimX (sezioni verticali dell'immagine)
    for j = 1:dimX
        % Individuazione della profondità k nella colonna corrente
        
        % Trova la prima profondità k in cui il valore supera la soglia di -45 dB
        k = find(d(:, j) > -45, 1);
        
        % Se non viene trovato alcun valore sopra la soglia, viene utilizzata la dimensione Z dell'immagine
        if isempty(k)
            k = dimZ;
        end
        
        % Aggiornamento della matrice S
        S(1:k, j, i) = false;   % Imposta a 0 la regione corrispondente all'acqua
        
        % Calcolo dello spessore dell'acqua nella matrice K
        K(j, i) = dimZ - k;
    end
end