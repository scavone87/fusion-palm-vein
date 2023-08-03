function [fileDat,outputImage] = templateWavelet2(fullPathName)


%APPLICAZIONE FILTRO WAVELET
inputImage=imread(fullPathName);
outputImage = filtroWaveletAdattivo3(inputImage);
%imwrite(outputImage, strcat(nomeUtente,'_1_filtroWavW.jpg'));

% %SMOOTHING
% f = fspecial('average',[3,3]);
% ff = imfilter(outputImage,f);

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
% figure;
%imwrite(tophatFiltered, strcat(nomeUtente,'_3_botHatW.jpg'));
 
%AUMENTO CONTRASTO
%imadjust l'1% dei dati è saturato al max e al minimo dell'intensità
contrastAdjusted = imadjust(tophatFiltered);
%imshow(contrastAdjusted)
%imwrite(contrastAdjusted, strcat(nomeUtente,'_4_aumentoContrastoW.jpg'));

%BINARIZZAZIONE
A=contrastAdjusted;
%prende una regione di pixel di 0.38, e tramite quella trova un valore di
%soglia da usare, ergo la soglia � dinamica
% % A_bw = imbinarize(A,'adaptive','ForegroundPolarity','bright','Sensitivity',0.38); %il bright indica che il foreground e' piu chiaro del background 
%imshow(A_bw);
%imwrite(A_bw, strcat(nomeUtente,'_5_binarizzazioneAdaptive0.38.jpg'));

%istruzioni inserite in sostituzione di imbinarize per motivi di
%retro-compatibilita'
level = graythresh(A);
A_bw = im2bw(A,level);

%CLEANING
% trova, enumera le compomenti connesse, elimina quell meno grandi di .. prima di 150
CC= bwconncomp(A_bw);
S = regionprops(CC, 'Area');
L = labelmatrix(CC);   % prima era 100
BW2 = ismember(L, find([S.Area] >= 500));
%imshow(BW2);
%imwrite(BW2, strcat(nomeUtente,'_6_cleaningW.jpg'));

%CLOSING
se=strel('disk', 8);
passo4=imclose(BW2, se);
%imwrite(passo4, strcat(nomeUtente,'_7_closingW.jpg'));

%FILLING
passo44= imfill(passo4,'holes');
%imwrite(passo44, strcat(nomeUtente,'_8_fillingW.jpg'));

%THINNING
passo5= bwmorph(passo44, 'thin', inf);
%imwrite(passo5, strcat(nomeUtente,'_9_thinningW.jpg'));

%PRUNNING
prun= bwmorph( passo5, 'spur', 21);
%imwrite(prun, strcat(nomeUtente,'_10_prunningW.jpg'));

%CLEANING LINEE PICCOLE
BWz = bwareaopen(prun, 30);
%imshow(BWz);
%imwrite(BWz, strcat(nomeUtente,'_11_lineePiccW.jpg'));

%DILATAZIONE
altro= strel('disk', 6);
fileDat= imdilate( BWz, altro);
%imwrite(nonloso,strcat(nomeUtente,'_12_dilatazioneW.jpg'));
%imshow(nonloso)
%dlmwrite(strcat(nomeUtente,'W.dat'),fileDat);



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