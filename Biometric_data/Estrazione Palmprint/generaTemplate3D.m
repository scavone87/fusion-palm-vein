% !!! Genera i template 3D e li salva nella cartella Template3D divisi per istante !!!

clear all;

clc; 
close all;

cartella=uigetdir(pwd, 'Seleziona la cartella file.mat');
directory_name=pwd;
cartella=strcat(cartella,'\');
dirs=dir(fullfile(cartella));
mkdir('Template3D');
mkdir('Template3D\istante000');
mkdir('Template3D\istante001');
mkdir('Template3D\istante002');
mkdir('Template3D\istante003');
mkdir('Template3D\istante004');
mkdir('Template3D\istante005');
mkdir('Template3D\istante006');
mkdir('Template3D\istante007');
mkdir('Template3D\istante008');
mkdir('Template3D\istante009');


k=1;
for i=3:length(dirs)
	path=strcat(cartella, dirs(i).name);
	path=strcat(path, '\');
	files=dir(fullfile(path, '*.mat'));
	Dimensione=size(files, 1);
	elementi=Dimensione;
	for contatore=1:elementi
		corrente=files(contatore).name(1:length(files(contatore).name)-4);
		generaTemplate4(corrente);
    end
end	