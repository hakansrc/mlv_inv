function y = IGBT_sw(Id,c)

k_on=0.128; %from the slope of two points
% alternatively two regions can be estimated for Eon since there was no
% data points between (0,0) and (3.84,1.09)
k_off=0.09333; % This line was quite linear and could be extrapolated to origin

if (strcmp(c,'on'))
    y=(Id*k_on+0.556)*540/600; %mJ
elseif (strcmp(c,'off'))
    y=(Id*k_off+0.02312)*540/600; %mJ
end
    
end
