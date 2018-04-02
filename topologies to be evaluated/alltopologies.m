cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated')
% open_system('all_topologies.slx');
clear
%% initialization for all topologies
global ma ref_frequency sw_frequency Sampling_time Fs stop_time
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 1050; %Hz
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
phase_current_THD = 1;
pp_voltage_waveforms = 1;
pp_voltage_THD = 1;
switch_waveforms = 1;
dataselector(topology_type,dclink_cur_rms,...
    dclink_volt_mean,dclink_cur_waveform,dclink_vol_waveform,...
    phase_current_waveforms,phase_current_THD,pp_voltage_waveforms,pp_voltage_THD,switch_waveforms) ;
