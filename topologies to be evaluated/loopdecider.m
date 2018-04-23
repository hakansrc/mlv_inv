function [sw_frequency] = loopdecider(startfreq,stopfreq,increment,topology_type,Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,Lsm,Efm,dclink_cur_rms,...
    dclink_volt_mean,dclink_cur_waveform,dclink_vol_waveform,...
    phase_current_waveforms,phase_current_THD,pp_voltage_waveforms,pp_voltage_THD,switch_waveforms,all_modules,scopes)
if topology_type == 'A'
    if dclink_cur_rms == 1
        savename = strcat('A_dclink_cur_rms_',num2str(sw_frequency),'Hz');
        A_dclink_cur_rms = mean(A_DCLINK_current_rms.signals.values(9200000:end));
        save(savename,'A_dclink_cur_rms')
    end
    if dclink_volt_mean==1
        savename = strcat('A_dclink_volt_mean_',num2str(sw_frequency),'Hz');
        A_dclink_volt_mean = mean(A_DCLINK_voltage_mean.signals.values(9200000:end));
        save(savename,'A_dclink_volt_mean')
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
        savename = strcat('A_phasecurrents1_',num2str(sw_frequency),'Hz');
        A_Phase_curs1.signals.values(:,1) = A_Phase_currents1.signals.values(7000000:end,1);
        A_Phase_curs1.signals.values(:,2) = A_Phase_currents1.signals.values(7000000:end,2);
        A_Phase_curs1.signals.values(:,3) = A_Phase_currents1.signals.values(7000000:end,3);
        A_Phase_curs1.time = A_Phase_currents1.time(7000000:end);
        save(savename,'A_Phase_curs1')
    end
    if phase_current_THD == 1
        savename = strcat('A_Ia1_THD_',num2str(sw_frequency),'Hz');
        A_Ia1_THD = mean(A_THD_Ia1.signals.values(9200000:end));
        save(savename,'A_Ia1_THD');
    end
    if pp_voltage_THD == 1
        savename = strcat('A_Vab1_THD_',num2str(sw_frequency),'Hz');
        A_Vab1_THD = mean(A_THD_Vab1.signals.values(9200000:end));
        save(savename,'A_Vab1_THD');
    end
    if pp_voltage_waveforms == 1
        savename = strcat('A_ppvoltages1_',num2str(sw_frequency),'Hz');
        A_LL_voltages1.signals.values(:,1) = A_LL_voltages1.signals.values(7000000:end,1);
        A_LL_voltages1.signals.values(:,2) = A_LL_voltages1.signals.values(7000000:end,2);
        A_LL_voltages1.signals.values(:,3) = A_LL_voltages1.signals.values(7000000:end,3);
        A_LL_voltages1.time = A_LL_voltages1.time(7000000:end);
        save(savename,'A_LL_voltages1')
    end
    if switch_waveforms== 1
        savename = strcat('A_sw_voltages_',num2str(sw_frequency),'Hz');
        A_sw1_volt.signals.values = A_sw1_voltage.signals.values(9800000:end);
        A_sw1_volt.time = A_sw1_voltage.time(9800000:end);
        save(savename,'A_sw1_volt');
        savename = strcat('A_sw_currents_',num2str(sw_frequency),'Hz');
        A_sw1_cur.signals.values = A_sw1_current.signals.values(9800000:end);
        A_sw1_cur.time = A_sw1_current.time(9800000:end);
        save(savename,'A_sw1_cur');
    end
