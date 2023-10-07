function render3DView(tresh, filter_siz, M, X, Y, Z, hFig3D)
% render3DView genera una visualizzazione 3D di dati volumetrici

% Parametri di profondità e spessore in mm
depth = 0.2;
thick = 0.2;
trans_flag = 1; % Flag per abilitare/disabilitare la trasparenza

% Calcolo della matrice SURF
SURF = flip(repmat(uint16((0:size(M,1)-1))', [1, size(M,2), size(M,3)]), 1);
% Applica una soglia alla matrice M e a SURF
SURF(M <= tresh) = 0;
% Trova la massima intensità lungo la dimensione z
surf = squeeze(max(SURF));
clear SURF  % Libera memoria

% Filtraggio passa-basso sulla superficie
h = fspecial('average', [filter_siz filter_siz]); % Crea un filtro medio
surf_f = imfilter(surf, h, 'replicate');  % Applica il filtro

% Calcoli per la profondità in termini di indici
depth_ind = round(depth / (Z(2)-Z(1)));
thick_ind = round(thick / (Z(2)-Z(1)));
max_dpth = size(M,1) - 1;
surf_filt = min(surf_f - depth_ind, max_dpth);

% Inizializza matrici di intensità e trasparenza
I = M;
A = M;

% Calcola una matrice di indici di profondità
DPTH_IND = flip(repmat(uint16((0:size(M,1)-1))', [1, size(M,2), size(M,3)]), 1);

% Elaborazione della trasparenza
ramp_dim = 2 * round(thick_ind / 2);
ramp = round((0:ramp_dim) / ramp_dim * 255);  % Crea una rampa per la trasparenza
Q = -ramp_dim/2:1:ramp_dim/2;  % Intervallo di indici per la trasparenza

% Calcola una matrice ripetuta di surf_filt per confronti elemento per elemento
surf_filt_matrix = repmat(reshape(surf_filt, [1, size(surf_filt)]), [size(M,1), 1, 1]);
A((DPTH_IND - ramp_dim/2) > surf_filt_matrix) = 0;
A((DPTH_IND + ramp_dim/2) < surf_filt_matrix) = 255;

% Applica la rampa di trasparenza se trans_flag è 1
if trans_flag == 1
    for i = 1:length(Q)
        A((DPTH_IND + Q(i)) == surf_filt_matrix) = ramp(i);
    end
end

% Visualizzazione 3D
figure(hFig3D);

% Utilizza la funzione vol3dd per creare la visualizzazione 3D
h = vol3dd('cdata', flip(shiftdim(I, 1), 1), 'alpha', flip(shiftdim(A, 1), 1), 'texture', '2D', 'xdata', [0, Y(end)], 'ydata', [0, X(end)], 'zdata', [0, Z(end)]);
colormap(gray(256));
set(gcf, 'Color', 'w');
set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k', 'FontSize', 12, 'XDir', 'reverse', 'YDir', 'reverse', 'ZDir', 'reverse');
axis tight;
xlabel('y [mm]');
ylabel('x [mm]');
zlabel('z [mm]');
end
