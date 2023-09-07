function [A] = binarizzazione(A, tipoBinarizzazione,filtered)
   % if tipoBinarizzazione == 0
   %     %Binarizzazione con media
   %      meanValue=mean2(A);
   %      threshold=meanValue*0.5;
   %      A(A >= threshold) = 255;
   %      A(A < threshold) = 0;
   %   % end
   % else
   %     %Binarizzazion con soglia di Ridler
   %     level = sogliaRidler(A); %tra 0 e 1
   %     thresholdA = level*99;
   %     A(A >= thresholdA) = 255;
   %     A(A < thresholdA) = 0;
   % end
   BW = imbinarize(im2gray(A), 'adaptive', 'Sensitivity', 1.000000, 'ForegroundPolarity', 'bright');
   % Close mask with disk
   radius = 4;
   decomposition = 0;
   se = strel('disk', radius, decomposition);
   A = imclose(BW, se);
end