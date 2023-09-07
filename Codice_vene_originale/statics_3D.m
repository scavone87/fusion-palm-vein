close all;
clear all;
clc;


[fileRisultati, path] = uigetfile('*.mat','Seleziona il file .mat dei risultati');
pathCompleto = [path fileRisultati];
load(pathCompleto);
pathStatistiche = uigetdir('', 'Seleziona cartella dove salvare le Statistiche');

timeStr = strrep(datestr(now),':','-');
k = strfind(fileRisultati,'.mat');
sourceStr = fileRisultati(1:k-1);
sName = [pathStatistiche, '/', sourceStr];
mkdir(sName);

matchT=size(T);
for i=1:matchT(1)
    Ut1=char(T.Utente1(i));
    Ut1=strrep(Ut1,'.mat','');
    nomeUt1=Ut1(1:(length(Ut1)-2));
    cifreUt1=str2num(Ut1(end));

    Ut2=char(T.Utente2(i));
    Ut2=strrep(Ut2,'.mat','');
    nomeUt2=Ut2(1:(length(Ut2)-2));
    cifreUt2=str2num(Ut2(end));
        
        if(strcmp(nomeUt1,nomeUt2)==1) %specificare l'uguaglianza tra stringhe
            T.Genuino(i)=1; 
        else
        T.Genuino(i)=0;
        end
end

genuino=0;
impostore=0;

tabellaGenuinoML=cell(1,3);
tabellaImpostoreML=cell(1,3);

match=size(T);
for i=1:match(1)

    pri=T{i,4};
    if (pri==1)
        genuino=genuino+1;
        tabellaGenuinoML(genuino,1)={T.Utente1(i)};
        tabellaGenuinoML(genuino,2)={T.Utente2(i)};
        scoml=(T{i,3});
        if(scoml<1||scoml==1)
            sml=round((scoml)*100);
            tabellaGenuinoML(genuino,3)={sml};
        else
            tabellaGenuinoML(genuino,3)={'100'};
        end
    else
        
        impostore=impostore+1;
        tabellaImpostoreML(impostore,1)={T.Utente1(i)};
        tabellaImpostoreML(impostore,2)={T.Utente2(i)};
        scomci=(T{i,3});
        if(scomci<1 || scomci==1)
            smci=round((scomci)*100);
            tabellaImpostoreML(impostore,3)={smci};
        else
            tabellaImpostoreML(impostore,3)={'100'};
        end
    end
end

