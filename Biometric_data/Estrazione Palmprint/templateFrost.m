function [fileDat,outputImage] = templateFrost(fullPathName)

%filename='alfonsoSimone_1';
%inputImage=imread(strcat(filename,'.jpg'));
inputImage = imread(fullPathName);
%APPLICAZIONE FILTRO FROST
outputImage = fcnFrostFilter(inputImage);
%imwrite(outputImage, strcat(nomeUtente,'_1_frost1F.jpg'));

%NORMALIZZAZIONE
im=outputImage;
minimo=min(im(:));
massimo= max(im(:));
nuovo= (im-minimo)*((255- 70)/ (massimo-minimo))+ 70;
%imshow(nuovo)
%imwrite(nuovo, strcat(nomeUtente,'_2_normaW.jpg'));

%BOTTOM HAT FILTER
% disk 70
se = strel('disk', 70);
tophatFiltered = imbothat(nuovo,se);
%imshow(tophatFiltered)
%imwrite(tophatFiltered, strcat(nomeUtente,'_3_botHatW.jpg'));
 
%AUMENTO CONTRASTO
%imadjust l'1% dei dati e' saturato al max e al minimo dell'intensita'
contrastAdjusted = imadjust(tophatFiltered);
%imshow(contrastAdjusted)
%imwrite(contrastAdjusted, strcat(nomeUtente,'_4_aumentoContrastoW.jpg'));

%BINARIZZAZIONE
A=contrastAdjusted;
threshold = 150;     % prima 150 ok  % uso di solito 180 % bei risultati 160
A_bw = A > threshold;
%imshow(A_bw);
%imwrite(A_bw, strcat(nomeUtente,'_5_binarizzazioneW.jpg'));

%CLEANING
% trova, enumera le compomenti connesse, elimina quell meno grandi di .. prima di 150
CC= bwconncomp(A_bw);
S = regionprops(CC, 'Area');
L = labelmatrix(CC);   % prima era 100
BW2 = ismember(L, find([S.Area] >= 500));
%imshow(BW2);
%imwrite(BW2, strcat(nomeUtente,'_6_cleaningW.jpg'));

%CLOSING
se=strel('disk', 10);
passo4=imclose(BW2, se);
%imwrite(passo4, strcat(nomeUtente,'_7_closingW.jpg'));

%FILLING
passo44= imfill(passo4,'holes');
%imwrite(passo44, strcat(nomeUtente,'_8_fillingW.jpg'));

%THINNING %stringe fino a quando può perchè c'e' inf
passo5= bwmorph(passo44, 'thin', inf);
%imwrite(passo5, strcat(nomeUtente,'_9_thinningW.jpg'));

%PRUNNING %ripete l'operaione 21 volte
prun= bwmorph( passo5, 'spur', 21);
%imwrite(prun, strcat(nomeUtente,'_10_prunningW.jpg'));

%CLEANING LINEE PICCOLE
BWz = bwareaopen(prun, 30);
%imshow(BWz);
%imwrite(BWz, strcat(nomeUtente,'_11_lineePiccW.jpg'));

%DILATAZIONE
altro= strel('disk', 6);
fileDat= imdilate(BWz, altro);
% % % % % disp(filename);
% % % % % stringa =strcat(filename,'.dat'); 
% % % % % dlmwrite(stringa,fileDat);

%imshow(nonloso)
%dlmwrite(strcat(filename,'.dat'),fileDat);



%SOVRAPPOSIZIONE
[m n]= size(inputImage);
 for i=1 : m
    for j=1 : n
        if  BWz(i,j)==1
        inputImage(i,j)=255;
        end 
    end 
 end	 
%imshow(inputImage)

%imwrite(outputImage, strcat(nomeUtente,'_13_FinaleW.jpg'));
