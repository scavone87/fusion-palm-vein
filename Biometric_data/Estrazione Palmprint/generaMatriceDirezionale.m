function [F] = generaMatriceDirezionale(direzione, dim)
%dim deve essere sempre dispari
%la matrice F sarà sempre quadrata

F = zeros(dim);

if(direzione == 0)
    F(ceil(dim/2),:) = ones(1,dim);
elseif(direzione == 45)
    F = fliplr(eye(dim));
elseif(direzione == 90)
    F(:, ceil(dim/2)) = ones(dim,1); 
elseif( direzione == 135)
    F = eye(dim);
end
        

end