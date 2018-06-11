function Vds = diode_cond(Id)
if (0<=Id) && (Id<0.382)
    Vds=(Id+2.578)/4.152;

elseif (0.382<=Id) && (Id<1.464)
    Vds=(Id+5.208)/7.84;

elseif (1.464<=Id) && (Id<7.638)
     Vds=(Id+8.62)/11.85;

elseif (7.638<=Id) && (Id<11.33)
     Vds=(Id+9.709)/12.644;
elseif (11.33<=Id) && (Id<15.467)
     Vds=(Id+10.049)/12.848;
elseif (15.467<=Id) && (Id<21.32)
     Vds=(Id+9.37)/12.506;
elseif (21.32<=Id) && (Id<25.33)
     Vds=(Id+9.24)/12.453;
end
end