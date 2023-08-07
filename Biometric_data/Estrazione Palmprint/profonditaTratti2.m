function [ matriceOutput ] = profonditaTratti2( matrice, matFile )

    
    matriceProfondita =  zeros(size(matrice,2),size(matrice,3));
    
    for (i=1:size(matrice,1))    
        
        matriceProfondita = matriceProfondita + squeeze(matrice(i,:,:));
        
    end
    
    matriceOutput = matriceProfondita;
          
    save(strcat(pwd,'\TemplateDoG3D\',matFile,'\',matFile,'.dat'),'matriceOutput'); 

    istante = str2num(matFile(end));

    if or((istante==0), isempty(istante)) 

      save(strcat(pwd,'\Template3D\istante000\',matFile,'.dat'),'matriceOutput');

    end

    if(istante==1)

      save(strcat(pwd,'\Template3D\istante001\',matFile,'.dat'),'matriceOutput');

    end

    if(istante==2)

      save(strcat(pwd,'\Template3D\istante002\',matFile,'.dat'),'matriceOutput');

    end
     
    if(istante==3)

      save(strcat(pwd,'\Template3D\istante003\',matFile,'.dat'),'matriceOutput');

    end
    
    if(istante==4)

      save(strcat(pwd,'\Template3D\istante004\',matFile,'.dat'),'matriceOutput');

    end

    if(istante==5)

      save(strcat(pwd,'\Template3D\istante005\',matFile,'.dat'),'matriceOutput');

    end
      
    if(istante==6)

      save(strcat(pwd,'\Template3D\istante006\',matFile,'.dat'),'matriceOutput');
    
    end

    if(istante==7)

      save(strcat(pwd,'\Template3D\istante007\',matFile,'.dat'),'matriceOutput');
    
    end
          
    if(istante==8)

      save(strcat(pwd,'\Template3D\istante008\',matFile,'.dat'),'matriceOutput');
    
    end
    
    if(istante==9)

      save(strcat(pwd,'\Template3D\istante009\',matFile,'.dat'),'matriceOutput');
          
    end


%     !!!visualizza il template 3D in jpg!!!       
%     figure;
%     imshow(matriceOutput);
     % imwrite(matriceOutput, strcat(pwd,'\Template3D\',matFile,'.jpg'));

%     !!!visualizza il template 3D a colori!!!
     figure
     matriceOutput = imresize(matriceOutput, 4);
     fig = imshow(matriceOutput); colormap(jet); colorbar;set(gca, 'CLim', [0, 6], 'FontName','TimesNewRoman','FontSize',16);
     savePath = strcat(pwd, '\Template3D\');
     saveas(fig,fullfile(savePath, matFile),'jpg');
        
end

