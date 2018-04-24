cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated')
% open_system('all_topologies.slx');
clear
%% initialization for all topologies
global ma ref_frequency sw_frequency Sampling_time Fs stop_time
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 1000; %Hz
Sampling_time = 1e-7; %sampling frequency of the model
Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 1; %duration of the model
%%
global topology_type np ns
% topology_type = input('Please specify the topology type','s');
topology_type = 'A';
[np ns] = topology_decider(topology_type);
Pout = 8000;
[Vin, Poutm, Ls, Ef, Efm, Vdc, Vdcm, Is, Xs, Vtln, Vtll, ma, delta, Load_Angle, pf, intangle1, intangle2, intangle3, intangle4, ...
    Lsm, THD_mean_frequency,Load_Nominal_Freq] = loadsourcesettings(topology_type,ns,np,Pout);


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
% startfreq = 2000;
% stopfreq = 100000;
% increment = 2000;
% for sw_frequency = startfreq:increment:stopfreq
%     DCLINK_Cap = capacitorselection(Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,Lsm,Efm);
%     tic
%     loopdecider(startfreq,stopfreq,increment,topology_type,Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,...
%         Lsm,Efm,dclink_cur_rms,...
%         dclink_volt_mean,dclink_cur_waveform,dclink_vol_waveform,...
%         phase_current_waveforms,phase_current_THD,pp_voltage_waveforms,pp_voltage_THD,switch_waveforms,all_modules,scopes);
%     toc
%     sw_frequency
% end
%% power variation
startpower = 6000; %W
endpower = 8000; %W
increment = 2000; %w
for a=3:1:5
    switch a
        case 1
            topology_type = 'A';
        case 2
            topology_type = 'B';
        case 3
            topology_type = 'C';
        case 4
            topology_type = 'D';
        case 5
            topology_type = 'E';
    end
    if topology_type =='A'
        sw_frequency = 10000;
    else
        sw_frequency = 50000;
    end
    for Pout = startpower:increment:endpower
        [np ns] = topology_decider(topology_type);
        topology_type
        DCLINK_Cap = capacitorselection(Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,Lsm,Efm);
        [Vin, Poutm, Ls, Ef, Efm, Vdc, Vdcm, Is, Xs, Vtln, Vtll, ma, delta, Load_Angle, pf, intangle1, intangle2, intangle3, intangle4, ...
            Lsm, THD_mean_frequency,Load_Nominal_Freq] = loadsourcesettings(topology_type,ns,np,Pout);
        dataselector(topology_type,dclink_cur_rms,...
            dclink_volt_mean,dclink_cur_waveform,dclink_vol_waveform,...
            phase_current_waveforms,phase_current_THD,pp_voltage_waveforms,pp_voltage_THD,switch_waveforms,all_modules,scopes) ;
        powervariation(Pout,sw_frequency,topology_type)
    end
    
end

%% spectrum trials
%     N = numel(A_Phase_currents1.signals.values(:,1));
%     LLab1_voltages_spectrum = fft(A_Phase_currents1.signals.values(:,1),N)/(0.5*N);
%     LLab1_voltages_spectrum_abs = abs(LLab1_voltages_spectrum(1:(N/2+1)));
% %     LLbc1_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(2).values,N)/(0.5*N);
% %     LLbc1_voltages_spectrum_abs = abs(LLbc1_voltages_spectrum(1:(N/2+1)));
% %     LLca1_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(3).values,N)/(0.5*N);
% %     LLca1_voltages_spectrum_abs = abs(LLca1_voltages_spectrum(1:(N/2+1)));
% %
%     freq = (0:(N/2))*Fs/N;
%     semilogy(freq,LLab1_voltages_spectrum_abs)
%     %%
%     N = numel(A_DCLINK_current.signals.values(6000000:end));
%     DCLINK_current_spectrum =fft(A_DCLINK_current.signals.values(6000000:end),N)/(0.5*N);
%     DCLINK_current_spectrum_abs = abs(DCLINK_current_spectrum(1:(N/2+1)));
%         freq = (0:(N/2))*Fs/N;
%     semilogy(freq,DCLINK_current_spectrum_abs)
%
% %% taking only one cycle
%
% plot(A_Phase_currents1.time(9800000:end),A_Phase_currents1.signals.values(9800000:end,1))
%



