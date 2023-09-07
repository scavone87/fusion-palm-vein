%%%%%%%%%%%%%%%%%%%function PER ESTRARRE 814 B-SCAN %%%%%%%%%%%%%%%%%%%
function path_b_s_estratti = estrazione_bscan(base_path, dataset_path, FileName)

%specifica il percorso del file .mat

fileMat = fullfile(dataset_path, FileName);
load(fileMat);
FileName(end - 3:end) = [];
path_b_s_estratti = fullfile(base_path, 'Dati elaborati','b-scan estratti', FileName);

path_bse = fullfile(base_path, 'Dati elaborati/b-scan estratti/');
mkdir (path_b_s_estratti);


for i = 1:length(Y)
    x = M(:, :, i);
    if i < 10
        nomeFile = strcat(FileName, '_00', num2str(i), '.bmp');
        salvataggio = fullfile(path_b_s_estratti, nomeFile);
        imwrite(x, salvataggio);
    else
        if i < 100
            nomeFile = strcat(FileName, '_0', num2str(i), '.bmp');
            salvataggio = fullfile(path_b_s_estratti, nomeFile);
            imwrite(x, salvataggio);
        else
            nomeFile = strcat(FileName, '_', num2str(i), '.bmp');
            salvataggio = fullfile(path_b_s_estratti, nomeFile);
            imwrite(x, salvataggio);


        end
    end

end
disp('ESTRAZIONE B-SCAN EFFETTUATA');
end
