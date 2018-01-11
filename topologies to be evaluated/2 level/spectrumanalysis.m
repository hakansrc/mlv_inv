clear
cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\2 level')
open_system('two_level_spwm.slx');
%simOut = sim('two_level_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
N = 2^20;

%% values of the signals
ma = 0.8;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 32250; %Hz
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 0.5/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 0.5; %duration of the model
set_param('two_level_spwm', 'StopTime', 'stop_time')  % duration of the simulation
set_param('two_level_spwm/powergui','SampleTime','Sampling_time'); % sampling frequency of the simulation
set_param('two_level_spwm/Subsystem/PhaseA_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('two_level_spwm/Subsystem/PhaseB_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('two_level_spwm/Subsystem/PhaseC_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
get_param('two_level_spwm/','SimulationTime')
%% Load&Source settings
Load_Real_Power = 8500; %W
Load_Inductive_Power = 4116; %VAr 
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = 50; %Hz
DCLINK_Cap1 = 100e-6; %Farads
DCLINK_Cap2 = 100e-6; %Farads

set_param('two_level_spwm/Load1','activePower','Load_Real_Power');
set_param('two_level_spwm/Load1','InductivePower','Load_Inductive_Power');
set_param('two_level_spwm/Load1','nominalfrequency','Load_Nominal_Freq');
set_param('two_level_spwm/DC Voltage Source','amplitude','DC_Voltage_Source');
set_param('two_level_spwm/DCLINK_Cap1','capacitance','DCLINK_Cap1')
set_param('two_level_spwm/DCLINK_Cap2','capacitance','DCLINK_Cap2')



set_param('two_level_spwm/Subsystem/Carrier_signal','freq','sw_frequency'); % setting freq value of the carrier

simOut = sim('two_level_spwm.slx'); %run the simulation

% figure
% plot(Phase_currents.time,[Phase_currents.signals(1).values]);



%% Spectrum of Ia
% Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
Ia_Spectrum = fft(Phase_currents.signals(1).values,N*2);
Ia_Spectrum_abs = abs(Ia_Spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

Ia_Spectrum_abs =Ia_Spectrum_abs/max(Ia_Spectrum_abs); % normalization
figure;
semilogy(freq,Ia_Spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Ia');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% figure;
% plot(numel(phase(Y)),phase(Y))                           % Plot the phase of the samples of CTFT of the audio signal
% ylabel('Phase (radians)');
% xlabel('Frequency (Hz)');
% % axis([0 4000 10^-4 1])                
%% Spectrum of DCLINK_current
% Fs = numel(DCLINK_current.data);  %Sampling Frequency
DCLINK_current_spectrum = fft(DCLINK_current.data,N*2);
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
DCLINK_voltage_spectrum = fft(DCLINK_voltage.data,N*2);
DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK_voltage_spectrum_abs = DCLINK_voltage_spectrum_abs/max(DCLINK_voltage_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK_voltage');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of VAB only
% Fs = numel(LL_voltages.signals(1).values);  %Sampling Frequency
LL_voltages_spectrum = fft(LL_voltages.signals(1).values,N*2);
LL_voltages_spectrum_abs = abs(LL_voltages_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

LL_voltages_spectrum_abs = LL_voltages_spectrum_abs/max(LL_voltages_spectrum_abs); % normalization
figure;
semilogy(freq,LL_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Vab');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


close_system('two_level_spwm.slx',false);

%% Spectrum of VAN 
% Fs = numel(LN_voltages.signals(1).values);  %Sampling Frequency
LN_voltages_spectrum = fft(LN_voltages.signals(1).values,N*2);
LN_voltages_spectrum_abs = abs(LN_voltages_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

LN_voltages_spectrum_abs = LN_voltages_spectrum_abs/max(LN_voltages_spectrum_abs); % normalization
figure;
semilogy(freq,LN_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Van');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%% plotting of THD's
figure
subplot(3,1,1);
plot(THD_Ia.time, 100*THD_Ia.data)
title('THD of Ia');
xlabel('Time(sec)');
ylabel('THD (%)');
close_system('two_level_spwm.slx',false);

subplot(3,1,2);
plot(THD_Van.time, 100*THD_Van.data)
title('THD of Van');
xlabel('Time(sec)');
ylabel('THD (%)');

subplot(3,1,3);
plot(THD_Vab.time, 100*THD_Vab.data)
title('THD of Vab');
xlabel('Time(sec)');
ylabel('THD (%)');

close_system('two_level_spwm.slx',false);



