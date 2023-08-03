function [M,Y] = interp_bio(M, Y, Z,repr_pitch, phys_pitch, pixel_length)
% Funzione: interp_bio
%
% Interpola i dati di scansione bio-ultrasonica per una migliore rappresentazione.
% Questa funzione interpola i dati di scansione bio-ultrasonica in modo da ottenere una
% maggiore risoluzione spaziale. Vengono interpolati i valori di M rispetto alle coordinate
% laterali dell'asse elettronico (X), meccanico (Y) e assiale (Z).
%
% Uso:
%   M = interp_bio(M, X, Y, Z, repr_pitch, phys_pitch, pixel_length)
%
% Input:
%   - M: Dati di scansione bio-ultrasonica in una matrice 3D.
%   - X: Coordinate laterali dell'asse elettronico (mm).
%   - Y: Coordinate laterali dell'asse meccanico (mm).
%   - Z: Coordinate dell'asse assiale (mm).
%   - repr_pitch: Passo di rappresentazione della sonda ultrasonica.
%   - phys_pitch: Passo fisico della sonda ultrasonica.
%   - pixel_length: Lunghezza del pixel corrispondente alla profondità selezionata (mm).
%
% Output:
%   - M: Dati di scansione bio-ultrasonica interpolati.
%
% Autore: Rocco Scavone
%
% Calcolo delle coordinate di interpolazione
Y_interp=(Y(1):(pixel_length/repr_pitch*phys_pitch):Y(length(Y)))';
Z_interp=(Z(1):(pixel_length/repr_pitch*phys_pitch):Z(length(Z)))';


% Conversione dei dati di scansione in formato double nell'intervallo [0,1]
M_double = double(M) / 255;

% Interpolazione dei dati di scansione rispetto all'asse Y
M_interp_y = interp1(Y, shiftdim(M_double, 2), Y_interp, 'makima');
M_interp = shiftdim(M_interp_y, 1);

% Interpolazione dei dati di scansione rispetto all'asse Z, se necessario
if repr_pitch ~= phys_pitch
    M_interp_z = interp1(Z, M_interp, Z_interp, 'makima');
    M_interp = M_interp_z;
end

% Ridimensionamento e arrotondamento dei dati di scansione interpolati
M = uint8(round(255 * M_interp));
end


