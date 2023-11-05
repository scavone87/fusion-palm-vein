function  [dilatedImageDat,rgbImage] = metodoNardiello(fullPathName,nomeSalv, utenteCorrente)

%APPLICAZIONE FILTRO WAVELET
inputImage = imread(fullPathName);
%filename='micheleLigrani_5';
%inputImage=imread(strcat(fullpathName,'.jpg'));
rect = [10 15 40 40]; 

[filteredImage] = SRAD(inputImage,40,0.9,rect);
%outputImage = filtroWavelet(inputImage,30);
%[filteredImage] = fcnFrostFilter(outputImage);


%imshow(filteredImage); title('SradFilter'); figure;
%imwrite(filteredImage, strcat(filename,'_filtroSRAD.jpg'));


%BOTTOM HAT FILTER 4 DIREZIONI
bottomHatFiltered = bottomhat4way(filteredImage);
%imshow(tophatFiltered); title('bottomHat'); figure;
%imwrite(bottomHatFiltered, strcat(filename,'_BotHat.jpg'));
 
%AUMENTO CONTRASTO
contrastAdjusted = imadjust(bottomHatFiltered,stretchlim(bottomHatFiltered),[]);
% imshow(contrastAdjusted); title('ContrastAdjusted'); figure;
%imwrite(contrastAdjusted,strcat(filename,'_contrastAdj.jpg'));



%BINARIZZAZIONE
A = contrastAdjusted;
meanValue=mean2(A);
threshold = meanValue*1.6;   % più è alto il fattore di scala meno dettagli saranno presenti
A_bw = A > threshold;
%imshow(A_bw); title('binarizzazione'); figure;
%imwrite(A_bw, strcat(filename,'_Bin.jpg'));


%CLEANING
CC= bwconncomp(A_bw);
S = regionprops(CC, 'Area');
L = labelmatrix(CC);  
BW2 = ismember(L, find([S.Area] >= 500));
%imshow(BW2); title('cleaning'); figure;
%imwrite(BW2, strcat(filename,'_cleaning.jpg'));

%CLOSING
se=strel('disk', 10);
closing=imclose(BW2, se);
%imshow(closing); title('closing'); figure;
%imwrite(closing, strcat(filename,'_closing.jpg'));


%imwrite(filling, strcat(filename,'_filling.jpg'));
%filling= imfill(closing,'holes');

%THINNING
thinning= bwmorph(closing, 'thin', inf);
%imshow(thinning);title('thinning');figure;
%imwrite(thinning, strcat(filename,'thinning.jpg'));

%PRUNNING
prun= bwmorph( thinning, 'spur', 21);
%imshow(prun);title('prunning');figure;
%imwrite(prun, strcat(filename,'_prunning.jpg'));

%CLEANING LINEE PICCOLE
BWz = bwareaopen(prun, 30);
%imshow(BWz);title('linee piccole');figure;
%imwrite(BWz, strcat(filename,'_lineePicc.jpg'));

%DILATAZIONE WARING RIMETTERE COME PRIMA DISK 6
dilatation_mask= strel('disk', 6);
dilatedImageDat= imdilate(BWz, dilatation_mask);

%imshow(dilatedImageDat); title('dilatazione'); figure;
%dlmwrite(strcat(filename,'.dat'),dilatedImageDat);
%imwrite(dilatedImageDat,strcat(fullpathName,'_dilatazione.jpg'))

rgbImage = cat(3, inputImage, inputImage, inputImage);
%SOVRAPPOSIZIONE %%WARNING:RIMETTERE COME PRIMA
[m n1]= size(A);% prima era size(I)
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

% imshow(rgbImage);title('sovrapposizone'); figure;
nomeSovrapposizione = split(fullPathName, '\');
nomeSovrapposizione = string(nomeSovrapposizione(end-1));
risultati = fullfile(pwd, 'template2D\'); 
folderS = 'template2Dsovrapposti';
folderSovrapp = fullfile(risultati, folderS);
if ~exist(folderSovrapp, 'dir')
    disp('La cartella non esiste')
    mkdir(folderSovrapp); 
end
pathSovrapposizione = fullfile(folderSovrapp, '\', nomeSovrapposizione);
if ~exist(pathSovrapposizione, 'dir')
    mkdir(pathSovrapposizione);
end
fig = figure('Visible', 'off');
imshow(rgbImage); title(utenteCorrente);
fileName = strcat(nomeSovrapposizione, '_', num2str(nomeSalv));
name = fullfile(pathSovrapposizione, fileName);
saveas(fig,name,'jpg');
close(fig);


end