end
if topology_type == 'B'
    if dclink_cur_rms == 1
        savename = strcat('B_dclink_cur_rmses_',num2str(sw_frequency),'Hz');
        B_dclink1_cur_rms = mean(BC_DCLINK1_current_rms.signals.values(9200000:end));
        B_dclink2_cur_rms = mean(BC_DCLINK2_current_rms.signals.values(9200000:end));
        save(savename,'B_dclink1_cur_rms','B_dclink2_cur_rms')
    end
    if dclink_volt_mean == 1
        savename = strcat('B_dclink_volt_means_',num2str(sw_frequency),'Hz');
        B_dclink1_volt_mean = mean(BC_DCLINK1_voltage_mean.signals.values(9200000:end));
        B_dclink2_volt_mean = mean(BC_DCLINK2_voltage_mean.signals.values(9200000:end));
        save(savename,'B_dclink1_volt_mean','B_dclink2_volt_mean')
    end
    if dclink_cur_waveform == 1
        savename = strcat('B_dclink_cur_waveform_',num2str(sw_frequency),'Hz');
        B_DCL1_current.signals.values = BC_DCLINK1_current.signals.values(7000000:end);
        B_DCL2_current.signals.values = BC_DCLINK2_current.signals.values(7000000:end);
        B_DCL1_current.time = BC_DCLINK1_voltage.time(7000000:end);
        B_DCL2_current.time = B_DCL1_current.time;
        save(savename,'B_DCL1_current','B_DCL2_current')
    end
    if dclink_vol_waveform==1
        savename = strcat('B_dclink_volt_waveform_',num2str(sw_frequency),'Hz');
        B_DCL1_voltage.signals.values = BC_DCLINK1_voltage.signals.values(7000000:end);
        B_DCL2_voltage.signals.values = BC_DCLINK2_voltage.signals.values(7000000:end);
        B_DCL1_voltage.time = BC_DCLINK1_voltage.time(7000000:end);
        B_DCL2_voltage.time = B_DCL1_voltage.time;
        save(savename,'B_DCL1_voltage','B_DCL2_voltage')
    end
    if phase_current_waveforms == 1
        savename = strcat('B_phasecurrents1_',num2str(sw_frequency),'Hz');
        B_Phase_curs1.signals.values(:,1) = BC_Phase_currents1.signals.values(7000000:end,1);
        B_Phase_curs1.signals.values(:,2) = BC_Phase_currents1.signals.values(7000000:end,2);
        B_Phase_curs1.signals.values(:,3) = BC_Phase_currents1.signals.values(7000000:end,3);
        B_Phase_curs1.time = BC_Phase_currents1.time(7000000:end);
        save(savename,'B_Phase_curs1')
        if all_modules == 1
            savename = strcat('B_phasecurrents3_',num2str(sw_frequency),'Hz');
            B_Phase_curs3.signals.values(:,1) = BC_Phase_currents3.signals.values(7000000:end,1);
            B_Phase_curs3.signals.values(:,2) = BC_Phase_currents3.signals.values(7000000:end,2);
            B_Phase_curs3.signals.values(:,3) = BC_Phase_currents3.signals.values(7000000:end,3);
            B_Phase_curs3.time = BC_Phase_currents3.time(7000000:end);
            save(savename,'B_Phase_curs3')
        end
    end
    if phase_current_THD==1
        savename = strcat('B_Ia1_THD_',num2str(sw_frequency),'Hz');
        B_Ia1_THD = mean(BC_THD_Ia1.signals.values(9200000:end));
        save(savename,'B_Ia1_THD');
        if all_modules == 1
            savename = strcat('B_Ia3_THD_',num2str(sw_frequency),'Hz');
            B_Ia3_THD = mean(BC_THD_Ia3.signals.values(9200000:end));
            save(savename,'B_Ia3_THD');
        end
    end
    if pp_voltage_THD == 1
        savename = strcat('B_Vab1_THD_',num2str(sw_frequency),'Hz');
        B_Vab1_THD = mean(BC_THD_Vab1.signals.values(9200000:end));
        save(savename,'B_Vab1_THD');
        if all_modules == 1
            savename = strcat('B_Vab3_THD_',num2str(sw_frequency),'Hz');
            B_Vab3_THD = mean(BC_THD_Vab3.signals.values(9200000:end));
            save(savename,'B_Vab3_THD');
        end
    end
    if pp_voltage_waveforms == 1
        savename = strcat('B_ppvoltages1_',num2str(sw_frequency),'Hz');
        B_LL_voltages1.signals.values(:,1) = BC_LL_voltages1.signals.values(7000000:end,1);
        B_LL_voltages1.signals.values(:,2) = BC_LL_voltages1.signals.values(7000000:end,2);
        B_LL_voltages1.signals.values(:,3) = BC_LL_voltages1.signals.values(7000000:end,3);
        B_LL_voltages1.time = BC_LL_voltages1.time(7000000:end);
        save(savename,'B_LL_voltages1')
        if all_modules == 1
            savename = strcat('B_ppvoltages3_',num2str(sw_frequency),'Hz');
            B_LL_voltages3.signals.values(:,1) = BC_LL_voltages3.signals.values(7000000:end,1);
            B_LL_voltages3.signals.values(:,2) = BC_LL_voltages3.signals.values(7000000:end,2);
            B_LL_voltages3.signals.values(:,3) = BC_LL_voltages3.signals.values(7000000:end,3);
            B_LL_voltages3.time = BC_LL_voltages3.time(7000000:end);
            save(savename,'B_LL_voltages3')
        end
    end
    if switch_waveforms== 1
        savename = strcat('B_sw_voltages_',num2str(sw_frequency),'Hz');
        B_sw1_volt.signals.values = BC_sw1_voltage.signals.values(9800000:end);
        B_sw1_volt.time = BC_sw1_voltage.time(9800000:end);
        save(savename,'B_sw1_volt');
        savename = strcat('B_sw_currents_',num2str(sw_frequency),'Hz');
        B_sw1_cur.signals.values = BC_sw1_current.signals.values(9800000:end);
        B_sw1_cur.time = BC_sw1_current.time(9800000:end);
        save(savename,'B_sw1_cur');
    end
