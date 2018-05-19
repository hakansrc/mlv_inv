function y = GaNB_sw(Id,c)

k_on=134.1*1e-6*(7.5/4.5)/20;%at 20 A and 25 C 134.1 uJ but linearizing the temperature energy of
                                            %  GaN getting help form the IGBT curves, (7.5 to 4.5 from 150 to 25 C) 

                                            
k_off=14.7*1e-6*(4.5/2.5)/20; 

if (strcmp(c,'on'))
    y=Id*k_on; %J
elseif (strcmp(c,'off'))
    y=Id*k_off; %J
end
    
end
