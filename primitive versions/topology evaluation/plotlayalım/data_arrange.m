% load('topology_A_alldata.mat')
% THD_Ia_A = THD_Ia1_all;
% THD_Vab_A = THD_Vab1_all;
% DCLINK_Irms_A = DCLINK_Icrms_all;
% sw_frequency_A = sw_frequencies;
% 
% clearvars -except THD_Ia_A THD_Vab_A DCLINK_Irms_A sw_frequency_A ...
%     THD_Ia_B THD_Vab_B DCLINK_Irms_B sw_frequency_B THD_Ia_C ...
%     THD_Vab_C DCLINK_Irms_C sw_frequency_C... 
%     THD_Ia_D THD_Vab_D DCLINK_upperc_Irms_D DCLINK_lowerc_Irms_D Inrms_D sw_frequency_D
%  
% save('THDs_DCLrms_sws.mat')
% 
% load('topology_b_all.mat')
% THD_Ia_B = THD_Ia1_all;
% THD_Vab_B = THD_Vab1_all;
% DCLINK_Irms_B = DCLINK_Ic1rms_all;
% sw_frequency_B = sw_frequencies;
% 
% clearvars -except THD_Ia_A THD_Vab_A DCLINK_Irms_A sw_frequency_A ...
%     THD_Ia_B THD_Vab_B DCLINK_Irms_B sw_frequency_B THD_Ia_C ...
%     THD_Vab_C DCLINK_Irms_C sw_frequency_C... 
%     THD_Ia_D THD_Vab_D DCLINK_upperc_Irms_D DCLINK_lowerc_Irms_D Inrms_D sw_frequency_D
%  
% save('THDs_DCLrms_sws.mat')
% 
% load('topology_c_all.mat')
% THD_Ia_C = THD_Ia1_all;
% THD_Vab_C = THD_Vab1_all;
% DCLINK_Irms_C = DCLINK_Ic1rms_all;
% sw_frequency_C = sw_frequencies;
% 
% clearvars -except THD_Ia_A THD_Vab_A DCLINK_Irms_A sw_frequency_A ...
%     THD_Ia_B THD_Vab_B DCLINK_Irms_B sw_frequency_B THD_Ia_C ...
%     THD_Vab_C DCLINK_Irms_C sw_frequency_C... 
%     THD_Ia_D THD_Vab_D DCLINK_upperc_Irms_D DCLINK_lowerc_Irms_D Inrms_D sw_frequency_D
%  
% save('THDs_DCLrms_sws.mat')
% 
% load('topology_d_all.mat')
% THD_Ia_D = THD_Ia1_all;
% THD_Vab_D = THD_Vab1_all;
% DCLINK_upperc_Irms_D = upperc_Irms_all;
% DCLINK_lowerc_Irms_D = lowerc_Irms_all;
% Inrms_D = In_rms_all;
% sw_frequency_D = sw_frequency_all;
% 
% clearvars -except THD_Ia_A THD_Vab_A DCLINK_Irms_A sw_frequency_A ...
%     THD_Ia_B THD_Vab_B DCLINK_Irms_B sw_frequency_B THD_Ia_C ...
%     THD_Vab_C DCLINK_Irms_C sw_frequency_C... 
%     THD_Ia_D THD_Vab_D DCLINK_upperc_Irms_D DCLINK_lowerc_Irms_D Inrms_D sw_frequency_D
%  
% save('THDs_DCLrms_sws.mat')
% 
% load('topology_e_all.mat')
% THD_Ia_E = THD_Ia1_all;
% THD_Vab_E = THD_Vab1_all;
% DCLINK_upperc_Irms_E = upperc_Irms_all;
% DCLINK_lowerc_Irms_E = lowerc_Irms_all;
% Inrms_E = In_rms_all;
% sw_frequency_E = sw_frequency_all;
% 
% clearvars -except THD_Ia_A THD_Vab_A DCLINK_Irms_A sw_frequency_A ...
%     THD_Ia_B THD_Vab_B DCLINK_Irms_B sw_frequency_B THD_Ia_C ...
%     THD_Vab_C DCLINK_Irms_C sw_frequency_C... 
%     THD_Ia_D THD_Vab_D DCLINK_upperc_Irms_D DCLINK_lowerc_Irms_D Inrms_D sw_frequency_D...
%     THD_Ia_E THD_Vab_E DCLINK_upperc_Irms_E DCLINK_lowerc_Irms_E Inrms_E sw_frequency_E
%  
% save('THDs_DCLrms_sws.mat')
%%
clear
load ('topology_A_all.mat');
% for count = 1:25
% A_Vab_spectrum(count,:) = LLab_voltages_spectrum_abs_all(count,:);
% 
% end
A_Vab_Spectrum_10khz = LLab_voltages_spectrum_abs_all(10,:);
A_Ia_Spectrum_10khz = Ia_Spectrum_abs_all(10,:);
A_DCLINK_Voltage_Spectrum_10khz = DCLINK_voltage_spectrum_abs_all(10,:);
A_DCLINK_Current_Spectrum_10khz = DCLINK_current_spectrum_abs_all(10,:);
A_freq_10khz = freq_all(10,:);

clearvars -except A_Vab_Spectrum_10khz A_Ia_Spectrum_10khz A_DCLINK_Voltage_Spectrum_10khz...
    A_DCLINK_Current_Spectrum_10khz A_freq_10khz
