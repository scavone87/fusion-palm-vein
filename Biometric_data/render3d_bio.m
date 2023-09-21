% BioMetric Data Representation
% Scavone Rocco
%%%%%%%3D RENDERING MODULE%%%%%%%%%

clc 
clearvars -except M X Y Z v fileUOB pixel_length

[fileRisultati, path] = uigetfile('*.mat','Seleziona il file .mat dei risultati');
pathCompleto = fullfile(path, fileRisultati);
load(pathCompleto);

% soglia di intensità per la rilevazione della superficie (0 - 255)
tresh = 64;
filter_siz = 20;

% profondità e spessore (mm)
depth = 0.2;
thick = 0.2;

% flag di trasparenza (0: intensità, 1: lineare rispetto alla profondità)
trans_flag = 1;

% Rilevazione della superficie
% Matrice dell'indice di profondità
SURF = flip(repmat(uint16((0:size(M,1)-1))', [1 size(M,2) size(M,3)]), 1);
SURF(M <= tresh) = 0;
surf = squeeze(max(SURF));
clear SURF

DPTH_IND = flip(repmat(uint16((0:size(M,1)-1))', [1 size(M,2) size(M,3)]), 1);
max_dpth = size(M,1) - 1;

% Filtraggio passa basso e profondità di penetrazione (mm)
% Filtraggio passa basso sulla superficie
h = fspecial('average', [filter_siz filter_siz]);
surf_f = imfilter(surf, h, 'replicate');

depth_ind = round(depth / (Z(2)-Z(1)));
thick_ind = round(thick / (Z(2)-Z(1)));

surf_filt = surf_f - depth_ind;
surf_max = surf_filt - round(thick_ind / 2);
surf_min = surf_filt + round(thick_ind / 2);

surf_filt(surf_filt > max_dpth) = max_dpth;
surf_max(surf_max > max_dpth) = max_dpth;
surf_min(surf_min > max_dpth) = max_dpth;

% Matrice di intensità
I = M;
% Matrice di trasparenza (0 = trasparenza totale, 255 = opacità totale)
A = M;

% Elaborazione della trasparenza
ramp_dim = 2 * round(thick_ind / 2);
ramp = round((0:ramp_dim) / ramp_dim * 255);
Q = -ramp_dim/2:1:ramp_dim/2;

surf_filt_matrix = repmat(reshape(surf_filt, [1 size(surf_filt)]), [size(M,1) 1 1]);

A((DPTH_IND - ramp_dim/2) > surf_filt_matrix) = 0;
A((DPTH_IND + ramp_dim/2) < surf_filt_matrix) = 255;

if trans_flag == 1
  for i = 1:length(Q)
    A((DPTH_IND + Q(i)) == surf_filt_matrix) = ramp(i);
  end
end

% Visualizzazione dei dati ultrasuoni 3D: Plot di intensità
figure
view(310+180, 40);
h = vol3dd('cdata', flip(shiftdim(I, 1), 1),...
           'alpha', flip(shiftdim(A, 1), 1),...
           'texture', '2D',...
           'xdata', [0 Y(end)],...
           'ydata', [0 X(end)],...
           'zdata', [0 Z(end)]);

fprintf("Dimensione x: %.2f [mm]\n", X(end));
fprintf("Dimensione y: %.2f [mm]\n", Y(end));
fprintf("Dimensione z: %.2f [mm]\n", Z(end));

colormap(gray(256))
set(gcf, 'Color', 'w')
set(gca, 'Color', 'w',...
         'XColor', 'k',...
         'YColor', 'k',...
         'ZColor', 'k',...
         'FontSize', 12,...
         'XDir', 'reverse',...
         'YDir', 'reverse',...
         'ZDir', 'reverse')
axis tight;
xlabel('y [mm]');
ylabel('x [mm]');
zlabel('z [mm]');