end
if topology_type == 'C'
    if dclink_cur_rms == 1
        savename = strcat('C_dclink_cur_rmses_',num2str(sw_frequency),'Hz');
        C_dclink1_cur_rms = mean(BC_DCLINK1_current_rms.signals.values(9200000:end));
        C_dclink2_cur_rms = mean(BC_DCLINK2_current_rms.signals.values(9200000:end));
        save(savename,'C_dclink1_cur_rms','B_dclink2_cur_rms')
    end
    if dclink_volt_mean == 1
        savename = strcat('C_dclink_volt_means_',num2str(sw_frequency),'Hz');
        C_dclink1_volt_mean = mean(BC_DCLINK1_voltage_mean.signals.values(9200000:end));
        C_dclink2_volt_mean = mean(BC_DCLINK2_voltage_mean.signals.values(9200000:end));
        save(savename,'C_dclink1_volt_mean','B_dclink2_volt_mean')
    end
    if dclink_cur_waveform == 1
        savename = strcat('C_dclink_cur_waveform_',num2str(sw_frequency),'Hz');
        C_DCL1_current.signals.values = BC_DCLINK1_current.signals.values(7000000:end);
        C_DCL2_current.signals.values = BC_DCLINK2_current.signals.values(7000000:end);
        C_DCL1_current.time = BC_DCLINK1_voltage.time(7000000:end);
        C_DCL2_current.time = C_DCL1_current.time;
        save(savename,'C_DCL1_current','B_DCL2_current')
    end
    if dclink_vol_waveform==1
        savename = strcat('C_dclink_volt_waveform_',num2str(sw_frequency),'Hz');
        C_DCL1_voltage.signals.values = BC_DCLINK1_voltage.signals.values(7000000:end);
        C_DCL2_voltage.signals.values = BC_DCLINK2_voltage.signals.values(7000000:end);
        C_DCL1_voltage.time = BC_DCLINK1_voltage.time(7000000:end);
        C_DCL2_voltage.time = C_DCL1_voltage.time;
        save(savename,'C_DCL1_voltage','B_DCL2_voltage')
    end
    if phase_current_waveforms == 1
        savename = strcat('C_phasecurrents1_',num2str(sw_frequency),'Hz');
        C_Phase_curs1.signals.values(:,1) = BC_Phase_currents1.signals.values(7000000:end,1);
        C_Phase_curs1.signals.values(:,2) = BC_Phase_currents1.signals.values(7000000:end,2);
        C_Phase_curs1.signals.values(:,3) = BC_Phase_currents1.signals.values(7000000:end,3);
        C_Phase_curs1.time = BC_Phase_currents1.time(7000000:end);
        save(savename,'C_Phase_curs1')
        if all_modules == 1
            savename = strcat('C_phasecurrents3_',num2str(sw_frequency),'Hz');
            C_Phase_curs3.signals.values(:,1) = BC_Phase_currents3.signals.values(7000000:end,1);
            C_Phase_curs3.signals.values(:,2) = BC_Phase_currents3.signals.values(7000000:end,2);
            C_Phase_curs3.signals.values(:,3) = BC_Phase_currents3.signals.values(7000000:end,3);
            C_Phase_curs3.time = BC_Phase_currents3.time(7000000:end);
            save(savename,'C_Phase_curs3')
            savename = strcat('C_phasecurrents2_',num2str(sw_frequency),'Hz');
            C_Phase_curs2.signals.values(:,1) = BC_Phase_currents2.signals.values(7000000:end,1);
            C_Phase_curs2.signals.values(:,2) = BC_Phase_currents2.signals.values(7000000:end,2);
            C_Phase_curs2.signals.values(:,3) = BC_Phase_currents2.signals.values(7000000:end,3);
            C_Phase_curs2.time = BC_Phase_currents2.time(7000000:end);
            save(savename,'C_Phase_curs2')
            savename = strcat('C_phasecurrents4_',num2str(sw_frequency),'Hz');
            C_Phase_curs4.signals.values(:,1) = BC_Phase_currents4.signals.values(7000000:end,1);
            C_Phase_curs4.signals.values(:,2) = BC_Phase_currents4.signals.values(7000000:end,2);
            C_Phase_curs4.signals.values(:,3) = BC_Phase_currents4.signals.values(7000000:end,3);
            C_Phase_curs4.time = BC_Phase_currents4.time(7000000:end);
            save(savename,'C_Phase_curs4')
        end
    end
    if phase_current_THD==1
        savename = strcat('C_Ia1_THD_',num2str(sw_frequency),'Hz');
        C_Ia1_THD = mean(BC_THD_Ia1.signals.values(9200000:end));
        save(savename,'C_Ia1_THD');
        if all_modules == 1
            savename = strcat('C_Ia3_THD_',num2str(sw_frequency),'Hz');
            C_Ia3_THD = mean(BC_THD_Ia3.signals.values(9200000:end));
            save(savename,'C_Ia3_THD');
            
            savename = strcat('C_Ia2_THD_',num2str(sw_frequency),'Hz');
            C_Ia2_THD = mean(BC_THD_Ia2.signals.values(9200000:end));
            save(savename,'C_Ia2_THD');
            
            savename = strcat('C_Ia4_THD_',num2str(sw_frequency),'Hz');
            C_Ia4_THD = mean(BC_THD_Ia4.signals.values(9200000:end));
            save(savename,'C_Ia4_THD');
        end
    end
    if pp_voltage_THD == 1
        savename = strcat('C_Vab1_THD_',num2str(sw_frequency),'Hz');
        C_Vab1_THD = mean(BC_THD_Vab1.signals.values(9200000:end));
        save(savename,'C_Vab1_THD');
        if all_modules == 1
            savename = strcat('C_Vab3_THD_',num2str(sw_frequency),'Hz');
            C_Vab3_THD = mean(BC_THD_Vab3.signals.values(9200000:end));
            save(savename,'C_Vab3_THD');
            
            savename = strcat('C_Vab2_THD_',num2str(sw_frequency),'Hz');
            C_Vab2_THD = mean(BC_THD_Vab2.signals.values(9200000:end));
            save(savename,'C_Vab2_THD');
            
            savename = strcat('C_Vab4_THD_',num2str(sw_frequency),'Hz');
            C_Vab4_THD = mean(BC_THD_Vab4.signals.values(9200000:end));
            save(savename,'C_Vab4_THD');
        end
    end
    if pp_voltage_waveforms == 1
        savename = strcat('C_ppvoltages1_',num2str(sw_frequency),'Hz');
        C_LL_voltages1.signals.values(:,1) = BC_LL_voltages1.signals.values(7000000:end,1);
        C_LL_voltages1.signals.values(:,2) = BC_LL_voltages1.signals.values(7000000:end,2);
        C_LL_voltages1.signals.values(:,3) = BC_LL_voltages1.signals.values(7000000:end,3);
        C_LL_voltages1.time = BC_LL_voltages1.time(7000000:end);
        save(savename,'C_LL_voltages1')
        if all_modules == 1
            savename = strcat('C_ppvoltages3_',num2str(sw_frequency),'Hz');
            C_LL_voltages3.signals.values(:,1) = BC_LL_voltages3.signals.values(7000000:end,1);
            C_LL_voltages3.signals.values(:,2) = BC_LL_voltages3.signals.values(7000000:end,2);
            C_LL_voltages3.signals.values(:,3) = BC_LL_voltages3.signals.values(7000000:end,3);
            C_LL_voltages3.time = BC_LL_voltages3.time(7000000:end);
            save(savename,'C_LL_voltages3')
            
            savename = strcat('C_ppvoltages2_',num2str(sw_frequency),'Hz');
            C_LL_voltages2.signals.values(:,1) = BC_LL_voltages2.signals.values(7000000:end,1);
            C_LL_voltages2.signals.values(:,2) = BC_LL_voltages2.signals.values(7000000:end,2);
            C_LL_voltages2.signals.values(:,3) = BC_LL_voltages2.signals.values(7000000:end,3);
            C_LL_voltages2.time = BC_LL_voltage2.time(7000000:end);
            save(savename,'C_LL_voltages2')
            
            savename = strcat('C_ppvoltages4_',num2str(sw_frequency),'Hz');
            C_LL_voltages4.signals.values(:,1) = BC_LL_voltages4.signals.values(7000000:end,1);
            C_LL_voltages4.signals.values(:,2) = BC_LL_voltages4.signals.values(7000000:end,2);
            C_LL_voltages4.signals.values(:,3) = BC_LL_voltages4.signals.values(7000000:end,3);
            C_LL_voltages4.time = BC_LL_voltages4.time(7000000:end);
            save(savename,'C_LL_voltages4')
        end
    end
    if switch_waveforms== 1
        savename = strcat('C_sw_voltages_',num2str(sw_frequency),'Hz');
        C_sw1_volt.signals.values = BC_sw1_voltage.signals.values(9800000:end);
        C_sw1_volt.time = BC_sw1_voltage.time(9800000:end);
        save(savename,'C_sw1_volt');
        savename = strcat('C_sw_currents_',num2str(sw_frequency),'Hz');
        C_sw1_cur.signals.values = BC_sw1_current.signals.values(9800000:end);
        C_sw1_cur.time = BC_sw1_current.time(9800000:end);
        save(savename,'C_sw1_cur');
    end
