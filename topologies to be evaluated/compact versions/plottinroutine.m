%% sw frekansi versus capacitance   
% normalization deðerleri at 41khz are provided below
% capacitor_a = capacitor_a*0.53;
% capacitor_b = capacitor_b*0.55;
% capacitor_c = capacitor_c*0.40;
% capacitor_d = capacitor_d*0.80;
% capacitor_e = capacitor_e*0.60;
load('ripples_caps_sws.mat')

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
legend('Topology A','Topology B','Topology C','Topology D','Topology E')
xlabel('Switching Frequency (kHz)')
ylabel('Capacitance (µF)')
title('Switching Frequency vs. Capacitance')
hold off
ylim([0 500])

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























