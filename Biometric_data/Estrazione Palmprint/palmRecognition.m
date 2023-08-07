function [dilatedImageDat, rgbImage] = palmRecognition(fullPathName)
    % Caricamento e pre-elaborazione dell'immagine
    I = imread(fullPathName);
    im1 = imresize(I, 0.25, 'bicubic');
    
    % Pre-elaborazione dell'immagine con filtro di riduzione del rumore specifico per immagini ultrasoniche
    denoisedImage = medfilt2(im1, [3, 3]); % Utilizzare un filtro mediano per ridurre il rumore
    
    % Correzione dell'illuminazione o equalizzazione dell'istogramma
    enhancedImage = adapthisteq(denoisedImage); % Equalizzazione dell'istogramma adattiva

    % Filtri avanzati - Filtri di Gabor
    wavelengths = [10, 20]; % Specificare diverse lunghezze d'onda per i filtri di Gabor
    orientations = [0, 45, 90, 135]; % Specificare diverse orientazioni per i filtri di Gabor
    gaborFiltered = zeros(size(enhancedImage));
    for i = 1:length(wavelengths)
        for j = 1:length(orientations)
            lambda = wavelengths(i);
            theta = orientations(j);
            gaborFilter = imgaborfilt(enhancedImage, lambda, theta); % Calcolo delle risposte del filtro di Gabor
            gaborFiltered = gaborFiltered + abs(gaborFilter); % Combinazione delle risposte dei filtri
        end
    end
    
    % Binarizzazione tramite soglia ottenuta tramite Otsu
    threshold = graythresh(gaborFiltered);
    binaryImage = imbinarize(gaborFiltered, threshold);
    
    % Operazioni di pulizia e ottimizzazione dei parametri
    binaryImage = bwareaopen(binaryImage, 30); % Rimozione delle regioni più piccole di una certa dimensione
    se = strel('disk', 1);
    dilatedImageDat = imdilate(binaryImage, se); % Dilatazione dell'immagine per migliorare la connettività delle regioni

    % Creazione dell'immagine RGB
    rgbImage = cat(3, im1, im1, im1);

    % Sovrapposizione delle features sulle regioni dilatate sull'immagine RGB
    [m, n1] = size(im1);
    for i = 1 : m
        for j = 1 : n1
            if dilatedImageDat(i, j) == 1
                rgbImage(i, j, 1) = 255;
                rgbImage(i, j, 2) = 255;
                rgbImage(i, j, 3) = 255;
            end
        end
    end

    % Implementazione di tecniche di apprendimento automatico (da sviluppare separatamente)
    % Utilizzare reti neurali convoluzionali (CNN) o altri algoritmi di apprendimento automatico
    % per rilevare e pulire le features biometriche.

    % Restituzione delle immagini risultanti
    figure;
    imshow(rgbImage);
end
