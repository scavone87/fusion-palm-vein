function [] = salvaTemplate3D(matriceOutput, matFile)
% salvaTemplate3D - Genera e salva un'immagine 3D da una matrice di output.
%
% Parametri:
%    matriceOutput - La matrice contenente i dati per l'immagine 3D.
%    matFile - Il nome del file da assegnare all'immagine salvata.
%
% Utilizzo:
%    salvaTemplate3D(matriceOutput, matFile) genera un'immagine 3D utilizzando
%    i dati dalla matrice di output fornita e la salva come file immagine con il
%    nome specificato da matFile.
%
%    Esempio:
%    matrice = ... % Inserire qui i dati della matrice
%    nomeFile = 'immagine_3d.jpg';
%    salvaTemplate3D(matrice, nomeFile);
%
%    Questa funzione crea una figura invisibile utilizzando i dati dalla matrice
%    di output fornita. L'immagine viene visualizzata con la colormap 'jet' e una
%    barra dei colori. La scala dei colori viene impostata tra 0 e 6. L'immagine
%    viene quindi salvata come file JPG nella directory 'Template3DJpg' nella
%    posizione corrente.
%
%    Si prega di assicurarsi che la directory 'Template3DJpg' esista nella
%    posizione corrente o verrà creata automaticamente.
%
%    Una volta completato il salvataggio, la figura invisibile verrà chiusa.
%
% Autore: Luongo Antonio, Scavone Rocco
% Data: Agosto 2023
%
% Vedi anche: imshow, colormap, colorbar, saveas

    % Crea una figura invisibile
    fig = figure('Visible', 'off');

    % Visualizza l'immagine utilizzando i dati dalla matrice di output
    imshow(matriceOutput);
    colormap(jet);
    colorbar;

    % Imposta la scala dei colori tra 0 e 6 e imposta il font del grafico
    set(gca, 'CLim', [0, 6], 'FontName','TimesNewRoman','FontSize',16);

    % Crea il percorso di salvataggio
    savePath = fullfile(pwd, '\template3D\Template3DJpg\');
    
    % Crea la directory se non esiste
    if ~exist(savePath, 'dir')
        mkdir(savePath);
    end
    
    % Salva l'immagine come file JPG
    saveas(fig,fullfile(savePath, matFile),'jpg');
    
    % Chiudi la figura invisibile
    close(fig);  % Chiudi la figura invisibile
end