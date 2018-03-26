count = 1;
for sw_frequency = 1050:1000:25050
    savename = strcat('IGBTmodel',num2str(count),'kHz');
    dataload = load(savename);
    Capacitor_all(count) = dataload.Capacitor_values;
    DCLINK_Icrms_all(count) = dataload.DCLINK_Icrms;
    DCLINK_Vcrms_all(count) = dataload.DCLINK_Vcrms;
    
    DCLINK_current_spectrum_abs_all(count,1:numel(dataload.DCLINK_current_spectrum_abs)) = dataload.DCLINK_current_spectrum_abs;
    DCLINK_voltage_spectrum_abs_all(count,1:numel(dataload.DCLINK_voltage_spectrum_abs)) = dataload.DCLINK_voltage_spectrum_abs;
    
    freq_all(count,1:numel(dataload.freq)) = dataload.freq;
    Ia_Spectrum_abs_all(count,1:numel(dataload.Ia_Spectrum_abs)) = dataload.Ia_Spectrum_abs;
    Ib_Spectrum_abs_all(count,1:numel(dataload.Ib_Spectrum_abs)) = dataload.Ib_Spectrum_abs;
    Ic_Spectrum_abs_all(count,1:numel(dataload.Ic_Spectrum_abs)) = dataload.Ic_Spectrum_abs;
    
    LLab_voltages_spectrum_abs_all(count,1:numel(dataload.LLab_voltages_spectrum_abs)) = dataload.LLab_voltages_spectrum_abs;
    LLbc_voltages_spectrum_abs_all(count,1:numel(dataload.LLbc_voltages_spectrum_abs)) = dataload.LLbc_voltages_spectrum_abs;
    LLca_voltages_spectrum_abs_all(count,1:numel(dataload.LLca_voltages_spectrum_abs)) = dataload.LLca_voltages_spectrum_abs;
    
    
    ripplepercentvector_all(count) = dataload.ripplepercentvector;
    ripplevector_all(count) = dataload.ripplevector;
    THD_Ia1_all(count) = dataload.THDV_2level_IGBTIa1;
    THD_Vab1_all(count) = dataload.THDV_2level_IGBTVab1;
    
    
    
    sw_frequencies(count) = sw_frequency;
    
    
    
    count = count+1;
end
