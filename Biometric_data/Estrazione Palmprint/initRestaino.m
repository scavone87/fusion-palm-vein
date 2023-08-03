function [I, im2] = initRestaino(immagineDaElaborare)
                w=[0.3666 0.3666 0.3666 0.3666 0.1833 0.1833 0.1833 0.1833 0.0916 0.0916 0.0916 0.0916];
                theta=[0 45 90 135 0 45 90 135 0 45 90 135];
                sigma=[1.4045 1.4045 1.4045 1.4045 2.8090 2.8090 2.8090 2.8090 5.6179 5.6179 5.6179 5.6179];
                dim=[9 9 9 9 17 17 17 17 35 35 35 35];
                type = 'even'; %reale

                I=imread(immagineDaElaborare); %input
                width = size(I,1);
                height = size(I,2);

                for n = 1:4
                    g9(:,:,n)=gabor2D(w(n)/(width/9),theta(n),sigma(n),dim(n),type);
                end

                imgGaborFilter=imfilter(I,g9,'circular');  %meglio di 'symmetric'
                im1=imresize(imgGaborFilter, [round(width/4) round(height/4)], 'bicubic'); % imposto la grandezza dell'immagine -> round di (size/4)
                im2=imresize(im1, 1.8 ,'bicubic'); 

end