function Vds=GaNB_reverse_cond(Id)
Id=abs(Id);
if (0<=Id) && (Id<20.06)
    Vds=1.25/20.06;

elseif (20.06<=Id) && (Id<30.09)
    Vds=(1.95-1.25)/(30.09-20.06)*Id;

elseif (30.09<=Id) && (Id<39.94)
     Vds=(2.76-1.95)/(39.94-30.09)*Id;

elseif (39.94<=Id) && (Id<49.62)
     Vds=(3.825-2.76)/(49.62-39.94)*Id;

elseif (49.62<=Id) && (Id<55.6)
     Vds=(5-3.825)/(55.6-49.62)*Id;
end

end