function y = IGBT_sw(Id,c)

k_on=5.79/40; %from the slope of two points
% alternatively two regions can be estimated for Eon since there was no
% data points between (0,0) and (3.84,1.09)
k_off=3.9/40; % This line was quite linear and could be extrapolated to origin

if (strcmp(c,'on'))
    y=Id*k_on; %mJ
elseif (strcmp(c,'off'))
    y=Id*k_off; %mJ
end
    
end
