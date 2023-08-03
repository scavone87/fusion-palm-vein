% load (strcat(pwd,matFile,'.mat'));
clearvars -except v pixel_length

[filenamemat, pathnamemat] = uigetfile({'*.mat'},'SELECT CAPTURE .mat');
fileMAT=strcat(pathnamemat,filenamemat);
load(fileMAT);


%PARAMETRI
tresh=64;   % Intensity treshold for surface detection (0 - 255)
filter_siz=20;  % Averaging filter

sz = size(M);
FFFF=zeros(sz(2),sz(3),sz(1)); % DIMX, DIMY E DIMZ PRESE DALLA MATRICE M

%estraggo la cartella del database
%k = strfind(pathnamemat,'mat\');
%dirPart = pathnamemat(1:k-1);
path=strcat(pwd,'\imageGeneratedFrom3D\',filenamemat(1:end-4));

if ~exist(path, 'dir')
    mkdir(path);
end

depth = 0;

for i=2:7
    depth=i*pixel_length;
    surface_detection;
    %[FileName, PathName] = uiputfile('*.jpg','Salva immagine: ');
    FileName=strcat( 'immagine_', num2str(i-1), "_",num2str( depth ),'.jpg' )
    Name = fullfile(path, FileName);
    %Name = fullfile(PathName, FileName);
    imwrite(FFF, Name, 'jpg');
    FFFF(:,:,i)=FFF;
end