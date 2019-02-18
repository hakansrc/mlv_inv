cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\mlv_inv\topologies to be evaluated\compact versions\compact2level\seriesparallel')
open_system('twolevel_seriesparallel.slx');
clear
N = 2^20;
%% values of the signals
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 1050; %Hz
Sampling_time = 1/(15*sw_frequency); %sampling frequency of the model
Fs = 0.5/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 0.0201; %duration of the model
%% Load&Source settings
Load_Real_Power = 8000; %W
Load_Power_Factor = 0.9; 
Load_Apparent_Power = Load_Real_Power/Load_Power_Factor; %VA
Load_Reactive_Power = Load_Apparent_Power*sin(acos(Load_Power_Factor)); %VAr
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = ref_frequency/(2*pi); %Hz

n = 2; %number of interleaved inverters
m = 2; %number of series DCLINKs (do not change this)

interleaving_angle = 360/(n);
intangle1 = 0;
intangle2 = interleaving_angle;
intangle3 = 0;
intangle4 = interleaving_angle;



Vll_rms = ma*DC_Voltage_Source*0.612/m;
Vln_rms = Vll_rms/sqrt(3);
Iline = Load_Apparent_Power/(Vll_rms*sqrt(3));
% Zbase = Vll_rms^2/Load_Apparent_Power;
% Xs = 0.5*Zbase;
theta = acos((Load_Real_Power/3)/(Vln_rms*Iline));


%% equating the angle of the load angle and the powerfactor angle
Load_Angle = acos(Load_Power_Factor);
Ef = Vln_rms*cos(Load_Angle);
Xs = sqrt((Vln_rms^2-Ef^2)/Iline^2);
Ls = n*m*Xs/ref_frequency; % n: number of interleaved inverters  

DCLINK_Cap = 100e-6; %Farads

Rin = 1; %ohm
Vin = DC_Voltage_Source + Rin*(Load_Real_Power/DC_Voltage_Source);




%% commenting out the inverters depending on the 'n' value
if n == 2
    set_param('twolevel_seriesparallel/Inverter1','commented','off')
    set_param('twolevel_seriesparallel/Inverter2','commented','off')
    set_param('twolevel_seriesparallel/Inverter3','commented','off')
    set_param('twolevel_seriesparallel/Inverter4','commented','off')
    set_param('twolevel_seriesparallel/Inverter 1 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 2 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 3 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 4 Load','commented','off')

end
if n == 1
    set_param('twolevel_seriesparallel/Inverter1','commented','off')
    set_param('twolevel_seriesparallel/Inverter2','commented','on')
    set_param('twolevel_seriesparallel/Inverter3','commented','off')
    set_param('twolevel_seriesparallel/Inverter4','commented','on')
    set_param('twolevel_seriesparallel/Inverter 1 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 2 Load','commented','on')
    set_param('twolevel_seriesparallel/Inverter 3 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 4 Load','commented','on')
end
if n == 0
    set_param('twolevel_seriesparallel/Inverter1','commented','on')
    set_param('twolevel_seriesparallel/Inverter2','commented','on')
    set_param('twolevel_seriesparallel/Inverter3','commented','on')
    set_param('twolevel_seriesparallel/Inverter4','commented','on')
    set_param('twolevel_seriesparallel/Inverter 1 Load','commented','on')
    set_param('twolevel_seriesparallel/Inverter 2 Load','commented','on')
    set_param('twolevel_seriesparallel/Inverter 3 Load','commented','on')
    set_param('twolevel_seriesparallel/Inverter 4 Load','commented','on')
end
    
                

 twolevelseriesparallel_interleaved = sim('twolevel_seriesparallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');

%% 2 series
count = 1;
n = 2;
interleaving_angle = 360/(n);
intangle1 = 0;
intangle2 = interleaving_angle;
intangle3 = 0;
intangle4 = interleaving_angle;
Ls = n*m*Xs/ref_frequency; % n: number of interleaved inverters  


%% commenting out the inverters depending on the 'n' value
if n == 2
    set_param('twolevel_seriesparallel/Inverter1','commented','off')
    set_param('twolevel_seriesparallel/Inverter2','commented','off')
    set_param('twolevel_seriesparallel/Inverter3','commented','off')
    set_param('twolevel_seriesparallel/Inverter4','commented','off')
    set_param('twolevel_seriesparallel/Inverter 1 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 2 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 3 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 4 Load','commented','off')

end
if n == 1
    set_param('twolevel_seriesparallel/Inverter1','commented','off')
    set_param('twolevel_seriesparallel/Inverter2','commented','on')
    set_param('twolevel_seriesparallel/Inverter3','commented','off')
    set_param('twolevel_seriesparallel/Inverter4','commented','on')
    set_param('twolevel_seriesparallel/Inverter 1 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 2 Load','commented','on')
    set_param('twolevel_seriesparallel/Inverter 3 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 4 Load','commented','on')
end
if n == 0
    set_param('twolevel_seriesparallel/Inverter1','commented','on')
    set_param('twolevel_seriesparallel/Inverter2','commented','on')
    set_param('twolevel_seriesparallel/Inverter3','commented','on')
    set_param('twolevel_seriesparallel/Inverter4','commented','on')
    set_param('twolevel_seriesparallel/Inverter 1 Load','commented','on')
    set_param('twolevel_seriesparallel/Inverter 2 Load','commented','on')
    set_param('twolevel_seriesparallel/Inverter 3 Load','commented','on')
    set_param('twolevel_seriesparallel/Inverter 4 Load','commented','on')
end
    
   
for sw_frequency = 1050:5000:100050
    capacitorsabiti = 200e-6*14000;
    DCLINK_Cap = 1.3*capacitorsabiti/sw_frequency;
    Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
    twolevelseriesparallel_interleaved = sim('twolevel_seriesparallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
    
    numberelement = numel(twolevelseriesparallel_interleaved.get('Ids1').data);
    Ids1(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1').data;
   % Ids1_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_1').time;
    
   
    count = count + 1;
    
end
save('dataC','Ids1');
    