%%%%%%%GRAFICI PER ML%%%%%%%%%%%%%%%%
TabGenML = cell2table(tabellaGenuinoML, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
TabImpML = cell2table(tabellaImpostoreML, 'VariableNames',{'Utente1' 'Utente2' 'Score'});

vec_gen=zeros(1,100);
vec_imp=zeros(1,100);

dime=size(TabGenML);
for i=1:dime(1)
   valore=TabGenML.Score(i);
  % valore=valore{1,1};
  if(valore~=0)
      vec_gen(1,valore)=vec_gen(1,valore)+1;
  end
   
      
end

 save('vec_gen.mat','vec_gen');

dime=size(TabImpML);
for i=1:dime(1)
   valore=TabImpML.Score(i);
 % valore=valore{1,1};
 if(valore ~= 0)
    vec_imp(1,valore)=vec_imp(1,valore)+1;
 end
 

end

 save('vec_gen.mat','vec_gen');
 save('vec_imp.mat','vec_imp');
% 

%normalizziamo le curve
max_genuino=max(vec_gen);
vett_norm_genuino=vec_gen/max_genuino;
max_impostore=max(vec_imp);
vett_norm_impostore=vec_imp/max_impostore;

s = strcat(sName, '/vettore_norm_genuini.mat');
save(s,'vett_norm_genuino');
s = strcat(sName, '/vettore_norm_impostori.mat');
save(s,'vett_norm_impostore');

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

%calcoliamo il FAR
indice=0;
for soglia=0:approssimazione:1
    indice=indice+1;
    if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
        somma=0;
        for i=1:(soglia/approssimazione)
            if(vec_imp(1,i)>0)
                somma=somma+vec_imp(1,i);
            end
        end
        vettore_FAR(1,indice)=(sum(vec_imp)-somma)/sum(vec_imp);
    else
        vettore_FAR(1,indice)=1;
    end
end
s = strcat(sName, '/vettore_far.mat');
save(s,'vettore_FAR');

%calcoliamo il FRR
indice=0;
for soglia=0:approssimazione:1
    indice=indice+1;
    if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
        somma=0;
        for i=1:(soglia/approssimazione)
            if(vec_gen(1,i)>0)
                somma=somma+vec_gen(1,i);
            end
        end
        vettore_FRR(1,indice)=somma/sum(vec_gen);
    else
        vettore_FRR(1,indice)=0;
    end
end
s = strcat(sName, '/vettore_frr.mat');
save(s,'vettore_FRR');

%raffigriamo FAR e FRR insieme INTERPOLATI
far_interp=interp1(1:intervalli+1,vettore_FAR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
frr_interp=interp1(1:intervalli+1,vettore_FRR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
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

%cerchiamo il valore di intersezione tra FAR e FRR
dimensione=size(far_interp); % CALCOLO RIGA E COLONNE MATRICE
dimensionecolonne=dimensione(2);

for i=1:dimensionecolonne
    EER_Y(1,i)=abs((far_interp(1,i)-frr_interp(1,i)))/2;
    EER_X(1,i)=i*0.001;
end

[eer_y_3D eer_x2]=min(EER_Y);
eer_x_ML=(eer_x2-1)*0.001;  %soglia
eer_y_ML=far_interp(eer_x2);%probabilità di errore

s = strcat(sName, '/EER_ML.mat');
save(s,'eer_x_ML','eer_y_ML');

% %DET Curve
vettore_far_ml=vettore_FAR;
vettore_frr_ml=vettore_FRR;
vettore_gmr_ml=(1-vettore_FRR).*100;

figure3=figure;
axes1 = axes('Parent',figure3,'FontSize',10,'FontName','Times New Roman');
ylim(axes1,[0 1]);
xlim(axes1,[0 1]);
box(axes1,'on');
hold(axes1,'all');
% vettore_far_ml_approx = smooth(vettore_far_ml, 0.2);
% vettore_frr_ml_approx = smooth(vettore_frr_ml, 0.2);
% plot1=plot(vettore_far_ml_approx,vettore_frr_ml_approx,'Parent',axes1,'LineWidth',1.5);
xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');

ylabel('False Rejection Rate (%)','FontSize',12,'FontName','Times New Roman');
EER_x=0.3020;
EER_y=0.0019;
hold on;
plot(EER_x,EER_y,'-ko','MarkerSize',5,'MarkerFaceColor','k');

%%%%%%%%%%%%%%GRAFICI PER GCI%%%%%%%%%%%%%%%%%%%%
% TabGenML4passate = cell2table(tabellaGenuinoML4passate, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% TabImpML4passate = cell2table(tabellaImpostoreML4passate, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% 
% vec_gen=zeros(1,100);
% vec_imp=zeros(1,100);
% 
% dime=size(TabGenML4passate);
% for i=1:dime(1)
%    valore=(TabGenML4passate.Score(i));
%    if(valore==0)
%        vec_gen(1,valore+1)=vec_gen(1,valore+1)+1;
%    else 
%        vec_gen(1,valore)=vec_gen(1,valore)+1;
%    end
% end
% 
% dime=size(TabImpML4passate);
% for i=1:dime(1)
%    valore=(TabImpML4passate.Score(i));
%    if(valore==0)
%        vec_imp(1,valore+1)=vec_imp(1,valore+1)+1;
%    else
%         vec_imp(1,valore)=vec_imp(1,valore)+1;
%    end
% end
% 
% %normalizziamo le curve
% max_genuino=max(vec_gen);
% vett_norm_genuino=vec_gen/max_genuino;
% max_impostore=max(vec_imp);
% vett_norm_impostore=vec_imp/max_impostore;
% 
% approssimazione= 0.01;
% intervalli= 1/approssimazione;
% %raffiguriamo le ricorrenze degli score degli impostori e dei genuini NORMALIZZATI
% figure1=figure;
% axes1 = axes('Parent',figure1,'FontSize',10);
% xlim(axes1,[0 1]);
% ylim(axes1,[0 1.05]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(approssimazione:approssimazione:1,vett_norm_impostore,'Parent',axes1);
% set(plot1(1),'DisplayName','impostor');
% xlabel('Score','FontSize',12);
% ylabel('frequency','FontSize',12);
% hold on;
% plot2=plot(approssimazione:approssimazione:1,vett_norm_genuino,'Color','red');
% set(plot2(1),'Color',[1 0 0],'DisplayName','genuine');
% legend1 = legend(axes1,'show');
% set(legend1,'Location','NorthWest');
% 
% %calcoliamo il FAR
% indice=0;
% for soglia=0:approssimazione:1
%     indice=indice+1;
%     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
%         somma=0;
%         for i=1:(soglia/approssimazione)
%             if(vec_imp(1,i)>0)
%                 somma=somma+vec_imp(1,i);
%             end
%         end
%         vettore_FAR(1,indice)=(sum(vec_imp)-somma)/sum(vec_imp);
%     else
%         vettore_FAR(1,indice)=1;
%     end
% end
% 
% %calcoliamo il FRR
% indice=0;
% for soglia=0:approssimazione:1
%     indice=indice+1;
%     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
%         somma=0;
%         for i=1:(soglia/approssimazione)
%             if(vec_gen(1,i)>0)
%                 somma=somma+vec_gen(1,i);
%             end
%         end
%         vettore_FRR(1,indice)=somma/sum(vec_gen);
%     else
%         vettore_FRR(1,indice)=0;
%     end
% end
% 
% %raffigriamo FAR e FRR insieme INTERPOLATI
% far_interp=interp1(1:intervalli+1,vettore_FAR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% frr_interp=interp1(1:intervalli+1,vettore_FRR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% figure2=figure;
% axes1 = axes('Parent',figure2);
% ylim(axes1,[0 1.05]);
% xlim(axes1,[0 1]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(0:0.001:1,far_interp);
% set(plot1(1),'DisplayName','FAR');
% xlabel('threshold t','FontSize',12);
% ylabel('error probability','FontSize',12);
% hold on;
% plot2=plot(0:0.001:1,frr_interp,'Color','red');
% set(plot2(1),'Color',[1 0 0],'DisplayName','FRR');
% legend5 = legend(axes1,'show');
% set(legend5,'Position',[0.152380952380951 0.684126984126991 0.15 0.1]);
% 
% %cerchiamo il valore di intersezione tra FAR e FRR
% dimensione=size(far_interp); % CALCOLO RIGA E COLONNE MATRICE
% dimensionecolonne=dimensione(2);
% 
% for i=1:dimensionecolonne
%     EER_Y(1,i)=abs((far_interp(1,i)-frr_interp(1,i)))/2;
%     EER_X(1,i)=i*0.001;
% end
% 
% [eer_y_3D eer_x2]=min(EER_Y);
% eer_x_GCI=(eer_x2-1)*0.001;  %soglia
% eer_y_GCI=far_interp(eer_x2);%probabilità di errore
% 
% save('EER_GCI.mat','eer_x_GCI','eer_y_GCI');

% %DET Curve
% vettore_far_gci=vettore_FAR.*100;
% vettore_frr_gci=vettore_FRR.*100;
% vettore_gmr_gci=(1-vettore_FRR).*100;


% figure3=figure;
% axes1 = axes('Parent',figure3,'FontSize',10,'FontName','Times New Roman');
% ylim(axes1,[0 16]);
% xlim(axes1,[0 8]);
% box(axes1,'on');
% hold(axes1,'all');
% hold on;
% plot1=plot(vettore_far,vettore_frr,'Parent',axes1,'LineWidth',1.5);
% xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
% ylabel('False Rejection Rate (%)','FontSize',12,'FontName','Times New Roman');
% EER_x=0.3020;
% EER_y=0.0019;
% hold on;
% plot(EER_x,EER_y,'-ko','MarkerSize',5,'MarkerFaceColor','k');

% %%%%%%%%%%%%GRAFICI PER ST%%%%%%%%%%%%%%%%%%%%%%%%
% TabGenST = cell2table(tabellaGenuinoST, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% TabImpST = cell2table(tabellaImpostoreST, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% 
% vec_gen=zeros(1,100);
% vec_imp=zeros(1,100);
% 
% dime=size(TabGenST);
% for i=1:dime(1)
%    valore=TabGenST.Score(i);
%    if(valore==0)
%        vec_gen(1,valore+1)=vec_gen(1,valore+1)+1;
%    else 
%        vec_gen(1,valore)=vec_gen(1,valore)+1;
%    end
% end
% 
% dime=size(TabImpST);
% for i=1:dime(1)
%    valore=TabImpST.Score(i);
%    if(valore==0)
%        vec_imp(1,valore+1)=vec_imp(1,valore+1)+1;
%    else
%         vec_imp(1,valore)=vec_imp(1,valore)+1;
%    end
% end
% 
% %normalizziamo le curve
% max_genuino=max(vec_gen);
% vett_norm_genuino=vec_gen/max_genuino;
% max_impostore=max(vec_imp);
% vett_norm_impostore=vec_imp/max_impostore;
% 
% approssimazione= 0.01;
% intervalli= 1/approssimazione;
% %raffiguriamo le ricorrenze degli score degli impostori e dei genuini NORMALIZZATI
% figure1=figure;
% axes1 = axes('Parent',figure1,'FontSize',10);
% xlim(axes1,[0 1]);
% ylim(axes1,[0 1.05]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(approssimazione:approssimazione:1,vett_norm_impostore,'Parent',axes1);
% set(plot1(1),'DisplayName','impostor');
% xlabel('Score','FontSize',12);
% ylabel('frequency','FontSize',12);
% hold on;
% plot2=plot(approssimazione:approssimazione:1,vett_norm_genuino,'Color','red');
% set(plot2(1),'Color',[1 0 0],'DisplayName','genuine');
% legend1 = legend(axes1,'show');
% set(legend1,'Location','NorthWest');
% 
% %calcoliamo il FAR
% indice=0;
% for soglia=0:approssimazione:1
%     indice=indice+1;
%     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
%         somma=0;
%         for i=1:(soglia/approssimazione)
%             if(vec_imp(1,i)>0)
%                 somma=somma+vec_imp(1,i);
%             end
%         end
%         vettore_FAR(1,indice)=(sum(vec_imp)-somma)/sum(vec_imp);
%     else
%         vettore_FAR(1,indice)=1;
%     end
% end
% 
% %calcoliamo il FRR
% indice=0;
% for soglia=0:approssimazione:1
%     indice=indice+1;
%     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
%         somma=0;
%         for i=1:(soglia/approssimazione)
%             if(vec_gen(1,i)>0)
%                 somma=somma+vec_gen(1,i);
%             end
%         end
%         vettore_FRR(1,indice)=somma/sum(vec_gen);
%     else
%         vettore_FRR(1,indice)=0;
%     end
% end
% 
% %raffigriamo FAR e FRR insieme INTERPOLATI
% far_interp=interp1(1:intervalli+1,vettore_FAR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% frr_interp=interp1(1:intervalli+1,vettore_FRR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% figure2=figure;
% axes1 = axes('Parent',figure2);
% ylim(axes1,[0 1.05]);
% xlim(axes1,[0 1]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(0:0.001:1,far_interp);
% set(plot1(1),'DisplayName','FAR');
% xlabel('threshold t','FontSize',12);
% ylabel('error probability','FontSize',12);
% hold on;
% plot2=plot(0:0.001:1,frr_interp,'Color','red');
% set(plot2(1),'Color',[1 0 0],'DisplayName','FRR');
% legend5 = legend(axes1,'show');
% set(legend5,'Position',[0.152380952380951 0.684126984126991 0.15 0.1]);
% 
% %cerchiamo il valore di intersezione tra FAR e FRR
% dimensione=size(far_interp); % CALCOLO RIGA E COLONNE MATRICE
% dimensionecolonne=dimensione(2);
% 
% for i=1:dimensionecolonne
%     EER_Y(1,i)=abs((far_interp(1,i)-frr_interp(1,i)))/2;
%     EER_X(1,i)=i*0.001;
% end
% 
% [eer_y_3D eer_x2]=min(EER_Y);
% eer_x_ST=(eer_x2-1)*0.001;  %soglia
% eer_y_ST=far_interp(eer_x2);%probabilità di errore
% 
% save('EER_ST.mat','eer_x_ST','eer_y_ST');
% 
% %DET Curve
% vettore_far_st=vettore_FAR.*100;
% vettore_frr_st=vettore_FRR.*100;
% vettore_gmr_st=(1-vettore_FRR).*100;
% % figure3=figure;
% % axes1 = axes('Parent',figure3,'FontSize',10,'FontName','Times New Roman');
% % ylim(axes1,[0 16]);
% % xlim(axes1,[0 8]);
% % box(axes1,'on');
% % hold(axes1,'all');
% % plot1=plot(vettore_far,vettore_frr,'Parent',axes1,'LineWidth',1.5);
% % xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
% % ylabel('False Rejection Rate (%)','FontSize',12,'FontName','Times New Roman');
% % EER_x=0.3020;
% % EER_y=0.0019;
% % hold on;
% % plot(EER_x,EER_y,'-ko','MarkerSize',5,'MarkerFaceColor','k');
% 
% % %%%%%%%%%%%%%%METODOLOGIA MW%%%%%%%%%%%%%%%%%%%%%%%%
% % load EER_MCI.mat;
% % load EER_GCI.mat;
% % load EER_ST.mat;
% % 
% % mwmci= (1/eer_y_MCI)/( (1/eer_y_MCI)+(1/eer_y_GCI)+(1/eer_y_ST)); 
% % mwgci= (1/eer_y_GCI)/( (1/eer_y_MCI)+(1/eer_y_GCI)+(1/eer_y_ST));  
% % mwst=  (1/eer_y_ST)/( (1/eer_y_MCI)+(1/eer_y_GCI)+(1/eer_y_ST)); 
% % 
% % for i=1:matchA(1) 
% %     AA=table2array(A(i,4));
% %     BB=table2array(A(i,5));
% %     CC=table2array(A(i,6));
% %     FF=((cell2mat(AA))*mwmci) + ((cell2mat(BB))*mwgci) + ((cell2mat(CC))*mwst);
% %     A(i,7)=array2table(FF);
% % end
% % 
% % %GRAFICI PER MW
% % genuino=0;
% % impostore=0;
% % matchA=size(A);
% % for i=1:matchA(1)
% %     pri=num2str(cell2mat(A{i,3}));
% %     if (pri=='1')
% %         genuino=genuino+1;
% %         
% %         tabellaGenuinoMW(genuino,1)={A.Utente1(i)};
% %         tabellaGenuinoMW(genuino,2)={A.Utente2(i)};
% %         scomw=A{i,7};
% %         smw=round((scomw)*100);
% %         tabellaGenuinoMW(genuino,3)={smw};
% %     else
% %         impostore=impostore+1;
% %         tabellaImpostoreMW(impostore,1)={A.Utente1(i)};
% %         tabellaImpostoreMW(impostore,2)={A.Utente2(i)};
% %         scomw=A{i,7};
% %         if(scomw<1 || scomw==1)
% %             smw=round((scomw)*100);
% %             tabellaImpostoreMW(impostore,3)={smw};
% %         else
% %             tabellaImpostoreMW(impostore,3)={'100'};
% %         end
% %     end
% % end
% % 
% % TabGenMW = cell2table(tabellaGenuinoMW, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% % TabImpMW = cell2table(tabellaImpostoreMW, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% % vec_gen=zeros(1,100);
% % vec_imp=zeros(1,100);
% % 
% % dime=size(TabGenMW);
% % for i=1:dime(1)
% %    valore=TabGenMW.Score(i);
% %    if(valore==0)
% %        vec_gen(1,valore+1)=vec_gen(1,valore+1)+1;
% %    else 
% %        vec_gen(1,valore)=vec_gen(1,valore)+1;
% %    end
% % end
% % 
% % dime=size(TabImpMW);
% % for i=1:dime(1)
% %    valore=TabImpMW.Score(i);
% %    if(valore==0)
% %        vec_imp(1,valore+1)=vec_imp(1,valore+1)+1;
% %    else
% %         vec_imp(1,valore)=vec_imp(1,valore)+1;
% %    end
% % end
% % 
% % %normalizziamo le curve
% % max_genuino=max(vec_gen);
% % vett_norm_genuino=vec_gen/max_genuino;
% % max_impostore=max(vec_imp);
% % vett_norm_impostore=vec_imp/max_impostore;
% % 
% % approssimazione= 0.01;
% % intervalli= 1/approssimazione;
% % %raffiguriamo le ricorrenze degli score degli impostori e dei genuini NORMALIZZATI
% % figure1=figure;
% % axes1 = axes('Parent',figure1,'FontSize',10);
% % xlim(axes1,[0 1]);
% % ylim(axes1,[0 1.05]);
% % box(axes1,'on');
% % hold(axes1,'all');
% % plot1=plot(approssimazione:approssimazione:1,vett_norm_impostore,'Parent',axes1);
% % set(plot1(1),'DisplayName','impostor');
% % xlabel('Score','FontSize',12);
% % ylabel('frequency','FontSize',12);
% % hold on;
% % plot2=plot(approssimazione:approssimazione:1,vett_norm_genuino,'Color','red');
% % set(plot2(1),'Color',[1 0 0],'DisplayName','genuine');
% % legend1 = legend(axes1,'show');
% % set(legend1,'Location','NorthWest');
% % 
% % %calcoliamo il FAR
% % indice=0;
% % for soglia=0:approssimazione:1
% %     indice=indice+1;
% %     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
% %         somma=0;
% %         for i=1:(soglia/approssimazione)
% %             if(vec_imp(1,i)>0)
% %                 somma=somma+vec_imp(1,i);
% %             end
% %         end
% %         vettore_FAR(1,indice)=(sum(vec_imp)-somma)/sum(vec_imp);
% %     else
% %         vettore_FAR(1,indice)=1;
% %     end
% % end
% % 
% % %calcoliamo il FRR
% % indice=0;
% % for soglia=0:approssimazione:1
% %     indice=indice+1;
% %     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
% %         somma=0;
% %         for i=1:(soglia/approssimazione)
% %             if(vec_gen(1,i)>0)
% %                 somma=somma+vec_gen(1,i);
% %             end
% %         end
% %         vettore_FRR(1,indice)=somma/sum(vec_gen);
% %     else
% %         vettore_FRR(1,indice)=0;
% %     end
% % end
% % 
% % %raffigriamo FAR e FRR insieme INTERPOLATI
% % far_interp=interp1(1:intervalli+1,vettore_FAR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% % frr_interp=interp1(1:intervalli+1,vettore_FRR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% % figure2=figure;
% % axes1 = axes('Parent',figure2);
% % ylim(axes1,[0 1.05]);
% % xlim(axes1,[0 1]);
% % box(axes1,'on');
% % hold(axes1,'all');
% % plot1=plot(0:0.001:1,far_interp);
% % set(plot1(1),'DisplayName','FAR');
% % xlabel('threshold t','FontSize',12);
% % ylabel('error probability','FontSize',12);
% % hold on;
% % plot2=plot(0:0.001:1,frr_interp,'Color','red');
% % set(plot2(1),'Color',[1 0 0],'DisplayName','FRR');
% % legend5 = legend(axes1,'show');
% % set(legend5,'Position',[0.152380952380951 0.684126984126991 0.15 0.1]);
% % 
% % %cerchiamo il valore di intersezione tra FAR e FRR
% % dimensione=size(far_interp); % CALCOLO RIGA E COLONNE MATRICE
% % dimensionecolonne=dimensione(2);
% % 
% % for i=1:dimensionecolonne
% %     EER_Y(1,i)=abs((far_interp(1,i)-frr_interp(1,i)))/2;
% %     EER_X(1,i)=i*0.001;
% % end
% % 
% % [eer_y_3D eer_x2]=min(EER_Y);
% % eer_x_MW=(eer_x2-1)*0.001;  %soglia
% % eer_y_MW=far_interp(eer_x2);%probabilità di errore
% % 
% % save('EER_MW.mat','eer_x_MW','eer_y_MW');
% % 
% % %DET Curve
% % vettore_far_mw=vettore_FAR.*100;
% % vettore_frr_mw=vettore_FRR.*100;
% % vettore_gmr_mw=(1-vettore_FRR).*100;
% 
% %%%%%%%%%%%%%%%%%%GRAFICI PER ML%%%%%%%%%%%%%%%%%%%%%%%%%%
% TabGenML = cell2table(tabellaGenuinoML, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% TabImpML = cell2table(tabellaImpostoreML, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% 
% vec_gen=zeros(1,100);
% vec_imp=zeros(1,100);
% 
% dime=size(TabGenML);
% for i=1:dime(1)
%    valore=TabGenML.Score(i);
%    if(valore==0)
%        vec_gen(1,valore+1)=vec_gen(1,valore+1)+1;
%    else 
%        vec_gen(1,valore)=vec_gen(1,valore)+1;
%    end
% end
% 
% dime=size(TabImpML);
% for i=1:dime(1)
%    valore=TabImpML.Score(i);
%    if(valore==0)
%        vec_imp(1,valore+1)=vec_imp(1,valore+1)+1;
%    else
%         vec_imp(1,valore)=vec_imp(1,valore)+1;
%    end
% end
% 
% %normalizziamo le curve
% max_genuino=max(vec_gen);
% vett_norm_genuino=vec_gen/max_genuino;
% max_impostore=max(vec_imp);
% vett_norm_impostore=vec_imp/max_impostore;
% 
% approssimazione= 0.01;
% intervalli= 1/approssimazione;
% %raffiguriamo le ricorrenze degli score degli impostori e dei genuini NORMALIZZATI
% figure1=figure;
% axes1 = axes('Parent',figure1,'FontSize',10);
% xlim(axes1,[0 1]);
% ylim(axes1,[0 1.05]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(approssimazione:approssimazione:1,vett_norm_impostore,'Parent',axes1,'LineWidth',1.5);
% set(plot1(1),'DisplayName','Impostor');
% xlabel('Score','FontSize',12,'FontName','Times New Roman');
% ylabel('Normalized Frequency','FontSize',12,'FontName','Times New Roman');
% hold on;
% plot2=plot(approssimazione:approssimazione:1,vett_norm_genuino,'Color','red','LineWidth',1.5);
% set(plot2(1),'Color',[1 0 0],'DisplayName','Genuine');
% legend1 = legend(axes1,'show');
% set(legend1,'Location','NorthWest');
% title('ML','fontweight', 'bold','FontSize',12);
% set(0,'defaultAxesFontName', 'Times New Roman');
% 
% %calcoliamo il FAR
% indice=0;
% for soglia=0:approssimazione:1
%     indice=indice+1;
%     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
%         somma=0;
%         for i=1:(soglia/approssimazione)
%             if(vec_imp(1,i)>0)
%                 somma=somma+vec_imp(1,i);
%             end
%         end
%         vettore_FAR(1,indice)=(sum(vec_imp)-somma)/sum(vec_imp);
%     else
%         vettore_FAR(1,indice)=1;
%     end
% end
% 
% %calcoliamo il FRR
% indice=0;
% for soglia=0:approssimazione:1
%     indice=indice+1;
%     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
%         somma=0;
%         for i=1:(soglia/approssimazione)
%             if(vec_gen(1,i)>0)
%                 somma=somma+vec_gen(1,i);
%             end
%         end
%         vettore_FRR(1,indice)=somma/sum(vec_gen);
%     else
%         vettore_FRR(1,indice)=0;
%     end
% end
% 
% %raffigriamo FAR e FRR insieme INTERPOLATI
% far_interp=interp1(1:intervalli+1,vettore_FAR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% frr_interp=interp1(1:intervalli+1,vettore_FRR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% figure2=figure;
% axes1 = axes('Parent',figure2);
% ylim(axes1,[0 1.05]);
% xlim(axes1,[0 1]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(0:0.001:1,far_interp,'LineWidth',2.5);
% set(plot1(1),'DisplayName','FAR');
% xlabel('Threshold','FontSize',12,'FontName','Times New Roman');
% ylabel('Error Probability','FontSize',12,'FontName','Times New Roman');
% hold on;
% plot2=plot(0:0.001:1,frr_interp,'Color','red', 'LineWidth',2.5);
% set(plot2(1),'Color',[1 0 0],'DisplayName','FRR');
% legend5 = legend(axes1,'show');
% set(legend5,'Position',[0.152380952380951 0.684126984126991 0.15 0.1]);
% title('ML','fontweight', 'bold','FontSize',12);
% 
% %cerchiamo il valore di intersezione tra FAR e FRR
% dimensione=size(far_interp); % CALCOLO RIGA E COLONNE MATRICE
% dimensionecolonne=dimensione(2);
% 
% for i=1:dimensionecolonne
%     EER_Y(1,i)=abs((far_interp(1,i)-frr_interp(1,i)))/2;
%     EER_X(1,i)=i*0.001;
% end
% 
% [eer_y_3D eer_x2]=min(EER_Y);
% eer_x_ML=(eer_x2-1)*0.001;  %soglia
% eer_y_ML=far_interp(eer_x2);%probabilità di errore
% 
% save('EER_ML.mat','eer_x_ML','eer_y_ML');
% 
% %DET Curve
% vettore_far_ml=vettore_FAR.*100;
% vettore_frr_ml=vettore_FRR.*100;
% vettore_gmr_ml=(1-vettore_FRR).*100;
% % figure3=figure;
% % axes1 = axes('Parent',figure3,'FontSize',10,'FontName','Times New Roman');
% % ylim(axes1,[0 16]);
% % xlim(axes1,[0 8]);
% % box(axes1,'on');
% % hold(axes1,'all');
% % plot1=plot(vettore_far,vettore_frr,'Parent',axes1,'LineWidth',1.5);
% % xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
% % ylabel('False Rejection Rate (%)','FontSize',12,'FontName','Times New Roman');
% 
% % EER_x=0.3020;
% % EER_y=0.0019;
% % hold on;
% % plot(EER_x,EER_y,'-ko','MarkerSize',5,'MarkerFaceColor','k');
% 
% 
% %%%%%%%%%%%%%%METODOLOGIA FUSED%%%%%%%%%%%%%%%%%%%%%%
% load EER_MCI.mat;
% load EER_GCI.mat;
% load EER_ST.mat;
% load EER_ML.mat;
% 
% fmci= (1/eer_y_MCI)/( (1/eer_y_MCI)+(1/eer_y_GCI)+(1/eer_y_ST)+(1/eer_y_ML)); 
% fgci= (1/eer_y_GCI)/( (1/eer_y_MCI)+(1/eer_y_GCI)+(1/eer_y_ST)+(1/eer_y_ML));  
% fst=  (1/eer_y_ST)/( (1/eer_y_MCI)+(1/eer_y_GCI)+(1/eer_y_ST)+(1/eer_y_ML)); 
% fml=  (1/eer_y_ML)/( (1/eer_y_MCI)+(1/eer_y_GCI)+(1/eer_y_ST)+(1/eer_y_ML)); 
% 
% for i=1:matchA(1) 
%     AA=table2array(A(i,4));
%     BB=table2array(A(i,5));
%     CC=table2array(A(i,6));
%     DD=table2array(A(i,7));
%     FF=((cell2mat(AA))*fmci) + ((cell2mat(BB))*fgci) + ((cell2mat(CC))*fst) + (DD*fml);
%     A(i,8)=array2table(FF);
% end
% 
% %GRAFICI PER FUSED
% genuino=0;
% impostore=0;
% matchA=size(A);
% for i=1:matchA(1)
%     pri=num2str(cell2mat(A{i,3}));
%     if (pri=='1')
%         genuino=genuino+1;
%         
%         tabellaGenuinoF(genuino,1)={A.Utente1(i)};
%         tabellaGenuinoF(genuino,2)={A.Utente2(i)};
%         scof=A{i,8};
%         sf=round((scof)*100);
%         tabellaGenuinoF(genuino,3)={sf};
%     else
%         impostore=impostore+1;
%         tabellaImpostoreF(impostore,1)={A.Utente1(i)};
%         tabellaImpostoreF(impostore,2)={A.Utente2(i)};
%         scof=A{i,8};
%         if(scof<1 || scof==1)
%             sf=round((scof)*100);
%             tabellaImpostoreF(impostore,3)={sf};
%         else
%             tabellaImpostoreF(impostore,3)={'100'};
%         end
%     end
% end
% 
% TabGenF = cell2table(tabellaGenuinoF, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% TabImpF = cell2table(tabellaImpostoreF, 'VariableNames',{'Utente1' 'Utente2' 'Score'});
% vec_gen=zeros(1,100);
% vec_imp=zeros(1,100);
% 
% dime=size(TabGenF);
% for i=1:dime(1)
%    valore=TabGenF.Score(i);
%    if(valore==0)
%        vec_gen(1,valore+1)=vec_gen(1,valore+1)+1;
%    else 
%        vec_gen(1,valore)=vec_gen(1,valore)+1;
%    end
% end
% 
% dime=size(TabImpF);
% for i=1:dime(1)
%    valore=TabImpF.Score(i);
%    if(valore==0)
%        vec_imp(1,valore+1)=vec_imp(1,valore+1)+1;
%    else
%         vec_imp(1,valore)=vec_imp(1,valore)+1;
%    end
% end
% 
% %normalizziamo le curve
% max_genuino=max(vec_gen);
% vett_norm_genuino=vec_gen/max_genuino;
% max_impostore=max(vec_imp);
% vett_norm_impostore=vec_imp/max_impostore;
% 
% approssimazione= 0.01;
% intervalli= 1/approssimazione;
% %raffiguriamo le ricorrenze degli score degli impostori e dei genuini NORMALIZZATI
% figure1=figure;
% axes1 = axes('Parent',figure1,'FontSize',10);
% xlim(axes1,[0 1]);
% ylim(axes1,[0 1.05]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(approssimazione:approssimazione:1,vett_norm_impostore,'Parent',axes1,'LineWidth',1.5);
% set(plot1(1),'DisplayName','Impostor');
% xlabel('Score','FontSize',12,'FontName','Times New Roman');
% ylabel('Normalized Frequency','FontSize',12,'FontName','Times New Roman');
% hold on;
% plot2=plot(approssimazione:approssimazione:1,vett_norm_genuino,'Color','red','LineWidth',1.5);
% set(plot2(1),'Color',[1 0 0],'DisplayName','Genuine');
% legend1 = legend(axes1,'show');
% set(legend1,'Location','NorthWest');
% title('FUSED','fontweight', 'bold','FontSize',12);
% 
% %calcoliamo il FAR
% indice=0;
% for soglia=0:approssimazione:1
%     indice=indice+1;
%     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
%         somma=0;
%         for i=1:(soglia/approssimazione)
%             if(vec_imp(1,i)>0)
%                 somma=somma+vec_imp(1,i);
%             end
%         end
%         vettore_FAR(1,indice)=(sum(vec_imp)-somma)/sum(vec_imp);
%     else
%         vettore_FAR(1,indice)=1;
%     end
% end
% 
% %calcoliamo il FRR
% indice=0;
% for soglia=0:approssimazione:1
%     indice=indice+1;
%     if(soglia>0) %il vettore 'vettore_ricorrenze_impostori' ha come prima posizione il valore di precisione_approssimazione e non parte da 0
%         somma=0;
%         for i=1:(soglia/approssimazione)
%             if(vec_gen(1,i)>0)
%                 somma=somma+vec_gen(1,i);
%             end
%         end
%         vettore_FRR(1,indice)=somma/sum(vec_gen);
%     else
%         vettore_FRR(1,indice)=0;
%     end
% end
% 
% %raffigriamo FAR e FRR insieme INTERPOLATI
% far_interp=interp1(1:intervalli+1,vettore_FAR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% frr_interp=interp1(1:intervalli+1,vettore_FRR,1:.1:intervalli+1,'cubic'); %0.1 sarebbe dividere per 10 un tratto = 9 punti in più per ogni 2 punti del vettore... (12-1)*9 + 12
% figure2=figure;
% axes1 = axes('Parent',figure2);
% ylim(axes1,[0 1.05]);
% xlim(axes1,[0 1]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(0:0.001:1,far_interp,'LineWidth',2.5);
% set(plot1(1),'DisplayName','FAR');
% xlabel('Threshold','FontSize',12,'FontName','Times New Roman');
% ylabel('Error Probability','FontSize',12,'FontName','Times New Roman');
% hold on;
% plot2=plot(0:0.001:1,frr_interp,'Color','red','LineWidth',2.5);
% set(plot2(1),'Color',[1 0 0],'DisplayName','FRR');
% legend5 = legend(axes1,'show');
% set(legend5,'Position',[0.152380952380951 0.684126984126991 0.15 0.1]);
% title('FUSED','fontweight', 'bold','FontSize',12);
% 
% %cerchiamo il valore di intersezione tra FAR e FRR
% dimensione=size(far_interp); % CALCOLO RIGA E COLONNE MATRICE
% dimensionecolonne=dimensione(2);
% 
% for i=1:dimensionecolonne
%     EER_Y(1,i)=abs((far_interp(1,i)-frr_interp(1,i)))/2;
%     EER_X(1,i)=i*0.001;
% end
% 
% [eer_y_3D eer_x2]=min(EER_Y);
% eer_x_F=(eer_x2-1)*0.001;  %soglia
% eer_y_F=far_interp(eer_x2);%probabilità di errore
% 
% save('EER_F.mat','eer_x_F','eer_y_F');
% vettore_far_f=vettore_FAR.*100;
% vettore_frr_f=vettore_FRR.*100;
% vettore_gmr_f=(1-vettore_FRR).*100;
% 
% %%%%%%%%%%%%%%DET Curves%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure3=figure;
% axes1 = axes('Parent',figure3,'FontSize',10,'FontName','Times New Roman');
% ylim(axes1,[0 16]);
% xlim(axes1,[0 10]);
% box(axes1,'on');
% hold(axes1,'all');
% plot1=plot(vettore_far_mci,vettore_frr_mci,'m','Parent',axes1,'LineWidth',1.5, 'Marker','o','MarkerFaceColor','m','MarkerSize',6);
% set(plot1(1),'DisplayName','MCI');
% xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
% ylabel('False Rejection Rate (%)','FontSize',12,'FontName','Times New Roman');
% hold on;
% plot2=plot(vettore_far_gci,vettore_frr_gci,'b','LineWidth',1.5, 'Marker','>','MarkerFaceColor','b','MarkerSize',5);
% set(plot2(1),'DisplayName','GCI'); 
% hold on;
% plot3=plot(vettore_far_st,vettore_frr_st,'c','LineWidth',1.5, 'Marker','x','MarkerSize',9);
% set(plot3(1),'DisplayName','ST');
% hold on;
% % plot4=plot(vettore_far_mw,vettore_frr_mw,'b','LineWidth',1.5);
% % set(plot4(1),'DisplayName','MW');
% % hold on;
% plot5=plot(vettore_far_ml,vettore_frr_ml,'b','LineWidth',1.5, 'Marker','s','MarkerFaceColor','b','MarkerSize',5);
% set(plot5(1),'DisplayName','ML');
% hold on;
% plot6=plot(vettore_far_f,vettore_frr_f,'r','LineWidth',1.5, 'Marker','x','MarkerSize',9);
% set(plot6(1),'DisplayName','F');
% legend5 = legend(axes1,'show','Location','North');
% hold on;
% x=[0 15];
% y=[0 15];
% plot7=plot(x,y,'k','LineWidth',1.5);
% title('DET Curves','fontweight', 'bold','FontSize',12);
% % EER_x=0.3020;
% % EER_y=0.0019;
% % hold on;
% % plot(EER_x,EER_y,'-ko','MarkerSize',5,'MarkerFaceColor','k');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%ROC Curves%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure8=figure;
% axes1 = axes('Parent',figure8,'FontSize',10);
% plot1=semilogx(vettore_far_mci,vettore_gmr_mci,'m','Parent',axes1,'LineWidth',1.5, 'Marker','o','MarkerFaceColor','m','MarkerSize',6);
% set(plot1(1),'DisplayName','MCI');
% hold on;
% plot2=semilogx(vettore_far_gci,vettore_gmr_gci,'b','LineWidth',1.5, 'Marker','>','MarkerFaceColor','b','MarkerSize',5);
% set(plot2(1),'DisplayName','GCI');
% hold on;
% plot3=semilogx(vettore_far_st,vettore_gmr_st,'c','LineWidth',1.5, 'Marker','x','MarkerSize',9);
% set(plot3(1),'DisplayName','ST');
% hold on;
% % plot4=semilogx(vettore_far_mw,vettore_gmr_mw,'b','LineWidth',1.5);
% % set(plot4(1),'DisplayName','MW');
% % hold on;
% plot5=semilogx(vettore_far_ml,vettore_gmr_ml,'b','LineWidth',1.5, 'Marker','s','MarkerFaceColor','b','MarkerSize',5);
% set(plot5(1),'DisplayName','ML');
% hold on;
% plot6=semilogx(vettore_far_f,vettore_gmr_f,'r','LineWidth',1.5, 'Marker','x','MarkerSize',9);
% set(plot6(1),'DisplayName','F');
% ylim(axes1,[75 100.5]);
% xlim(axes1,[.001 100]);
% box(axes1,'on');
% hold(axes1,'all');
% legend(axes1,'show','Location','SouthEast');
% xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
% ylabel('Genuine Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
% title('ROC Curves','fontweight', 'bold','FontSize',12);
