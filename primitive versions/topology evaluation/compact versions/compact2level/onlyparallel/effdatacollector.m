count = 1;
for Load_Real_Power = 800:800:8000
    savename = strcat('topology_A_eff_load_',num2str(Load_Real_Power),'W');
    dataload = load(savename);
    
    Isw1_all(count,1:numel(dataload.Isw1)) = dataload.Isw1;
    timedata_all(count,1:numel(dataload.Isw1)) = dataload.Isw1_timedata;
    
    
    Load_Real_Power_all(count) = Load_Real_Power;
    
    
    
    count = count+1;
end