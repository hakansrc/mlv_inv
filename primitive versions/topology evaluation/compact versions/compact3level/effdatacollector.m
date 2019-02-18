count = 1;
for Load_Real_Power = 800:800:8000
    savename = strcat('final_topology_E_capacitor',num2str(Load_Real_Power),'W');
    dataload = load(savename);
    
    diode_current_all(count,1:numel(dataload.diode_current)) = dataload.diode_current;
    diode_voltage_all(count,1:numel(dataload.diode_voltage)) = dataload.diode_voltage;
    
    lowersw_current_all(count,1:numel(dataload.lowersw_current)) = dataload.lowersw_current;
    lowersw_voltage_all(count,1:numel(dataload.lowersw_voltage)) = dataload.lowersw_voltage;

    uppersw_current_all(count,1:numel(dataload.uppersw_current)) = dataload.uppersw_current;
    uppersw_voltage_all(count,1:numel(dataload.uppersw_voltage)) = dataload.uppersw_voltage;
    Vab1_all(count,1:numel(dataload.Vab1)) = dataload.Vab1;
    Ia1_all(count,1:numel(dataload.Ia1)) = dataload.Ia1;
    
%     neg_diode1_current_all(count,1:numel(dataload.neg_diode1_current)) = dataload.neg_diode1_current;
%     neg_diode1_voltage_all(count,1:numel(dataload.neg_diode1_voltage)) = dataload.neg_diode1_voltage;
    
%     neg_lowersw_current_all(count,1:numel(dataload.neg_lowersw_current)) = dataload.neg_lowersw_current;
%     neg_lowersw_voltage_all(count,1:numel(dataload.neg_lowersw_voltage)) = dataload.neg_lowersw_voltage;
% 
%     neg_uppersw_current_all(count,1:numel(dataload.neg_uppersw_current)) = dataload.neg_uppersw_current;
%     neg_uppersw_voltage_all(count,1:numel(dataload.neg_uppersw_voltage)) = dataload.neg_uppersw_voltage;
%     
    timedata_all(count,1:numel(dataload.timedata)) = dataload.timedata;

    
    
    Load_Real_Power_all(count) = Load_Real_Power;
    
    
    
    count = count+1;
end