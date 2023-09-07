%% procedura automatica per estrarre pattern venoso
%specificare la posizione della cartella contenente "Codice" nella
%variabile base_path e della cartella contenente i file.mat in
%dataset_path. Lo script provvederà a creare la struttura di cartelle, ad analizzare tutti i file e a
%svuotare le cartelle contenenti i dati intermedi ad esecuzione finita. I dati
%elaborati si troveranno in Dati elaborati/Template 2D;
clc;
clear;
close all;

folderPath = fullfile(pwd, 'Dati elaborati');

% Verifica che la cartella esista prima di eliminarla
if exist(folderPath, 'dir')
    % Rimuovi la cartella e il suo contenuto in modo ricorsivo
    try
        rmdir(folderPath, 's');
        disp('Cartella eliminata con successo.');
    catch
        error('Si è verificato un errore durante l''eliminazione della cartella.');
    end
else
    disp('La cartella non esiste.');
end

%% -------------CONFIGURAZIONE-----------------------------
filtered =1;   % = 1 usa il filtro SRAD, = 0 nessun filtro
sovrapposizione =1 ; % =0  non genera sovrapposizione, =1 genera sovrapprosizione
tipoBinarizzazione =1; % = 0 con media, = 1 con soglia di Ridler;

%base_path = 'D:/Sensori/';
base_path = pwd;
%dataset_path = [base_path 'Dataset/'];
dataset_path = fullfile(fileparts(pwd), '\Biometric_data\Matfiles');

%num_core = 56; %inserire il numero di core fisici della macchina su cui viene eseguito il codice (non il numero di thread)
%--------------------------------------------------------

%% creo la struttura di cartelle
datiElaborati = 'Dati elaborati';

mkdir(fullfile(datiElaborati));
mkdir(fullfile(datiElaborati, 'b-scan estratti'));
mkdir(fullfile(datiElaborati, 'mask b-scan'));
mkdir(fullfile(datiElaborati, 'regioniconnesse b-scan'));
mkdir(fullfile(datiElaborati, 'grafici2D'));
mkdir(fullfile(datiElaborati, 'grafici3D'));
mkdir(fullfile(datiElaborati, 'template2D'));
mkdir(fullfile(datiElaborati, 'template3D'));

if filtered == 1
    mkdir(fullfile(datiElaborati, 'srad filtered b-scan'));
end

%% scansiono la cartella del dataset
filePattern = fullfile(dataset_path, '*.mat');
fileList = dir(filePattern);
[n , ~] = size(fileList);
%% inizio l'estrazione

mean_time_acc = 0;
mean_time = 0;

% % Verifica se il cluster è già attivo
% currentPool = gcp('nocreate');
% 
% % Se il cluster non è attivo, avvialo
% if isempty(currentPool)
%     parpool(); % Inizializza il pool parallelo
% end


parfor i=1:n
    path_b_s_estratti = estrazione_bscan(base_path, dataset_path, fileList(i).name);
    
    if filtered == 1 
        path_filtered_b_scan = filtroSRAD(base_path, path_b_s_estratti);
        path_mask_b_scan = maskCiclo(base_path,  path_filtered_b_scan, filtered,tipoBinarizzazione);
    else
        path_mask_b_scan = maskCiclo(base_path,path_b_s_estratti, filtered,tipoBinarizzazione);
    end
    
    [path_regioni_connesse, path_dati_elaborati,variabile] = findconncompCiclo(base_path, path_mask_b_scan,tipoBinarizzazione,filtered);
    
    %modaZ = estrazionevenafinale(path_regioni_connesse, path_dati_elaborati,variabile);
    estrazionevena(path_regioni_connesse, path_dati_elaborati,variabile);

    % cleanup(base_path, filtered);

end


path_connesse = fullfile("Dati elaborati/regioniconnesse b-scan");
path_dati_elaborati = fullfile("Dati elaborati");
file_list = dir(path_connesse);
parfor i=3:size(file_list,1)
    path_regioni_connesse = fullfile(path_connesse, file_list(i).name);
    estrazionevena(path_regioni_connesse, path_dati_elaborati,"a");
end

