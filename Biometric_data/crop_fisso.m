x_lim=[3 28];
y_lim=[6 44];
z_lim=[0 7];


disp(X);
X_c=X(find(X>x_lim(1)&X<x_lim(2)));

Z_c=Z(find(Z>z_lim(1)&Z<z_lim(2)));

    Y_c=Y(find(Y>y_lim(1)&Y<y_lim(2)));


X_c=X_c-X_c(1);

Y_c=Y_c-Y_c(1);
Z_c=Z_c-Z_c(1);
M_c=M(find(Z>z_lim(1)&Z<z_lim(2)),find(X>x_lim(1)&X<x_lim(2)),find(Y>y_lim(1)&Y<y_lim(2)));

M=M_c;
X=X_c;
Y=Y_c;
Z=Z_c;

clear M_c;