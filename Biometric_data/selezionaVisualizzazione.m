choiceVisualization = questdlg ('Vorresti visualizzare la matrice .mat?','Visualizzazione matrice .mat', 'Render 2D', 'Render 3D', 'No', 'No');

switch choiceVisualization
    case 'Render 2D'
        render2d_bio;
        msgbox('La matrice .mat è stata creata con successo!','Success');
    case 'Render 3D'
        render3d_bio;
        msgbox('La matrice .mat è stata creata con successo!','Success');
    case 'No'
        msgbox('La matrice .mat è stata salvata con successo!','Success');
end