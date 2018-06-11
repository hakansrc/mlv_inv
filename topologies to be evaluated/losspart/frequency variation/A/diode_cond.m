function Vds=diode_cond(If)
If=abs(If);
if (0<=If) && (If<0.05)
    Vds=If/0.128;

elseif (0.05<=If) && (If<1.3)
    Vds=(If+3.43)/8.93;


elseif (1.3<=If) && (If<3.12)
     Vds=(If+5.59)/13;


elseif (3.12<=If) && (If<5.47)
     Vds=(If+12.625)/23.5;

elseif (5.47<=If) && (If<9.09)
     Vds=(If+17.75)/30.16;
     
elseif (9.09<=If) && (If<18.85)
     Vds=(If+27.10)/40.67;
     
elseif (18.85<=If) && (If<30.06)
     Vds=(If+41.47)/53.38;
    
     elseif (30.06<=If) && (If<40.18)
     Vds=(If+60.34)/67.46;
end


end