end
if topology_type == 'D'
    if dclink_cur_rms == 1
        savename = strcat('D_dclink_cur_rms_',num2str(sw_frequency),'Hz');
        D_dclink_cur_rms = mean(DE_DCLINK_current_rms.signals.values(9200000:end));
        save(savename,'D_dclink_cur_rms')
    end
    if dclink_volt_mean==1
        savename = strcat('D_dclink_volt_mean_',num2str(sw_frequency),'Hz');
        D_dclink_volt_mean = mean(DE_DCLINK_voltage_mean.signals.values(9200000:end));
        save(savename,'D_dclink_volt_mean')
        
        %         savename = strcat('D_upperc_volt_mean_',num2str(sw_frequency),'Hz');
        %         D_upperc_volt_mean = mean(DE_upperc_voltage_mean.signals.values(9200000:end));
        %         save(savename,'D_upperc_volt_mean')
        %
        %         savename = strcat('D_lowerc_volt_mean_',num2str(sw_frequency),'Hz');
        %         D_lowerc_volt_mean = mean(DE_lowerc_voltage_mean.signals.values(9200000:end));
        %         save(savename,'D_lowerc_volt_mean')
    end
    if dclink_cur_waveform == 1
        savename = strcat('D_dclink_cur_waveform_',num2str(sw_frequency),'Hz');
        D_DCL_current.signals.values=DE_DCLINK_current.signals.values(7000000:end);
        D_DCL_current.time = DE_DCLINK_current.time(7000000:end);
        save(savename,'D_DCL_current');
        
        %         savename = strcat('D_upperc_cur_waveform_',num2str(sw_frequency),'Hz');
        %         D_upperc_current.signals.values=DE_upperc_current.signals.values(7000000:end);
        %         D_upperc_current.time = DE_upperc_current.time(7000000:end);
        %         save(savename,'D_upperc_current');
        %
        %         savename = strcat('D_lowerc_cur_waveform_',num2str(sw_frequency),'Hz');
        %         D_lowerc_current.signals.values=DE_lowerc_current.signals.values(7000000:end);
        %         D_lowerc_current.time = DE_lowerc_current.time(7000000:end);
        %         save(savename,'D_lowerc_current');
        
    end
    if dclink_vol_waveform == 1
        savename = strcat('D_dclink_vol_waveform_',num2str(sw_frequency),'Hz');
        D_DCL_voltage.signals.values=DE_DCLINK_voltage.signals.values(7000000:end);
        D_DCL_voltage.time = DE_DCLINK_voltage.time(7000000:end);
        save(savename,'D_DCL_voltage');
        
        %         savename = strcat('D_lowerc_vol_waveform_',num2str(sw_frequency),'Hz');
        %         D_lowerc_voltage.signals.values=DE_lowerc_voltage.signals.values(7000000:end);
        %         D_lowerc_voltage.time = DE_lowerc_voltage.time(7000000:end);
        %         save(savename,'D_lowerc_voltage');
        %
        %         savename = strcat('D_upperc_vol_waveform_',num2str(sw_frequency),'Hz');
        %         D_upperc_voltage.signals.values=DE_upperc_voltage.signals.values(7000000:end);
        %         D_upperc_voltage.time = DE_upperc_voltage.time(7000000:end);
        %         save(savename,'D_upperc_voltage');
        
    end
    if phase_current_waveforms==1
        savename = strcat('D_phasecurrents1_',num2str(sw_frequency),'Hz');
        D_Phase_curs1.signals.values(:,1) = DE_Phase_currents1.signals.values(7000000:end,1);
        D_Phase_curs1.signals.values(:,2) = DE_Phase_currents1.signals.values(7000000:end,2);
        D_Phase_curs1.signals.values(:,3) = DE_Phase_currents1.signals.values(7000000:end,3);
        D_Phase_curs1.time = DE_Phase_currents1.time(7000000:end);
        save(savename,'D_Phase_curs1')
    end
    if phase_current_THD == 1
        savename = strcat('D_Ia1_THD_',num2str(sw_frequency),'Hz');
        D_Ia1_THD = mean(DE_THD_Ia1.signals.values(9200000:end));
        save(savename,'D_Ia1_THD');
    end
    if pp_voltage_THD == 1
        savename = strcat('D_Vab1_THD_',num2str(sw_frequency),'Hz');
        D_Vab1_THD = mean(DE_THD_Vab1.signals.values(9200000:end));
        save(savename,'D_Vab1_THD');
    end
    if pp_voltage_waveforms == 1
        savename = strcat('D_ppvoltages1_',num2str(sw_frequency),'Hz');
        D_LL_voltages1.signals.values(:,1) = DE_LL_voltages1.signals.values(7000000:end,1);
        D_LL_voltages1.signals.values(:,2) = DE_LL_voltages1.signals.values(7000000:end,2);
        D_LL_voltages1.signals.values(:,3) = DE_LL_voltages1.signals.values(7000000:end,3);
        D_LL_voltages1.time = DE_LL_voltages1.time(7000000:end);
        save(savename,'D_LL_voltages1')
    end
    if switch_waveforms== 1
        savename = strcat('D_uppersw_voltages_',num2str(sw_frequency),'Hz');
        D_uppersw_voltages.signals.values = DE_uppersw_voltage.signals.values(9800000:end);
        D_uppersw_voltages.time = DE_uppersw_voltage.time(9800000:end);
        save(savename,'D_uppersw_voltages');
        
        savename = strcat('D_uppersw_currents_',num2str(sw_frequency),'Hz');
        D_uppersw_currents.signals.values = DE_uppersw_current.signals.values(9800000:end);
        D_uppersw_currents.time = DE_uppersw_current.time(9800000:end);
        save(savename,'D_uppersw_currents');
        
        savename = strcat('D_lowersw_voltages_',num2str(sw_frequency),'Hz');
        D_lowersw_voltages.signals.values = DE_lowersw_voltage.signals.values(9800000:end);
        D_lowersw_voltages.time = DE_lowersw_voltage.time(9800000:end);
        save(savename,'D_lowersw_voltages');
        
        savename = strcat('D_lowersw_currents_',num2str(sw_frequency),'Hz');
        D_lowersw_currents.signals.values = DE_lowersw_current.signals.values(9800000:end);
        D_lowersw_currents.time = DE_lowersw_current.time(9800000:end);
        save(savename,'D_lowersw_currents');
        
        savename = strcat('D_diode_voltages_',num2str(sw_frequency),'Hz');
        D_diode_voltages.signals.values = DE_Diode1_voltage.signals.values(9800000:end);
        D_diode_voltages.time = DE_Diode1_voltage.time(9800000:end);
        save(savename,'D_diode_voltages');
        
        savename = strcat('D_diode_currents_',num2str(sw_frequency),'Hz');
        D_diode_currents.signals.values = DE_Diode1_current.signals.values(9800000:end);
        D_diode_currents.time = DE_Diode1_current.time(9800000:end);
        save(savename,'D_diode_currents');
    end
    
