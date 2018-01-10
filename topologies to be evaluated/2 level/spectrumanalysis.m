clear
cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\2 level')
open_system('two_level_spwm.slx');
%simOut = sim('two_level_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
N = 2^20;
ma = 0.8;
ref_frequency = 2*pi*50;
sw_frequency = 2000;
Sampling_time = 50e-6; %sampling frequency of the model
stop_time = 0.5; %duration of the model

set_param('two_level_spwm', 'StopTime', 'stop_time')
set_param('two_level_spwm/powergui','SampleTime','Sampling_time');
set_param('two_level_spwm/Subsystem/PhaseA_Ref','amplitude','ma','frequency','ref_frequency');
set_param('two_level_spwm/Subsystem/PhaseB_Ref','amplitude','ma','frequency','ref_frequency');
set_param('two_level_spwm/Subsystem/PhaseC_Ref','amplitude','ma','frequency','ref_frequency');

set_param('two_level_spwm/Subsystem/Carrier_signal','freq','sw_frequency');

simOut = sim('two_level_spwm.slx');

figure
plot(Phase_currents.time,[Phase_currents.signals(1).values]);



%% Spectrum of Ia
Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
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
Fs = numel(DCLINK_current.data);  %Sampling Frequency
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
Fs = numel(DCLINK_voltage.data);  %Sampling Frequency
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
Fs = numel(LL_voltages.signals(1).values);  %Sampling Frequency
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







