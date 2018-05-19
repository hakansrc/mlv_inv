function Vds= IGBT_cond( Id )
if (0<=Id) && (Id<0.94)
    Vds=0;

elseif (0.94<=Id) && (Id<4.33)
    Vds=(0.795-0.5)/(4.33-0.94)*Id;

elseif (4.33<=Id) && (Id<14.7)
     Vds=(1.23-0.795)/(14.7-4.33)*Id;

elseif (14.7<=Id) && (Id<40)
     Vds=(1.99-1.23)/(40-14.7)*Id;
end

end

