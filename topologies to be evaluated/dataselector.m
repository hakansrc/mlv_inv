function x = dataselector(topology_type,dclink_cur_rms,dclink_volt_mean,dclink_cur_waveform,...
    dclink_vol_waveform,phase_current_waveforms,phase_current_THD,pp_voltage_waveforms,pp_voltage_THD,switch_waveforms,all_modules,scopes)
if topology_type == 'A'
    if dclink_cur_rms == 1
        set_param('all_topologies/Topology_A/A_DCLINK_current_rms','commented','off')
    else
        set_param('all_topologies/Topology_A/A_DCLINK_current_rms','commented','on')
    end
    if dclink_volt_mean == 1
        set_param('all_topologies/Topology_A/A_DCLINK_voltage_mean','commented','off')
    else
        set_param('all_topologies/Topology_A/A_DCLINK_voltage_mean','commented','on')
    end
    if dclink_cur_waveform == 1
        set_param('all_topologies/Topology_A/A_DCLINK_current','commented','off')
    else
        set_param('all_topologies/Topology_A/A_DCLINK_current','commented','on')
    end
    if dclink_vol_waveform == 1
        set_param('all_topologies/Topology_A/A_DCLINK_voltage','commented','off')
    else
        set_param('all_topologies/Topology_A/A_DCLINK_voltage','commented','on')
    end
    if phase_current_waveforms == 1
        set_param('all_topologies/Topology_A/Inverter 1 Load/A_Phase_currents1','commented','off')
    else
        set_param('all_topologies/Topology_A/Inverter 1 Load/A_Phase_currents1','commented','on')
    end
    if phase_current_THD == 1
        set_param('all_topologies/Topology_A/Inverter 1 Load/A_THD_Ia1','commented','off')
    else
        set_param('all_topologies/Topology_A/Inverter 1 Load/A_THD_Ia1','commented','on')
    end
    if pp_voltage_waveforms == 1
        set_param('all_topologies/Topology_A/Inverter 1 Load/A_LL_voltages1','commented','off')
    else
        set_param('all_topologies/Topology_A/Inverter 1 Load/A_LL_voltages1','commented','on')
    end
    if pp_voltage_THD == 1
        set_param('all_topologies/Topology_A/Inverter 1 Load/A_THD_Vab1','commented','off')
    else
        set_param('all_topologies/Topology_A/Inverter 1 Load/A_THD_Vab1','commented','on')
    end
    if switch_waveforms == 1
        set_param('all_topologies/Topology_A/A_sw1_voltage','commented','off')
        set_param('all_topologies/Topology_A/A_sw1_current','commented','off')
    else
        set_param('all_topologies/Topology_A/A_sw1_voltage','commented','on')
        set_param('all_topologies/Topology_A/A_sw1_current','commented','off')
    end
