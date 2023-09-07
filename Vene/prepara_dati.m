%% carica dati
clc;
close;
clear;
%scegli cartella dati
dataset_dir = uigetdir(pwd, 'Seleziona la cartella contenente il dataset');
cd(dataset_dir);
dirData = dir('*.mat');
[n , ~] = size(dirData);
mkdir 'dati preparati';
for i=1:n
    tic;
    name = dirData(i).name;
    file = load(name);
    estrazione = file.Matvena3D;
    conta = 1;
    [z, y, x] = size(file.Matvena3D);
    remodeled_matrix = zeros(1,3);
    for k=1:x
        for j=1:y
            for l=1:z
                if(estrazione(l,j,k)==1)
                    remodeled_matrix(conta,:) = [l,j,k];
                    conta = conta + 1;
                end
            end
        end        
    end
    [x1,y1,z1]=find(estrazione(2:end,2:end,2:end));
    result=mode(x1);
    [~, modaZ] = max(result);
    Matvena3D=estrazione;
    Matvena3D(Matvena3D==1)=0;
    Matvena3D(remodeled_matrix(1,1),remodeled_matrix(1,2))=1;
    for p=2:461
        Matvena3D(modaZ,remodeled_matrix(p,2),p)=1;    
    end
    disp(size(Matvena3D));
    %% salva
    save_path = strcat(dataset_dir, '/dati preparati/', name);
    save(save_path,'Matvena3D');
    completamento = [num2str((i*100/n)) '%']
end