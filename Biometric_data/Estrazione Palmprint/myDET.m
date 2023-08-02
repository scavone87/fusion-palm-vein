% DET Curve
vettore_far_ml=vettore_FAR.*100;
vettore_frr_ml=vettore_FRR.*100;

plot1=plot(vettore_far_ml,vettore_frr_ml);
xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
ylabel('False Rejection Rate (%)','FontSize',12,'FontName','Times New Roman');
hold on;
%x=[0 length(vettore_far_ml)*2/3];
%y=[0 length(vettore_frr_ml)*2/3];
%plot7=plot(x,y,'k','LineWidth',0.1);
%hold on;

%retta_x=0:0.001:0.6134;
%hold on;
%plot(retta_x,0.6134,'k','LineWidth',0.001);