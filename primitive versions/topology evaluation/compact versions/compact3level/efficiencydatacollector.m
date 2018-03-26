count = 1;
for sw_frequency = 1000:1000:100000
    savename = strcat('topology_E_duzfrekans',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    diode1_current_all(count,1:numel(dataload.diode1_current)) = dataload.diode1_current;
    diode1_voltage_all(count,1:numel(dataload.diode1_voltage)) = dataload.diode1_voltage;
    
    lowersw_current_all(count,1:numel(dataload.lowersw_current)) = dataload.lowersw_current;
    lowersw_voltage_all(count,1:numel(dataload.lowersw_voltage)) = dataload.lowersw_voltage;

    uppersw_current_all(count,1:numel(dataload.uppersw_current)) = dataload.uppersw_current;
    uppersw_voltage_all(count,1:numel(dataload.uppersw_voltage)) = dataload.uppersw_voltage;
    
    neg_diode1_current_all(count,1:numel(dataload.neg_diode1_current)) = dataload.neg_diode1_current;
    neg_diode1_voltage_all(count,1:numel(dataload.neg_diode1_voltage)) = dataload.neg_diode1_voltage;
    
    neg_lowersw_current_all(count,1:numel(dataload.neg_lowersw_current)) = dataload.neg_lowersw_current;
    neg_lowersw_voltage_all(count,1:numel(dataload.neg_lowersw_voltage)) = dataload.neg_lowersw_voltage;

    neg_uppersw_current_all(count,1:numel(dataload.neg_uppersw_current)) = dataload.neg_uppersw_current;
    neg_uppersw_voltage_all(count,1:numel(dataload.neg_uppersw_voltage)) = dataload.neg_uppersw_voltage;
    
    timedata_all(count,1:numel(dataload.timedata)) = dataload.timedata;
    
    sw_frequency_all(count) = sw_frequency;
    count=count+1;

    
end