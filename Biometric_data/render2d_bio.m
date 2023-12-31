%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BioMetric Data Representation   %
% Luglio 2023 - Scavone Rocco      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%2D RENDERING MODULE%%%%%%%%%
close all;
clc 
clearvars -except M X Y Z v fileUOB pixel_length parametri_acquisizione

[fileRisultati, path] = uigetfile('*.mat','Seleziona il file .mat dei risultati');
% load Risultati3DCodiceMarino.mat;
pathCompleto = [path fileRisultati];
% load(fileRisultati);
load(pathCompleto);


%load AgatielloRoberto_011.mat

% % Visualizing 2D Ultrasound data: B and C Scans at defined values
curr_x_pos = Y(round(length(Y)/2));
curr_y_pos = X(round(length(X)/2));
curr_c_pos = Z(round(length(Z)/2));

% RENDER 2D DATA

% Plot of the x and y b-scans
set(0,'Units','pixels') 
scnsize = get(0,'ScreenSize');
bdwidth = 5;
topbdwidth = 65;

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
pos3 = [pos2(1),...
	scnsize(4) - pos2(4) - pos1(3) - 2*(topbdwidth + bdwidth) - bdwidth ,...
	pos2(3),...
	pos1(3)];



xbscan=figure('Position',pos1) ;
y=curr_x_pos;
imagesc( X,Z,squeeze(M (:,:,find( abs(Y-y)==(min(abs(Y-y)) ) ))),[0 255]);
colormap(gray(256));
set(gca,'ActivePositionProperty','position');
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('x-lateral distance [mm]');
ylabel('axial distance [mm]');
x_h=get(gca);

ybscan=figure('Position',pos2) ;
x=curr_y_pos;
imagesc(Y,Z,squeeze(M (:,find( abs(X-x)==(min(abs(X-x)) ) ),:)),[0 255]);
colormap(gray(256));
set(gca,'ActivePositionProperty','position');
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('y-lateral distance [mm]');
ylabel('axial distance [mm]');
y_h=get(gca);

cscan=figure('Position',pos3) ;
z=curr_c_pos;
imagesc(Y,X,squeeze(M(find((abs(Z-z)==(min(abs(Z-z))))),:,:)),[0 255]);
colormap(gray(256));
set(gca,'ActivePositionProperty','position');
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('y-lateral distance [mm]');
ylabel('x-lateral distance [mm]');
z_h=get(gca);


% 2D Rendering user interface 

% box
pos_2d  = [1/8*scnsize(3) + bdwidth,... 
	1/3*scnsize(4) - 100 - topbdwidth,...
	scnsize(3)/3 - 2*bdwidth,...
	100];

pos2d_control = figure('Position',pos_2d,'Toolbar','none','Menubar','none');

