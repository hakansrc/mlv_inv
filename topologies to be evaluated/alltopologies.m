cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated')
% open_system('all_topologies.slx');
clear
%% initialization for all topologies
global ma ref_frequency sw_frequency Sampling_time Fs stop_time
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 1050; %Hz
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 1; %duration of the model
%%
global topology_type np ns
topology_type = input('Please specify the topology type','s');
commentouter(topology_type);
%% Load&Source settings
% Pout = 8000; %W
% Poutm = Pout/(ns*np);
% Ef = 155;
% Efm = Ef/ns;
% % Ls's value will be decided depending on the topology
% Ls = 13.8e-3; % H
% Lsm = Ls;
% Vdc = 540; % Vdc
% Vdcm = Vdc/ns; % V
% Is = Poutm/(3*np*Efm); % Aline
% Xs = ref_frequency*Lsm; % Ohm
% Vtln = sqrt(Efm^2+(Xs*Is)^2); % Vln
% Vtll = Vtln*sqrt(3); % Vll
% ma = (Vtll)/(Vdcm*0.612);
% delta = 180*atan(Xs*Is/Efm)/pi;
% Load_Angle = delta*pi/180;
% pf = cos(Load_Angle);
% 
% interleaving_angle = 360/np;
% intangle1 = 0;
% intangle2 = intangle1 + interleaving_angle;
% intangle3 =intangle1;
% intangle4 = intangle2;
loadsourcesettings(topology_type,ns,np)
%% capacitor selection
% dont know how it works, please refer to mesutto
% Idcrms1 = Is*sqrt( 2*ma*(sqrt(3)/(4*pi) +...
%     pf^2*(sqrt(3)/pi-9*ma/16)) ); % Amps
% 
% Vdcrip = 1;
% Cdcreq1 = ns*(ma*Is/(16*sw_frequency*Vdcrip))*...
%     sqrt( (6 - (96*sqrt(3)*ma)/(5*pi) +...
%     (9*ma^2/2) )*pf^2 + (8*sqrt(3)*ma)/(5*pi) ); % Farads
% 
% % When no interleaving is used, the ripple voltage (or capacitance)
% % can be directly multiplied by the number of parallel connected modules
% %[intc,intv] = interleaving_effect(n,ns);
% intc = 1;
% intv = 1;
% Idcrms = Idcrms1*np*intc; % Amps
% Cdcreq = Cdcreq1*np*intv; % Amps
% DCLINK_Cap = Cdcreq;
% 
% %capacitorsabiti = 200e-6*14000;
% %DCLINK_Cap = capacitorsabiti/sw_frequency;
% Rin = 1; %ohm
% Vin = Vdc + Rin*(Pout/Vdc);
% 
% Ls = Lsm;
% Ef = Efm;

capacitorselection(Is,ma,pf,ns,np,sw_frequency,Vdc,Pout,Lsm,Efm)



