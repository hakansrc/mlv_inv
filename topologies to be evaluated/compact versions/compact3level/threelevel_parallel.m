cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\compact versions\compact3level')
open_system('threelevel_spwm.slx');
N = 2^20;
%% values of the signals
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 2050; %Hz
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 0.5/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 0.2; %duration of the model
%% Load&Source settings
Load_Real_Power = 8500; %W
Load_Power_Factor = 0.9; 
Load_Apparent_Power = Load_Real_Power/Load_Power_Factor; %VA
Load_Reactive_Power = Load_Apparent_Power*sin(acos(Load_Power_Factor)); %VAr
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = ref_frequency/(2*pi); %Hz

n = 1; %number of parallel modules (3 at max)

interleaving_angle = 360/n;
intangle1 = 0;
intangle2 = intangle1 + interleaving_angle;
intangle3 = intangle2 + interleaving_angle;
% intangle4 = intangle3 + interleaving_angle;

Vll_rms = ma*DC_Voltage_Source*0.612;
Iline = Load_Apparent_Power/(Vll_rms*sqrt(3));
Zload = n*Vll_rms/(Iline*sqrt(3));  %ohm total
Rload = Zload*Load_Power_Factor;  %ohm total
Xload = Zload*sin(acos(Load_Power_Factor)); %ohm total
Lload = Xload/ref_frequency;

Rin = 1; %ohm
Vin = DC_Voltage_Source + Rin*(Load_Real_Power/DC_Voltage_Source);

DCLINK_Cap1 = 1000000000e-6; %Farads
DCLINK_Cap2 = 1000000000e-6; %Farads
%% commenting out the inverters depending on the 'n' value
if n==3
    set_param('threelevel_spwm/Load 1','commented','off')
    set_param('threelevel_spwm/Load 2','commented','off')
    set_param('threelevel_spwm/Load 3','commented','off')
end   
    if n == 2
        set_param('threelevel_spwm/Load 1','commented','off')
        set_param('threelevel_spwm/Load 2','commented','off')
        set_param('threelevel_spwm/Load 3','commented','on')
    end
        if n == 1
            set_param('threelevel_spwm/Load 1','commented','off')
            set_param('threelevel_spwm/Load 2','commented','on')
            set_param('threelevel_spwm/Load 3','commented','on')
        end
            if n == 0
                set_param('threelevel_spwm/Load 1','commented','on')
                set_param('threelevel_spwm/Load 2','commented','on')
                set_param('threelevel_spwm/Load 3','commented','on')
            end
                
% simOut = sim('three_levelparallel_spwm.slx'); %run the simulation
threelevelspwm_p = sim('threelevel_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');

% figure
% plot(Phase_currents.time,[Phase_currents.signals(1).values]);


timelength = round((numel(threelevelspwm_p.get('DCLINK_voltage').time))*0.8);
maxvoltage = max(threelevelspwm_p.get('DCLINK_voltage').data(timelength:end));
minvoltage = min(threelevelspwm_p.get('DCLINK_voltage').data(timelength:end));
threelevel_DCRipple = maxvoltage - minvoltage;
meanupperc = mean(threelevelspwm_p.get('upperc_voltage').data(timelength:end));
meanlowerc = mean(threelevelspwm_p.get('lowerc_voltage').data(timelength:end));
threelevelDCLINK_v_difference = abs(meanupperc-meanlowerc);


fprintf('upperc Vcrms value is: %d \n',mean(threelevelspwm_p.get('upperc_vrms').signals(1).values(timelength:end)));
fprintf('lowerc Vcrms value is: %d \n',mean(threelevelspwm_p.get('lowerc_vrms').signals(1).values(timelength:end)));
fprintf('Capacitor voltage difference is: %d \n',threelevelDCLINK_v_difference);
fprintf('DCLINK Vrms value is: %d \n',mean(threelevelspwm_p.get('DCLINK_Vrms').signals(1).values(timelength:end)));
fprintf('DCLINK Icrms value is: %d \n',mean(threelevelspwm_p.get('DCLINK_Irms').signals(1).values(timelength:end)));
fprintf('Ineutralrms value is: %d \n',mean(threelevelspwm_p.get('Ineutralrms').signals(1).values(timelength:end)));


