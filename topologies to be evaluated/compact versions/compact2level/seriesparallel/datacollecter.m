count = 1;
for sw_frequency = 1050:5000:100050
    savename = strcat('topology_B_',num2str(sw_frequency),'Hz','.mat');
    dataload = load(savename);
    Capacitor_all(count) = dataload.Capacitor_values;
    DCLINK_Ic1rms_all(count) = dataload.DCLINK_Ic1rms;
    DCLINK_Ic2rms_all(count) = dataload.DCLINK_Ic2rms;
    DCLINK_Vc1rms_all(count) = dataload.DCLINK_Vc1rms;
    DCLINK_Vc2rms_all(count) = dataload.DCLINK_Vc2rms;
    
    DCLINK_cap1_current_spectrum_abs_all(count,1:numel(dataload.DCLINK_cap1_current_spectrum_abs)) = dataload.DCLINK_cap1_current_spectrum_abs;
    DCLINK_cap1_voltage_spectrum_abs_all(count,1:numel(dataload.DCLINK_cap1_voltage_spectrum_abs)) = dataload.DCLINK_cap1_voltage_spectrum_abs;
    DCLINK_cap2_current_spectrum_abs_all(count,1:numel(dataload.DCLINK_cap2_current_spectrum_abs)) = dataload.DCLINK_cap2_current_spectrum_abs;
    DCLINK_cap2_voltage_spectrum_abs_all(count,1:numel(dataload.DCLINK_cap2_voltage_spectrum_abs)) = dataload.DCLINK_cap2_voltage_spectrum_abs;
    Ia1_Spectrum_abs_all(count,1:numel(dataload.Ia1_Spectrum_abs)) = dataload.Ia1_Spectrum_abs;
%     Ia2_Spectrum_abs_all(count,1:numel(dataload.Ia2_Spectrum_abs)) = dataload.Ia2_Spectrum_abs;
    Ia3_Spectrum_abs_all(count,1:numel(dataload.Ia3_Spectrum_abs)) = dataload.Ia3_Spectrum_abs; 
%     Ia4_Spectrum_abs_all(count,1:numel(dataload.Ia4_Spectrum_abs)) = dataload.Ia4_Spectrum_abs; 
    Ib1_Spectrum_abs_all(count,1:numel(dataload.Ib1_Spectrum_abs)) = dataload.Ib1_Spectrum_abs; 
%     Ib2_Spectrum_abs_all(count,1:numel(dataload.Ib2_Spectrum_abs)) = dataload.Ib2_Spectrum_abs;
    Ib3_Spectrum_abs_all(count,1:numel(dataload.Ib3_Spectrum_abs)) = dataload.Ib3_Spectrum_abs; 
%     Ib4_Spectrum_abs_all(count,1:numel(dataload.Ib4_Spectrum_abs)) = dataload.Ib4_Spectrum_abs;
    Ic1_Spectrum_abs_all(count,1:numel(dataload.Ic1_Spectrum_abs)) = dataload.Ic1_Spectrum_abs; 
%     Ic2_Spectrum_abs_all(count,1:numel(dataload.Ic2_Spectrum_abs)) = dataload.Ic2_Spectrum_abs;
    Ic3_Spectrum_abs_all(count,1:numel(dataload.Ic3_Spectrum_abs)) = dataload.Ic3_Spectrum_abs; 
%     Ic4_Spectrum_abs_all(count,1:numel(dataload.Ic4_Spectrum_abs)) = dataload.Ic4_Spectrum_abs; 
    
    LLab1_voltages_spectrum_abs_all(count,1:numel(dataload.LLab1_voltages_spectrum_abs)) = dataload.LLab1_voltages_spectrum_abs;
%     LLab2_voltages_spectrum_abs_all(count,1:numel(dataload.LLab2_voltages_spectrum_abs)) = dataload.LLab2_voltages_spectrum_abs;
    LLab3_voltages_spectrum_abs_all(count,1:numel(dataload.LLab3_voltages_spectrum_abs)) = dataload.LLab3_voltages_spectrum_abs;
%     LLab4_voltages_spectrum_abs_all(count,1:numel(dataload.LLab4_voltages_spectrum_abs)) = dataload.LLab4_voltages_spectrum_abs;
    LLbc1_voltages_spectrum_abs_all(count,1:numel(dataload.LLbc1_voltages_spectrum_abs)) = dataload.LLbc1_voltages_spectrum_abs;
%     LLbc2_voltages_spectrum_abs_all(count,1:numel(dataload.LLbc2_voltages_spectrum_abs)) = dataload.LLbc2_voltages_spectrum_abs;
    LLbc3_voltages_spectrum_abs_all(count,1:numel(dataload.LLbc3_voltages_spectrum_abs)) = dataload.LLbc3_voltages_spectrum_abs;
%     LLbc4_voltages_spectrum_abs_all(count,1:numel(dataload.LLbc4_voltages_spectrum_abs)) = dataload.LLbc4_voltages_spectrum_abs;
    LLca1_voltages_spectrum_abs_all(count,1:numel(dataload.LLca1_voltages_spectrum_abs)) = dataload.LLca1_voltages_spectrum_abs;
%     LLca2_voltages_spectrum_abs_all(count,1:numel(dataload.LLca2_voltages_spectrum_abs)) = dataload.LLca2_voltages_spectrum_abs;
    LLca3_voltages_spectrum_abs_all(count,1:numel(dataload.LLca3_voltages_spectrum_abs)) = dataload.LLca3_voltages_spectrum_abs;
%     LLca4_voltages_spectrum_abs_all(count,1:numel(dataload.LLca4_voltages_spectrum_abs)) = dataload.LLca4_voltages_spectrum_abs;
    
    freq_all(count,1:numel(dataload.freq)) = dataload.freq;
    
    THD_Ia1_all(count) = dataload.THD_Ia1;
    THD_Vab1_all(count) = dataload.THD_Vab1;
%     THD_Ia2_all(count) = dataload.THD_Ia2;
%     THD_Vab2_all(count) = dataload.THD_Vab2;
    THD_Ia3_all(count) = dataload.THD_Ia3;
    THD_Vab3_all(count) = dataload.THD_Vab3;
%     THD_Ia4_all(count) = dataload.THD_Ia4;
%     THD_Vab4_all(count) = dataload.THD_Vab4;
    ripple1percent_all(count) = dataload.ripple1percent;
    ripple1vector_all(count) = dataload.ripple1vector;
    ripple2percent_all(count) = dataload.ripple2percent;
    ripple2vector_all(count) = dataload.ripple2vector;
    
    Vab1_all(count,1:numel(dataload.Vab1)) = dataload.Vab1;
%     Vab2_all(count,1:numel(dataload.Vab2)) = dataload.Vab2;
    Vab3_all(count,1:numel(dataload.Vab3)) = dataload.Vab3;
%     Vab4_all(count,1:numel(dataload.Vab4)) = dataload.Vab4;
    
    Ia1_all(count,1:numel(dataload.Ia1)) = dataload.Ia1;
%     Ia2_all(count,1:numel(dataload.Ia2)) = dataload.Ia2;
    Ia3_all(count,1:numel(dataload.Ia3)) = dataload.Ia3;
%     Ia4_all(count,1:numel(dataload.Ia4)) = dataload.Ia4;
    
    phasecurrentstime_all(count,1:numel(dataload.phasecurrentstime))= dataload.phasecurrentstime;
    sw_frequencies(count) = sw_frequency;
    
    
    
    count = count+1;
end