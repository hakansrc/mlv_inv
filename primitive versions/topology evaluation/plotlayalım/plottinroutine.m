%% sw frekansi versus capacitance   
% normalization deðerleri at 41khz are provided below
load('ripples_caps_sws.mat')
capacitor_a = capacitor_a*0.53;
capacitor_b = capacitor_b*0.55;
capacitor_c = capacitor_c*0.40;
capacitor_d = capacitor_d*0.80;
capacitor_e = capacitor_e*0.60;

% load('Cap_a.mat')
% capacitor_a = Capacitor_values;
load('Cap_b.mat')
capacitor_b = Capacitor_values;
sw_frequency_b = sw_frequencies_all;
load('Cap_c.mat')
capacitor_c = Capacitor_values;
sw_frequency_c = sw_frequencies_all;
load('Cap_d.mat')
capacitor_d = Capacitor_values;
sw_frequency_d = sw_frequencies_all;
load('Cap_e.mat')
sw_frequency_e = sw_frequencies_all;
capacitor_e = Capacitor_values;
capacitor_a = capacitor_a*0.53;
capacitor_b = capacitor_b*0.55;
capacitor_c = capacitor_c*0.40;
capacitor_d = capacitor_d*0.80;
capacitor_e = capacitor_e*0.60;

figure 
plot(sw_frequency_a/1000,capacitor_a*1e6,'Linewidth',1.5);
hold on
plot(sw_frequency_b/1000,2*capacitor_b*1e6,'Linewidth',1.5);
hold on
plot(sw_frequency_c/1000,2*capacitor_c*1e6,'Linewidth',1.5);
hold on
plot(sw_frequency_d/1000,2*capacitor_d*1e6,'Linewidth',1.5);
hold on
plot(sw_frequency_e/1000,2*capacitor_e*1e6,'Linewidth',1.5);
legend('2L-VSI','2L-2S-VSI','2L-2S2P-VSI','3L-VSI','3L-2P-VSI','FontWeight','bold')
xlabel('Switching Frequency (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Capacitance (µF)','FontSize',16,'FontWeight','bold')
title('Switching Frequency vs. Capacitance','FontWeight','bold')
hold off
ylim([0 500])
% xlim([0 100])
% yticks([0 100 200 300 400 500])
set(gca, 'XTick', [0 10 20 30 40 50 60 70 80 90 100])
set(gca,'fontsize',15,'FontWeight','bold')
grid on

%% sw frekansi versus ripplepercent_a 
load('ripples_caps_sws.mat')
figure 
plot(sw_frequency_a/1000,ripplepercent_a,'Linewidth',2);
hold on
plot(sw_frequency_b/1000,ripplepercent_b,'Linewidth',2);
hold on
plot(sw_frequency_c/1000,ripplepercent_c,'Linewidth',2);
hold on
plot(sw_frequency_d/1000,ripplepercent_d,'Linewidth',2);
hold on
plot(sw_frequency_e/1000,ripplepercent_e,'Linewidth',2);
legend('2L-VSI','2L-2S-VSI','2L-2S2P-VSI','3L-VSI','3L-2P-VSI','FontWeight','bold','Location','northwest')
xlabel('Switching Frequency (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Ripple Percent (%)','FontSize',16,'FontWeight','bold')
title('Switching Frequency vs. Ripple Percent','FontWeight','bold')
hold off
xlim([0 100])
ylim([0 1.2])
set(gca, 'YTick', [0 0.2 0.4 0.6 0.8 1 1.2])
set(gca,'fontsize',15,'FontWeight','bold')


%%  sw frekans vs currenthd
load('THDs_DCLrms_sws.mat')
figure
plot(sw_frequency_A/1000,THD_Ia_A,'Linewidth',3)
hold on
plot(sw_frequency_B/1000,THD_Ia_B,'Linewidth',3)
hold on
plot(sw_frequency_C/1000,THD_Ia_C,'Linewidth',3)
hold on
plot(sw_frequency_D/1000,THD_Ia_D,'Linewidth',3)
hold on
plot(sw_frequency_E/1000,THD_Ia_E,'Linewidth',3)
legend('2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz','FontWeight','bold')
xlabel('Switching Frequency (kHz)','FontSize',16,'FontWeight','bold')
ylabel('THD (%) ','FontSize',16,'FontWeight','bold')
title('Switching Frequency vs. Line Current THD','FontWeight','bold')
hold off
xlim([0 100])
ylim([0 6])
set(gca, 'YTick', [0 1 2 3 4 5 6])
set(gca,'fontsize',15,'FontWeight','bold')


%% spectrumlar 
load('spectrums.mat')

