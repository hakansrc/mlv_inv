cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\compact versions\compact2level\seriesparallel')
open_system('twolevel_seriesparallel.slx');
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

n = 2; %number of interleaved inverters
m = 2; %number of series DCLINKs

interleaving_angle = 360/n;
intangle1 = 0;
intangle2 = intangle1 + interleaving_angle;
intangle3 = intangle2 + interleaving_angle;
intangle4 = intangle3 + interleaving_angle;


Vll_rms = ma*DC_Voltage_Source*0.612/m;
Iline = Load_Apparent_Power/(Vll_rms*sqrt(3));
Zload = m*n*Vll_rms/(Iline*sqrt(3));
Rload = Zload*Load_Power_Factor;
Xload = Zload*sin(acos(Load_Power_Factor));
Lload = Xload/ref_frequency;


DCLINK_Cap = 100e-6; %Farads

Rin = 1; %ohm
Vin = DC_Voltage_Source + Rin*(Load_Real_Power/DC_Voltage_Source);




%% commenting out the inverters depending on the 'n' value
if n==4
    set_param('twolevel_seriesparallel/Inverter1','commented','off')
    set_param('twolevel_seriesparallel/Inverter2','commented','off')
    set_param('twolevel_seriesparallel/Inverter3','commented','off')
    set_param('twolevel_seriesparallel/Inverter4','commented','off')
    set_param('twolevel_seriesparallel/Inverter5','commented','off')
    set_param('twolevel_seriesparallel/Inverter6','commented','off')
    set_param('twolevel_seriesparallel/Inverter7','commented','off')
    set_param('twolevel_seriesparallel/Inverter8','commented','off')
    set_param('twolevel_seriesparallel/Inverter 1 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 2 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 3 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 4 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 5 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 6 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 7 Load','commented','off')
    set_param('twolevel_seriesparallel/Inverter 8 Load','commented','off')
end   
    if n == 3
        set_param('twolevel_seriesparallel/Inverter1','commented','off')
        set_param('twolevel_seriesparallel/Inverter2','commented','off')
        set_param('twolevel_seriesparallel/Inverter3','commented','off')
        set_param('twolevel_seriesparallel/Inverter4','commented','on')
        set_param('twolevel_seriesparallel/Inverter5','commented','off')
        set_param('twolevel_seriesparallel/Inverter6','commented','off')
        set_param('twolevel_seriesparallel/Inverter7','commented','off')
        set_param('twolevel_seriesparallel/Inverter8','commented','on')
        set_param('twolevel_seriesparallel/Inverter 1 Load','commented','off')
        set_param('twolevel_seriesparallel/Inverter 2 Load','commented','off')
        set_param('twolevel_seriesparallel/Inverter 3 Load','commented','off')
        set_param('twolevel_seriesparallel/Inverter 4 Load','commented','on')
        set_param('twolevel_seriesparallel/Inverter 5 Load','commented','off')
        set_param('twolevel_seriesparallel/Inverter 6 Load','commented','off')
        set_param('twolevel_seriesparallel/Inverter 7 Load','commented','off')
        set_param('twolevel_seriesparallel/Inverter 8 Load','commented','on')
    end
        if n == 2
            set_param('twolevel_seriesparallel/Inverter1','commented','off')
            set_param('twolevel_seriesparallel/Inverter2','commented','off')
            set_param('twolevel_seriesparallel/Inverter3','commented','on')
            set_param('twolevel_seriesparallel/Inverter4','commented','on')
            set_param('twolevel_seriesparallel/Inverter5','commented','off')
            set_param('twolevel_seriesparallel/Inverter6','commented','off')
            set_param('twolevel_seriesparallel/Inverter7','commented','on')
            set_param('twolevel_seriesparallel/Inverter8','commented','on')
            set_param('twolevel_seriesparallel/Inverter 1 Load','commented','off')
            set_param('twolevel_seriesparallel/Inverter 2 Load','commented','off')
            set_param('twolevel_seriesparallel/Inverter 3 Load','commented','on')
            set_param('twolevel_seriesparallel/Inverter 4 Load','commented','on')
            set_param('twolevel_seriesparallel/Inverter 5 Load','commented','off')
            set_param('twolevel_seriesparallel/Inverter 6 Load','commented','off')
            set_param('twolevel_seriesparallel/Inverter 7 Load','commented','on')
            set_param('twolevel_seriesparallel/Inverter 8 Load','commented','on')
        end
            if n == 1
                set_param('twolevel_seriesparallel/Inverter1','commented','off')
                set_param('twolevel_seriesparallel/Inverter2','commented','on')
                set_param('twolevel_seriesparallel/Inverter3','commented','on')
                set_param('twolevel_seriesparallel/Inverter4','commented','on')
                set_param('twolevel_seriesparallel/Inverter5','commented','off')
                set_param('twolevel_seriesparallel/Inverter6','commented','on')
                set_param('twolevel_seriesparallel/Inverter7','commented','on')
                set_param('twolevel_seriesparallel/Inverter8','commented','on')
                set_param('twolevel_seriesparallel/Inverter 1 Load','commented','off')
                set_param('twolevel_seriesparallel/Inverter 2 Load','commented','on')
                set_param('twolevel_seriesparallel/Inverter 3 Load','commented','on')
                set_param('twolevel_seriesparallel/Inverter 4 Load','commented','on')
                set_param('twolevel_seriesparallel/Inverter 5 Load','commented','off')
                set_param('twolevel_seriesparallel/Inverter 6 Load','commented','on')
                set_param('twolevel_seriesparallel/Inverter 7 Load','commented','on')
                set_param('twolevel_seriesparallel/Inverter 8 Load','commented','on')
            end
                if n == 0
                    set_param('twolevel_seriesparallel/Inverter1','commented','on')
                    set_param('twolevel_seriesparallel/Inverter2','commented','on')
                    set_param('twolevel_seriesparallel/Inverter3','commented','on')
                    set_param('twolevel_seriesparallel/Inverter4','commented','on')
                    set_param('twolevel_seriesparallel/Inverter5','commented','on')
                    set_param('twolevel_seriesparallel/Inverter6','commented','on')
                    set_param('twolevel_seriesparallel/Inverter7','commented','on')
                    set_param('twolevel_seriesparallel/Inverter8','commented','on')
                    set_param('twolevel_seriesparallel/Inverter 1 Load','commented','on')
                    set_param('twolevel_seriesparallel/Inverter 2 Load','commented','on')
                    set_param('twolevel_seriesparallel/Inverter 3 Load','commented','on')
                    set_param('twolevel_seriesparallel/Inverter 4 Load','commented','on')
                    set_param('twolevel_seriesparallel/Inverter 5 Load','commented','on')
                    set_param('twolevel_seriesparallel/Inverter 6 Load','commented','on')
                    set_param('twolevel_seriesparallel/Inverter 7 Load','commented','on')
                    set_param('twolevel_seriesparallel/Inverter 8 Load','commented','on')
                end
                
                

