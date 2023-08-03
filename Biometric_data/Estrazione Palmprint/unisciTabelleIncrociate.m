[fileRisultati1, path1] = uigetfile('*.mat','Seleziona il file .mat dei risultati del db1');
pathCompleto1 = [path1 fileRisultati1];
load(pathCompleto1);
T_1 = T;
[fileRisultati2, path2] = uigetfile('*.mat','Seleziona il file .mat dei risultati del db2');
pathCompleto2 = [path2 fileRisultati2];
load(pathCompleto2);
T_2 = T;
[fileRisultatiInc, pathInc] = uigetfile('*.mat','Seleziona il file .mat dei risultati incrociati');
pathCompletoInc = [pathInc fileRisultatiInc];
load(pathCompletoInc);
T_Inc = T;

for i = 1 : size(T_2) 
    T_1(end+1,:) = T_2(i,:);
end
T_12 = T_1;

for i = 1 : size(T_Inc) 
    T_12(end+1,:) = T_Inc(i,:);
end
T_Def = T_12;
T = T_Def;

[nomestructmat, pathstructmat]=uiputfile('.mat','Save definive struct .mat');
save(strcat(pathstructmat,nomestructmat), 'T');


