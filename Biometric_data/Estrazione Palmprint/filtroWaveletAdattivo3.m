function [denoised_norm] = filtroWaveletAdattivo3(inputImage) 



%inputImage=imread('alfonsoSimone_1.jpg');
inputImageL=log(double(inputImage));
inputImage = uint8(inputImageL);

L=2;
wname = 'db4'; %nome dello specifico filtro di wavelet da utilizzare
[C,S] = wavedec2(inputImage,L,wname); 

for i = 1:L
    [H{i},V{i},D{i}] = detcoef2('all',C,S,i); 
end

%noise variance
sigma = (median(abs(H{1}(:)))/0.6745)^2;
%Threshold 3 details subbands in each scale
for i = 1:L
    T_H{i} = tagliaBanda(H{i},sigma);
    T_V{i} = tagliaBanda(V{i},sigma);
    T_D{i} = tagliaBanda(D{i},sigma);
end

%% Regroup the thresholded subbands to Matlab C and S structure
t_C = C; 
tail = S(1,1)*S(1,2); % the number of approximation coefficients
for i = 1:L
    
    % The number of coefficients in decomposition level i
    num = S(i+1,1)*S(i+1,2);
    
    % Horizontal sbbband in decomposition level i
    head = tail+1;
    tail = head+num-1;
    t_C(head:tail) = T_H{L-i+1}(:);
    
    % Vertical sbbband in decomposition level i
    head = tail+1;
    tail = head+num-1;
    t_C(head:tail) = T_V{L-i+1}(:);
    
    % Diagonal sbbband in decomposition level i
    head = tail+1;
    tail = head+num-1;
    t_C(head:tail) = T_D{L-i+1}(:);
    
end

%% Reconstruct the denoised image
denoised_norm = waverec2(t_C, S, wname);
% ----
% imagesc(denoised_norm);colormap(gray);figure;
%denoised = denoised_norm*sigma;
%imagesc(denoised);colormap(gray);


%imshow(uint8(exp(denoised_norm)));
        

%figure,imagesc(denoised_norm);colormap(gray);
%figure,imagesc(uint8(denoised_norm));colormap(gray);
%figure,imshow(uint8(denoised_norm))
% figure,imagesc(delta);colormap(gray);













% V1img = wcodemat(V1,255,'mat',1);
% H1img = wcodemat(H1,255,'mat',1);
% D1img = wcodemat(D1,255,'mat',1);
% A1img = wcodemat(A1,255,'mat',1);
% 
% subplot(2,2,1);
% imagesc(A1img);
% colormap pink(255);
% title('Approximation Coef. of Level 1');
% 
% subplot(2,2,2);
% imagesc(H1img);
% title('Horizontal detail Coef. of Level 1');
% 
% subplot(2,2,3);
% imagesc(V1img);
% title('Vertical detail Coef. of Level 1');
% subplot(2,2,4);
% imagesc(D1img);
% title('Diagonal detail Coef. of Level 1');

%end

