function Vds=GaN_reverse_cond(Id)
Id=abs(Id);
if (0<=Id) && (Id<2.018)
    Vds=Id/7.945;
    
elseif (2.018<=Id) && (Id<5.84)
    Vds=(Id-0.0607)/7.705;
    
elseif (5.84<=Id) && (Id<11.90)
    Vds=(Id-0.208)/7.509;
    
elseif (11.90<=Id) && (Id<16.04)
    Vds=(Id-1.716)/6.54;
    
elseif (16.04<=Id) && (Id<20.079)
    Vds=(Id-3.51)/5.721;
    
elseif (20.079<=Id) && (Id<22.84)
    Vds=(Id-7.014)/4.51;
elseif (22.84<=Id) && (Id<25.07)
    Vds=(Id-10.18)/3.608;
end


end

