%% procedura automatica per estrarre pattern venoso
%specificare la posizione della cartella contenente "Codice" nella
%variabile base_path e della cartella contenente i file.mat in
%dataset_path. Lo script provvederà a creare la struttura di cartelle, ad analizzare tutti i file e a
%svuotare le cartelle contenenti i dati intermedi ad esecuzione finita. I dati
%elaborati si troveranno in Dati elaborati/Template 2D;
clc;
%clear;
close all;
%% -------------CONFIGURAZIONE-----------------------------
filtered =0;   % = 1 usa il filtro SRAD, = 0 nessun filtro
sovrapposizione =1 ; % =0  non genera sovrapposizione, =1 genera sovrapprosizione
tipoBinarizzazione =0; % = 0 con media, = 1 con soglia di Ridler;

%base_path = 'D:/Sensori/';
base_path = 'C:/Users/user/Desktop/Nuova cartella (5)/codice/Codice/';
%dataset_path = [base_path 'Dataset/'];
dataset_path = [base_path 'acquisizioni_51/'];

num_core = 4; %inserire il numero di core fisici della macchina su cui viene eseguito il codice (non il numero di thread)
%--------------------------------------------------------

%% creo la struttura di cartelle
cd(base_path);
mkdir 'Dati elaborati';
cd 'Dati elaborati'/;
mkdir 'b-scan estratti';
mkdir 'mask b-scan';
mkdir 'regioniconnesse b-scan';
mkdir 'grafici2D';
mkdir 'grafici3D';
mkdir 'template2D';
mkdir 'template3D'
if filtered == 1
    mkdir 'srad filtered b-scan';
end

%% scansiono la cartella del dataset
cd(dataset_path);
dirData = dir('*.mat');
[n , ~] = size(dirData);
%% inizio l'estrazione
cd ..
cleanup(base_path, filtered);
mean_time_acc = 0;
mean_time = 0;

if(filtered ~= 0)
    parpool('local', num_core);
end
cd ..;
for i=1:n
    tic;
    dirData(i).name;
    cd ..; 
    path_b_s_estratti = estrazione_bscan(base_path, dirData(i).name);
    
    if filtered == 1 
        path_filtered_b_scan = filtroSRAD(base_path, path_b_s_estratti);
        path_mask_b_scan = maskCiclo(base_path,  path_filtered_b_scan, filtered,tipoBinarizzazione);
    else
        path_mask_b_scan = maskCiclo(base_path,path_b_s_estratti, filtered,tipoBinarizzazione);
    end
    cd ..;
    cd ..; 
    [path_regioni_connesse, path_dati_elaborati,variabile] = findconncompCiclo(base_path, path_mask_b_scan,tipoBinarizzazione,filtered);
    cd ..; 
    modaZ = estrazionevenafinale(path_regioni_connesse, path_dati_elaborati,variabile);
    cd ..;
    cd ..;
    % svuoto le cartelle contententi gli step intermedi prima di passare a
   % una nuova immagine
%      cd ..
%      cd ..
     cleanup(base_path, filtered);
    %calcolo l'avanzamento della procedura
    time = toc;
    per_comp = 100*i/n;
    percentuale = strcat(num2str(per_comp), '%%\n');
    fprintf(percentuale);
    mean_time_acc = mean_time_acc + toc;
    mean_time = mean_time_acc/i;
    residual_time = mean_time * (n-i);
    residual_time = residual_time/60;
    stringa = strcat('Tempo residuo in minuti: ', num2str(residual_time), '\n');
    fprintf(stringa);
    cd ..; %aggiunto
end
%% estrazione terminata
if filtered ~= 0
    delete(gcp);
end
mean_time_acc = mean_time_acc/60;
messaggio1 = strcat('Tempo totale in minuti: ', num2str(mean_time_acc), '\n');
messaggio2 = strcat('Tempo medio esecuzione: ', num2str(mean_time), '\n');
fprintf(messaggio1);
fprintf(messaggio2);


