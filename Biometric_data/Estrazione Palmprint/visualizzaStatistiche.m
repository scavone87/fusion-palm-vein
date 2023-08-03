close all;
%richiedo la cartella delle statistiche da visualizzare
pathDiPartenza = [pwd '\Statistiche'];
directoryName = uigetdir(pathDiPartenza, 'Seleziona la cartella in cui sono contenute le statistiche da visualizzare');

pathEER = [directoryName '\EER_ML.mat'];
pathFAR = [directoryName '\vettore_far.mat'];
pathFRR = [directoryName '\vettore_frr.mat'];
pathGEN = [directoryName '\vettore_norm_genuini.mat'];
pathIMP = [directoryName '\vettore_norm_impostori.mat'];

load(pathEER);
load(pathFAR);
load(pathFRR);
load(pathGEN);
load(pathIMP);

%GRAFICO IMPOSTORI-GENUINI
% max_genuino=max(vec_gen);
% vett_norm_genuino=vec_gen/max_genuino;
% max_impostore=max(vec_imp);
% vett_norm_impostore=vec_imp/max_impostore;

S=std(vett_norm_impostore);
S1=mean(vett_norm_genuino);
approssimazione= 0.01;
intervalli= 1/approssimazione;
%raffiguriamo le ricorrenze degli score degli impostori e dei genuini NORMALIZZATI
figure1=figure;
axes1 = axes('Parent',figure1,'FontSize',10);
xlim(axes1,[0 1]);
ylim(axes1,[0 1.05]);
box(axes1,'on');
hold(axes1,'all');
plot1=plot(approssimazione:approssimazione:1,vett_norm_impostore,'Parent',axes1);
set(plot1(1),'DisplayName','impostor');
xlabel('Score','FontSize',12);
ylabel('frequency','FontSize',12);
hold on;
plot2=plot(approssimazione:approssimazione:1,vett_norm_genuino,'Color','red');
set(plot2(1),'Color',[1 0 0],'DisplayName','genuine');
legend1 = legend(axes1,'show');
set(legend1,'Location','NorthWest');

%GRAFICO FAR-FRR
far_interp=interp1(1:intervalli+1,vettore_FAR,1:.1:intervalli+1,'pchip'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
frr_interp=interp1(1:intervalli+1,vettore_FRR,1:.1:intervalli+1,'pchip'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
figure2=figure;
axes1 = axes('Parent',figure2);
ylim(axes1,[0 1.05]);
xlim(axes1,[0 1]);
box(axes1,'on');
hold(axes1,'all');
plot1=plot(0:0.001:1,far_interp);
set(plot1(1),'DisplayName','FAR');
xlabel('threshold t','FontSize',12);
ylabel('error probability','FontSize',12);
hold on;
plot2=plot(0:0.001:1,frr_interp,'Color','red');
set(plot2(1),'Color',[1 0 0],'DisplayName','FRR');
legend5 = legend(axes1,'show');
set(legend5,'Position',[0.152380952380951 0.684126984126991 0.15 0.1]);

%CURVE DET
drawDETcurve;