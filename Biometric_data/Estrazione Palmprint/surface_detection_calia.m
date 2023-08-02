% Surface detection
% Depth index matrix
SURF=flipdim(repmat(uint16((0:size(M,1)-1))',[1 size(M,2) size(M,3)]),1);
SURF(M<=tresh)=0;
surf=squeeze(max(SURF));
clear SURF

DPTH_IND=flipdim(repmat(uint16((0:size(M,1)-1))',[1 size(M,2) size(M,3)]),1);
max_dpth=size(M,1)-1;

% Averaging and penetration depth (mm)
% Low pass filter of surf
h = fspecial('average', [filter_siz filter_siz]) ;
surf_f = imfilter(surf,h,'replicate');
depth_ind = round ( depth / (Z(2)-Z(1)) );
surf_filt = surf_f - depth_ind;
max_filt=max(max(surf_filt));
if ( max_filt > max_dpth)
    surf_filt(surf_filt>max_dpth)=max_dpth;
end
%
s=reshape(surf_filt,[1 size(surf_filt)]);
CMP=repmat(s,[size(M,1) 1 1]);
FFF=reshape( M((DPTH_IND==CMP)), size(surf_filt)) ;
% FFF=flipud(FFF);
% FFF=fliplr(FFF);