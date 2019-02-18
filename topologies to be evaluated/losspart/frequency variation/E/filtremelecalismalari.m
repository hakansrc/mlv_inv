topology_type = 'E';
for satir = 1:50;
% for  satir = 1:50;
    savename1 = strcat(topology_type,'_diode_currents_',num2str(satir*2),'000Hz');
    load(savename1);
%     savename2 = strcat(topology_type,'_diode_voltages_',num2str(satir*2),'000Hz');
%     load(savename2);
    Id = E_diode_currents.signals.values;
%     plot(Id)
    hold on
max(Id)
%% filtering
    maxval = max(E_diode_currents.signals.values);
    peak = 12.20;
    dcval = maxval-peak;
    filtered_signal = zeros(1,numel(E_diode_currents.signals.values));
    for k = 1:numel(E_diode_currents.signals.values)
        if abs(E_diode_currents.signals.values(k)) > 1e-3
            filtered_signal(k) = E_diode_currents.signals.values(k) - dcval;
        else
            filtered_signal(k) = E_diode_currents.signals.values(k);
        end
    end
%     figure 
%     plot(filtered_signal)
%     hold on
%     plot(A_sw1_cur.signals.values)
    fprintf('Dc value for %s W is %d\n',savename1,dcval)
    %%
    plot(filtered_signal)
hold on
end
%%  
for satir = 1:50;
%     clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff Econd swon n L Pbottom P_reverse_condbottom ...
%        P_GaNtop P_GaNbottom P_GaNbottom_sw P_Cossbottom Pbottom Erevcond Esw revcond Eon Ts cond Ecoss Eoss Ts
   savename1 = strcat(topology_type,'_lowersw_currents_',num2str(satir*2),'000Hz');
    load(savename1);
        Id(satir,:) = E_lowersw_currents.signals.values;

%     savename2 = strcat(topology_type,'_lowersw_voltages_',num2str(satir*2),'000Hz');
%     load(savename2);
%     plot(Id)
% hold on
%     Id = E_lowersw_currents.signals.values;
% max(Id)
%% filtering
    maxval = max(Id(satir,:));
    peak = 12.20;
    dcval = maxval-peak;
    filtered_signal = zeros(1,numel(Id(satir,:)));
    for la = 1:numel(Id(satir,:))
        if (Id(satir,la) < 0.4)&&(Id(satir,la) > -0.4)
            Id(satir,la) = 0;
        end
    end    
    for k = 1:numel(Id(satir,:))
        if abs(Id(satir,k)) > 0
            filtered_signal(k) = Id(satir,k) - dcval;
        else
            filtered_signal(k) = Id(satir,k);
        end
    end
%     figure 
    plot(filtered_signal)
    hold on
%     plot(A_sw1_cur.signals.values)
    fprintf('Dc value for %s W is %d\n',savename1,dcval)
    %%
%     plot(filtered_signal)
% hold on
end
%%
% figure
plot(filtered_signal)
hold on
plot(Id(1,:))
%%
for satir = 1:50;
%     clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff Econd swon n L Pbottom P_reverse_condbottom ...
%        P_GaNtop P_GaNbottom P_GaNbottom_sw P_Cossbottom Pbottom Erevcond Esw revcond Eon Ts cond Ecoss Eoss Ts
   savename1 = strcat(topology_type,'_uppersw_currents_',num2str(satir*2),'000Hz');
    load(savename1);
        Id = E_uppersw_currents.signals.values;

%     savename2 = strcat(topology_type,'_lowersw_voltages_',num2str(satir*2),'000Hz');
%     load(savename2);
    plot(Id)
hold on
    Id = E_diode_currents.signals.values;
max(Id)
end