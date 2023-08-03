depth=str2double(get(depth_h,'String'));
depth_ind = round ( depth / (Z(2)-Z(1)) );
surf_filt = surf_f - depth_ind;
%
max_filt=max(max(surf_filt));
if ( max_filt > max_dpth)
    surf_filt(surf_filt>max_dpth)=max_dpth;
end
%
s=reshape(surf_filt,[1 size(surf_filt)]);
CMP=repmat(s,[size(M,1) 1 1]);
FFF=reshape( M((DPTH_IND==CMP)), size(surf_filt)) ;
figure(pattern)
imagesc(Y,X,FFF,[0 255]);
colormap(gray(256));
set(gca,'ActivePositionProperty','position');
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('y-lateral distance [mm]');
ylabel('x-lateral distance [mm]');

clear CMP;
set(xslide_h,'Value',str2double(get(depth_h,'String')));
