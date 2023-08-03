function [BWz, merge] = metodo_estrazione_linee(immagine)

directions = [0 45 90 135];
dimDirectionalMatrix = 3;

% Caricamento dell'immagine di input
A = imread(immagine);
A=imrotate(A,90);
A=flip(A,2);

% Aumento del contrasto
A = imadjust(A);

% Ridimensioniamo l'immagine
Aresize=imresize(A, [128 128], 'bicubic'); 
clear A;
A=imresize(Aresize, 1.7 ,'bicubic'); % la dimensione diventa [x*1.7 y*1.7]

% Applicazione del filtro di Frost
A = fcnFrostFilter(A);

% Aumentiamo nuovamente il contrasto
A = imadjust(A); % se il pixel è vicino a 0 lo porta ancora più vicino a 0. Lo stesso per l'1

% Normalizzazione dell'immagine precedente
% I pixel dell'immagine sono divisi per il massimo valore assunto dai pixel
Anorm = mat2gray(A); % mette tutti i valori tra 0 e 1


% Clonazione dell'immagine normalizzata in quattro copie
images(:,:,1) = Anorm; %Img0
images(:,:,2) = Anorm; %Img45
images(:,:,3) = Anorm; %Img90
images(:,:,4) = Anorm; %Img135

% Applicazione del filtro mediano solo per l'immagine che evidenzierà le linee 
% nella direzione di 0° (Img0)
images(:,:,1) = medfilt2(images(:,:,1), [3 3]); %di default è 3x3 la finestra

% Filtraggio con operazione di convoluzione di ogni immagine per un elemento struttante
% generato con la funzione generaMatriceDirezionale
% Le immagini C1, C2, C3, C4 rappresentano le quattro immagini, ognuna delle quali è 
% deputata ad evidenziare le linee in una determinata direzione (C1 a 0°, C2 a 45°,
% C3 a 90° e C4 a 135°
F = generaMatriceDirezionale(0, 5);
C1 = conv2(images(:,:,1), F, 'same');

F = generaMatriceDirezionale(45, 5);
C2 = conv2(images(:,:,2), F, 'same');

F = generaMatriceDirezionale(90, 5);
C3 = conv2(images(:,:,3), F, 'same');

F = generaMatriceDirezionale(135, 5);
C4 = conv2(images(:,:,4), F, 'same');


% Definizione dell'elemento strutturante di tipo disco
% utilizzato per l'operazione di bottom-hat
n=5;
SE = strel('disk',n,8); %definizione dell'elemento strutturante circolare
%nhood = getnhood(SE); 
%imagesc(nhood);

% Operazione di bottom-hat; dopo ogni operazione di bottom-hat eseguiamo subito 
% un'operazione di filtraggio e di ritaglio dei bordi per ripulire le immagini
IM1 = imbothat(C1, SE);
M = mean(mean(IM1));
k = 3;
threashold = k*M;
IM1(IM1<=threashold) = 0;
IM1 = IM1(n : end - n , n : end - n);

IM2 = imbothat(C2, SE);
M = mean(mean(IM2));
k = 3;
threashold = k*M;
IM2(IM2<=threashold) = 0;
IM2 = IM2(n : end - n , n : end - n);

IM3 = imbothat(C3, SE);
M = mean(mean(IM3));
k = 3;
threashold = k*M;
IM3(IM3<=threashold) = 0;
IM3 = IM3(n : end - n , n : end - n);

IM4 = imbothat(C4, SE);
M = mean(mean(IM4));
k = 3;
threashold = k*M;
IM4(IM4<=threashold) = 0;
IM4 = IM4(n : end - n , n : end - n);

% Combinazione delle immagini ottenute al passo precedente
IMG = IM1+IM2+IM3+IM4;

% Riduzione del rumore
M = mean(mean(IMG));
k = 3;
threashold = k*M;
IMG(IMG<=threashold) = 0;

% Normalizzazione
IMGnorm = mat2gray(IMG);

% Binarizzazione
Mprimo = mean(mean(IMGnorm));
IMGnorm(IMGnorm<=Mprimo) = 0;
IMGnorm(IMG>Mprimo) = 1;

% Operazioni morfologiche
% closing
se=strel('disk', 5); 
imClosing=imclose(IMGnorm, se);

% trova, enumera le compomenti connesse
CC= bwconncomp(imClosing);
S = regionprops(CC, 'Area'); %calcola l'area di ogni componente connessa
%labelmatrix è più efficiente bwlabel e di bwlabeln perchè ritorna  
%la corrispondente label matrix nella classe numerica più piccola necessaria 
%per il numero di oggetti
L = labelmatrix(CC);   
%crea un'immagine binaria contenente solo le regioni connesse con area
%maggiore di 50
BW2 = ismember(L, find([S.Area] >= 50)); 

% chiusura buchi
ChiusuraBuchi= imfill(imClosing,'holes');

% thinning
Thinning= bwmorph(ChiusuraBuchi, 'thin', inf);

% elimina linee piu corte di...
BWz = bwareaopen(Thinning, 15); %rimuove le componenti connesse che contengono meno di 15 pixel

% Sovrapposizione del template con immagine di partenza
templateUnint8 = im2uint8(BWz); %conversione dell'immagine in interi a 8-bit
A = A(n : end - n, n : end - n);
merge = A+templateUnint8;
save('pergola.dat','BWz');
end