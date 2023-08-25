function [ matriceOutput ] = filtraggioInProfondita(matriceZXY,sizeNeighboorhod)
% filtraggioInProfondita - Applica un processo di filtraggio in profondità su una matrice tridimensionale.
%
%   matriceOutput = filtraggioInProfondita(matriceZXY, sizeNeighboorhod)
%
% Input:
%   matriceZXY - Una matrice tridimensionale (z, x, y) su cui applicare il filtraggio.
%   sizeNeighboorhod - Dimensione dell'elemento strutturale per la dilatazione morfologica.
%
% Output:
%   matriceOutput - Matrice tridimensionale risultante dal processo di filtraggio.
%
% Descrizione:
%   Questa funzione esegue un processo di filtraggio in profondità su una matrice tridimensionale.
%   Utilizza l'operazione di dilatazione morfologica e l'operazione logica AND per applicare il filtraggio.
%   L'elemento strutturale utilizzato per la dilatazione è un quadrato di dimensioni definite da sizeNeighboorhod.
%   Il risultato del filtraggio viene restituito in matriceOutput.
%
% Esempio:
%   % Creare una matrice tridimensionale di esempio
%   matriceZXY = randi([0, 1], 4, 3, 3);
%   sizeNeighboorhod = 3;
%   matriceFiltrata = filtraggioInProfondita(matriceZXY, sizeNeighboorhod);
%
%
% Note:
%   Assicurarsi che la dimensione di sizeNeighboorhod sia adeguata per l'applicazione della dilatazione.
%   Questa funzione è adatta per applicazioni di filtraggio in profondità utilizzando operazioni morfologiche.
%

    neighboorhod = strel('square',sizeNeighboorhod);  

    sizeTemplate = size(matriceZXY);
    
    matriceTemplate =  zeros(sizeTemplate);
    
    matriceTemplate(1,:,:) = imdilate(matriceZXY(1,:,:),neighboorhod);
    
    matriceTemp = matriceZXY;
    
    for(i=1:sizeTemplate(1)-1)
    
        currentMatrix = squeeze(matriceTemp(1,:,:));

        dilatateCurrentMatrix = imdilate(currentMatrix,neighboorhod); 

        nextDepthMatrix = squeeze(matriceTemp(i+1,:,:));
        
        FilteredNextDepthMatrix = bitand(dilatateCurrentMatrix,nextDepthMatrix);

        matriceTemp(i+1,:,:) = FilteredNextDepthMatrix;

        matriceTemplate(i+1,:,:) = imdilate(FilteredNextDepthMatrix,neighboorhod);
        
    end
    
    matriceOutput = matriceTemplate;
    
end