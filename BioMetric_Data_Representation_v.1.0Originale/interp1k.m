function [ Z_i , M_I ] = interp1k( Z , M , Z_i , k)
%Performs interp1 on unit8 data in k steps

size_h=size(M,2);
int=1;
h_wait = waitbar(0,'Please wait while interpolating...');
for i=0:k-1;
M_I( : , int :(i+1)*floor(size_h/k) , : ) = uint8(floor( 255* interp1 ( Z ,  double(    M ( : , int:(i+1)*floor(size_h/k) , : )  )/255    , Z_i , 'linear')  )) ;
waitbar((i+1)/(k))
int = (i+1)*floor(size_h/k) + 1;
end
close(h_wait);