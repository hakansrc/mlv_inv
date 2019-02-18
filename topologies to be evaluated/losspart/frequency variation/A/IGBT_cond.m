function Vds= IGBT_cond( Id )
if (0<Id) && (Id<0.9)
    Vds= Id/1.81;
    
elseif (0.9<=Id) && (Id<2.48)
    Vds=(Id+2.78)/7.41;
    
elseif (2.48<=Id) && (Id<9.36)
    Vds=(Id+12.78)/21.5;
    
elseif (9.36<=Id) && (Id<=26.48)
    Vds=(Id+22.7)/31.13;
elseif (26.48<=Id) && (Id<=40.36)
    Vds=(Id+28.35)/34.7;
end

end

