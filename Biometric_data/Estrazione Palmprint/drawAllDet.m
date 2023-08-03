if(isempty(findobj('type','figure','name','allDet')))
    figure('name','allDet')
    flag = 1;
    legends = {};
end

while (flag)

inputS = inputdlg('Inserisci il nome della strategia da inserire nella legenda:', 'Nome strategia', [1 40]);
nomeStrategia = inputS{1};

%carica i vettori far e frr
[fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file .mat FAR');
[fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file .mat FRR');
FAR = load(strcat(pathFAR, fileFAR));
FRR = load(strcat(pathFRR, fileFRR));
vettore_FAR = FAR.vettore_FAR;
vettore_FRR = FRR.vettore_FRR;

myDET

legends{end+1} = strcat(nomeStrategia, '');

scelta = questdlg('Vuoi aggiungere un''altra curva?', 'Another curve?' ,'Si','No','Si');
if(strcmp(scelta,'No'))
    flag = 0;
end
        
end

legend(legends,'Location','northeast')

x=[0 100];
y=[0 100];
plot7=plot(x,y,'k','LineWidth',0.1);