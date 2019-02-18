topology_type = 'E';
%% dcl current rms
count = 1;
for sw_frequency = 2000:2000:100000
    savename = strcat(topology_type,'_dclink_cur_rms_',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    dclink_cur_rms(count) = dataload.(strcat(topology_type,'_dclink_cur_rms'));
    
    count = count+1;
end
%% dcl current
count = 1;
for sw_frequency = 2000:2000:100000
    savename = strcat(topology_type,'_dclink_cur_waveform_',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    dclink_cur_waveform(count,:) = dataload.(strcat(topology_type,'_DCL_current'));
    count = count+1;
end
%% dcl voltage
count = 1;
for sw_frequency = 2000:2000:100000
    savename = strcat(topology_type,'_dclink_vol_waveform_',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    dclink_vol_waveform(count,:) = dataload.(strcat(topology_type,'_DCL_voltage'));
    count = count+1;
end
%% dcl voltage mean
count = 1;
for sw_frequency = 2000:2000:100000
    savename = strcat(topology_type,'_dclink_volt_mean_',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    dclink_vol_mean(count) = dataload.(strcat(topology_type,'_dclink_volt_mean'));
    count = count+1;
end
%% current THDs
clear
topology_type = 'E';
count = 1;
endfreq = 100000;
for sw_frequency = 2000:2000:endfreq
    savename = strcat(topology_type,'_Ia1_THD_',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    ia1_thd(count) = dataload.(strcat(topology_type,'_Ia1_THD'));
    count = count+1;
end
sw_frequency = 2000:2000:endfreq
hold on
plot(sw_frequency,100*ia1_thd)
%% voltage THDs
count = 1;
for sw_frequency = 2000:2000:100000
    savename = strcat(topology_type,'_Vab1_THD_',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    vab1_thd(count) = dataload.(strcat(topology_type,'_Vab1_THD'));
    count = count+1;
end
%% phase currents
count = 1;
for sw_frequency = 2000:2000:100000
    savename = strcat(topology_type,'_phasecurrents1_',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    phase_currents(count,:) = dataload.(strcat(topology_type,'_Phase_curs1'));
    count = count +1;
end
%% pp voltages
count = 1;
for sw_frequency = 2000:2000:100000
    savename = strcat(topology_type,'_ppvoltages1_',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    phase_currents(count,:) = dataload.(strcat(topology_type,'_LL_voltages1'));
    count = count +1;
end





