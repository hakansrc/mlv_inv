function [DCLINK_Cap] = capacitorselection(Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,Lsm,Efm)
Idcrms1 = Is*sqrt( 2*ma*(sqrt(3)/(4*pi) +...
    pf^2*(sqrt(3)/pi-9*ma/16)) ); % Amps

Vdcrip = 1;
Cdcreq1 = ns*(ma*Is/(16*sw_frequency*Vdcrip))*...
    sqrt( (6 - (96*sqrt(3)*ma)/(5*pi) +...
    (9*ma^2/2) )*pf^2 + (8*sqrt(3)*ma)/(5*pi) ); % Farads

% When no interleaving is used, the ripple voltage (or capacitance)
% can be directly multiplied by the number of parallel connected modules
%[intc,intv] = interleaving_effect(n,ns);
intc = 1;
intv = 1;
Idcrms = Idcrms1*np*intc; % Amps
Cdcreq = Cdcreq1*np*intv; % Amps
DCLINK_Cap = Cdcreq;

%capacitorsabiti = 200e-6*14000;
%DCLINK_Cap = capacitorsabiti/sw_frequency;
Ls = Lsm;
Ef = Efm;

end