end
if (topology_type == 'B')||(topology_type == 'C')
    if dclink_cur_rms == 1
        set_param('all_topologies/Topology_BC/BC_DCLINK2_current_rms','commented','off')
        set_param('all_topologies/Topology_BC/BC_DCLINK1_current_rms','commented','off')
    else
        set_param('all_topologies/Topology_BC/BC_DCLINK2_current_rms','commented','on')
        set_param('all_topologies/Topology_BC/BC_DCLINK1_current_rms','commented','on')
    end
    if dclink_volt_mean == 1
        set_param('all_topologies/Topology_BC/BC_DCLINK2_voltage_mean','commented','off')
        set_param('all_topologies/Topology_BC/BC_DCLINK1_voltage_mean','commented','off')
    else
        set_param('all_topologies/Topology_BC/BC_DCLINK2_voltage_mean','commented','on')
        set_param('all_topologies/Topology_BC/BC_DCLINK1_voltage_mean','commented','on')
    end
    if dclink_cur_waveform == 1
        set_param('all_topologies/Topology_BC/BC_DCLINK2_current','commented','off')
        set_param('all_topologies/Topology_BC/BC_DCLINK1_current','commented','off')
    else
        set_param('all_topologies/Topology_BC/BC_DCLINK2_current','commented','on')
        set_param('all_topologies/Topology_BC/BC_DCLINK1_current','commented','on')
    end
    if dclink_vol_waveform == 1
        set_param('all_topologies/Topology_BC/BC_DCLINK2_voltage','commented','off')
        set_param('all_topologies/Topology_BC/BC_DCLINK1_voltage','commented','off')
    else
        set_param('all_topologies/Topology_BC/BC_DCLINK2_voltage','commented','on')
        set_param('all_topologies/Topology_BC/BC_DCLINK1_voltage','commented','on')
    end
    if phase_current_waveforms == 1
        if all_modules == 1
            if topology_type == 'B'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_Phase_currents1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_Phase_currents3','commented','off')
            end
            if topology_type == 'C'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_Phase_currents1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_Phase_currents3','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_Phase_currents2','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_Phase_currents4','commented','off')
            end
        else
            if topology_type == 'B'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_Phase_currents1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_Phase_currents3','commented','on')
            end
            if topology_type == 'C'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_Phase_currents1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_Phase_currents3','commented','on')
                set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_Phase_currents2','commented','on')
                set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_Phase_currents4','commented','on')
            end
        end
    else
        set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_Phase_currents1','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_Phase_currents3','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_Phase_currents2','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_Phase_currents4','commented','on')
    end
    
    
    if pp_voltage_waveforms == 1
        if all_modules == 1
            if topology_type == 'B'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_LL_voltages1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_LL_voltages3','commented','off')
            end
            if topology_type == 'C'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_LL_voltages1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_LL_voltages3','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_LL_voltages2','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_LL_voltages4','commented','off')
            end
        else
            if topology_type == 'B'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_LL_voltages1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_LL_voltages3','commented','on')
            end
            if topology_type == 'C'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_LL_voltages1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_LL_voltages3','commented','on')
                set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_LL_voltages2','commented','on')
                set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_LL_voltages4','commented','on')
            end
        end
    else
        set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_LL_voltages1','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_LL_voltages3','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_LL_voltages2','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_LL_voltages4','commented','on')
    end
    
    if phase_current_THD == 1
        if all_modules == 1
            if topology_type == 'B'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Ia1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Ia3','commented','off')
            end
            if topology_type == 'C'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Ia1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Ia3','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_THD_Ia2','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_THD_Ia4','commented','off')
            end
        else
            if topology_type == 'B'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Ia1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Ia3','commented','on')
            end
            if topology_type == 'C'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Ia1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Ia3','commented','on')
                set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_THD_Ia2','commented','on')
                set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_THD_Ia4','commented','on')
            end
        end
    else
        set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Ia1','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Ia3','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_THD_Ia2','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_THD_Ia4','commented','on')
    end
    if pp_voltage_THD == 1
        if all_modules == 1
            if topology_type == 'B'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Vab1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Vab3','commented','off')
            end
            if topology_type == 'C'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Vab1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Vab3','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_THD_Vab2','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_THD_Vab4','commented','off')
            end
        else
            if topology_type == 'B'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Vab1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Vab3','commented','on')
            end
            if topology_type == 'C'
                set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Vab1','commented','off')
                set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Vab3','commented','on')
                set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_THD_Vab2','commented','on')
                set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_THD_Vab4','commented','on')
            end
        end
    else
        set_param('all_topologies/Topology_BC/Inverter 1 Load/BC_THD_Vab1','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 3 Load/BC_THD_Vab3','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 2 Load/BC_THD_Vab2','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 4 Load/BC_THD_Vab4','commented','on')
    end
    if switch_waveforms== 1
        set_param('all_topologies/Topology_BC/BC_sw1_voltage','commented','off')
        set_param('all_topologies/Topology_BC/BC_sw1_current','commented','off')
    else
        set_param('all_topologies/Topology_BC/BC_sw1_voltage','commented','on')
        set_param('all_topologies/Topology_BC/BC_sw1_current','commented','on')
    end
