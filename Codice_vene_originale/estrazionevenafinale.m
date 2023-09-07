%%%%%%%%%%%procedura che estrarre un pattern venoso 2D
function modaZ =estrazionevenafinale(path_regioni_connesse, path_dati_elaborati,variabile)

X=[];
Z=[];
Xmm=[];
Zmm=[];
Y=[];

% impostare percorso della cartellla contenente le 461 immaginidelle regioni connesse 

d = dir(path_regioni_connesse);
d(1:2)=[];
fileName = d(1).name;
fileBMP = strcat(path_regioni_connesse,fileName);
M = imread(fileBMP); %leggo la prima immagine e estraggo la sottomatrice
if variabile == false
    Submatrix=M(130:238,1:397);%sottomatrice da 6 mm a 11 mm sull'asse della profondit� 
                             %e da 0 mm a 18 mm sull'asse x  
else
    Submatrix=M(130:238,1:510);
end
%imshow(Submatrix);
Submatrix(Submatrix==0)=1;  % imposto tutti i pixel a 1 in modo tale da trovare il centroide della sottomatrice
CCsubmatrix= bwconncomp(Submatrix);
Ssubmatrix = regionprops(CCsubmatrix, 'centroid');  %calcolo il cetroide della sottomatrice
centroidcrop = cat(1, Ssubmatrix.Centroid);
centroidcrop=round(centroidcrop); %arrotondo i valori del centroide per trovare le celle corrispondenti                                          
                                  %della sottomatrice
centroidcrop(:,2) = centroidcrop(:,2)+120;  %calcolo le coordinate equivalenti della matrice
%centroidccrop(1,1)=297;
 CC= bwconncomp(M);
S = regionprops(CC, 'centroid');
centroids = cat(1, S.Centroid);
centroids=round(centroids);
%trovo il centroide piu vicino al punto medio della sottomatrice
minimo=20000000;
if length(centroids)~=0
    for k=1 : length(centroids(:,end))
        distanzaEuclidea = sqrt((centroidcrop(1,1)-centroids(k,1)).^2 +(centroidcrop(1,2)-centroids(k,2)).^2);
        if(distanzaEuclidea < minimo)
            minimo=distanzaEuclidea;  
            X(1)=centroids(k,1);
            Z(1)=centroids(k,2);
        end
        
    end
else
    centroids=centroidcrop;
    X(1)=centroids(1,1);
    Z(1)=centroids(1,2);
end
Y(1)=200;
Xmm(1)=X(1)*0.0462;
Zmm(1)=Z(1)*0.0462;
Ymm(1)=Y(1)*0.0462;
Matvena2D=M;
Matvena3D=M;
Matvena2D(Matvena2D==1)=0;
Matvena3D(Matvena3D==1)=0;
Matvena2D(1,X(1))=1;
Matvena3D(Z(1),X(1))=1;
x_cont=zeros(length(d),1);
Z_cont=zeros(length(d),1);
for i=2 : length(d)
    Y(i)=Y(1)+i-1;
    Ymm(i)=Y(i)*0.0462;
    fileName = d(i).name;
    fileBMP = strcat(path_regioni_connesse,fileName);
    M = imread(fileBMP);
    CCM= bwconncomp(M);
    SM = regionprops(CCM, 'centroid');
    centroids = cat(1, SM.Centroid);
    centroids=round(centroids);
    %---
    %per ogni immagine trovo il centroide pi� vicino al centroide
    %precedente
    minimo=20000000;
    %hold on
    if length(centroids)~=0       
        k=1;
        while (k <= length(centroids(:,1)))
            if centroids(k,2)>=Z(i-1)-12 && centroids(k,2)<=Z(i-1)+12 && centroids(k,1)>=X(i-1)-15 && centroids(k,1)<=X(i-1)+15    
              distanzaEuclidea = sqrt((X(i-1)-centroids(k,1)).^2 +(Z(i-1)-centroids(k,2)).^2);
              if(distanzaEuclidea < minimo)
                    minimo=distanzaEuclidea;               
                    X(i)=centroids(k,1);
                    Z(i)=centroids(k,2);                   
              end
          end
              k=k+1;
        end
   
       if minimo==20000000
            X(i)=X(i-1);
            Z(i)=Z(i-1);
       end
    else
        %continue
        X(i)=X(i-1);
        Z(i)=Z(i-1);
    end
    Xmm(i)=X(i)*0.0462;
    Zmm(i)=Z(i)*0.0462;
    x_cont(i,1)=X(i);
    z_cont(i,1)=Z(i);
    Matvena2D(i,X(i))=1;
    Matvena3D(Z(i),X(i),i)=1;
    vena3D(Z(i),X(i),i)=1;
end
result = zeros(size(Z));
[a,b,c] = size(vena3D);
for i =10:a
    for j=1:b
        for k=1:c
            if(vena3D(i,j,k)==1)
                result(i) = result(i)+1;
            end
        end
    end
end
[~, modaZ] = max(result);
%%% grafico 2D del pattern venoso espresso in millimetri
path_sovr = strcat(path_dati_elaborati, 'grafici2D/');
cd(path_sovr)


figure;
plot(Xmm,Ymm,'k*');
grid on;
xlim([0 542*0.0462]);
ylim([Ymm(1) Ymm(end)]);
%zlim([0 238*0.0462]);
xlabel('X-lateral distance [mm]');
ylabel('Y-lateral distance [mm]');
%zlabel('Z-lateral distance [mm]');
print(fileName,'-dpng')
%%% grafico 3D del pattern venoso espresso in millimetri

 path_sovr = strcat(path_dati_elaborati, 'grafici3D/');
 cd(path_sovr)

figure;
plot3(Xmm,Ymm,Zmm,'k*');
grid on;
xlim([0 542*0.0462]);
ylim([Ymm(1) Ymm(end)]);
zlim([0 238*0.0462]);
xlabel('X-lateral distance [mm]');
ylabel('Y-lateral distance [mm]');
zlabel('Z-lateral distance [mm]');

print(fileName,'-dpng')
path_sovr = strcat(path_dati_elaborati, 'grafici3D/');
 cd(path_sovr)
% figure(3);
 Matvena2D=flip(Matvena2D); %capovolgo la matrice
% %senza flip ottengo il pattern venoso come su sovrapposizione  sul grafico
% imshow(Matvena2D);



% SALVATAGGIO TEMPLATE 2D E 3D

fileName(end-16:end)=[];
FileName2D = strcat(fileName,'.mat');
PathName2D = strcat(path_dati_elaborati ,'template2D/');
PathName3D = strcat(path_dati_elaborati ,'template3D/');

save(strcat(PathName2D,FileName2D), 'Matvena2D');
save(strcat(PathName3D,FileName2D), 'Matvena3D');


end