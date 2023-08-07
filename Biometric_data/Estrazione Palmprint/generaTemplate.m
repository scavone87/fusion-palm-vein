%%%%%%%%%%%%%% FASI %%%%%%%%%%%%%%
% 1. Normalization
% 2. Negative image
% 3. Top-Hat filter
% 4. Contrast adjustment
% 5. Binarization
% 6. Connected component labeling
% Fasi successive: closing, chiusura buchi, thinning, potatura, elimina corte

function [BWz] = generaTemplate(inputImage, imgFiltrata,fullPathSave,fileName) 
%inputImage -> img di input
%imgFiltrata -> img dopo il filtro di gabor e imresize

% Normalization
minimo = min(imgFiltrata(:));
massimo = max(imgFiltrata(:));
normImg = (imgFiltrata-minimo)*((255-70)/(massimo-minimo)) + 70;

% Negative
negImg = massimo - normImg;

% Top-hat
se = strel('disk', 20);
tophatFiltered = imtophat(negImg,se);
%figure('Name', 'Top-Hat Filtered Image')
%imshow(tophatFiltered)

% Contrast adjustment
imgContrastAdj = imadjust(tophatFiltered);
%figure('Name', 'Image after contrast adjustment')
%imshow(imgContrastAdj)

% Binarization
% figure('Name','Istogramma');
% imhist(inputImage); %istogramma sull'img prima di gabor
[y,x] = imhist(inputImage);
massimoY =max(y);
indice = find(y==massimoY);
threshold = max(x(indice));  %se ci sono pi? valori possibili, prendo il massimo

imgBinar = imgContrastAdj > threshold;
%figure('Name', 'Binarization')
%imshow(imgBinar);

% Componenti connesse
CC= bwconncomp(imgBinar);
S = regionprops(CC, 'Area');
L = labelmatrix(CC);   
BW2 = ismember(L, find([S.Area] >= 70));
% figure('Name', 'Afer connected component labeling')
% imshow(BW2);

%closing
se=strel('disk', 3);
imClosing=imclose(BW2, se);

% chiusura buchi
ChiusuraBuchi= imfill(imClosing,'holes');

% thinning
Thinning= bwmorph(ChiusuraBuchi, 'thin', inf);

% potatura
Potatura= bwmorph( Thinning, 'spur', 10); 

% elimina linee piu corte di...
BWz = bwareaopen(Potatura, 20);
% figure('Name', 'Final');
% imshow(BWz);

% sovrapposizione
%outputImage = imgFiltrata;
%outputImage(BWz==1)=255;
% figure('Name', 'Sovrapposizione');
% imshow(outputImage)

% disp(fullPathSave);
Name = fullfile(fullPathSave, fileName);
%imwrite(BWz, Name, 'jpg'); %salvo i template (BWz)

% salva template in .dat
% fileDat = strcat(fileName,'.dat');
% dlmwrite(fileDat,BWz)

end

