clear
k = 1;
%% A_IGBT
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
%% A diode cond 
clear
k = 1;

for If = 0:0.01:40.18

if (0<=If) && (If<0.05)
    Vds(k)=If/0.128;

elseif (0.05<=If) && (If<1.3)
    Vds(k)=(If+3.43)/8.93;


elseif (1.3<=If) && (If<3.12)
     Vds(k)=(If+5.59)/13;


elseif (3.12<=If) && (If<5.47)
     Vds(k)=(If+12.625)/23.5;

elseif (5.47<=If) && (If<9.09)
     Vds(k)=(If+17.75)/30.16;
     
elseif (9.09<=If) && (If<18.85)
     Vds(k)=(If+27.10)/40.67;
     
elseif (18.85<=If) && (If<30.06)
     Vds(k)=(If+41.47)/53.38;
    
     elseif (30.06<=If) && (If<=40.18)
     Vds(k)=(If+60.34)/67.46;
end
k = k+1;
end
If = 0:0.01:40.18;
plot(Vds,If,'LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
%% A diode sw 
clear
k = 1;

for If = 0:0.01:40.18

if (0<=If) && (If<3.915)
    Err(k)=If*0.209;

elseif (3.915<=If) && (If<9.95)
    Err(k)=If*0.091+0.463;

elseif (9.95<=If) && (If<16.64)
     Err(k)=If*0.0807+0.556;

elseif (16.64<=If) && (If<25.44)
     Err(k)=If*0.066+0.813;
elseif (25.44<=If) && (If<35.07)
     Err(k)=If*0.054+1.12;
elseif (35.07<=If) && (If<=40.45)
     Err(k)=If*0.0446+1.44;
       
end

k = k+1;
end
If = 0:0.01:40.18;
plot(If,Err,'LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
%% A IGBT sw
clear
k = 1;

for If = 0:0.01:40.18

if (0<=If) && (If<3.915)
    Err(k)=If*0.209;

elseif (3.915<=If) && (If<9.95)
    Err(k)=If*0.091+0.463;

elseif (9.95<=If) && (If<16.64)
     Err(k)=If*0.0807+0.556;

elseif (16.64<=If) && (If<25.44)
     Err(k)=If*0.066+0.813;
elseif (25.44<=If) && (If<35.07)
     Err(k)=If*0.054+1.12;
elseif (35.07<=If) && (If<=40.45)
     Err(k)=If*0.0446+1.44;
       
end

k = k+1;
end
If = 0:0.01:40.18;
plot(If,Err,'LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
%% B GAN cond
clear
k = 1;
for Id = 0:0.01:42.36
if (0<=Id) && (Id<11.33)
    Vds(k)=Id/16.325;

elseif (11.33<=Id) && (Id<25.36)
    Vds(k)=(Id-0.792)/15.18;

elseif (25.36<=Id) && (Id<35.06)
     Vds(k)=(Id-3.317)/13.623;

elseif (35.06<=Id) && (Id<=42.36)
     Vds(k)=(Id-8.483)/11.406;

end
    k = k+1;
end
Id = 0:0.01:42.36;
figure
plot(Vds,Id,'LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
%% D diode cond
clear
k = 1;
for Id = 0:0.01:42.36
if (0<=Id) && (Id<0.0258)
    Vds(k)=Id/0.043;

elseif (0.0258<=Id) && (Id<3.612)
    Vds(k)=(Id+9.45)/15.8;

elseif (3.612<=Id) && (Id<8.39)
     Vds(k)=(Id+29.04)/39.49;

elseif (8.39<=Id) && (Id<22.88)
     Vds(k)=(Id+35.63)/46.44;
elseif (22.88<=Id) && (Id<39.76)
     Vds(k)=(Id+37.88)/48.22;
elseif (39.76<=Id) && (Id<50.50)
     Vds(k)=(Id+42.58)/51.14;

end
    k = k+1;
end
Id = 0:0.01:42.36;
% figure
plot(Vds,Id,'LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
%% C E Gan Cond
clear
k = 1;
for Id = 0:0.01:23
if (0<=Id) && (Id<2.018)
    Vds(k)=Id/7.945;
    
elseif (2.018<=Id) && (Id<5.84)
    Vds(k)=(Id-0.0607)/7.705;
    
elseif (5.84<=Id) && (Id<11.90)
    Vds(k)=(Id-0.208)/7.509;
    
elseif (11.90<=Id) && (Id<16.04)
    Vds(k)=(Id-1.716)/6.54;
    
elseif (16.04<=Id) && (Id<20.079)
    Vds(k)=(Id-3.51)/5.721;
    
elseif (20.079<=Id) && (Id<22.84)
    Vds(k)=(Id-7.014)/4.51;
elseif (22.84<=Id) && (Id<25.07)
    Vds(k)=(Id-10.18)/3.608;
end
    k = k+1;
end
Id = 0:0.01:23;
% figure
plot(Vds,Id,'LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
%% C E diode Cond
clear
k = 1;
for Id = 0:0.01:23
if (0<=Id) && (Id<0.382)
    Vds(k)=(Id+2.578)/4.152;

elseif (0.382<=Id) && (Id<1.464)
    Vds(k)=(Id+5.208)/7.84;

elseif (1.464<=Id) && (Id<7.638)
     Vds(k)=(Id+8.62)/11.85;

elseif (7.638<=Id) && (Id<11.33)
     Vds(k)=(Id+9.709)/12.644;
elseif (11.33<=Id) && (Id<15.467)
     Vds(k)=(Id+10.049)/12.848;
elseif (15.467<=Id) && (Id<21.32)
     Vds(k)=(Id+9.37)/12.506;
elseif (21.32<=Id) && (Id<25.33)
     Vds(k)=(Id+9.24)/12.453;
end
    k = k+1;
end
Id = 0:0.01:23;
% figure
plot(Vds,Id,'LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')