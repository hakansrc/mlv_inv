function [] = powervariation(Pout,sw_frequency,topology_type)
sim('all_topologies.slx');

if topology_type == 'A'
    savename = strcat('A_sw_voltages_',num2str(Pout),'_W');
    A_sw1_volt.signals.values = A_sw1_voltage.signals.values(9800000:end);
    A_sw1_volt.time = A_sw1_voltage.time(9800000:end);
    save(savename,'A_sw1_volt');
    savename = strcat('A_sw_currents_',num2str(Pout),'_W');
    A_sw1_cur.signals.values = A_sw1_current.signals.values(9800000:end);
    A_sw1_cur.time = A_sw1_current.time(9800000:end);
    save(savename,'A_sw1_cur');
end
if topology_type == 'B'
    savename = strcat('B_sw_voltages_',num2str(Pout),'_W');
    B_sw1_volt.signals.values = BC_sw1_voltage.signals.values(9800000:end);
    B_sw1_volt.time = BC_sw1_voltage.time(9800000:end);
    save(savename,'B_sw1_volt');
    savename = strcat('B_sw_currents_',num2str(Pout),'_W');
    B_sw1_cur.signals.values = BC_sw1_current.signals.values(9800000:end);
    B_sw1_cur.time = BC_sw1_current.time(9800000:end);
    save(savename,'B_sw1_cur');
end
if topology_type == 'C'
    savename = strcat('C_sw_voltages_',num2str(Pout),'_W');
    C_sw1_volt.signals.values = BC_sw1_voltage.signals.values(9800000:end);
    C_sw1_volt.time = BC_sw1_voltage.time(9800000:end);
    save(savename,'C_sw1_volt');
    savename = strcat('C_sw_currents_',num2str(Pout),'_W');
    C_sw1_cur.signals.values = BC_sw1_current.signals.values(9800000:end);
    C_sw1_cur.time = BC_sw1_current.time(9800000:end);
    save(savename,'C_sw1_cur');
end
if topology_type == 'D'
    savename = strcat('D_uppersw_voltages_',num2str(Pout),'_W');
    D_uppersw_voltages.signals.values = DE_uppersw_voltage.signals.values(9800000:end);
    D_uppersw_voltages.time = DE_uppersw_voltage.time(9800000:end);
    save(savename,'D_uppersw_voltages');
    
    savename = strcat('D_uppersw_currents_',num2str(Pout),'_W');
    D_uppersw_currents.signals.values = DE_uppersw_current.signals.values(9800000:end);
    D_uppersw_currents.time = DE_uppersw_current.time(9800000:end);
    save(savename,'D_uppersw_currents');
    
    savename = strcat('D_lowersw_voltages_',num2str(Pout),'_W');
    D_lowersw_voltages.signals.values = DE_lowersw_voltage.signals.values(9800000:end);
    D_lowersw_voltages.time = DE_lowersw_voltage.time(9800000:end);
    save(savename,'D_lowersw_voltages');
    
    savename = strcat('D_lowersw_currents_',num2str(Pout),'_W');
    D_lowersw_currents.signals.values = DE_lowersw_current.signals.values(9800000:end);
    D_lowersw_currents.time = DE_lowersw_current.time(9800000:end);
    save(savename,'D_lowersw_currents');
    
    savename = strcat('D_diode_voltages_',num2str(Pout),'_W');
    D_diode_voltages.signals.values = DE_Diode1_voltage.signals.values(9800000:end);
    D_diode_voltages.time = DE_Diode1_voltage.time(9800000:end);
    save(savename,'D_diode_voltages');
    
    savename = strcat('D_diode_currents_',num2str(Pout),'_W');
    D_diode_currents.signals.values = DE_Diode1_current.signals.values(9800000:end);
    D_diode_currents.time = DE_Diode1_current.time(9800000:end);
    save(savename,'D_diode_currents');
end
if topology_type == 'E'
    savename = strcat('E_uppersw_voltages_',num2str(Pout),'_W');
    E_uppersw_voltages.signals.values = DE_uppersw_voltage.signals.values(9800000:end);
    E_uppersw_voltages.time = DE_uppersw_voltage.time(9800000:end);
    save(savename,'E_uppersw_voltages');
    
    savename = strcat('E_uppersw_currents_',num2str(Pout),'_W');
    E_uppersw_currents.signals.values = DE_uppersw_current.signals.values(9800000:end);
    E_uppersw_currents.time = DE_uppersw_current.time(9800000:end);
    save(savename,'E_uppersw_currents');
    
    savename = strcat('E_lowersw_voltages_',num2str(Pout),'_W');
    E_lowersw_voltages.signals.values = DE_lowersw_voltage.signals.values(9800000:end);
    E_lowersw_voltages.time = DE_lowersw_voltage.time(9800000:end);
    save(savename,'E_lowersw_voltages');
    
    savename = strcat('E_lowersw_currents_',num2str(Pout),'_W');
    E_lowersw_currents.signals.values = DE_lowersw_current.signals.values(9800000:end);
    E_lowersw_currents.time = DE_lowersw_current.time(9800000:end);
    save(savename,'E_lowersw_currents');
    
    savename = strcat('E_diode_voltages_',num2str(Pout),'_W');
    E_diode_voltages.signals.values = DE_Diode1_voltage.signals.values(9800000:end);
    E_diode_voltages.time = DE_Diode1_voltage.time(9800000:end);
    save(savename,'E_diode_voltages');
    
    savename = strcat('E_diode_currents_',num2str(Pout),'_W');
    E_diode_currents.signals.values = DE_Diode1_current.signals.values(9800000:end);
    E_diode_currents.time = DE_Diode1_current.time(9800000:end);
    save(savename,'E_diode_currents');
end
Pout
end