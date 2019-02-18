
%% Load&Source settings
Load_Real_Power = 8000; %W
Load_Power_Factor = 0.9; 
Load_Apparent_Power = Load_Real_Power/Load_Power_Factor; %VA
Load_Reactive_Power = Load_Apparent_Power*sin(acos(Load_Power_Factor)); %VAr
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = 50;
ref_frequency = 100*pi;
n = 1; %number of interleaved inverters
m = 2; %number of series DCLINKs (do not change this)

interleaving_angle = 360/(n);
intangle1 = 0;
intangle2 = interleaving_angle;
intangle3 = 0;
intangle4 = interleaving_angle;


ma = 0.9;
Vll_rms = ma*DC_Voltage_Source*0.612/m;
Vln_rms = Vll_rms/sqrt(3);
Iline = Load_Apparent_Power/(Vll_rms*sqrt(3));
%% equating the angle of the load angle and the powerfactor angle
Load_Angle = acos(Load_Power_Factor);
Ef = Vln_rms*cos(Load_Angle);
Xs = sqrt((Vln_rms^2-Ef^2)/Iline^2);
Ls = n*m*Xs/ref_frequency; % n: number of interleaved inverters  

DCLINK_Cap = 100e-6; %Farads

Rin = 1; %ohm
Vin = DC_Voltage_Source + Rin*(Load_Real_Power/DC_Voltage_Source);
%% 

count = 1;
for sw_frequency = 1000:1:100000;
capacitorsabiti = 200e-6*14000;

DCLINK_Cap = 1.35*capacitorsabiti/sw_frequency;
cornerfreq(count) = 1/((2*pi)*sqrt(Ls*DCLINK_Cap)); 
freqdegeri(count) = sw_frequency;

count = count+1;
end
figure

plot(freqdegeri,cornerfreq,'Linewidth',1.5)
xlabel('Switching Frequency (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Resonant Frequency','FontSize',16,'FontWeight','bold')
set(gca,'fontsize',15,'FontWeight','bold')
