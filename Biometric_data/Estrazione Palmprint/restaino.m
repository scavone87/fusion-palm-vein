function restaino(i)
I=imread(fullPathName); %input
width = size(I,1);
height = size(I,2);
        
for n = 1:4
    g9(:,:,n)=gabor2D(w(n)/(width/9),theta(n),sigma(n),dim(n),type);
end
        
imgGaborFilter=imfilter(I,g9,'circular');  %meglio di 'symmetric'
im1=imresize(imgGaborFilter, [round(width/4) round(height/4)], 'bicubic'); % imposto la grandezza dell'immagine -> round di (size/4)
im2=imresize(im1, 1.8 ,'bicubic'); 
generaTemplate(I,im2,fullPathSave,filesJpg(i).name);