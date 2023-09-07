%%%%%%%%%%%procedura che estrarre un pattern venoso 2D
function modaZ =estrazionevenafinale(path_regioni_connesse, path_dati_elaborati,variabile)

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
fileName = d(1).name;
fileBMP = fullfile(path_regioni_connesse, fileName);
M = imread(fileBMP);

% if variabile == false
%     Submatrix = M(108:216, 216:433);
% else
%     Submatrix = M(65:217, 1:510);
% end
Submatrix = M;
Submatrix(Submatrix == 0) = 1;
CCsubmatrix = bwconncomp(Submatrix);
Ssubmatrix = regionprops(CCsubmatrix, 'centroid');
centroidcrop = round(cat(1, Ssubmatrix.Centroid));
centroidcrop(:, 2) = centroidcrop(:, 2) + 120;

CC = bwconncomp(M);
S = regionprops(CC, 'centroid');
centroids = round(cat(1, S.Centroid));

minDist = 20000000;

for k = 1:length(centroids)
    dist = norm(centroidcrop - centroids);
    if dist < minDist
        minDist = dist;
        X(1) = centroids(k, 1);
        Z(1) = centroids(k, 2);
    end
end

if isempty(centroids)
    centroids = centroidcrop;
    X(1) = centroids(1, 1);
    Z(1) = centroids(1, 2);
end

Y(1) = 1;
Xmm(1) = X(1) * 0.0462;
Zmm(1) = Z(1) * 0.0462;
Ymm(1) = Y(1) * 0.1267;
Matvena2D = M;
Matvena3D = M;
Matvena2D(Matvena2D == 1) = 0;
Matvena3D(Matvena3D == 1) = 0;
Matvena2D(1, X(1)) = 1;
Matvena3D(Z(1), X(1)) = 1;
x_cont = zeros(length(d), 1);
z_cont = zeros(length(d), 1);

for i = 2:length(d)
    Y(i) = Y(1) + i - 1;
    Ymm(i) = Y(i) * 0.1267;
    fileName = d(i).name;
    fileBMP = fullfile(path_regioni_connesse, fileName);
    M = imread(fileBMP);
    CCM = bwconncomp(M);
    SM = regionprops(CCM, 'centroid');
    centroids = round(cat(1, SM.Centroid));
    minDist = 20000000;

    for k = 1:size(centroids,1)
        if centroids(k, 2) >= Z(i-1) - 12 && centroids(k, 2) <= Z(i-1) + 12 && ...
                centroids(k, 1) >= X(i-1) - 15 && centroids(k, 1) <= X(i-1) + 15
            dist = norm([X(i-1), Z(i-1)] - centroids(k, :));
            if dist < minDist
                minDist = dist;
                X(i) = centroids(k, 1);
                Z(i) = centroids(k, 2);
            end
        end
    end

    if minDist == 20000000
        X(i) = X(i-1);
        Z(i) = Z(i-1);
    end

    Xmm(i) = X(i) * 0.0462;
    Zmm(i) = Z(i) * 0.0462;
    x_cont(i, 1) = X(i);
    z_cont(i, 1) = Z(i);
    Matvena2D(i, X(i)) = 1;
    Matvena3D(Z(i), X(i), i) = 1;
end
result = zeros(size(Z));
[a, b, c] = size(Matvena3D);

for i = 1:a
    for j = 1:b
        for k = 1:c
            if Matvena3D(i, j, k) == 1
                result(k) = result(k) + 1;
            end
        end
    end
end

[~, modaZ] = max(result);

% Grafico 2D del pattern venoso espresso in millimetri
fileName = fileName(1:end-17);
path_sovr = fullfile(path_dati_elaborati, 'grafici2D');

%figure;
plot(Xmm, Ymm, 'k*');
grid on;
xlim([0 761 * 0.0462]);
ylim([Ymm(1) Ymm(end)]);
xlabel('X-lateral distance [mm]');
ylabel('Y-lateral distance [mm]');
print(fullfile(path_sovr, [fileName, '_2D']), '-dpng');

% Grafico 3D del pattern venoso espresso in millimetri
path_sovr = fullfile(path_dati_elaborati, 'grafici3D');

%figure;
plot3(Xmm, Ymm, Zmm, 'k*');
grid on;
xlim([0 761 * 0.0462]);
ylim([Ymm(1) Ymm(end)]);
zlim([0 271 * 0.0462]);
xlabel('X-lateral distance [mm]');
ylabel('Y-lateral distance [mm]');
zlabel('Z-lateral distance [mm]');
print(fullfile(path_sovr, [fileName, '_3D']), '-dpng');

% Salvataggio TEMPLATE 2D E 3D
FileName2D = [fileName, '.mat'];
PathName2D = fullfile(path_dati_elaborati, 'template2D');
PathName3D = fullfile(path_dati_elaborati, 'template3D');

save(fullfile(PathName2D, FileName2D), 'Matvena2D');
save(fullfile(PathName3D, FileName2D), 'Matvena3D');



end