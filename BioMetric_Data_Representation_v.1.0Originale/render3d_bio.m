%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BioMetric Data Representation   %
% April 2010 - Alessandro Savoia  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%3D RENDERING MODULE%%%%%%%%%

close all
clc 
clear all

load NuovaM.mat

% intensity treshold for surface detection (0 - 255)
tresh=64;
filter_siz=20;

% depth and thickness (mm)
depth=0.2;
thick=0.2;

% transparency flags (0 : intensity - 1 : linear with depth)
trans_flag=0;

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
thick_ind = round ( thick / (Z(2)-Z(1)) );

surf_filt = surf_f - depth_ind;
surf_max = surf_filt - round(thick_ind / 2);
surf_min = surf_filt + round(thick_ind / 2);

surf_filt(surf_filt>max_dpth)=max_dpth;
surf_max(surf_max>max_dpth)=max_dpth;
surf_min(surf_min>max_dpth)=max_dpth;

% Intensity matrix
I = M;
% Transparency matrix ( 0 = Total transparency ; 255 = Total opacity )
A = M;

% Tranparency processing
ramp_dim=2*round(thick_ind / 2);
ramp=round((0:ramp_dim)/ramp_dim*255);
Q=-ramp_dim/2:1:ramp_dim/2;

A(( (DPTH_IND-ramp_dim/2)>repmat(reshape(surf_filt,[1 size(surf_filt)]),[size(M,1) 1 1])))=0;
A((  (DPTH_IND+ramp_dim/2)<repmat(reshape(surf_filt,[1 size(surf_filt)]),[size(M,1) 1 1])))=255;

if trans_flag == 1
  for i=1:length(Q)
  A(( (DPTH_IND+Q(i))  == repmat(reshape(surf_filt,[1 size(surf_filt)]),[size(M,1) 1 1])))=ramp(i);
  end
end

% % Visualizing 3D Ultrasound data: Intensity Plot
figure
view(310+180,40);
h = vol3dd('cdata',(shiftdim(I,1)),...
           'alpha',(shiftdim(A,1)),...
           'texture','2D',...
           'xdata',[0 Y(length(Y))],...
           'ydata',[0 X(length(X))],...
           'zdata',[0 Z(length(Z))]);
colormap(gray(256))
set(gcf,'Color','k')
%set(gcf,'InvertHardcopy','off')
set(gca,'Color','k',...
    'XColor','w',...
    'YColor','w',...
    'ZColor','w',...
    'FontSize',12,...
    'XDir','reverse',...
    'YDir','reverse',...
    'ZDir','reverse')
axis tight;
xlabel('y[mm]');
ylabel('x[mm]');
zlabel('z[mm]');




