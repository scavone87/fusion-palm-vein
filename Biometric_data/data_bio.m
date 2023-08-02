function [M, X, Y, Z] = data_bio(filelist, pixel_length, stepsize, phys_pitch, repr_pitch, dimY)
% Funzione: data_bio
%
% Legge, elabora e salva i dati di scansione bio-ultrasonica.
% Questi calcoli consentono di ottenere le coordinate spaziali corrispondenti ai pixel 
% nella scansione bio-ultrasonica, consentendo così una corretta rappresentazione e interpretazione
% dei dati acquisiti.
%
% L'asse X rappresenta la direzione di scansione elettronica ed è calcolato utilizzando il passo fisico della sonda ultrasonica (phys_pitch), 
% il passo di rappresentazione (repr_pitch) e la lunghezza del pixel corrispondente alla profondità selezionata (pixel_length).
% 
% L'asse Y rappresenta la direzione di scansione meccanica ed è calcolato utilizzando il passo di scansione meccanica (stepsize).
%
% L'asse Z rappresenta la direzione assiale ed è calcolato utilizzando la lunghezza del pixel corrispondente alla profondità selezionata (pixel_length).
%
% Uso:
%   [M, X, Y, Z] = data_bio(filelist, pixel_length, stepsize, phys_pitch, repr_pitch)
%
% Input:
%   - filelist: Elenco dei file di immagine da leggere.
%   - pixel_length: Lunghezza del pixel corrispondente alla profondità selezionata.
%   - stepsize: Dimensione del passo della scansione meccanica.
%   - phys_pitch: Passo fisico della sonda ultrasonica.
%   - repr_pitch: Passo di rappresentazione della sonda ultrasonica.
%   - dimY: Dimensione lungo la direzione y (ovvero il num di BSCAN)
%
% Output:
%   - M: Dati di scansione bio-ultrasonica in una matrice 3D.
%   - X: Coordinate laterali dell'asse X (direzione di scansione elettronica) in millimetri.
%   - Y: Coordinate laterali dell'asse Y (direzione di scansione meccanica) in millimetri.
%   - Z: Coordinate dell'asse Z (direzione assiale) in millimetri.
%
% Autore: Rocco Scavone

% Inizializzazione della matrice M con dimensioni appropriate
M = uint8(zeros(size(imread(filelist{1}), 1), size(imread(filelist{1}), 2), dimY));

% Caricamento dei dati di scansione
h_wait = waitbar(0, 'Attendere...');
for i = 1:dimY
    I = imread(filelist{i});
    M(:,:,i) = I;
    waitbar(i/dimY)
end
close(h_wait);

% Calcolo delle coordinate degli assi X, Y, Z in millimetri
X = (((0:size(M,2)-1)' * phys_pitch) / repr_pitch) * pixel_length;
Y = (0:size(M,3)-1)'*stepsize;
Z = (0:size(M,1)-1)' * pixel_length;
end
