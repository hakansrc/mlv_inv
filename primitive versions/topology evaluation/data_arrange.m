load('topology_a_alldata.mat')
THD_Ia_A = THD_Ia1_all;
THD_Vab_A = THD_Vab1_all;
DCLINK_Irms_A = DCLINK_Icrms_all;
sw_frequency_A = sw_frequencies;

clearvars -except THD_Ia_A THD_Vab_A DCLINK_Irms_A sw_frequency_A