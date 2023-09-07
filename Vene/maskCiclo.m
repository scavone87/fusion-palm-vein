function path_mask_b_scan = maskCiclo(base_path, path_b_s_estratti, filtered,tipoBinarizzazione)
nomeUtente = split(path_b_s_estratti, '\');
nomeUtente = string(nomeUtente(end));
path_mask_b_scan = fullfile(base_path, 'Dati elaborati','mask b-scan', nomeUtente);
mkdir(path_mask_b_scan);
% delete *.bmp;


d = dir(path_b_s_estratti); %d=816
d(1:2) = []; %elimino i primi due elementi perche non sono immagini
ciclo = zeros(300,1);
if (filtered ~= 0)
    ciclo = 1:length(d);
    
else
    ciclo = 1:192;
end
for i = 1 : size(d, 1)
    fileName = d(i).name;
    fileBMP = fullfile(path_b_s_estratti, fileName);
    fileName = erase(fileName, ".bmp");
    if (filtered ~= 0)
        fileName = erase(fileName, "_filtered");
    end
    matriceBSCAN = imread(fileBMP);
     if (filtered ~= 1)
        matriceBSCAN_withContrast = imadjust(matriceBSCAN,[0.1 1],[]);
     else
        matriceBSCAN_withContrast = matriceBSCAN;
     end
   matriceBSCAN_withContrast = binarizzazione(matriceBSCAN_withContrast,tipoBinarizzazione,filtered);
   salva = fullfile(path_mask_b_scan, strcat(fileName, '_mask.bmp'));
   imwrite(matriceBSCAN_withContrast, salva);
end

disp('MASCHERE APPLICATE');
end
