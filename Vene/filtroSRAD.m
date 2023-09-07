function path_filtered_b_scan = filtroSRAD(base_path, path_b_s_estratti)
    nomeUtente = split(path_b_s_estratti, '\');
    nomeUtente = string(nomeUtente(end));
    path_filtered_b_scan = fullfile(base_path, 'Dati elaborati', 'srad filtered b-scan', nomeUtente);
    if ~isfolder(path_filtered_b_scan)
        mkdir(path_filtered_b_scan);
    end

    files = dir(fullfile(path_b_s_estratti, '*.bmp'));

    parfor i = 1:numel(files)
        fileName = files(i).name;
        fileBMP = fullfile(path_b_s_estratti, fileName);
        [~, name, ~] = fileparts(fileName);
        matriceBSCAN = imread(fileBMP);
        rect = [0 0 50 50];
        %C = specklefilt(matriceBSCAN,DegreeOfSmoothing=1,NumIterations=50);

        C = SRAD(matriceBSCAN, 50, 0.2, rect);
        %D = imadjust(C, [0.1 1], []);
        D = imadjust(C);
        filteredFileName = fullfile(path_filtered_b_scan, [name, '_filtered.bmp']);
        imwrite(D, filteredFileName);
    end

    disp('FILTRO SRAD APPLICATO');
end
