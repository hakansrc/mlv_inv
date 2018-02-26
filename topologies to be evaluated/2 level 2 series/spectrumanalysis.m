% clear
cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\2 level 2 series')
open_system('two_level_series_spwm.slx');
%simOut = sim('two_level_series_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
N = 2^20;

%% values of the signals
ma = 1;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 2050; %Hz
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 0.5/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 0.5; %duration of the model
set_param('two_level_series_spwm', 'StopTime', 'stop_time')  % duration of the simulation
set_param('two_level_series_spwm/powergui','SampleTime','Sampling_time'); % sampling frequency of the simulation

set_param('two_level_series_spwm/Switches1/Subsystem/PhaseA_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('two_level_series_spwm/Switches1/Subsystem/PhaseB_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('two_level_series_spwm/Switches1/Subsystem/PhaseC_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves

set_param('two_level_series_spwm/Switches2/Subsystem/PhaseA_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('two_level_series_spwm/Switches2/Subsystem/PhaseB_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
set_param('two_level_series_spwm/Switches2/Subsystem/PhaseC_Ref','amplitude','ma','frequency','ref_frequency'); % setting ma and freq values of the ref sine waves
%% Load&Source settings
Load_Real_Power = 8500; %W
Load_Power_Factor = 0.9; 
Load_Apparent_Power = Load_Real_Power/Load_Power_Factor; %VA
Load_Reactive_Power = Load_Apparent_Power*sin(acos(Load_Power_Factor)); %VAr
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = ref_frequency/(2*pi); %Hz

n = 2; %number of series modules
Vll_rms = ma*DC_Voltage_Source*0.612/n;
Iline = Load_Apparent_Power/(Vll_rms*sqrt(3));
Zload = Vll_rms/(Iline*sqrt(3));  %ohm total
Rload = n*Zload*Load_Power_Factor;  %ohm total
Xload = n*Zload*sin(acos(Load_Power_Factor)); %ohm total
Lload = Xload/ref_frequency;
% Load_Inductive_Power = 4116; %VAr 
DCLINK1_Cap = 100e-6; %Farads
DCLINK2_Cap = 100e-6; %Farads

set_param('two_level_series_spwm/twolevelser_load1','Resistance','Rload','Inductance','Lload');
set_param('two_level_series_spwm/twolevelser_load2','Resistance','Rload','Inductance','Lload');
set_param('two_level_series_spwm/twolevelser_load3','Resistance','Rload','Inductance','Lload');

set_param('two_level_series_spwm/twolevelser_load4','Resistance','Rload','Inductance','Lload');
set_param('two_level_series_spwm/twolevelser_load5','Resistance','Rload','Inductance','Lload');
set_param('two_level_series_spwm/twolevelser_load6','Resistance','Rload','Inductance','Lload');

% set_param('two_level_series_spwm/Load1','activePower','Load_Real_Power/2');
% set_param('two_level_series_spwm/Load1','InductivePower','Load_Inductive_Power/2');
% set_param('two_level_series_spwm/Load1','nominalfrequency','Load_Nominal_Freq');
% 
% set_param('two_level_series_spwm/Load2','activePower','Load_Real_Power/2');
% set_param('two_level_series_spwm/Load2','InductivePower','Load_Inductive_Power/2');
% set_param('two_level_series_spwm/Load2','nominalfrequency','Load_Nominal_Freq');

% set_param('two_level_series_spwm/DC Voltage Source','amplitude','DC_Voltage_Source');
set_param('two_level_series_spwm/DCLINK1_Cap','capacitance','DCLINK1_Cap')
set_param('two_level_series_spwm/DCLINK2_Cap','capacitance','DCLINK2_Cap')

Rin = 1; %ohm
Vin = DC_Voltage_Source + Rin*(Load_Real_Power/DC_Voltage_Source);

set_param('two_level_series_spwm/Switches1/Subsystem/Carrier_signal','freq','sw_frequency'); % setting freq value of the carrier
set_param('two_level_series_spwm/Switches2/Subsystem/Carrier_signal','freq','sw_frequency'); % setting freq value of the carrier

% simOut = sim('two_level_series_spwm.slx'); %run the simulation
twolevelspwm_s = sim('two_level_series_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');

% figure
% plot(Phase_currents.time,[Phase_currents.signals(1).values]);



%% Spectrum of Ia1
% Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
Ia1_Spectrum = fft(twolevelspwm_s.get('Phase_currents_load1').signals(1).values,N*2);
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
Ia2_Spectrum = fft(twolevelspwm_s.get('Phase_currents_load2').signals(1).values,N*2);
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
%% Spectrum of DCLINK1_current
% Fs = numel(DCLINK1_current.data);  %Sampling Frequency
DCLINK1_current_spectrum = fft(twolevelspwm_s.get('DCLINK1_current').data,N*2);
DCLINK1_current_spectrum_abs = abs(DCLINK1_current_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK1_current_spectrum_abs = DCLINK1_current_spectrum_abs/max(DCLINK1_current_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK1_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK1_current');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of DCLINK2_current
% Fs = numel(DCLINK2_current.data);  %Sampling Frequency
DCLINK2_current_spectrum = fft(twolevelspwm_s.get('DCLINK2_current').data,N*2);
DCLINK2_current_spectrum_abs = abs(DCLINK2_current_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK2_current_spectrum_abs = DCLINK2_current_spectrum_abs/max(DCLINK2_current_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK2_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK2_current');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of DCLINK1_voltage
% Fs = numel(DCLINK1_voltage.data);  %Sampling Frequency
DCLINK1_voltage_spectrum = fft(twolevelspwm_s.get('DCLINK1_voltage').data,N*2);
DCLINK1_voltage_spectrum_abs = abs(DCLINK1_voltage_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK1_voltage_spectrum_abs = DCLINK1_voltage_spectrum_abs/max(DCLINK1_voltage_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK1_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK1_voltage');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of DCLINK2_voltage
% Fs = numel(DCLINK2_voltage.data);  %Sampling Frequency
DCLINK2_voltage_spectrum = fft(twolevelspwm_s.get('DCLINK2_voltage').data,N*2);
DCLINK2_voltage_spectrum_abs = abs(DCLINK2_voltage_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK2_voltage_spectrum_abs = DCLINK2_voltage_spectrum_abs/max(DCLINK2_voltage_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK2_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK2_voltage');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of VAB1 only
% Fs = numel(LL1_voltages.signals(1).values);  %Sampling Frequency
LL1_voltages_spectrum = fft(twolevelspwm_s.get('LL1_voltages').signals(1).values,N*2);
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
LL2_voltages_spectrum = fft(twolevelspwm_s.get('LL2_voltages').signals(1).values,N*2);
LL2_voltages_spectrum_abs = abs(LL2_voltages_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

LL2_voltages_spectrum_abs = LL2_voltages_spectrum_abs/max(LL2_voltages_spectrum_abs); % normalization
figure;
semilogy(freq,LL2_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Vab2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%% plotting of THD's
figure
subplot(2,2,1);
plot(twolevelspwm_s.get('THD_Ia1').time, 100*twolevelspwm_s.get('THD_Ia1').data)
title('THD of Ia1');
xlabel('Time(sec)');
ylabel('THD (%)');

subplot(2,2,2);
plot(twolevelspwm_s.get('THD_Vab1').time, 100*twolevelspwm_s.get('THD_Vab1').data)
title('THD of Vab1');
xlabel('Time(sec)');
ylabel('THD (%)');

subplot(2,2,3);
plot(twolevelspwm_s.get('THD_Ia2').time, 100*twolevelspwm_s.get('THD_Ia2').data)
title('THD of Ia2');
xlabel('Time(sec)');
ylabel('THD (%)');

subplot(2,2,4);
plot(twolevelspwm_s.get('THD_Vab2').time, 100*twolevelspwm_s.get('THD_Vab2').data)
title('THD of Vab2');
xlabel('Time(sec)');
ylabel('THD (%)');

halfof_timelength = round((numel(twolevelspwm_s.get('DCLINK1_voltage').time))/2);
maxvoltage1 = max(twolevelspwm_s.get('DCLINK1_voltage').data(halfof_timelength:end));
minvoltage1 = min(twolevelspwm_s.get('DCLINK1_voltage').data(halfof_timelength:end));
twolevel_s_DC1Ripple = maxvoltage1 - minvoltage1;
maxvoltage2 = max(twolevelspwm_s.get('DCLINK2_voltage').data(halfof_timelength:end));
minvoltage2 = min(twolevelspwm_s.get('DCLINK2_voltage').data(halfof_timelength:end));
twolevel_s_DC2Ripple = maxvoltage2 - minvoltage2;



% close_system('two_level_series_spwm.slx',false);



