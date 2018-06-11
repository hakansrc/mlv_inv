function Vds = diode_cond(Id)
if (0<=Id) && (Id<0.0258)
    Vds=Id/0.043;

elseif (0.0258<=Id) && (Id<3.612)
    Vds=(Id+9.45)/15.8;

elseif (3.612<=Id) && (Id<8.39)
     Vds=(Id+29.04)/39.49;

elseif (8.39<=Id) && (Id<22.88)
     Vds=(Id+35.63)/46.44;
elseif (22.88<=Id) && (Id<39.76)
     Vds=(Id+37.88)/48.22;
elseif (39.76<=Id) && (Id<50.50)
     Vds=(Id+42.58)/51.14;

end
end