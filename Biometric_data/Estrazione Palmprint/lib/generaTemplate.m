function []=generaTemplate(matFile, template3DDir, template3DIstantiDir)

mkdir(fullfile(template3DDir, matFile));

%profonditaTratti(filtraggioInProfondita(generaMatriceContenenteTemplate(matFile),1),matFile);
matrice = generaMatriceContenenteTemplate(matFile);
matriceFiltrata = filtraggioInProfondita(matrice, 1);
profonditaTratti(matriceFiltrata, matFile,template3DDir, template3DIstantiDir);

end
