function [ matriceOutput ] = filtraggioInProfondita(matriceZXY,sizeNeighboorhod)

    neighboorhod = strel('square',sizeNeighboorhod);  

    sizeTemplate = size(matriceZXY);
    
    matriceTemplate =  zeros(sizeTemplate);
    
    
    matriceTemplate(1,:,:) = imdilate(matriceZXY(1,:,:),neighboorhod);
    
    matriceTemp = matriceZXY;
    
    for(i=1:sizeTemplate(1)-1)
    
        currentMatrix = squeeze(matriceTemp(i,:,:));

        dilatateCurrentMatrix = imdilate(currentMatrix,neighboorhod); 

        nextDepthMatrix = squeeze(matriceTemp(i+1,:,:));
        
        
        FilteredNextDepthMatrix = bitand(dilatateCurrentMatrix,nextDepthMatrix);

        matriceTemp(i+1,:,:) = FilteredNextDepthMatrix;
        
        
        
       
        matriceTemplate(i+1,:,:) = imdilate(FilteredNextDepthMatrix,neighboorhod);
        
    
    end
    
    matriceOutput = matriceTemplate;
    
end