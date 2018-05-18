function y = GaN_sw(Id,c)

k_on=(80/15)*1e-6; %from the slope of two points
% alternatively two regions can be estimated for Eon since there was no
% data points between (0,0) and (3.84,1.09)
k_off=(13.5/15)*1e-6; % This line was quite linear and could be extrapolated to origin

if (strcmp(c,'on'))
    y=Id*k_on; %J
elseif (strcmp(c,'off'))
    y=Id*k_off; %J
end
    
end
