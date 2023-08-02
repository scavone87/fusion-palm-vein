% DET Curve
vettore_far_ml=vettore_FAR.*100;
vettore_frr_ml=vettore_FRR.*100;
% 
figure3=figure;
axes1 = axes('Parent',figure3,'FontSize',10,'FontName','Times New Roman');
ylim(axes1,[0 length(vettore_frr_ml)*2/3]);
xlim(axes1,[0 length(vettore_far_ml)*2/3]);
box(axes1,'on');
hold(axes1,'all');
plot1=plot(vettore_far_ml,vettore_frr_ml,'Parent',axes1,'LineWidth',1.5);
xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
ylabel('False Rejection Rate (%)','FontSize',12,'FontName','Times New Roman');
hold on;
x=[0 length(vettore_far_ml)*2/3];
y=[0 length(vettore_frr_ml)*2/3];
plot7=plot(x,y,'k','LineWidth',0.1);
hold on;
% EER_x=0.6134;
% EER_y=0.6134;
% plot(EER_y,EER_y,'-ko','MarkerSize',5,'MarkerFaceColor','k');

retta_x=0:0.001:0.6134;
hold on;
plot(retta_x,0.6134,'k','LineWidth',0.001);

% gtext('EER','FontSize',12,'FontName','Times New Roman');
% gtext('FAR=FRR','FontSize',12,'FontName','Times New Roman');
