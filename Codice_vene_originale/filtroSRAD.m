function path_filtered_b_scan = filtroSRAD(base_path, path_b_s_estratti)
    path_filtered_b_scan = strcat(base_path, 'Dati elaborati/srad filtered b-scan/');
    cd(path_filtered_b_scan);
    delete *.bmp;

    cd([base_path 'Dati elaborati/']);

    d = dir(path_b_s_estratti);
    d(1:2) = []; %elimino i primi due elementi perch� non sono immagini
    [n , ~] = size(d);
    cd ..; 
    parfor i = 200 : n - 154
  % parfor i = 350 : n - 4
        fileName = d(i).name;
        fileBMP = strcat(path_b_s_estratti, fileName);
        fileName = erase(fileName, ".bmp");
        matriceBSCAN = imread(fileBMP);
        rect =[0 0 50 50];
        [C] = SRAD(matriceBSCAN,40,0.1,rect);
        D = imadjust(C,[0.1 1],[]);
        % figure;
        % imshow(filteredImage);
        cd(path_filtered_b_scan);
        imwrite(D, strcat(fileName, '_filtered.bmp'));
        % pause;
    end
    disp('FILTRO SRAD APPLICATO');
end