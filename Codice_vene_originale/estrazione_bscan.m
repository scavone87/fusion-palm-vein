%%%%%%%%%%%%%%%%%%%function PER ESTRARRE 814 B-SCAN %%%%%%%%%%%%%%%%%%%
function path_b_s_estratti = estrazione_bscan(base_path, FileName)

%specifica il percorso del file .mat
%dataset_path = strcat(base_path, 'Dataset/');
dataset_path = strcat(base_path, 'acquisizioni_51/');
PathName = dataset_path;
fileMat = strcat(PathName, FileName);
load(fileMat);
FileName(end - 3:end) = [];
path_b_s_estratti = strcat(strcat(base_path, 'Dati elaborati/b-scan estratti/'), FileName);
path_b_s_estratti = [path_b_s_estratti '/'];

path_bse = strcat(base_path, 'Dati elaborati/b-scan estratti/');
mkdir (path_bse, FileName);


for i = 1:length(Y)
    x = M(:, :, i);
    if i < 10
        imwrite(x, [path_b_s_estratti strcat(FileName, '_00') num2str(i) '.bmp']);
    else
        if i < 100
            imwrite(x, [path_b_s_estratti strcat(FileName, '_0') num2str(i) '.bmp']);
        else
            imwrite(x, [path_b_s_estratti strcat(FileName, '_') num2str(i) '.bmp']);
            
            
        end
    end
    
end
disp('ESTRAZIONE B-SCAN EFFETTUATA');
end
