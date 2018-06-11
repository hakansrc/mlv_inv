function Err = diode_sw(Id)
If=abs(Id);
if (0<=If) && (If<3.915)
    Err=(If*0.209)*(540/600);

elseif (3.915<=If) && (If<9.95)
    Err=(If*0.091+0.463)*(540/600);

elseif (9.95<=If) && (If<16.64)
     Err=(If*0.0807+0.556)*(540/600);

elseif (16.64<=If) && (If<25.44)
     Err=(If*0.066+0.813)*(540/600);
elseif (25.44<=If) && (If<35.07)
     Err=(If*0.054+1.12)*(540/600);
elseif (35.07<=If) && (If<40.45)
     Err=(If*0.0446+1.44)*(540/600);
       
end

end

