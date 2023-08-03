% Intensity treshold for surface detection (0 - 255)
tresh=str2double(get(tresh_h,'String'));
% Surface detection
% Depth index matrix
SURF=flipdim(repmat(uint16((0:size(M,1)-1))',[1 size(M,2) size(M,3)]),1);
SURF(M<=tresh)=0;
surf=squeeze(max(SURF));
clear SURF
DPTH_IND=flipdim(repmat(uint16((0:size(M,1)-1))',[1 size(M,2) size(M,3)]),1);
max_dpth=size(M,1)-1;

% Averaging and penetration depth (mm)
filter_siz=str2double(get(filter_h,'String'));
% Low pass filter of surf
h = fspecial('average', [filter_siz filter_siz]) ;
surf_f = imfilter(surf,h,'replicate');

update_pattern;