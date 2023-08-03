% !!! UNISCE L'IMMAGINE DI PROFONDITA' 0.05 mm CON QUELLA DI PROFONDITA' 0.1 mm !!!

function [im13]=merge12(im1, im2)

%inputImage=imread(strcat(fullpathName,'.jpg'));

im11 = imread(im1); %lettura dell'immagine a profondita'  di 0.05 mm
im12 = imread(im2); %lettura dell'immagine a profondita'  di 0.1 mm

dimensione = size(im11); 
dimensionerighe = dimensione(1);
dimensionecolonne= dimensione(2);

matriceFinale=zeros(dimensionerighe,dimensionecolonne);

im11 = double(im11);
im12 = double(im12);

for i=1:dimensionerighe    
    for j=1:dimensionecolonne
        if(im11(i,j)-im12(i,j)<0)
           matriceFinale(i,j)=im12(i,j);
        else
           matriceFinale(i,j)=im11(i,j);
        end
    end
end
matriceFinale2=uint8(matriceFinale);
im13=matriceFinale2;
