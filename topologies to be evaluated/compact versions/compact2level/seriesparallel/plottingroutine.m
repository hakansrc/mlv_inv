count = 1;
for count = 1:1:20
    figure
    plot3(sw_frequency(1,:),DCLINK_cap1_current_spectrum_abs_all(count,1:end),freq_all(count,1:end));
    
    
end
% 
% for la = 1:1:350001
%     sw_frequency(la,1:end) = sw_frequency(1,1:end);
%     
%     
% end