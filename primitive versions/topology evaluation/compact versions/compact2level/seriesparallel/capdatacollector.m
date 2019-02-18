count = 1;
for sw_frequency = 1050:1000:101050
    savename = strcat('topology_C_capacitor',num2str(sw_frequency),'Hz');
    dataload = load(savename);
    Capacitor_values(count) = dataload.Capacitor_values;
    sw_frequencies_all(count) = sw_frequency;
    count = count+1;
end