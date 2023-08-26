% !!! Genera i template 3D e li salva nella cartella Template3D divisi per istante !!!
addpath("lib\");
clearvars -except startTime_mainScript;
close all;

% Verifica se il cluster è già attivo
currentPool = gcp('nocreate');

% Se il cluster non è attivo, avvialo
if isempty(currentPool)
    parpool(); % Inizializza il pool parallelo
end

startTime_generaTemplate3D = tic;
path = fullfile(fileparts(pwd), 'Matfiles');
dirs=dir(fullfile(path));

template3DDir = 'template3D\Template3D';
template3DIstantiDir = 'template3D\Template3DIstanti';

mkdir(fullfile(template3DIstantiDir, 'istante000'));
mkdir(fullfile(template3DIstantiDir, 'istante001'));
mkdir(fullfile(template3DIstantiDir, 'istante002'));
mkdir(fullfile(template3DIstantiDir, 'istante003'));
mkdir(fullfile(template3DIstantiDir, 'istante004'));
mkdir(fullfile(template3DIstantiDir, 'istante005'));
mkdir(fullfile(template3DIstantiDir, 'istante006'));
mkdir(fullfile(template3DIstantiDir, 'istante007'));
mkdir(fullfile(template3DIstantiDir, 'istante008'));
mkdir(fullfile(template3DIstantiDir, 'istante009'));
mkdir(fullfile(template3DIstantiDir, 'istante010'));


files=dir(fullfile(path, '*.mat'));
Dimensione=size(files, 1);
elementi=Dimensione;
parfor contatore=1:elementi
    corrente=files(contatore).name(1:length(files(contatore).name)-4);
    generaTemplate(corrente,template3DDir, template3DIstantiDir);
end

% Fine tempo di esecuzione dello script principale
endTime_generaTemplate3D = toc(startTime_generaTemplate3D);

fprintf('Tempo di esecuzione dello script generaTemplate3D: %.2f secondi\n', endTime_generaTemplate3D);