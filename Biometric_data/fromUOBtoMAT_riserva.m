clear all
clc

% Richiedi all'utente di selezionare una cartella
initialPath = uigetdir('Seleziona una cartella al livello superiore');

% Controlla se l'utente ha annullato la selezione della cartella
if initialPath == 0
    disp('Selezione della cartella annullata.');
    return;
end

% Ottieni l'elenco dei file nella cartella
subfolderList = dir(initialPath);
subfolderNames = {subfolderList([subfolderList.isdir]).name};
subfolderNames = subfolderNames(~ismember(subfolderNames, {'.', '..'}));

if isempty(subfolderNames)
    disp('Nessuna sottocartella trovata.');
    return;
end

% Ciclo attraverso le sottocartelle e esegui il codice per ciascuna
for subfolderIdx = 1:numel(subfolderNames)
    subfolderName = subfolderNames{subfolderIdx};
    pathnameUOB = fullfile(initialPath, subfolderName);
    % Controlla se l'utente ha annullato la selezione della cartella
    if pathnameUOB == 0
        disp('Selezione della cartella annullata.');
        return;
    end

    % Ottieni l'elenco dei file nella cartella
    filePattern = fullfile(pathnameUOB, 'palmo_*_SliceIQ.uob');
    fileList = dir(filePattern);

    out=regexp(pathnameUOB,'\','split');
    nomeFileMat = string(out(end));

    for i=1 : size(fileList,1)
        filenameuob = fileList(i).name;
        fileUOB=fullfile(pathnameUOB, filenameuob);
        pathnameBS = [pwd '\BSCAN' '\'];
        nomeElaborato = strcat(nomeFileMat, filenameuob(6:9));
        fprintf('Elaborazione di: %s\n', nomeElaborato);
        DataObj=DataUlaopBaseBand(fileUOB);
        dimZ = DataObj.uos.info.blocklength.num;
        dimX = DataObj.uop.item0.global.nlines.num;
        dimY = DataObj.uos.info.nblocks.num / dimX;
        RYMIN = DataObj.uop.item0.rxsettings.rymin.num;
        RYMAX = DataObj.uop.item0.rxsettings.rymax.num;
        profondita_campo = RYMAX - RYMIN;
        sound_speed = DataObj.uop.workingset.soundspeed.num;
        fs = DataObj.fs;
        Ndec = DataObj.uop.item0.rxelab.ndec(3).num;
        focus = DataObj.uop.item0.txsettings.tyfocus.num;
        PRF = DataObj.uop.ssg.prf.num;
        scansione_meccanica = 38;
        lunghezza_sonda = 38.4;
        phys_pitch= 0.2;
        repr_pitch = 0.2;
        v = visualization;
        v = v.calcola_pixel_length(sound_speed,fs);
        v = v.calcola_res_y(dimY, scansione_meccanica);
        v.new_dimX = floor((dimX * lunghezza_sonda)/(v.pixel_length * (dimX - 1)));
        pixel_length = v.pixel_length;
        save visualization_info.mat v dimX dimY dimZ profondita_campo scansione_meccanica lunghezza_sonda phys_pitch repr_pitch pixel_length
        eliminaResidui;
        convert2bmp;
        preprocessing_bio;
    end
end