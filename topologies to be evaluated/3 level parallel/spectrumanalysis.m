%% module 1&2 are in series and 3&4 are in parallel with them respectrively
% clear
cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\3 level parallel')
open_system('three_levelparallel_spwm.slx');
%simOut = sim('two_level_series_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
N = 2^20;
set_param('three_levelparallel_spwm/Switches2','commented','off')
set_param('three_levelparallel_spwm/Load2','commented','off')


%% values of the signals
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 2050; %Hz
interleaving_angle = 180; %degrees
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 0.5/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 0.5; %duration of the model
set_param('three_levelparallel_spwm', 'StopTime', 'stop_time')  % duration of the simulation
set_param('three_levelparallel_spwm/powergui','SampleTime','Sampling_time'); % sampling frequency of the simulation

set_param('three_levelparallel_spwm/Switches1/Subsystem/PhaseA_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('three_levelparallel_spwm/Switches1/Subsystem/PhaseB_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('three_levelparallel_spwm/Switches1/Subsystem/PhaseC_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves

set_param('three_levelparallel_spwm/Switches2/Subsystem/PhaseA_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('three_levelparallel_spwm/Switches2/Subsystem/PhaseB_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('three_levelparallel_spwm/Switches2/Subsystem/PhaseC_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
%% Load&Source settings
Load_Real_Power = 8500; %W
Load_Inductive_Power = 4116; %VAr 
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = 50; %Hz
DCLINK_Cap1 = 100e-6; %Farads
DCLINK_Cap2 = 100e-6; %Farads

set_param('three_levelparallel_spwm/Load1','activePower','Load_Real_Power/2');
set_param('three_levelparallel_spwm/Load1','InductivePower','Load_Inductive_Power/2');
set_param('three_levelparallel_spwm/Load1','nominalfrequency','Load_Nominal_Freq');

set_param('three_levelparallel_spwm/Load2','activePower','Load_Real_Power/2');
set_param('three_levelparallel_spwm/Load2','InductivePower','Load_Inductive_Power/2');
set_param('three_levelparallel_spwm/Load2','nominalfrequency','Load_Nominal_Freq');

set_param('three_levelparallel_spwm/DC Voltage Source','amplitude','DC_Voltage_Source');
set_param('three_levelparallel_spwm/DCLINK_Cap1','capacitance','DCLINK_Cap1')
set_param('three_levelparallel_spwm/DCLINK_Cap2','capacitance','DCLINK_Cap2')

set_param('three_levelparallel_spwm/Switches1/Subsystem/Carrier_signal1','freq','sw_frequency','phase','0'); % setting freq value of the carrier
set_param('three_levelparallel_spwm/Switches1/Subsystem/Carrier_signal2','freq','sw_frequency','phase','0'); % setting freq value of the carrier
set_param('three_levelparallel_spwm/Switches2/Subsystem/Carrier_signal1','freq','sw_frequency','phase','interleaving_angle'); % setting freq value of the carrier
set_param('three_levelparallel_spwm/Switches2/Subsystem/Carrier_signal2','freq','sw_frequency','phase','interleaving_angle'); % setting freq value of the carrier

% simOut = sim('three_levelparallel_spwm.slx'); %run the simulation
threelevelspwm_p = sim('three_levelparallel_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');

% figure
% plot(Phase_currents.time,[Phase_currents.signals(1).values]);



%% Spectrum of Ia1
% Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
Ia1_Spectrum = fft(threelevelspwm_p.get('Phase_currents_load1').signals(1).values,N*2);
Ia1_Spectrum_abs = abs(Ia1_Spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

Ia1_Spectrum_abs =Ia1_Spectrum_abs/max(Ia1_Spectrum_abs); % normalization
figure;
semilogy(freq,Ia1_Spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Ia1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% figure;
% plot(numel(phase(Y)),phase(Y))                           % Plot the phase of the samples of CTFT of the audio signal
% ylabel('Phase (radians)');
% xlabel('Frequency (Hz)');
% % axis([0 4000 10^-4 1])      
%% Spectrum of Ia2
% Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
Ia2_Spectrum = fft(threelevelspwm_p.get('Phase_currents_load2').signals(1).values,N*2);
Ia2_Spectrum_abs = abs(Ia2_Spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

Ia2_Spectrum_abs =Ia2_Spectrum_abs/max(Ia2_Spectrum_abs); % normalization
figure;
semilogy(freq,Ia2_Spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Ia2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% figure;
% plot(numel(phase(Y)),phase(Y))                           % Plot the phase of the samples of CTFT of the audio signal
% ylabel('Phase (radians)');
% xlabel('Frequency (Hz)');
% % axis([0 4000 10^-4 1])    
%% Spectrum of DCLINK_current
% Fs = numel(DCLINK_current.data);  %Sampling Frequency
DCLINK_current_spectrum = fft(threelevelspwm_p.get('DCLINK_current').data,N*2);
DCLINK_current_spectrum_abs = abs(DCLINK_current_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK_current_spectrum_abs = DCLINK_current_spectrum_abs/max(DCLINK_current_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK_current');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of DCLINK_voltage
% Fs = numel(DCLINK_voltage.data);  %Sampling Frequency
DCLINK_voltage_spectrum = fft(threelevelspwm_p.get('DCLINK_voltage').data,N*2);
DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK_voltage_spectrum_abs = DCLINK_voltage_spectrum_abs/max(DCLINK_voltage_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK1_voltage');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of VAB1 only
% Fs = numel(LL1_voltages.signals(1).values);  %Sampling Frequency
LL1_voltages_spectrum = fft(threelevelspwm_p.get('LL1_voltages').signals(1).values,N*2);
LL1_voltages_spectrum_abs = abs(LL1_voltages_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

LL1_voltages_spectrum_abs = LL1_voltages_spectrum_abs/max(LL1_voltages_spectrum_abs); % normalization
figure;
semilogy(freq,LL1_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Vab1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of VAB2 only
% Fs = numel(LL2_voltages.signals(1).values);  %Sampling Frequency
LL2_voltages_spectrum = fft(threelevelspwm_p.get('LL2_voltages').signals(1).values,N*2);
LL2_voltages_spectrum_abs = abs(LL2_voltages_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

LL2_voltages_spectrum_abs = LL2_voltages_spectrum_abs/max(LL2_voltages_spectrum_abs); % normalization
figure;
semilogy(freq,LL2_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Vab2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%% Spectrum of Ineutral
% Fs = numel(LL2_voltages.signals(1).values);  %Sampling Frequency
Ineutral_spectrum = fft(threelevelspwm_p.get('Ineutral').data,N*2);
Ineutral_spectrum_abs = abs(Ineutral_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

Ineutral_spectrum_abs = Ineutral_spectrum_abs/max(Ineutral_spectrum_abs); % normalization
figure;
semilogy(freq,Ineutral_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Ineutral');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% plotting of THD's
figure
subplot(2,2,1);
plot(threelevelspwm_p.get('THD_Ia1').time, 100*threelevelspwm_p.get('THD_Ia1').data)
title('THD of Ia1');
xlabel('Time(sec)');
ylabel('THD (%)');

subplot(2,2,2);
plot(threelevelspwm_p.get('THD_Vab1').time, 100*threelevelspwm_p.get('THD_Vab1').data)
title('THD of Vab1');
xlabel('Time(sec)');
ylabel('THD (%)');

subplot(2,2,3);
plot(threelevelspwm_p.get('THD_Ia2').time, 100*threelevelspwm_p.get('THD_Ia2').data)
title('THD of Ia2');
xlabel('Time(sec)');
ylabel('THD (%)');

subplot(2,2,4);
plot(threelevelspwm_p.get('THD_Vab2').time, 100*threelevelspwm_p.get('THD_Vab2').data)
title('THD of Vab2');
xlabel('Time(sec)');
ylabel('THD (%)');


close_system('two_level_seriesparallel_spwm.slx',true);



