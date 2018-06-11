clear
topology_type = 'E';
satir = 1;
savename1 = strcat(topology_type,'_diode_currents_',num2str(satir*2),'000Hz');
load(savename1);
savename2 = strcat(topology_type,'_diode_voltages_',num2str(satir*2),'000Hz');
load(savename2);
%%% fitering
minval = min(E_diode_currents.signals.values);
maxval = max(E_diode_currents.signals.values);
peak = (maxval-minval)/2;
dcval = maxval-peak;
filtered_signal = zeros(1,numel(E_diode_currents.signals.values));
for k = 1:numel(E_diode_currents.signals.values)
    if abs(E_diode_currents.signals.values(k)) > 1e-3
        filtered_signal(k) = E_diode_currents.signals.values(k) - dcval;
    else
        filtered_signal(k) = E_diode_currents.signals.values(k);
    end
end

plot(E_diode_currents.signals.values)
% hold on
% plot(filtered_signal)
%

%%
clear
topology_type = 'E';
satir = 20;
savename1 = strcat(topology_type,'_lowersw_currents_',num2str(satir*2),'000Hz');
load(savename1);
savename2 = strcat(topology_type,'_lowersw_voltages_',num2str(satir*2),'000Hz');
load(savename2);
Id = E_lowersw_currents.signals.values;
for la = 1:numel(Id)
    if (Id(la) <= 1e-3)&&(Id(la) >= -1e-3)
        Id(la) = 0;
    end
end
%     minval = min(E_lowersw_currents.signals.values);
maxval = max(Id);
peak = 24.5242/2;
dcval = maxval-peak;
filtered_signal = zeros(1,numel(Id));
for k = 1:numel(Id)
    if abs(Id(k)) > 1e-3
        filtered_signal(k) = Id(k) - dcval;
    else
        filtered_signal(k) = Id(k);
    end
end
plot(Id)
hold on
plot(filtered_signal)

