function y = GaN_sw(Id,c)

k_on=(270/400)*47.5*1e-6*(7.5/4.5)/15; %from the slope of two points
% alternatively two regions can be estimated for Eon since there was no
% data points between (0,0) and (3.84,1.09)
k_off=(270/400)*7.5*1e-6*(4.5/2.5)/15; % This line was quite linear and could be extrapolated to origin

if (strcmp(c,'on'))
    y=Id*k_on; %J
elseif (strcmp(c,'off'))
    y=Id*k_off; %J
end
    
end
