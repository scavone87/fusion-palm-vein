function []=generaTemplate4(matFile)

	mkdir(strcat('TemplateDoG3D/', matFile, '/'));
	
	profonditaTratti2(filtraggioInProfondita(generaMatriceContenenteTemplate(matFile),1),matFile);
	
end	
	