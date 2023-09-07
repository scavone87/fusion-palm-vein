%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BioMetric Data Representation   %
% April 2010 - Alessandro Savoia  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INTERPOLATE DATA
% Interpolation basis
X_i=X;
Y_i=(Y(1):(pixel_length/repr_pitch*phys_pitch):Y(length(Y)))';
Z_i=(Z(1):(pixel_length/repr_pitch*phys_pitch):Z(length(Z)))';

% Convert data to float
M64 = double(M)/255;

% Interpolate mechanical scan direction (Y) data 
M_i=shiftdim( interp1 (Y , shiftdim(M64,2) , Y_i ) , 1);

% Interpolate axial (Z) data
if repr_pitch~=phys_pitch
    M_I= interp1 ( Z , M_i , Z_i )  ;
    M_i=M_I;
    clear M_I;    
end

% Revert to unsigned integer
M=uint8(round( 255*M_i));
X=X_i;
Y=Y_i;
Z=Z_i;

clear M_i;
clear M64;