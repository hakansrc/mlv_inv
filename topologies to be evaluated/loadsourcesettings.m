function [Vin, Poutm, Ls, Ef, Efm, Vdc, Vdcm, Is, Xs, Vtln, Vtll, ma, delta, Load_Angle, pf, intangle1, intangle2, intangle3, intangle4, Lsm, THD_mean_frequency,Load_Nominal_Freq]  = loadsourcesettings(topology_type,ns,np,Pout)
ref_frequency = 2*pi*50;
% Pout = 6000; %W
Poutm = Pout/(ns*np);
% Ls = 13.8e-3; %will be decided based on topology
% Ef = 154.55;
if topology_type == 'A'
    Ls = 13.8e-3;
    Ef = 154.55;
end
if topology_type == 'B'
    Ls = 13.8e-3/2;
    Ef = 154.55/2;
end
if topology_type == 'C'
    Ls = 13.8e-3;
    Ef = 154.55/2;
end
if topology_type == 'D'
    Ls = 13.8e-3;
    Ef = 154.55;
end
if topology_type == 'E'
    Ls = 2*13.8e-3;
    Ef = 154.55;
end
Vdc = 540;
Vdcm = Vdc/ns;
Is = Poutm/(3*Ef); % Aline
Xs = ref_frequency*Ls; % Ohm
Vtln = sqrt(Ef^2+(Xs*Is)^2); % Vln
Vtll = Vtln*sqrt(3); % Vll
ma = (Vtll)/(Vdcm*0.612);
delta = 180*atan(Xs*Is/Ef)/pi;
Load_Angle = delta*pi/180;
pf = cos(Load_Angle);

interleaving_angle = 360/np;
intangle1 = 0;
intangle2 = intangle1 + interleaving_angle;
intangle3 =intangle1;
intangle4 = intangle2;
Rin = 1; %ohm
Vin = Vdc + Rin*(Pout/Vdc);
THD_mean_frequency = 10;
Load_Nominal_Freq = 50;
Efm = 0;
Lsm = 0;

end