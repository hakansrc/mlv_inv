%% sw frekansi versus capacitance   
% normalization deðerleri at 41khz are provided below
load('ripples_caps_sws.mat')
% capacitor_a = capacitor_a*0.53;
% capacitor_b = capacitor_b*0.55;
% capacitor_c = capacitor_c*0.40;
% capacitor_d = capacitor_d*0.80;
% capacitor_e = capacitor_e*0.60;


figure 
plot(sw_frequency_a/1000,capacitor_a*1e6,'Linewidth',2);
hold on
plot(sw_frequency_b/1000,2*capacitor_b*1e6,'Linewidth',2);
hold on
plot(sw_frequency_c/1000,2*capacitor_c*1e6,'Linewidth',2);
hold on
plot(sw_frequency_d/1000,2*capacitor_d*1e6,'Linewidth',2);
hold on
plot(sw_frequency_e/1000,2*capacitor_e*1e6,'Linewidth',2);
legend('Topology A','Topology B','Topology C','Topology D','Topology E','FontWeight','bold')
xlabel('Switching Frequency (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Capacitance (µF)','FontSize',16,'FontWeight','bold')
title('Switching Frequency vs. Capacitance','FontWeight','bold')
hold off
ylim([0 500])
xlim([0 100])
% yticks([0 100 200 300 400 500])
set(gca, 'YTick', [0 100 200 300 400 500])
set(gca,'fontsize',15,'FontWeight','bold')

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
legend('Topology A','Topology B','Topology C','Topology D','Topology E')
xlabel('Switching Frequency (kHz')
ylabel('Ripple Percent (%)')
title('Switching Frequency vs. Ripple Percent')
hold off

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
legend('Topology A','Topology B','Topology C','Topology D','Topology E')
xlabel('Switching Frequency (kHz)')
ylabel('THD (%) ')
title('Switching Frequency vs. Line Current THD')
hold off

%% spectrumlar 
load('spectrums.mat')

figure
ploticin(1:350001) = 1;
plot3(ploticin,A_freq_10khz,A_DCLINK_Current_Spectrum_10khz,'LineWidth',1.5)
hold on
plot3(2*ploticin,B_freq_51khz,B_DCLINK_Current_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(3*ploticin,C_freq_51khz,C_DCLINK_Current_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(4*ploticin,D_freq_51khz,D_DCLINK_Current_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(5*ploticin,E_freq_51khz,E_DCLINK_Current_Spectrum_51khz,'LineWidth',1.5)
view(45,25)
legend('Topology A 10kHz','Topology B 51kHz','Topology C 51kHz','Topology D 51kHz','Topology E  51kHz')
title('DCLINK Current Spectrum')
hold off

figure
ploticin(1:350001) = 1;
A_DCLINK_Voltage_Spectrum_10khz(1) = 0;
B_DCLINK_Voltage_Spectrum_51khz(1) = 0;
C_DCLINK_Voltage_Spectrum_51khz(1) = 0;
D_DCLINK_Voltage_Spectrum_51khz(1) = 0;
E_DCLINK_Voltage_Spectrum_51khz(1) = 0;
plot3(ploticin,A_freq_10khz,A_DCLINK_Voltage_Spectrum_10khz,'LineWidth',1.5)
hold on
plot3(2*ploticin,B_freq_51khz,B_DCLINK_Voltage_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(3*ploticin,C_freq_51khz,C_DCLINK_Voltage_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(4*ploticin,D_freq_51khz,D_DCLINK_Voltage_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(5*ploticin,E_freq_51khz,E_DCLINK_Voltage_Spectrum_51khz,'LineWidth',1.5)
view(45,25)
legend('Topology A 10kHz','Topology B 51kHz','Topology C 51kHz','Topology D 51kHz','Topology E  51kHz')
title('DCLINK Voltage Spectrum Except for the DC Component')
hold off


figure
ploticin(1:350001) = 1;
plot3(ploticin,A_freq_10khz,A_Vab_Spectrum_10khz,'LineWidth',1.5)
hold on
plot3(2*ploticin,B_freq_51khz,B_Vab_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(3*ploticin,C_freq_51khz,C_Vab_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(4*ploticin,D_freq_51khz,D_Vab_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(5*ploticin,E_freq_51khz,E_Vab_Spectrum_51khz,'LineWidth',1.5)
view(45,25)
legend('Topology A 10kHz','Topology B 51kHz','Topology C 51kHz','Topology D 51kHz','Topology E  51kHz')
title('Phase Voltages Spectrum')
hold off



figure
ploticin(1:350001) = 1;
plot3(ploticin,A_freq_10khz,A_Ia_Spectrum_10khz,'LineWidth',1.5)
hold on
plot3(2*ploticin,B_freq_51khz,B_Ia_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(3*ploticin,C_freq_51khz,C_Ia_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(4*ploticin,D_freq_51khz,D_Ia_Spectrum_51khz,'LineWidth',1.5)
hold on
plot3(5*ploticin,E_freq_51khz,E_Ia_Spectrum_51khz,'LineWidth',1.5)
view(45,25)
legend('Topology A 10kHz','Topology B 51kHz','Topology C 51kHz','Topology D 51kHz','Topology E  51kHz')
title('Phase Currents Spectrum')
hold off























