%% procedura che applica la maschera a 461 immagini B-scan in scala di grigi, le quali vengono salvate nella cartella mask b-scan
function path_mask_b_scan = maskCiclo(base_path, path_b_s_estratti, filtered,tipoBinarizzazione)
path_mask_b_scan = strcat(base_path, 'Dati elaborati/mask b-scan/');
cd(path_mask_b_scan);
delete *.bmp;

cd([base_path 'Dati elaborati/']);

d = dir(path_b_s_estratti); %d=816
d(1:2) = []; %elimino i primi due elementi perche non sono immagini
ciclo = zeros(461,1);
if (filtered ~= 0)
    ciclo = 1:length(d);
else
    ciclo = 200:length(d) - 154;
end
for i = ciclo
    fileName = d(i).name;
    fileBMP = strcat(path_b_s_estratti, fileName);
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
    cd ..;
    cd ..;
    cd(base_path);
   matriceBSCAN_withContrast = binarizzazione(matriceBSCAN_withContrast,tipoBinarizzazione,filtered);
    cd(path_mask_b_scan);
    imwrite(matriceBSCAN_withContrast, strcat(fileName, '_mask.bmp'));
end

disp('MASCHERE APPLICATE');
end
