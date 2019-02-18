clear
topology_type = 'D';

satir = 20;
    savename1 = strcat(topology_type,'_diode_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_diode_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
    
         %% fitering
%     minval = min(D_diode_currents.signals.values);
    maxval = max(D_diode_currents.signals.values);
    peak = 24.5242;
    dcval = maxval-peak;
    filtered_signal = zeros(1,numel(D_diode_currents.signals.values));
    for k = 1:numel(D_diode_currents.signals.values)
        if abs(D_diode_currents.signals.values(k)) > 1e-3
            filtered_signal(k) = D_diode_currents.signals.values(k) - dcval;
        else
            filtered_signal(k) = D_diode_currents.signals.values(k);
        end
    end
%     figure 
%     plot(filtered_signal)
%     hold on
%     plot(A_sw1_cur.signals.values)
    fprintf('Dc value for %s W is %d\n',savename1,dcval)
plot(filtered_signal)
hold on
plot( D_diode_currents.signals.values)
    %% fitering
%     topology_type = 'D';
% satir = 20;
    savename1 = strcat(topology_type,'_lowersw_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_lowersw_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
%     minval = min(D_diode_currents.signals.values);
    maxval = max(D_lowersw_currents.signals.values);
    peak = 24.5242;
    dcval = maxval-peak;
    filtered_signal = zeros(1,numel(D_lowersw_currents.signals.values));
    for k = 1:numel(D_lowersw_currents.signals.values)
        if abs(D_lowersw_currents.signals.values(k)) > 1e-3
            filtered_signal(k) = D_lowersw_currents.signals.values(k) - dcval;
        else
            filtered_signal(k) = D_lowersw_currents.signals.values(k);
        end
    end
        fprintf('Dc value for %s  is %d\n',savename1,dcval)
plot(filtered_signal)
figure 
plot(D_lowersw_currents.signals.values)

    