% text and labels
uicontrol('Style', 'text',...
    'String','X-BSCAN',...
    'Position', [0 4/5*pos_2d(4) pos_2d(3)/4 pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','Y-BSCAN',...
    'Position', [0 3/5*pos_2d(4) pos_2d(3)/4 pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','CSCAN',...
    'Position', [0 2/5*pos_2d(4) pos_2d(3)/4 pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','mm',...
    'Position', [3.8/4*pos_2d(3) 4/5*pos_2d(4) 0.2/4*pos_2d(3) pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','mm',...
    'Position', [3.8/4*pos_2d(3) 3/5*pos_2d(4) 0.2/4*pos_2d(3) pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','mm',...
    'Position', [3.8/4*pos_2d(3) 2/5*pos_2d(4) 0.2/4*pos_2d(3) pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','y = ',...
    'Position', [2.9/4*pos_2d(3) 4/5*pos_2d(4) 0.2/4*pos_2d(3) pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','x = ',...
    'Position', [2.9/4*pos_2d(3) 3/5*pos_2d(4) 0.2/4*pos_2d(3) pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','z = ',...
    'Position', [2.9/4*pos_2d(3) 2/5*pos_2d(4) 0.2/4*pos_2d(3) pos_2d(4)/5]);

% sliders
xslide_h = uicontrol('Style','slider',...
                     'Min',min(Y),'Max',max(Y),...
                     'Value',Y(find( abs(Y-y)==(min(abs(Y-y)) ) )),...
                     'Position', [1/4*pos_2d(3) 4/5*pos_2d(4) 1.8*pos_2d(3)/4 pos_2d(4)/5],...
                     'SliderStep',[Y(2)/Y(length(Y)) 10*Y(2)/Y(length(Y))],...
                     'Callback','update_2drender');
yslide_h = uicontrol('Style','slider',...
                     'Min',min(X),'Max',max(X),...
                     'Value',X(find( abs(X-x)==(min(abs(X-x)) ) )),...
                     'Position', [1/4*pos_2d(3) 3/5*pos_2d(4) 1.8*pos_2d(3)/4 pos_2d(4)/5],...
                     'SliderStep',[X(2)/X(length(X)) 10*X(2)/X(length(X))],...
                     'Callback','update_2drender');
cslide_h = uicontrol('Style','slider',...
                     'Min',min(Z),'Max',max(Z),...
                     'Value',Z(find((abs(Z-z)==(min(abs(Z-z)))))),...
                     'Position', [1/4*pos_2d(3) 2/5*pos_2d(4) 1.8*pos_2d(3)/4 pos_2d(4)/5],...
                     'SliderStep',[Z(2)/Z(length(Z)) 10*Z(2)/Z(length(Z))],...
                     'Callback','update_2drender');

% position data
x_pos_h = uicontrol('Style', 'edit',...
    'String',num2str(Y(find( abs(Y-y)==(min(abs(Y-y)) ) ))),...
    'Position', [3.1/4*pos_2d(3) 4/5*pos_2d(4) 0.7*pos_2d(3)/4 pos_2d(4)/5]);
y_pos_h = uicontrol('Style', 'edit',...
    'String',num2str(X(find( abs(X-x)==(min(abs(X-x)) ) ))),...
    'Position', [3.1/4*pos_2d(3) 3/5*pos_2d(4) 0.7*pos_2d(3)/4 pos_2d(4)/5]);
c_pos_h = uicontrol('Style', 'edit',...
    'String',num2str(Z(find((abs(Z-z)==(min(abs(Z-z))))))),...
    'Position', [3.1/4*pos_2d(3) 2/5*pos_2d(4) 0.7*pos_2d(3)/4 pos_2d(4)/5]);

% buttons
update_h = uicontrol('Position',[3.1/4*pos_2d(3) 1/5*pos_2d(4) 0.7*pos_2d(3)/4 pos_2d(4)/5],...
                    'String','Update',...
                    'Callback','update_pos2drenderer');


% measure

% toggle buttons
xmeas=0;
xexists=0;
ymeas=0;
yexists=0;
cmeas=0;
cexists=0;
measx_h = uicontrol('Style','togglebutton',...
                    'Position',[0.1/4*pos_2d(3) 1/5*pos_2d(4) 0.9*pos_2d(3)/4 pos_2d(4)/5],...
                    'String','Meas. X-BSCAN',...
                    'Callback','xmeas=1;,measure_2drender');
measy_h = uicontrol('Style','togglebutton',...
                    'Position',[(1.1/4)*pos_2d(3) 1/5*pos_2d(4) 0.9*pos_2d(3)/4 pos_2d(4)/5],...
                    'String','Meas. Y-BSCAN',...
                    'Callback','ymeas=1;,measure_2drender');
measc_h = uicontrol('Style','togglebutton',...
                    'Position',[(2.1/4)*pos_2d(3) 1/5*pos_2d(4) 0.9*pos_2d(3)/4 pos_2d(4)/5],...
                    'String','Meas. C-SCAN',...
                    'Callback','cmeas=1;,measure_2drender');
% measure data               
x_meas_h = uicontrol('Style', 'edit',...
    'String','',...
    'Position', [0.1/4*pos_2d(3) 0 0.6*pos_2d(3)/4 pos_2d(4)/5]);
y_meas_h = uicontrol('Style', 'edit',...
    'String','',...
    'Position', [(1.1/4)*pos_2d(3) 0 0.6*pos_2d(3)/4 pos_2d(4)/5]);
c_meas_h = uicontrol('Style', 'edit',...
    'String','',...
    'Position', [(2.1/4)*pos_2d(3) 0 0.6*pos_2d(3)/4 pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','mm',...
    'Position', [0.6/4*pos_2d(3) 0 0.3*pos_2d(3)/4 pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','mm',...
    'Position', [(1.6/4)*pos_2d(3) 0 0.3*pos_2d(3)/4 pos_2d(4)/5]);
uicontrol('Style', 'text',...
    'String','mm',...
    'Position', [(2.6/4)*pos_2d(3) 0 0.3*pos_2d(3)/4 pos_2d(4)/5]);