end
if topology_type == 'E'
    if dclink_cur_rms == 1
        savename = strcat('E_dclink_cur_rms_',num2str(sw_frequency),'Hz');
        E_dclink_cur_rms = mean(DE_DCLINK_current_rms.signals.values(9200000:end));
        save(savename,'E_dclink_cur_rms')
    end
    if dclink_volt_mean==1
        savename = strcat('E_dclink_volt_mean_',num2str(sw_frequency),'Hz');
        E_dclink_volt_mean = mean(DE_DCLINK_voltage_mean.signals.values(9200000:end));
        save(savename,'E_dclink_volt_mean')
        
        %         savename = strcat('E_upperc_volt_mean_',num2str(sw_frequency),'Hz');
        %         E_upperc_volt_mean = mean(DE_upperc_voltage_mean.signals.values(9200000:end));
        %         save(savename,'E_upperc_volt_mean')
        %
        %         savename = strcat('E_lowerc_volt_mean_',num2str(sw_frequency),'Hz');
        %         E_lowerc_volt_mean = mean(DE_lowerc_voltage_mean.signals.values(9200000:end));
        %         save(savename,'E_lowerc_volt_mean')
    end
    if dclink_cur_waveform == 1
        savename = strcat('E_dclink_cur_waveform_',num2str(sw_frequency),'Hz');
        E_DCL_current.signals.values=DE_DCLINK_current.signals.values(7000000:end);
        E_DCL_current.time = DE_DCLINK_current.time(7000000:end);
        save(savename,'E_DCL_current');
        
        %         savename = strcat('E_upperc_cur_waveform_',num2str(sw_frequency),'Hz');
        %         E_upperc_current.signals.values=DE_upperc_current.signals.values(7000000:end);
        %         E_upperc_current.time = DE_upperc_current.time(7000000:end);
        %         save(savename,'E_upperc_current');
        %
        %         savename = strcat('E_lowerc_cur_waveform_',num2str(sw_frequency),'Hz');
        %         E_lowerc_current.signals.values=DE_lowerc_current.signals.values(7000000:end);
        %         E_lowerc_current.time = DE_lowerc_current.time(7000000:end);
        %         save(savename,'E_lowerc_current');
        
    end
    if dclink_vol_waveform == 1
        savename = strcat('E_dclink_vol_waveform_',num2str(sw_frequency),'Hz');
        E_DCL_voltage.signals.values=DE_DCLINK_voltage.signals.values(7000000:end);
        E_DCL_voltage.time = DE_DCLINK_voltage.time(7000000:end);
        save(savename,'E_DCL_voltage');
        
        %         savename = strcat('E_lowerc_vol_waveform_',num2str(sw_frequency),'Hz');
        %         E_lowerc_voltage.signals.values=DE_lowerc_voltage.signals.values(7000000:end);
        %         E_lowerc_voltage.time = DE_lowerc_voltage.time(7000000:end);
        %         save(savename,'E_lowerc_voltage');
        %
        %         savename = strcat('E_upperc_vol_waveform_',num2str(sw_frequency),'Hz');
        %         E_upperc_voltage.signals.values=DE_upperc_voltage.signals.values(7000000:end);
        %         E_upperc_voltage.time = DE_upperc_voltage.time(7000000:end);
        %         save(savename,'E_upperc_voltage');
        
    end
    if phase_current_waveforms==1
        savename = strcat('E_phasecurrents1_',num2str(sw_frequency),'Hz');
        E_Phase_curs1.signals.values(:,1) = DE_Phase_currents1.signals.values(7000000:end,1);
        E_Phase_curs1.signals.values(:,2) = DE_Phase_currents1.signals.values(7000000:end,2);
        E_Phase_curs1.signals.values(:,3) = DE_Phase_currents1.signals.values(7000000:end,3);
        E_Phase_curs1.time = DE_Phase_currents1.time(7000000:end);
        save(savename,'E_Phase_curs1')
        if all_modules == 1
            savename = strcat('E_phasecurrents2_',num2str(sw_frequency),'Hz');
            E_Phase_curs2.signals.values(:,1) = DE_Phase_currents2.signals.values(7000000:end,1);
            E_Phase_curs2.signals.values(:,2) = DE_Phase_currents2.signals.values(7000000:end,2);
            E_Phase_curs2.signals.values(:,3) = DE_Phase_currents2.signals.values(7000000:end,3);
            E_Phase_curs2.time = DE_Phase_currents2.time(7000000:end);
            save(savename,'E_Phase_curs1')
        end
    end
    if phase_current_THD == 1
        savename = strcat('E_Ia1_THD_',num2str(sw_frequency),'Hz');
        E_Ia1_THD = mean(DE_THD_Ia1.signals.values(9200000:end));
        save(savename,'E_Ia1_THD');
        if all_modules == 1
            savename = strcat('E_Ia2_THD_',num2str(sw_frequency),'Hz');
            E_Ia2_THD = mean(DE_THD_Ia2.signals.values(9200000:end));
            save(savename,'E_Ia2_THD');
        end
    end
    if pp_voltage_THD == 1
        savename = strcat('E_Vab1_THD_',num2str(sw_frequency),'Hz');
        E_Vab1_THD = mean(DE_THD_Vab1.signals.values(9200000:end));
        save(savename,'E_Vab1_THD');
        if all_modules == 1
            savename = strcat('E_Vab2_THD_',num2str(sw_frequency),'Hz');
            E_Vab2_THD = mean(DE_THD_Vab2.signals.values(9200000:end));
            save(savename,'E_Vab2_THD');
        end
    end
    if pp_voltage_waveforms == 1
        savename = strcat('E_ppvoltages1_',num2str(sw_frequency),'Hz');
        E_LL_voltages1.signals.values(:,1) = DE_LL_voltages1.signals.values(7000000:end,1);
        E_LL_voltages1.signals.values(:,2) = DE_LL_voltages1.signals.values(7000000:end,2);
        E_LL_voltages1.signals.values(:,3) = DE_LL_voltages1.signals.values(7000000:end,3);
        E_LL_voltages1.time = DE_LL_voltages1.time(7000000:end);
        save(savename,'E_LL_voltages1')
        if all_modules == 1
            savename = strcat('E_ppvoltages2_',num2str(sw_frequency),'Hz');
            E_LL_voltages2.signals.values(:,1) = DE_LL_voltages2.signals.values(7000000:end,1);
            E_LL_voltages2.signals.values(:,2) = DE_LL_voltages2.signals.values(7000000:end,2);
            E_LL_voltages2.signals.values(:,3) = DE_LL_voltages2.signals.values(7000000:end,3);
            E_LL_voltages2.time = DE_LL_voltages2.time(7000000:end);
            save(savename,'E_LL_voltages2')
        end
    end
    if switch_waveforms== 1
        savename = strcat('E_uppersw_voltages_',num2str(sw_frequency),'Hz');
        E_uppersw_voltages.signals.values = DE_uppersw_voltage.signals.values(9800000:end);
        E_uppersw_voltages.time = DE_uppersw_voltage.time(9800000:end);
        save(savename,'E_uppersw_voltages');
        
        savename = strcat('E_uppersw_currents_',num2str(sw_frequency),'Hz');
        E_uppersw_currents.signals.values = DE_uppersw_current.signals.values(9800000:end);
        E_uppersw_currents.time = DE_uppersw_current.time(9800000:end);
        save(savename,'E_uppersw_currents');
        
        savename = strcat('E_lowersw_voltages_',num2str(sw_frequency),'Hz');
        E_lowersw_voltages.signals.values = DE_lowersw_voltage.signals.values(9800000:end);
        E_lowersw_voltages.time = DE_lowersw_voltage.time(9800000:end);
        save(savename,'E_lowersw_voltages');
        
        savename = strcat('E_lowersw_currents_',num2str(sw_frequency),'Hz');
        E_lowersw_currents.signals.values = DE_lowersw_current.signals.values(9800000:end);
        E_lowersw_currents.time = DE_lowersw_current.time(9800000:end);
        save(savename,'E_lowersw_currents');
        
        savename = strcat('E_diode_voltages_',num2str(sw_frequency),'Hz');
        E_diode_voltages.signals.values = DE_Diode1_voltage.signals.values(9800000:end);
        E_diode_voltages.time = DE_Diode1_voltage.time(9800000:end);
        save(savename,'E_diode_voltages');
        
        savename = strcat('E_diode_currents_',num2str(sw_frequency),'Hz');
        E_diode_currents.signals.values = DE_Diode1_current.signals.values(9800000:end);
        E_diode_currents.time = DE_Diode1_current.time(9800000:end);
        save(savename,'E_diode_currents');
    end
    
end
end