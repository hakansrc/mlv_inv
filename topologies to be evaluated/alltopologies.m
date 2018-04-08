cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated')
% open_system('all_topologies.slx');
clear
%% initialization for all topologies
global ma ref_frequency sw_frequency Sampling_time Fs stop_time
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 1000; %Hz
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 1; %duration of the model
%%
global topology_type np ns
topology_type = input('Please specify the topology type','s');
[np ns] = topology_decider(topology_type);
 
[Vin,Pout, Poutm, Ls, Ef, Efm, Vdc, Vdcm, Is, Xs, Vtln, Vtll, ma, delta, Load_Angle, pf, intangle1, intangle2, intangle3, intangle4, ...
    Lsm, THD_mean_frequency,Load_Nominal_Freq] = loadsourcesettings(topology_type,ns,np); 


DCLINK_Cap = capacitorselection(Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,Lsm,Efm);

%% datas to be collected 0 not to collect, 1 to collect
dclink_cur_rms = 1;
dclink_volt_mean = 1;
dclink_cur_waveform = 1;
dclink_vol_waveform = 1;
phase_current_waveforms = 1;
all_modules = 1; % 0 for one module phase currents and voltage, 1 for all modules phase currents and voltages
scopes = 1; % 0 to comment out scopes, they occupy major space in the ram in the case of long simulations
phase_current_THD = 1;
pp_voltage_waveforms = 1;
pp_voltage_THD = 1;
switch_waveforms = 1;

dataselector(topology_type,dclink_cur_rms,...
    dclink_volt_mean,dclink_cur_waveform,dclink_vol_waveform,...
    phase_current_waveforms,phase_current_THD,pp_voltage_waveforms,pp_voltage_THD,switch_waveforms,all_modules,scopes) ;
%% loop settings
startfreq = 1000;
stopfreq = 100000;
increment = 1000;

%% spectrum trials for continous case
N = numel(A_LL_voltages1.signals.values(:,1));
Fs = N/stop_time;

    Ia1_Spectrum = fft(A_Phase_currents1.signals.values(:,1),N)/(0.5*N);
    Ia1_Spectrum_abs = abs(Ia1_Spectrum(1:(N/2+1)));    
%     Ib1_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(2).values,N)/(0.5*N);
%     Ib1_Spectrum_abs = abs(Ib1_Spectrum(1:(N/2+1)));    
%     Ic1_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(3).values,N)/(0.5*N);
%     Ic1_Spectrum_abs = abs(Ic1_Spectrum(1:(N/2+1)));    
    
    freq = (0:(N/2))*Fs/N; 

plot(freq,Ia1_Spectrum_abs)