twolevelseriesparallel_interleaved = sim('twolevel_seriesparallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');

%% Spectrum of DCLINK_voltage
% Fs = numel(DCLINK_voltage.data);  %Sampling Frequency
DCLINK1_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').data,N*2);
DCLINK1_voltage_spectrum_abs = abs(DCLINK1_voltage_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK1_voltage_spectrum_abs = DCLINK1_voltage_spectrum_abs/max(DCLINK1_voltage_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK1_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK1_voltage');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of DCLINK_current
% Fs = numel(DCLINK1_current.data);  %Sampling Frequency
DCLINK1_current_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_current').data,N*2);
DCLINK1_current_spectrum_abs = abs(DCLINK1_current_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

DCLINK1_current_spectrum_abs = DCLINK1_current_spectrum_abs/max(DCLINK1_current_spectrum_abs); % normalization
figure;
semilogy(freq,DCLINK1_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of DCLINK1_current');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of VAB1 only
% Fs = numel(LL_voltages.signals(1).values);  %Sampling Frequency
LL_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(1).values,N*2);
LL_voltages_spectrum_abs = abs(LL_voltages_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

LL_voltages_spectrum_abs = LL_voltages_spectrum_abs/max(LL_voltages_spectrum_abs); % normalization
figure;
semilogy(freq,LL_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Vab1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%% Spectrum of Ia1 only
% Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
Ia_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(1).values,N*2);
Ia_Spectrum_abs = abs(Ia_Spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

Ia_Spectrum_abs =Ia_Spectrum_abs/max(Ia_Spectrum_abs); % normalization
figure;
semilogy(freq,Ia_Spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
title('Spectrum of Ia');
xlabel('Frequency (Hz)');
ylabel('Magnitude');



timelength = round((numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').time))*0.8);
maxvoltage = max(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').data(timelength:end));
minvoltage = min(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').data(timelength:end));
twolevelseriesparallel_DC1Ripple = maxvoltage - minvoltage;
maxvoltage = max(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').data(timelength:end));
minvoltage = min(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').data(timelength:end));
twolevelseriesparallel_DC2Ripple = maxvoltage - minvoltage;


