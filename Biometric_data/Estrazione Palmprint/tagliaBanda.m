function [ tresholded_subBand ] = tagliaBanda(subBand,sigma)


%Matrice dei pesi
 W=[0.25 0.35 0.55 0.35 0.25; 
     0.3 0.4 0.6 0.4 0.3; 
     0.45 0.5 0.1 0.5 0.45; 
     0.3 0.4 0.6 0.4 0.3; 
     0.25 0.35 0.55 0.35 0.25];


%Calcolo delta e creazione matrice dei threshold lambda
sz=5;
mn=floor(sz/2);
delta = zeros(size(subBand));
subBandPadded = padarray(subBand,[mn,mn]);
sommaPesi = sum(W(:));

for i=1:size(subBandPadded,1)-mn*2
    for j=1:size(subBandPadded,2)-mn*2
        tmp = subBandPadded(i:i+(sz-1),j:j+(sz-1)); %finestra scorrevole
        molt = (tmp.^2) .* W; %moltiplicazione vicinato coefficiente per finestra pesi
        delta(i,j)=sum(molt(:))./sommaPesi; %genero il coefficiente pesato
    end
end


lambda = sigma./delta;


tresholded_subBand = zeros(size(delta));

for i=1:size(delta,1)
    for j=1:size(delta,2)
        if subBand(i,j)>=lambda(i,j)
            tresholded_subBand(i,j)= delta(i,j);
        end
        if subBand(i,j)<lambda(i,j)
            tresholded_subBand(i,j)=0;
        end
    end
end


% for i=1:size(delta,1)
%     for j=1:size(delta,2)
%         tresholded_subBand = wthresh(subBand(i,j),'s',lambda(i,j));
%     end
% end




end

