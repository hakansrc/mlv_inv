function Vds=GaN_reverse_cond(Id)
Id=abs(Id);
if (0<=Id) && (Id<10.02)
    Vds=1.31/10.02;

elseif (10.02<=Id) && (Id<15.03)
    Vds=(2.03-1.31)/(15.03-10.02)*Id;

elseif (15.03<=Id) && (Id<20.04)
     Vds=(2.89-2.03)/(20.04-15.03)*Id;

elseif (20.04<=Id) && (Id<23.11)
     Vds=(3.58-2.89)/(23.11-20.04)*Id;

elseif (23.11<=Id) && (Id<25.76)
     Vds=(4.38-3.58)/(25.76-23.11)*Id;

elseif (25.76<=Id) && (Id<26.94)
     Vds=(5.01-4.38)/(26.94-25.76)*Id;
end


end

