function [ matriceOutput ] = generaMatriceContenenteTemplate(matFile)
% Questa funzione prende i template a varie profondità e le unisce in una sola matrice
          
    path=strcat(pwd,'\risultati\TemplateDoG\',matFile,'\');
    
    %ricommentare template1
    template1 = importdata(strcat(path,'TEMPLATE1.dat'));
    template2 = importdata(strcat(path,'TEMPLATE2.dat'));
    template3 = importdata(strcat(path,'TEMPLATE3.dat'));
    template4= importdata(strcat(path,'TEMPLATE4.dat'));
    template5 = importdata(strcat(path,'TEMPLATE5.dat'));
    template6 = importdata(strcat(path,'TEMPLATE6.dat'));
    sizeTemplate = size(template2);
    
    matriceTemplate =  zeros(sizeTemplate(1),sizeTemplate(2),12);
    
    for (i=1:6)    
        
        index = i;
        
        index = int2str(index);
        
        name = strcat('template',index);
        
        currentTemplate = eval(name);
        
        matriceTemplate(:,:,i) = currentTemplate;
        
%       figure;imshow(currentTemplate);
        
    end
    
    matriceTemplate = shiftdim(matriceTemplate,2);
      
    matriceOutput = matriceTemplate;
    
end