figure
ploticin(1:350001) = 1;
plot3(ploticin,A_freq_10khz/1000,A_DCLINK_Current_Spectrum_10khz,'LineWidth',1.5)
hold on
plot3(2*ploticin,B_freq_51khz/1000,B_DCLINK_Current_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(3*ploticin,C_freq_51khz/1000,C_DCLINK_Current_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(4*ploticin,D_freq_51khz/1000,D_DCLINK_Current_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(5*ploticin,E_freq_51khz/1000,E_DCLINK_Current_Spectrum_51khz,'LineWidth',1.5)
view(45,25)
% legend('2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz','FontWeight','bold')
title('DCLINK Current Spectrum','FontSize',16)
set(gca, 'YTick', [0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]*10^2 )
set(gca,'XTick', [1 2 3 4 5])
set(gca,'XTicklabel',{'2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz'});
% XTick([1 2 3 4 5])

set(gca,'fontsize',12,'FontWeight','bold')
% xlabel('Switching Frequency (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Frequency (kHz)','FontSize',16,'FontWeight','bold')
zlabel('Magnitude','FontSize',16,'FontWeight','bold')

grid on
zlim([0 10])
view([3*pi 10 20])


hold off

%%
figure
ploticin(1:350001) = 1;
A_DCLINK_Voltage_Spectrum_10khz(1) = 0;
B_DCLINK_Voltage_Spectrum_51khz(1) = 0;
C_DCLINK_Voltage_Spectrum_51khz(1) = 0;
D_DCLINK_Voltage_Spectrum_51khz(1) = 0;
E_DCLINK_Voltage_Spectrum_51khz(1) = 0;
plot3(ploticin,A_freq_10khz/1000,A_DCLINK_Voltage_Spectrum_10khz,'LineWidth',4)
hold on
plot3(2*ploticin,B_freq_51khz/1000,B_DCLINK_Voltage_Spectrum_51khz,'LineWidth',4)
hold on
plot3(3*ploticin,C_freq_51khz/1000,C_DCLINK_Voltage_Spectrum_51khz,'LineWidth',4)
hold on
plot3(4*ploticin,D_freq_51khz/1000,D_DCLINK_Voltage_Spectrum_51khz,'LineWidth',4)
hold on
plot3(5*ploticin,E_freq_51khz/1000,E_DCLINK_Voltage_Spectrum_51khz,'LineWidth',4)
view(45,25)
% legend('2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz','FontWeight','bold')
title('DCLINK Voltage Spectrum Except for the DC Component','FontSize',16)
set(gca, 'YTick', [0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]*10^2 )
xlim([1 5])
set(gca,'XTick', [1 2 3 4 5])
set(gca,'XTicklabel',{'2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz'});
grid on
GridStyle.LineWidth = 2.5;
ylabel('Frequency (kHz)','FontSize',16,'FontWeight','bold')
zlabel('Magnitude','FontSize',16,'FontWeight','bold')
set(gca,'fontsize',12,'FontWeight','bold')

zlim([0 5])
view([3*pi 10 20])

hold off
%%

figure
ploticin(1:350001) = 1;
plot3(ploticin,A_freq_10khz/1000,A_Vab_Spectrum_10khz,'LineWidth',1.5)
hold on
plot3(2*ploticin,B_freq_51khz/1000,B_Vab_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(3*ploticin,C_freq_51khz/1000,C_Vab_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(4*ploticin,D_freq_51khz/1000,D_Vab_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(5*ploticin,E_freq_51khz/1000,E_Vab_Spectrum_51khz,'LineWidth',1.5)
% legend('2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz','FontWeight','bold')
title('Vab Spectrum','FontSize',16)
set(gca, 'YTick', [0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]*10^2 )
xlim([1 5])
set(gca,'XTick', [1 2 3 4 5])
set(gca,'XTicklabel',{'2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz'});
grid on
ylabel('Frequency (kHz)','FontSize',16,'FontWeight','bold')
zlabel('Magnitude','FontSize',16,'FontWeight','bold')
set(gca,'fontsize',12,'FontWeight','bold')

zlim([0 500])
view([5*pi 25 15])

hold off

%% 

figure
ploticin(1:350001) = 1;
plot3(ploticin,A_freq_10khz/1000,A_Ia_Spectrum_10khz,'LineWidth',1.5)
hold on
plot3(2*ploticin,B_freq_51khz/1000,B_Ia_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(3*ploticin,C_freq_51khz/1000,C_Ia_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(4*ploticin,D_freq_51khz/1000,D_Ia_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(5*ploticin,E_freq_51khz/1000,E_Ia_Spectrum_51khz,'LineWidth',1.5)
% legend('2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz','FontWeight','bold')
title('Ia Spectrum','FontSize',16)
set(gca, 'YTick', [0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]*10^2 )
xlim([1 5])
set(gca,'XTick', [1 2 3 4 5])
set(gca,'XTicklabel',{'2L-VSI 10kHz','2L-2S-VSI 50kHz','2L-2S2P-VSI 50kHz','3L-VSI 50kHz','3L-2P-VSI 50kHz'});
grid on
ylabel('Frequency (kHz)','FontSize',16,'FontWeight','bold')
zlabel('Magnitude','FontSize',16,'FontWeight','bold')
set(gca,'fontsize',12,'FontWeight','bold')

% zlim([0 500])
view([5*pi 25 15])



















