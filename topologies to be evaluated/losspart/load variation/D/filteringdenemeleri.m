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
    filtered_signal = zeros(1,numel(A_sw1_cur.signals.values));
    for k = 1:numel(A_sw1_cur.signals.values)
        if abs(A_sw1_cur.signals.values(k)) > 1e-3
            filtered_signal(k) = A_sw1_cur.signals.values(k) - dcval;
        else
            filtered_signal(k) = A_sw1_cur.signals.values(k);
        end
    end
%     figure 
%     plot(filtered_signal)
%     hold on
%     plot(A_sw1_cur.signals.values)
    fprintf('Dc value for %s W is %d\n',savename1,dcval)
plot(filtered_signal)