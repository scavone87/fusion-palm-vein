%%%%%%%%%%%procedura che estrarre un pattern venoso 2D
function [] =estrazionevena(path_regioni_connesse, path_dati_elaborati,variabile)

X = [];
Z = [];
Y = [];
Xmm = [];
Zmm = [];
Ymm = [];
Matvena2D = [];
Matvena3D = [];

d = dir(path_regioni_connesse);
d(1:2) = [];

% Leggi la prima immagine
% fileName = d(1).name;
% fileBMP = fullfile(path_regioni_connesse, fileName);
% M = imread(fileBMP);

% Creazione dell'immagine template
% template_image = zeros(size(M, 1), size(M, 2));

% Xmm(1) = X(1) * 0.0462;
% Zmm(1) = Z(1) * 0.0462;
% Ymm(1) = Y(1) * 0.1267;
% Matvena2D = M;
% Matvena3D = M;
% Matvena2D(Matvena2D == 1) = 0;
% Matvena3D(Matvena3D == 1) = 0;
% Matvena2D(1, X(1)) = 1;
% Matvena3D(Z(1), X(1)) = 1;
% x_cont = zeros(length(d), 1);
% z_cont = zeros(length(d), 1);
Y = [1:1:300];
Ymm(1) = Y(1) * 0.1267;
% Creazione di un'immagine vuota delle stesse dimensioni dell'immagine originale
% outputImage = zeros(round(835*0.0462),round(300*0.1267));
outputImage = zeros(835,300);

for i = 1:size(d,1)
    Ymm(i) = Y(i) * 0.1267;
    fileName = d(i).name;
    fileBMP = fullfile(path_regioni_connesse, fileName);
    M = imread(fileBMP);
    % Estrai le caratteristiche dalle vene segmentate
    vein_properties = regionprops(M, 'Area', 'Perimeter', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Centroid', 'BoundingBox');

    % Inizializza vettori per le caratteristiche
    vein_lengths = [];
    vein_widths = [];
    vein_shapes = [];
    vein_dispositions = [];

    for j = 1:numel(vein_properties)

        centroid = vein_properties(j).Centroid;
        % x = ceil(centroid(1)*0.0462); % Coordinata x del centroide
        % y = ceil(Y(i)*0.1267); % Coordinata y fissa come specificato
        x = ceil(centroid(1)); % Coordinata x del centroide
        y = ceil(Y(i)); % Coordinata y fissa come specificato
        % Disegna il pixel nelle coordinate specificate
        outputImage(x, y) = 255; % Imposta il valore del pixel a bianco (255)
          
    end

end
% BW = outputImage(:, 150*0.1267:0.1267:250*0.1267);
BW = outputImage;
% CC = bwconncomp(outputImage);
% S = regionprops(CC, 'Area');
% L = labelmatrix(CC);
% BW = ismember(L, find([S.Area] < 50 & [S.Area] > 22));
% BW = BW(:, 150*0.1267:0.1267:250*0.1267);
imshow(BW);
fprintf('Size: %f - %f\n', size(BW, 1), size(BW, 2))
path_sovr = fullfile(path_dati_elaborati, 'grafici2D');
savePathGrafico = fullfile(path_sovr, [fileName(1:end-4), '_2D']);
print(savePathGrafico, '-dpng');
fileName = fileName(1:end-17);
FileName2D = [fileName, '.mat'];
PathName2D = fullfile(path_dati_elaborati, 'template2D');
% save(fullfile(PathName2D, FileName2D), 'Matvena2D');
dlmwrite(fullfile(PathName2D, FileName2D), BW);


% % Grafico 2D del pattern venoso espresso in millimetri
% path_sovr = fullfile(path_dati_elaborati, 'grafici2D');
% 
% figure;
% plot(Xmm, Ymm, 'k*');
% grid on;
% xlim([0 761 * 0.0462]);
% ylim([Ymm(1) Ymm(end)]);
% xlabel('X-lateral distance [mm]');
% ylabel('Y-lateral distance [mm]');
% print(fullfile(path_sovr, [fileName(1:end-4), '_2D']), '-dpng');
% 
% % Grafico 3D del pattern venoso espresso in millimetri
% path_sovr = fullfile(path_dati_elaborati, 'grafici3D');
% 
% figure;
% plot3(Xmm, Ymm, Zmm, 'k*');
% grid on;
% xlim([0 761 * 0.0462]);
% ylim([Ymm(1) Ymm(end)]);
% zlim([0 271 * 0.0462]);
% xlabel('X-lateral distance [mm]');
% ylabel('Y-lateral distance [mm]');
% zlabel('Z-lateral distance [mm]');
% print(fullfile(path_sovr, [fileName(1:end-4), '_3D']), '-dpng');
% 
% % Salvataggio TEMPLATE 2D E 3D
% fileName = fileName(1:end-17);
% FileName2D = [fileName, '.mat'];
% PathName2D = fullfile(path_dati_elaborati, 'template2D');
% PathName3D = fullfile(path_dati_elaborati, 'template3D');
% 
% save(fullfile(PathName2D, FileName2D), 'Matvena2D');
% save(fullfile(PathName3D, FileName2D), 'Matvena3D');



end