end
if (topology_type == 'D')||(topology_type == 'E')
    if dclink_cur_rms == 1
        set_param('all_topologies/Topology_DE/datacollecter/DE_DCLINK_current_rms','commented','off')
        set_param('all_topologies/Topology_DE/datacollecter/DE_lowerc_current_rms','commented','off')
        set_param('all_topologies/Topology_DE/datacollecter/DE_upperc_current_rms','commented','off')
    else
        set_param('all_topologies/Topology_DE/datacollecter/DE_DCLINK_current_rms','commented','on')
        set_param('all_topologies/Topology_DE/datacollecter/DE_lowerc_current_rms','commented','on')
        set_param('all_topologies/Topology_DE/datacollecter/DE_upperc_current_rms','commented','on')
    end
    if dclink_volt_mean == 1
        set_param('all_topologies/Topology_DE/datacollecter/DE_DCLINK_voltage_mean','commented','off')
        set_param('all_topologies/Topology_DE/datacollecter/DE_lowerc_voltage_mean','commented','off')
        set_param('all_topologies/Topology_DE/datacollecter/DE_upperc_voltage_mean','commented','off')
    else
        set_param('all_topologies/Topology_DE/datacollecter/DE_DCLINK_voltage_mean','commented','on')
        set_param('all_topologies/Topology_DE/datacollecter/DE_lowerc_voltage_mean','commented','on')
        set_param('all_topologies/Topology_DE/datacollecter/DE_upperc_voltage_mean','commented','on')
    end
    if dclink_cur_waveform == 1
        set_param('all_topologies/Topology_DE/datacollecter/DE_DCLINK_current','commented','off')
        set_param('all_topologies/Topology_DE/datacollecter/DE_lowerc_current','commented','off')
        set_param('all_topologies/Topology_DE/datacollecter/DE_upperc_current','commented','off')
    else
        set_param('all_topologies/Topology_DE/datacollecter/DE_DCLINK_current','commented','on')
        set_param('all_topologies/Topology_DE/datacollecter/DE_lowerc_current','commented','on')
        set_param('all_topologies/Topology_DE/datacollecter/DE_upperc_current','commented','on')
    end
    if dclink_vol_waveform == 1
        set_param('all_topologies/Topology_DE/datacollecter/DE_DCLINK_voltage','commented','off')
        set_param('all_topologies/Topology_DE/datacollecter/DE_lowerc_voltage','commented','off')
        set_param('all_topologies/Topology_DE/datacollecter/DE_upperc_voltage','commented','off')
    else
        set_param('all_topologies/Topology_DE/datacollecter/DE_DCLINK_voltage','commented','on')
        set_param('all_topologies/Topology_DE/datacollecter/DE_lowerc_voltage','commented','on')
        set_param('all_topologies/Topology_DE/datacollecter/DE_upperc_voltage','commented','on')
    end
    if phase_current_waveforms == 1
        if all_modules == 1
            if topology_type == 'D'
                set_param('all_topologies/Topology_DE/Load 1/DE_Phase_currents1','commented','off')
            end
            if topology_type == 'E'
                set_param('all_topologies/Topology_DE/Load 1/DE_Phase_currents1','commented','off')
                set_param('all_topologies/Topology_DE/Load 2/DE_Phase_currents2','commented','off')
            end
        else
            if topology_type == 'D'
                set_param('all_topologies/Topology_DE/Load 1/DE_Phase_currents1','commented','off')
            end
            if topology_type == 'E'
                set_param('all_topologies/Topology_DE/Load 1/DE_Phase_currents1','commented','off')
                set_param('all_topologies/Topology_DE/Load 2/DE_Phase_currents2','commented','on')
            end
        end
    else
        set_param('all_topologies/Topology_DE/Load 1/DE_Phase_currents1','commented','on')
        set_param('all_topologies/Topology_DE/Load 2/DE_Phase_currents2','commented','on')
    end
    if pp_voltage_waveforms == 1
        if all_modules == 1
            if topology_type == 'D'
                set_param('all_topologies/Topology_DE/Load 1/DE_LL_voltages1','commented','off')
            end
            if topology_type == 'E'
                set_param('all_topologies/Topology_DE/Load 1/DE_LL_voltages1','commented','off')
                set_param('all_topologies/Topology_DE/Load 2/DE_LL_voltages2','commented','off')
            end
        else
            if topology_type == 'D'
                set_param('all_topologies/Topology_DE/Load 1/DE_LL_voltages1','commented','off')
            end
            if topology_type == 'E'
                set_param('all_topologies/Topology_DE/Load 1/DE_LL_voltages1','commented','off')
                set_param('all_topologies/Topology_DE/Load 2/DE_LL_voltages2','commented','on')
            end
        end
    else
        set_param('all_topologies/Topology_DE/Load 1/DE_LL_voltages1','commented','on')
        set_param('all_topologies/Topology_DE/Load 2/DE_LL_voltages2','commented','on')
    end    
    if phase_current_THD == 1
        if all_modules == 1
            if topology_type == 'D'
                set_param('all_topologies/Topology_DE/Load 1/DE_THD_Ia1','commented','off')
            end
            if topology_type == 'E'
                set_param('all_topologies/Topology_DE/Load 1/DE_THD_Ia1','commented','off')
                set_param('all_topologies/Topology_DE/Load 2/DE_THD_Ia2','commented','off')
            end
        else
            if topology_type == 'D'
                set_param('all_topologies/Topology_DE/Load 1/DE_THD_Ia1','commented','off')
            end
            if topology_type == 'E'
                set_param('all_topologies/Topology_DE/Load 1/DE_THD_Ia1','commented','off')
                set_param('all_topologies/Topology_DE/Load 2/DE_THD_Ia2','commented','on')
            end
        end
    else
        set_param('all_topologies/Topology_DE/Load 1/DE_THD_Ia1','commented','on')
        set_param('all_topologies/Topology_DE/Load 2/DE_THD_Ia2','commented','on')
    end   
    if pp_voltage_THD == 1
        if all_modules == 1
            if topology_type == 'D'
                set_param('all_topologies/Topology_DE/Load 1/DE_THD_Vab1','commented','off')
            end
            if topology_type == 'E'
                set_param('all_topologies/Topology_DE/Load 1/DE_THD_Vab1','commented','off')
                set_param('all_topologies/Topology_DE/Load 2/DE_THD_Vab2','commented','off')
            end
        else
            if topology_type == 'D'
                set_param('all_topologies/Topology_DE/Load 1/DE_THD_Vab1','commented','off')
            end
            if topology_type == 'E'
                set_param('all_topologies/Topology_DE/Load 1/DE_THD_Vab1','commented','off')
                set_param('all_topologies/Topology_DE/Load 2/DE_THD_Vab2','commented','on')
            end
        end
    else
        set_param('all_topologies/Topology_DE/Load 1/DE_THD_Vab1','commented','on')
        set_param('all_topologies/Topology_DE/Load 2/DE_THD_Vab2','commented','on')
    end 
    if switch_waveforms == 1
        set_param('all_topologies/Topology_DE/Load 1/DE_uppersw_current','commented','off')
        set_param('all_topologies/Topology_DE/Load 1/DE_uppersw_voltage','commented','off')
        set_param('all_topologies/Topology_DE/Load 1/DE_lowersw_current','commented','off')
        set_param('all_topologies/Topology_DE/Load 1/DE_lowersw_voltage','commented','off')
        set_param('all_topologies/Topology_DE/Load 1/DE_Diode1_current','commented','off')
        set_param('all_topologies/Topology_DE/Load 1/DE_Diode1_voltage','commented','off')
    else
        set_param('all_topologies/Topology_DE/Load 1/DE_uppersw_current','commented','on')
        set_param('all_topologies/Topology_DE/Load 1/DE_uppersw_voltage','commented','on')
        set_param('all_topologies/Topology_DE/Load 1/DE_lowersw_current','commented','on')
        set_param('all_topologies/Topology_DE/Load 1/DE_lowersw_voltage','commented','on')
        set_param('all_topologies/Topology_DE/Load 1/DE_Diode1_current','commented','on')
        set_param('all_topologies/Topology_DE/Load 1/DE_Diode1_voltage','commented','on')        
    end
