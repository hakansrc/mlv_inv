function Vds=GaNB_reverse_cond(Id)
Id=abs(Id);
if (0<=Id) && (Id<11.33)
    Vds=Id/16.325;

elseif (11.33<=Id) && (Id<25.36)
    Vds=(Id-0.792)/15.18;

elseif (25.36<=Id) && (Id<35.06)
     Vds=(Id-3.317)/13.623;

elseif (35.06<=Id) && (Id<42.36)
     Vds=(Id-8.483)/11.406;

end
end