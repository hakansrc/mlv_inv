clear
k = 1;
%% line1
x0 = 0;
y0 = 0;
x1 = 0.66;
y1 = 1.98;


for Id = 0:0.01:40.36
    if (0<Id) && (Id<0.9)
        Vds(k)= Id/1.81;
        
    elseif (0.9<=Id) && (Id<2.48)
        Vds(k)=(Id+2.78)/7.41;
        
    elseif (2.48<=Id) && (Id<9.36)
        Vds(k)=(Id+12.78)/21.5;
        
    elseif (9.36<=Id) && (Id<=26.48)
        Vds(k)=(Id+22.7)/31.13;
    elseif (26.48<=Id) && (Id<=40.36)
        Vds(k)=(Id+28.35)/34.7;
    end
    k = k+1;
end
Id = 0:0.01:40.36;
plot(Vds,Id,'LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
