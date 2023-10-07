% BioMetric Data Representation
% Scavone Rocco
%%%%%%%3D RENDERING MODULE%%%%%%%%%

clc 
clearvars -except M X Y Z v fileUOB pixel_length parametri_acquisizione

[fileRisultati, path] = uigetfile('*.mat','Seleziona il file .mat dei risultati');
pathCompleto = fullfile(path, fileRisultati);
load(pathCompleto);

fprintf("Dimensione x: %.2f [mm]\n", X(end));
fprintf("Dimensione y: %.2f [mm]\n", Y(end));
fprintf("Dimensione z: %.2f [mm]\n", Z(end));

% soglia di intensità per la rilevazione della superficie (0 - 255)
tresh = 64;
filter_siz = 20;
% Crea la figura solo una volta
hFig3D = figure('Name', 'Render 3D', 'NumberTitle', 'off');
loadingText = text(0.5, 0.5, 0.5, 'Caricamento...', 'HorizontalAlignment', 'center', 'FontSize', 14);
view(310+180, 40);
render3DView(tresh, filter_siz, M, X, Y, Z, hFig3D);
delete(loadingText);

%%
% set(0,'Units','pixels') 
% scnsize = get(0,'ScreenSize');
% bdwidth = 5;
% topbdwidth = 70;
% 
% % box
% pos_2d  = [1/3*scnsize(3) + bdwidth,... 
% 	1/3*scnsize(4) - 100 - topbdwidth,...
% 	scnsize(3)/2 - 2*bdwidth,...
% 	60];
% 
% pos2d_control = figure('Position',pos_2d,'Toolbar','none','Menubar','none');
% 
% % text and labels
% uicontrol('Style', 'text',...
%     'String','SURFACE DETECTION:',...
%     'Position', [0/5*pos_2d(3) 1/3*pos_2d(4) 1/5*pos_2d(3) pos_2d(4)/3]);
% uicontrol('Style', 'text',...
%     'String','Treshold (0 - 255) = ',...
%     'Position', [1/5*pos_2d(3) 1/3*pos_2d(4) 1/5*pos_2d(3) pos_2d(4)/3]);
% uicontrol('Style', 'text',...
%     'String','Filter size (pixels) = ',...
%     'Position', [2.6/5*pos_2d(3) 1/3*pos_2d(4) 0.8/5*pos_2d(3) pos_2d(4)/3]);
% 
% % data
% tresh_h = uicontrol('Style', 'edit',...
%     'String',num2str(tresh),...
%     'Position', [2/5*pos_2d(3) 1/3*pos_2d(4) 0.5/5*pos_2d(3) pos_2d(4)/3] );
% filter_h = uicontrol('Style', 'edit',...
%     'String',num2str(filter_siz),...
%     'Position', [3.4/5*pos_2d(3) 1/3*pos_2d(4) 0.5/5*pos_2d(3) pos_2d(4)/3] );
% 
% % buttons
% detect_h = uicontrol('Position',[4/5*pos_2d(3) 1/3*pos_2d(4) 1/5*pos_2d(3) pos_2d(4)/3],...
%                     'String','Update',...
%                     'Callback','render3DView(str2double(get(tresh_h,"String")), str2double(get(filter_h,"String")), M, X, Y, Z, hFig3D)');



