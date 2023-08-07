function [dilatedImageDat,rgbImage]= DoGfilter(fullPathName,nomeSalv)

tic;
%LETTURA IMMAGINE
I = imread(fullPathName);

%RESIZE DELL'IMMAGINE
im1=imresize(I, 0.25, 'bicubic'); % imposto la grandezza dell'immagine mantenendo le proporzioni
%imshow(im1);title('imresize');figure;

%APPLICAZIONE FILTRO SRAD
rect = [10 15 40 40]; 
[filteredImage] = SRAD(im1,40,1.5,rect);
%imshow(filteredImage);title('srad');figure;

%APPLICAZIONE FILTRO DoG
gaussian1 = fspecial('gaussian',11,15); 
dog1 = conv2(filteredImage,gaussian1,'same');
gaussian2 = fspecial('gaussian',11,20);
dog2 = conv2(filteredImage,gaussian2,'same');
dogFilterImage2 = dog2 - dog1;
%imshow(dogFilterImage2,[]);title('DoGfilter');figure;

%AUMENTO CONTRASTO
contrastAdjusted = imadjust(dogFilterImage2,stretchlim(dogFilterImage2),[]);
%imshow(contrastAdjusted); title('ContrastAdjusted'); figure;
%imwrite(contrastAdjusted,strcat(filename,'_contrastAdj.jpg'));

%BINARIZZAZIONE
A = contrastAdjusted;
meanValue=mean2(A);
threshold = meanValue*1.5; %più è alto il fattore di scala meno dettagli saranno presenti

A_bw = A > threshold;
%imshow(A_bw); title('binarizzazione'); figure;
%imwrite(A_bw, strcat(filename,'_Bin.jpg'));

%CLEANING
CC= bwconncomp(A_bw);
S = regionprops(CC, 'Area');
L = labelmatrix(CC);  
BW2 = ismember(L, find([S.Area] >= 50));
%imshow(BW2); title('cleaning'); figure;
%imwrite(BW2, strcat(filename,'_cleaning.jpg'));

%CLOSING
se=strel('disk',3);
closing=imclose(BW2, se);
%imshow(closing); title('closing'); figure;
%imwrite(closing, strcat(filename,'_closing.jpg'));

%FILLING
filling= imfill(closing,'holes');
%imshow(filling);title('filling');figure;
%imwrite(filling, strcat(filename,'_filling.jpg'));

%THINNING
thinning= bwmorph(filling, 'thin', inf);
%imshow(thinning);title('thinning');figure;
%imwrite(thinning, strcat(filename,'thinning.jpg'));

%PRUNNING
prun= bwmorph( thinning, 'spur', 6);
%imshow(prun);title('prunning');figure;
%imwrite(prun, strcat(filename,'_prunning.jpg'));

%CLEANING LINEE PICCOLE
BWz = bwareaopen(prun, 30);
% imshow(BWz);title('linee piccole - template finale');figure;
%imwrite(BWz, strcat(filename,'_lineePicc.jpg'));

%DILATAZIONE WARING RIMETTERE COME PRIMA DISK 6
dilatation_mask= strel('disk', 1);
dilatedImageDat= imdilate(BWz, dilatation_mask);
%imshow(dilatedImageDat); title('dilatazione'); figure;
%dlmwrite(strcat(filename,'.dat'),dilatedImageDat);
%imwrite(dilatedImageDat,strcat(filename,'_dilatazione.jpg'))

rgbImage = cat(3, im1, im1, im1);
%SOVRAPPOSIZIONE %%WARNING:RIMETTERE COME PRIMA
[m n1]= size(im1);% prima era size(I)
 for i=1 : m
    for j=1 : n1
        if  dilatedImageDat(i,j)==1
        %inputImage(i,j)=255;
        rgbImage(i,j,1)=255;
        rgbImage(i,j,2)=255;
        rgbImage(i,j,3)=255;
        end 
    end 
 end	 

% figure;
% rgbImage=imrotate(rgbImage,90);
% imshow(rgbImage)
nomeSovrapposizione = split(fullPathName, '\');
nomeSovrapposizione = string(nomeSovrapposizione(end-1));
risultati = 'C:\PcLab\Fusion Palm-Vein\Biometric_data\Estrazione Palmprint\risultati\';
folderS = 'template2DsovrappostiDoG';
folderSovrapp = fullfile(risultati, folderS);
if ~exist(folderSovrapp, 'dir')
    disp('La cartella non esiste')
    mkdir(folderSovrapp); 
end
pathSovrapposizione = fullfile(folderSovrapp, '\', nomeSovrapposizione);
if ~exist(pathSovrapposizione, 'dir')
    mkdir(pathSovrapposizione);
end
fig = imshow(rgbImage); 
fileName = strcat(nomeSovrapposizione, '_', num2str(nomeSalv));
name = fullfile(pathSovrapposizione, fileName);
saveas(fig,name,'jpg');
toc;

