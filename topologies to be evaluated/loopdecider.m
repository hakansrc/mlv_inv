function [] = loopdecider(startfreq,stopfreq,increment,topology_type,Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,Lsm,Efm,dclink_cur_rms,...
    dclink_volt_mean,dclink_cur_waveform,dclink_vol_waveform,...
    phase_current_waveforms,phase_current_THD,pp_voltage_waveforms,pp_voltage_THD,switch_waveforms,all_modules,scopes)
for sw_frequency = startfreq:increment:stopfreq
    if topology_type == 'A'
        tic
        DCLINK_Cap = capacitorselection(Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,Lsm,Efm);
%         Topology_A = sim('all_topologies.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
sim('all_topologies.slx');
        if dclink_cur_rms == 1
            savename = strcat('A_dclink_cur_rms_',num2str(sw_frequency),'Hz');
            icaprms = mean(A_DCLINK_current_rms.signals.values(9200000:end));
            save(savename,'icaprms')
        end
        if dclink_volt_mean==1
            savename = strcat('A_dclink_volt_mean_',num2str(sw_frequency),'Hz');
            voltmean = mean(A_DCLINK_voltage_mean.signals.values(9200000:end));
            save(savename,'voltmean')
        end
        if dclink_cur_waveform == 1
            savename = strcat('A_dclink_cur_waveform_',num2str(sw_frequency),'Hz');
            A_DCL_current.signals.values=A_DCLINK_current.signals.values(7000000:end);
            A_DCL_current.time = A_DCLINK_current.time(7000000:end);
            save(savename,'A_DCL_current');
        end
        if dclink_vol_waveform == 1
            savename = strcat('A_dclink_vol_waveform_',num2str(sw_frequency),'Hz');
            A_DCL_voltage.signals.values=A_DCLINK_voltage.signals.values(7000000:end);
            A_DCL_voltage.time = A_DCLINK_voltage.time(7000000:end);
            save(savename,'A_DCL_voltage');
        end
        if phase_current_waveforms==1
           savename = strcat('A_phasecurrents_',num2str(sw_frequency),'Hz');
           A_Phase_currents.signals.values(:,1) = A_Phase_currents1.signals.values(7000000:end,1);
           A_Phase_currents.signals.values(:,2) = A_Phase_currents1.signals.values(7000000:end,2);
           A_Phase_currents.signals.values(:,3) = A_Phase_currents1.signals.values(7000000:end,3);
           A_Phase_currents.time = A_Phase_currents1.time(7000000:end);
           save(savename,'A_Phase_currents')
        end
        if phase_current_THD == 1
            savename = strcat('A_current_THD_',num2str(sw_frequency),'Hz');
            THDmean = mean(A_THD_Ia1.signals.values(9200000:end));
            save(savename,'THDmean');
        end
        if pp_voltage_THD == 1
            savename = strcat('A_voltage_THD_',num2str(sw_frequency),'Hz');
            THDmean = mean(A_THD_Vab1.signals.values(9200000:end));
            save(savename,'THDmean');
        end
        if pp_voltage_waveforms == 1
            savename = strcat('A_ppvoltages_',num2str(sw_frequency),'Hz');
            A_LL_voltages.signals.values(:,1) = A_LL_voltages1.signals.values(7000000:end,1);
            A_LL_voltages.signals.values(:,2) = A_LL_voltages1.signals.values(7000000:end,2);
            A_LL_voltages.signals.values(:,3) = A_LL_voltages1.signals.values(7000000:end,3);
            A_LL_voltages.time = A_LL_voltages1.time(7000000:end);
            save(savename,'A_LL_voltages')
        end
        if switch_waveforms== 1
           savename = strcat('A_sw_voltages_',num2str(sw_frequency),'Hz');
           A_sw1_volt.signals.values = A_sw1_voltage.signals.values;
           A_sw1_volt.time = A_sw1_voltage.time;
           save(savename,'A_sw1_volt');
           savename = strcat('A_sw_currents_',num2str(sw_frequency),'Hz');
           A_sw1_cur.signals.values = A_sw1_current.signals.values;
           A_sw1_cur.time = A_sw1_current.time;
           save(savename,'A_sw1_cur');           
        end
        toc
    end
end
end