end

if scopes == 1
    set_param('all_topologies/Topology_A/Inverter 1 Load/Phase_currents','commented','off')
    set_param('all_topologies/Topology_A/Inverter 1 Load/LL_voltages','commented','off')
    set_param('all_topologies/Topology_BC/Inverter 4 Load/Phase_currents','commented','off')
    set_param('all_topologies/Topology_BC/Inverter 4 Load/LL_voltages','commented','off')
    set_param('all_topologies/Topology_BC/Inverter 3 Load/Phase_currents','commented','off')
    set_param('all_topologies/Topology_BC/Inverter 3 Load/LL_voltages','commented','off')
    set_param('all_topologies/Topology_BC/Inverter 2 Load/Phase_currents','commented','off')
    set_param('all_topologies/Topology_BC/Inverter 2 Load/LL_voltages','commented','off')
    set_param('all_topologies/Topology_BC/Inverter 1 Load/Phase_currents','commented','off')
    set_param('all_topologies/Topology_BC/Inverter 1 Load/LL_voltages','commented','off')
    set_param('all_topologies/Topology_DE/Load 1/Phase_currents','commented','off')
    set_param('all_topologies/Topology_DE/Load 1/LL_voltages','commented','off')
    set_param('all_topologies/Topology_DE/Load 2/Phase_currents','commented','off')
    set_param('all_topologies/Topology_DE/Load 2/LL_voltages','commented','off')
else 
    set_param('all_topologies/Topology_A/Inverter 1 Load/Phase_currents','commented','on')
    set_param('all_topologies/Topology_A/Inverter 1 Load/LL_voltages','commented','on')
    set_param('all_topologies/Topology_BC/Inverter 4 Load/Phase_currents','commented','on')
    set_param('all_topologies/Topology_BC/Inverter 4 Load/LL_voltages','commented','on')
    set_param('all_topologies/Topology_BC/Inverter 3 Load/Phase_currents','commented','on')
    set_param('all_topologies/Topology_BC/Inverter 3 Load/LL_voltages','commented','on')
    set_param('all_topologies/Topology_BC/Inverter 2 Load/Phase_currents','commented','on')
    set_param('all_topologies/Topology_BC/Inverter 2 Load/LL_voltages','commented','on')
    set_param('all_topologies/Topology_BC/Inverter 1 Load/Phase_currents','commented','on')
    set_param('all_topologies/Topology_BC/Inverter 1 Load/LL_voltages','commented','on')
    set_param('all_topologies/Topology_DE/Load 1/Phase_currents','commented','on')
    set_param('all_topologies/Topology_DE/Load 1/LL_voltages','commented','on')
    set_param('all_topologies/Topology_DE/Load 2/Phase_currents','commented','on')
    set_param('all_topologies/Topology_DE/Load 2/LL_voltages','commented','on')    

end
end


