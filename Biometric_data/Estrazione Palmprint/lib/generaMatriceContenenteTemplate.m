function [matriceOutput] = generaMatriceContenenteTemplate(matFile)
    pathTemplate2D = fullfile(pwd, 'template2D\Template2D', matFile, '');

    templatePaths = {
        'TEMPLATE1.dat',
        'TEMPLATE2.dat',
        'TEMPLATE3.dat',
        'TEMPLATE4.dat',
        'TEMPLATE5.dat',
        'TEMPLATE6.dat'
    };

    matriceTemplate = cell(1, 6);

    parfor i = 1:6
        templatePath = fullfile(pathTemplate2D, templatePaths{i});
        matriceTemplate{i} = importdata(templatePath);
    end

    matriceTemplate = cat(3, matriceTemplate{:});

    matriceOutput = shiftdim(matriceTemplate, 2);
end