save('spectrums.mat')



clear
load('topology_B_all.mat')

B_Vab_Spectrum_51khz = LLab1_voltages_spectrum_abs_all(11,:);
B_Ia_Spectrum_51khz = Ia1_Spectrum_abs_all(11,:);
B_DCLINK_Voltage_Spectrum_51khz = DCLINK_cap1_voltage_spectrum_abs_all(11,:);
B_DCLINK_Current_Spectrum_51khz = DCLINK_cap1_current_spectrum_abs_all(11,:);
B_freq_51khz = freq_all(11,:);

clearvars -except A_Vab_Spectrum_10khz A_Ia_Spectrum_10khz A_DCLINK_Voltage_Spectrum_10khz...
    A_DCLINK_Current_Spectrum_10khz A_freq_10khz...
    B_Vab_Spectrum_51khz B_Ia_Spectrum_51khz B_DCLINK_Voltage_Spectrum_51khz...
    B_DCLINK_Current_Spectrum_51khz B_freq_51khz

save('spectrums.mat')


clear
load('topology_C_all.mat')

C_Vab_Spectrum_51khz = LLab1_voltages_spectrum_abs_all(11,:);
C_Ia_Spectrum_51khz = Ia1_Spectrum_abs_all(11,:);
C_DCLINK_Voltage_Spectrum_51khz = DCLINK_cap1_voltage_spectrum_abs_all(11,:);
C_DCLINK_Current_Spectrum_51khz = DCLINK_cap1_current_spectrum_abs_all(11,:);
C_freq_51khz = freq_all(11,:);

clearvars -except A_Vab_Spectrum_10khz A_Ia_Spectrum_10khz A_DCLINK_Voltage_Spectrum_10khz...
    A_DCLINK_Current_Spectrum_10khz A_freq_10khz...
    B_Vab_Spectrum_51khz B_Ia_Spectrum_51khz B_DCLINK_Voltage_Spectrum_51khz...
    B_DCLINK_Current_Spectrum_51khz B_freq_51khz C_Vab_Spectrum_51khz C_Ia_Spectrum_51khz...
    C_DCLINK_Voltage_Spectrum_51khz C_DCLINK_Current_Spectrum_51khz C_freq_51khz

save('spectrums.mat')


load('topology_D_all.mat')
D_Vab_Spectrum_51khz = LLab1_voltages_spectrum_abs_all(11,:);
D_Ia_Spectrum_51khz = Ia1_Spectrum_abs_all(11,:);
D_DCLINK_Voltage_Spectrum_51khz = DCLINK_upperc_voltage_spectrum_abs_all(11,:);
D_DCLINK_Current_Spectrum_51khz = DCLINK_upperc_current_spectrum_abs_all(11,:);
D_freq_51khz = freq_all(11,:);




clearvars -except A_Vab_Spectrum_10khz A_Ia_Spectrum_10khz A_DCLINK_Voltage_Spectrum_10khz...
    A_DCLINK_Current_Spectrum_10khz A_freq_10khz...
    B_Vab_Spectrum_51khz B_Ia_Spectrum_51khz B_DCLINK_Voltage_Spectrum_51khz...
    B_DCLINK_Current_Spectrum_51khz B_freq_51khz C_Vab_Spectrum_51khz C_Ia_Spectrum_51khz...
    C_DCLINK_Voltage_Spectrum_51khz C_DCLINK_Current_Spectrum_51khz C_freq_51khz...
    D_Vab_Spectrum_51khz D_Ia_Spectrum_51khz D_DCLINK_Voltage_Spectrum_51khz... 
    D_DCLINK_Current_Spectrum_51khz D_freq_51khz


save('spectrums.mat')


load('topology_E_all.mat')
E_Vab_Spectrum_51khz = LLab1_voltages_spectrum_abs_all(11,:);
E_Ia_Spectrum_51khz = Ia1_Spectrum_abs_all(11,:);
E_DCLINK_Voltage_Spectrum_51khz = DCLINK_upperc_voltage_spectrum_abs_all(11,:);
E_DCLINK_Current_Spectrum_51khz = DCLINK_upperc_current_spectrum_abs_all(11,:);
E_freq_51khz = freq_all(11,:);

clearvars -except A_Vab_Spectrum_10khz A_Ia_Spectrum_10khz A_DCLINK_Voltage_Spectrum_10khz...
    A_DCLINK_Current_Spectrum_10khz A_freq_10khz...
    B_Vab_Spectrum_51khz B_Ia_Spectrum_51khz B_DCLINK_Voltage_Spectrum_51khz...
    B_DCLINK_Current_Spectrum_51khz B_freq_51khz C_Vab_Spectrum_51khz C_Ia_Spectrum_51khz...
    C_DCLINK_Voltage_Spectrum_51khz C_DCLINK_Current_Spectrum_51khz C_freq_51khz...
    D_Vab_Spectrum_51khz D_Ia_Spectrum_51khz D_DCLINK_Voltage_Spectrum_51khz... 
    D_DCLINK_Current_Spectrum_51khz D_freq_51khz E_Vab_Spectrum_51khz E_Ia_Spectrum_51khz...
    E_DCLINK_Voltage_Spectrum_51khz E_DCLINK_Current_Spectrum_51khz E_freq_51khz
save('spectrums.mat')




