function [filelist, cartella] = init_bio()
% Funzione: init_bio
%
% Inizializza i parametri per la scansione bio-ultrasonica.
%
% Uso:
%   [filelist, cartella] = init_bio()
%
% Output:
%   - filelist: Elenco dei file di immagine da leggere.
%   - cartella: Percorso della cartella contenente le immagini di scansione.
%
% Autore: Rocco Scavone
%
filelist = cell(32, 1);
cartella = 'BSCAN'; % Inserisci il percorso della cartella dei B-scan generati

% Creazione della lista dei file di immagine nella cartella
list = dir(fullfile(cartella, '*.bmp'));
filelist = fullfile(cartella, {list.name});
end
