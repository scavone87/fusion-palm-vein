%     close all;
%     clear all;
%     clc;

%     intervalli=1/0.01;
%     [fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file  media 2D .mat FAR');
%     [fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file media 2D .mat FRR');
%     far_2D = load(strcat(pathFAR, fileFAR));
%     frr_2D = load(strcat(pathFRR, fileFRR));
% 
%     %DET CURVE 1
     vettore_far_m1_2D = far_2D.vettore_FAR;  
      vettore_frr_m1_2D = frr_2D.vettore_FRR;
     %vettore_far_m1_2D = [vettore_far_m1_2D(1) vettore_far_m1_2D(2) vettore_far_m1_2D(60) vettore_far_m1_2D(83) vettore_far_m1_2D(84)];
     %vettore_frr_m1_2D = [vettore_frr_m1_2D(1) vettore_frr_m1_2D(2) vettore_frr_m1_2D(60) vettore_frr_m1_2D(83) vettore_frr_m1_2D(84)]; 
%      vettore_far_m1_2D =interp1(vettore_far_m1_2D,1:0.001:intervalli+1,'makima'); 
%     
%      vettore_frr_m1_2D =interp1(vettore_frr_m1_2D,1:0.001:intervalli+1,'makima'); 
% %    vettore_gmr_m1_2D=(1-frr_2D).*100;
% 
%     [fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file media 3D .mat FAR');
%     [fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file media 3D .mat FRR');
%     far_3D = load(strcat(pathFAR, fileFAR));
%     frr_3D = load(strcat(pathFRR, fileFRR));
%     
%     %DET Curve 2
%     vettore_far_m1_3D=far_3D.vettore_FAR.*100;
%    vettore_far_m1_3D= interp1(1:intervalli+1,vettore_far_m1_3D,1:.1:intervalli+1,'cubic'); 
%     vettore_frr_m1_3D=frr_3D.vettore_FRR.*100;
%     vettore_frr_m1_3D=interp1(1:intervalli+1,vettore_frr_m1_3D,1:.1:intervalli+1,'cubic'); 
%   
%     % 
%     [fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file  media+srad 2D .mat FAR');
%     [fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file media+srad 2D .mat FRR');
%     far_2D_2 = load(strcat(pathFAR, fileFAR));
%     frr_2D_2 = load(strcat(pathFRR, fileFRR));
%     
%     %DET Curve 3
     vettore_far_m2_2D=far_2D_2.vettore_FAR;
     vettore_far_m2_2D=interp1(vettore_far_m2_2D,1:1:intervalli+1,'makima'); 
     vettore_frr_m2_2D=frr_2D_2 .vettore_FRR;
     vettore_frr_m2_2D=interp1(vettore_frr_m2_2D,1:1:intervalli+1,'makima'); 
%     
%     [fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file  media+srad 3D .mat FAR');
%     [fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file media+srad 3D .mat FRR');
%     far_3D_2 = load(strcat(pathFAR, fileFAR));
%     frr_3D_2 = load(strcat(pathFRR, fileFRR));
%     %DET Curve 4
%     vettore_far_m2_3D=far_3D_2.vettore_FAR.*100;
%     vettore_far_m2_3D=interp1(1:intervalli+1,vettore_far_m2_3D,1:.1:intervalli+1,'cubic');
%     vettore_frr_m2_3D=frr_3D_2.vettore_FRR.*100;
%     vettore_frr_m2_3D =interp1(1:intervalli+1,vettore_frr_m2_3D,1:.1:intervalli+1,'cubic');
%     
%     [fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file  ridler 2D .mat FAR');
%     [fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file ridler 2D .mat FRR');
%     far_2D_3 = load(strcat(pathFAR, fileFAR));
%     frr_2D_3 = load(strcat(pathFRR, fileFRR));
%     
%     %DET Curve 5
     vettore_far_m3_2D=far_2D_3.vettore_FAR;
      vettore_far_m3_2D=interp1(vettore_far_m3_2D,1:.001:intervalli+1,'makima');
    vettore_frr_m3_2D=frr_2D_3.vettore_FRR;
      vettore_frr_m3_2D=interp1( vettore_frr_m3_2D,1:.001:intervalli+1,'makima');
%     % 
%     [fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file  ridler 3D .mat FAR');
%     [fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file ridler 3D .mat FRR');
%     far_3D_3 = load(strcat(pathFAR, fileFAR));
%     frr_3D_3 = load(strcat(pathFRR, fileFRR));
%     
%     %DET Curve 6
%     vettore_far_m3_3D=far_3D_3.vettore_FAR.*100;
%     vettore_far_m3_3D =interp1(1:intervalli+1,  vettore_far_m3_3D,1:.1:intervalli+1,'cubic');
%     vettore_frr_m3_3D=frr_3D_3.vettore_FRR.*100;
%     vettore_frr_m3_3D=interp1(1:intervalli+1,vettore_frr_m3_3D,1:.1:intervalli+1,'cubic');
%     
%     [fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file  ridler+srad 2D .mat FAR');
%     [fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file ridler+srad 2D .mat FRR');
%     far_2D_4 = load(strcat(pathFAR, fileFAR));
%     frr_2D_4 = load(strcat(pathFRR, fileFRR));
%     
%     %DET Curve 7
     vettore_far_m4_2D=far_2D_4.vettore_FAR;
   vettore_far_m4_2D =interp1(1:intervalli+1,vettore_far_m4_2D,1:.001:intervalli+1,'makima');
    vettore_frr_m4_2D=frr_2D_4.vettore_FRR;
    vettore_frr_m4_2D=interp1(1:intervalli+1,vettore_frr_m4_2D,1:.001:intervalli+1,'makima');
%     
%     [fileFAR, pathFAR] = uigetfile('*.mat','Seleziona il file  ridler+srad 3D .mat FAR');
%     [fileFRR, pathFRR] = uigetfile('*.mat','Seleziona il file ridler+srad 3D .mat FRR');
%     far_3D_4 = load(strcat(pathFAR, fileFAR));
%     frr_3D_4 = load(strcat(pathFRR, fileFRR));
% 
%     %DET Curve 8
%     vettore_far_m4_3D=far_3D_4.vettore_FAR.*100;
%     vettore_far_m4_3D =interp1(1:intervalli+1,vettore_far_m4_3D,1:.1:intervalli+1,'cubic');
%     vettore_frr_m4_3D=frr_3D_4.vettore_FRR.*100;
%     vettore_frr_m4_3D=interp1(1:intervalli+1,vettore_frr_m4_3D,1:.1:intervalli+1,'cubic');

    %imposto gli assi
    figure3=figure;
    axes1 = axes('Parent',figure3,'FontSize',10,'FontName','Times New Roman');
    %ylim(axes1,[0 30]);
    ylim(axes1,[0 0.5]);
    %xlim(axes1,[0 25]);
    xlim(axes1,[0 0.5]);
    box(axes1,'on');
    hold(axes1,'all');

    %Grafici curva DET
     plot1=plot(vettore_far_m1_2D,vettore_frr_m1_2D,'Parent',axes1,'LineWidth',1.5,'Color','b');
     hold on;
%     plot2=plot(vettore_far_m1_3D,vettore_frr_m1_3D,'Parent',axes1,'LineWidth',1.5);
%     hold on;
     plot3=plot(vettore_far_m2_2D,vettore_frr_m2_2D,'Parent',axes1,'LineWidth',1.5,'Color','r');
%     hold on;
 %   plot4=plot(vettore_far_m2_3D,vettore_frr_m2_3D,'Parent',axes1,'LineWidth',1.5);
   % hold on;
     plot5=plot(vettore_far_m3_2D,vettore_frr_m3_2D,'Parent',axes1,'LineWidth',1.5,'Color','g');
%     hold on;
%     plot6=plot(vettore_far_m3_3D,vettore_frr_m3_3D,'Parent',axes1,'LineWidth',1.5);
%     hold on;
    plot7=plot(vettore_far_m4_2D,vettore_frr_m4_2D,'Parent',axes1,'LineWidth',1.5,'Color','y');
%     hold on;
 %   plot8=plot(vettore_far_m4_3D,vettore_frr_m4_3D,'Parent',axes1,'LineWidth',1.5);
    hold on;
    f=inline('x');
    x=[0:0.1:30];
    y=f(x);
    plot(x,y);
%     P = InterX([x;y],[vettore_far_m1_3D;vettore_frr_m1_3D]);
    P1= InterX([x;y],[vettore_far_m1_2D;vettore_frr_m1_2D]);
   %  P2 = InterX([x;y],[vettore_far_m2_3D;vettore_frr_m2_3D]);
    P3= InterX([x;y],[vettore_far_m2_2D;vettore_frr_m2_2D]);
%     P4 = InterX([x;y],[vettore_far_m3_3D;vettore_frr_m3_3D]);
    P5= InterX([x;y],[vettore_far_m3_2D;vettore_frr_m3_2D]);
  % P6 = InterX([x;y],[vettore_far_m4_3D;vettore_frr_m4_3D]);
   P7= InterX([x;y],[vettore_far_m4_2D;vettore_frr_m4_2D]);

%     plot(P(1,:),P(2,:),'ro')
%     hold on
     plot(P1(1,:),P1(2,:),'ro')
%     hold on
 %    plot(P2(1,:),P2(2,:),'ro')
%     hold on
   plot(P3(1,:),P3(2,:),'ro')
   % hold on
%     plot(P4(1,:),P4(2,:),'ro')
%     hold on
    plot(P5(1,:),P5(2,:),'ro')
%     hold on
  %  plot(P6(1,:),P6(2,:),'ro')
%     hold on
   plot(P7(1,:),P7(2,:),'ro')
    hold on

    %legend('Media 2D','Media 3D','Srad + Media 2D','Srad + Media 3D','Ridler 2D','Ridler 3D','Srad + Ridler 2D','Srad + Ridler 3D')
    legend('Srad + Media 3D','Srad + Ridler 3D')
   xlabel('False Acceptance Rate (%)','FontSize',12,'FontName','Times New Roman');
    ylabel('False Rejection Rate (%)','FontSize',12,'FontName','Times New Roman');
    title('DET Curves','fontweight', 'bold','FontSize',12);

