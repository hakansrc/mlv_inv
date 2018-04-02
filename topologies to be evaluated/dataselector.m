function x = dataselector(topology_type,dclink_cur_rms,dclink_volt_mean,dclink_cur_waveform,dclink_vol_waveform,phase_current_waveforms,phase_current_THD,pp_voltage_waveforms,pp_voltage_THD,switch_waveforms)
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


end