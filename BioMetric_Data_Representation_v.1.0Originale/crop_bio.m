%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BioMetric Data Representation   %
% April 2010 - Alessandro Savoia  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CROP DATA

% Plot of the x and y b-scans
set(0,'Units','pixels') 
scnsize = get(0,'ScreenSize');
bdwidth = 5;
topbdwidth = 70;

x_rat=X(length(X))/(X(length(X))+Y(length(Y)));
y_rat=Y(length(Y))/(X(length(X))+Y(length(Y)));
z_rat=Z(length(Z))/(X(length(X))+Y(length(Y)));

pos1  = [bdwidth,... 
	scnsize(4)- z_rat*scnsize(3) - 2*(topbdwidth + bdwidth),...
	x_rat*scnsize(3) - 2*bdwidth,...
	z_rat*scnsize(3) + (topbdwidth + bdwidth)];
pos2 = [pos1(1) + x_rat*scnsize(3),...
	pos1(2),...
	y_rat*scnsize(3) - 2*bdwidth,...
	pos1(4)];

xbscan=figure('Position',pos1) ;
x_h=gca;
imagesc(X,Z,squeeze(M(:,:,round(length(Y)/2))),[0 255]);
colormap(gray(256));
set(gca,'ActivePositionProperty','position');
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('x-lateral distance [mm]');
ylabel('axial distance [mm]');

ybscan=figure('Position',pos2) ;
y_h=gca;
imagesc(Y,Z,squeeze(M(:,round(length(X)/2),:)),[0 255]);
colormap(gray(256));
set(gca,'ActivePositionProperty','position');
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('y-lateral distance [mm]');
ylabel('axial distance [mm]');


figure(xbscan)
xrect = imrect(gca, []);
figure(ybscan)
yrect = imrect(gca, []);

xapi = iptgetapi(xrect);
yapi = iptgetapi(yrect);

% Crop user interface 

% box
pos_crop  = [1/3*scnsize(3) + bdwidth,... 
	1/3*scnsize(4) - 100 - topbdwidth,...
	scnsize(3)/3 - 2*bdwidth,...
	100];

crop_control = figure('Position',pos_crop,'Toolbar','none','Menubar','none');

% text and labels
uicontrol('Style', 'text',...
    'String','x min. (mm)',...
    'Position', [1/5*pos_crop(3) 3/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
uicontrol('Style', 'text',...
    'String','x max. (mm)',...
    'Position', [2/5*pos_crop(3) 3/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
uicontrol('Style', 'text',...
    'String','y min. (mm)',...
    'Position', [3/5*pos_crop(3) 3/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
uicontrol('Style', 'text',...
    'String','y max. (mm)',...
    'Position', [4/5*pos_crop(3) 3/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
uicontrol('Style', 'text',...
    'String','X-BSCAN',...
    'Position', [0 2/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
uicontrol('Style', 'text',...
    'String','Y-BSCAN',...
    'Position', [0 1/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);


% buttons
cancel_h = uicontrol('Position',[1/5*pos_crop(3) 0 pos_crop(3)/5 pos_crop(4)/4],...
                    'String','Done',...
                    'Callback','uiresume(gcbf)');
update_h = uicontrol('Position',[3/5*pos_crop(3) 0 pos_crop(3)/5 pos_crop(4)/4],...
                    'String','Update',...
                    'Callback','update_positions');

% data
xpos = xapi.getPosition();
ypos = yapi.getPosition();

x_xmin_h = uicontrol('Style', 'edit',...
    'String',num2str(xpos(1)),...
    'Position', [1/5*pos_crop(3) 2/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
x_xmax_h = uicontrol('Style', 'edit',...
    'String',num2str(xpos(1)+xpos(3)),...
    'Position', [2/5*pos_crop(3) 2/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
x_ymin_h = uicontrol('Style', 'edit',...
    'String',num2str(xpos(2)),...
    'Position', [3/5*pos_crop(3) 2/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
x_ymax_h = uicontrol('Style', 'edit',...
    'String',num2str(xpos(2)+xpos(4)),...
    'Position', [4/5*pos_crop(3) 2/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
y_xmin_h = uicontrol('Style', 'edit',...
    'String',num2str(ypos(1)),...
    'Position', [1/5*pos_crop(3) 1/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
y_xmax_h = uicontrol('Style', 'edit',...
    'String',num2str(ypos(1)+ypos(3)),...
    'Position', [2/5*pos_crop(3) 1/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
y_ymin_h = uicontrol('Style', 'edit',...
    'String',num2str(ypos(2)),...
    'Position', [3/5*pos_crop(3) 1/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);
y_ymax_h = uicontrol('Style', 'edit',...
    'String',num2str(ypos(2)+ypos(4)),...
    'Position', [4/5*pos_crop(3) 1/4*pos_crop(4) pos_crop(3)/5 pos_crop(4)/4]);

xapi.addNewPositionCallback(@(p) set(x_xmin_h,'String',num2str(p(1))));
xapi.addNewPositionCallback(@(p) set(x_ymin_h,'String',num2str(p(2))));
xapi.addNewPositionCallback(@(p) set(x_xmax_h,'String',num2str(p(1)+p(3))));
xapi.addNewPositionCallback(@(p) set(x_ymax_h,'String',num2str(p(2)+p(4))));

yapi.addNewPositionCallback(@(p) set(y_xmin_h,'String',num2str(p(1))));
yapi.addNewPositionCallback(@(p) set(y_ymin_h,'String',num2str(p(2))));
yapi.addNewPositionCallback(@(p) set(y_xmax_h,'String',num2str(p(1)+p(3))));
yapi.addNewPositionCallback(@(p) set(y_ymax_h,'String',num2str(p(2)+p(4))));

uiwait(gcf); 
close(crop_control);

xpos = xapi.getPosition();
ypos = yapi.getPosition();

close(xbscan);
close(ybscan);

%CROP Data
x_lim=[xpos(1) xpos(1)+xpos(3)];
y_lim=[ypos(1) ypos(1)+ypos(3)];
z_lim=[min([xpos(2) ypos(2)]) max([xpos(2)+xpos(4) ypos(2)+ypos(4)])];
X_c=X(find(X>x_lim(1)&X<x_lim(2)));
Y_c=Y(find(Y>y_lim(1)&Y<y_lim(2)));
Z_c=Z(find(Z>z_lim(1)&Z<z_lim(2)));
X_c=X_c-X_c(1);
Y_c=Y_c-Y_c(1);
Z_c=Z_c-Z_c(1);
M_c=M(find(Z>z_lim(1)&Z<z_lim(2)),find(X>x_lim(1)&X<x_lim(2)),find(Y>y_lim(1)&Y<y_lim(2)));

M=M_c;
X=X_c;
Y=Y_c;
Z=Z_c;

clear M_c;
