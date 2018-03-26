for count = 1:1:3
    figure
    plot(timedata_all(count,:),lowersw_current_all(count,:))
end
%%
for count = 1:1:3
    figure
    plot(timedata_all(count,:),lowersw_voltage_all(count,:))
end