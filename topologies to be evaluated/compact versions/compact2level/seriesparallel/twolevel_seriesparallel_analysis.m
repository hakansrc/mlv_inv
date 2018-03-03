cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\compact versions\compact2level\seriesparallel')
open_system('twolevel_seriesparallel.slx');
clear
N = 2^20;
%% values of the signals
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 61050; %Hz
Sampling_time = 1/(20*50000); %sampling frequency of the model
Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 0.7; %duration of the model
%% Load&Source settings
Load_Real_Power = 8000; %W
Load_Power_Factor = 0.9; 
Load_Apparent_Power = Load_Real_Power/Load_Power_Factor; %VA
Load_Reactive_Power = Load_Apparent_Power*sin(acos(Load_Power_Factor)); %VAr
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = ref_frequency/(2*pi); %Hz

n = 1; %number of interleaved inverters
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
%% finding by force
% for delta = 0:0.000001*pi:2*pi
%     theformula = sin(delta)*Vln_rms/(cos(theta-delta)*Xs*Iline);
%     acilar(la) = theformula;
%     if (0.9999<theformula)&&(theformula<1.0001)
%         yukacisi = delta;
%         break
%     end
%     la = la+1;
% end
% %  delta = 0:0.000001*pi:2*pi;
% Load_Angle = yukacisi
% Ef = Vln_rms*cos(Load_Angle)-cos(pi/2-theta+Load_Angle)*Xs*Iline;
%%
% Zload = m*n*Vll_rms/(Iline*sqrt(3));
% Rload = Zload*Load_Power_Factor;
% Xload = Zload*sin(acos(Load_Power_Factor));
% Lload = Xload/ref_frequency;

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
    
                

%  twolevelseriesparallel_interleaved = sim('twolevel_seriesparallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
% % % % % % % % % % % % % %% Spectrum of DCLINK1_voltage
% % % % % % % % % % % % % % Fs = numel(DCLINK_voltage.data);  %Sampling Frequency
% % % % % % % % % % % % % DCLINK1_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').data,N*2);
% % % % % % % % % % % % % DCLINK1_voltage_spectrum_abs = abs(DCLINK1_voltage_spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % DCLINK1_voltage_spectrum_abs = DCLINK1_voltage_spectrum_abs/max(DCLINK1_voltage_spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % semilogy(freq,DCLINK1_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of DCLINK1 voltage');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% Spectrum of DCLINK1_current
% % % % % % % % % % % % % % Fs = numel(DCLINK1_current.data);  %Sampling Frequency
% % % % % % % % % % % % % DCLINK1_current_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_current').data,N*2);
% % % % % % % % % % % % % DCLINK1_current_spectrum_abs = abs(DCLINK1_current_spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % % DCLINK1_current_spectrum_abs = DCLINK1_current_spectrum_abs/max(DCLINK1_current_spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % semilogy(freq,DCLINK1_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of DCLINK1 current');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% Spectrum of DCLINK2_voltage
% % % % % % % % % % % % % % Fs = numel(DCLINK_voltage.data);  %Sampling Frequency
% % % % % % % % % % % % % DCLINK1_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').data,N*2);
% % % % % % % % % % % % % DCLINK1_voltage_spectrum_abs = abs(DCLINK1_voltage_spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % DCLINK1_voltage_spectrum_abs = DCLINK1_voltage_spectrum_abs/max(DCLINK1_voltage_spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % semilogy(freq,DCLINK1_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of DCLINK2 voltage');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% Spectrum of DCLINK2_current
% % % % % % % % % % % % % % Fs = numel(DCLINK1_current.data);  %Sampling Frequency
% % % % % % % % % % % % % DCLINK1_current_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK2_current').data,N*2);
% % % % % % % % % % % % % DCLINK1_current_spectrum_abs = abs(DCLINK1_current_spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % DCLINK1_current_spectrum_abs = DCLINK1_current_spectrum_abs/max(DCLINK1_current_spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % semilogy(freq,DCLINK1_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of DCLINK2 current');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% Spectrum of VAB1 only
% % % % % % % % % % % % % % Fs = numel(LL_voltages.signals(1).values);  %Sampling Frequency
% % % % % % % % % % % % % LL_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(1).values,N*2);
% % % % % % % % % % % % % LL_voltages_spectrum_abs = abs(LL_voltages_spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % % LL_voltages_spectrum_abs = LL_voltages_spectrum_abs/max(LL_voltages_spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % plot(freq,LL_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of Vab1');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% Spectrum of Ia1 only
% % % % % % % % % % % % % % Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
% % % % % % % % % % % % % Ia_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(1).values,N*2);
% % % % % % % % % % % % % Ia_Spectrum_abs = abs(Ia_Spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % Ia_Spectrum_abs =Ia_Spectrum_abs/max(Ia_Spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % semilogy(freq,Ia_Spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of Ia1');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% plotting of THD's
% % % % % % % % % % % % % figure
% % % % % % % % % % % % % subplot(2,1,1);
% % % % % % % % % % % % % plot(twolevelseriesparallel_interleaved.get('THD_Ia1').time, 100*twolevelseriesparallel_interleaved.get('THD_Ia1').data)
% % % % % % % % % % % % % title('THD of Ia1');
% % % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % % 
% % % % % % % % % % % % % % subplot(3,1,2);
% % % % % % % % % % % % % % plot(twolevelspwm.get('THD_Van').time, 100*twolevelspwm.get('THD_Van').data)
% % % % % % % % % % % % % % title('THD of Van');
% % % % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % % 
% % % % % % % % % % % % % subplot(2,1,2);
% % % % % % % % % % % % % plot(twolevelseriesparallel_interleaved.get('THD_Vab1').time, 100*twolevelseriesparallel_interleaved.get('THD_Vab1').data)
% % % % % % % % % % % % % title('THD of Vab1');
% % % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % % 
% % % % % % % % % % % % % figure
% % % % % % % % % % % % % subplot(2,1,1);
% % % % % % % % % % % % % plot(twolevelseriesparallel_interleaved.get('THD_Ia3').time, 100*twolevelseriesparallel_interleaved.get('THD_Ia3').data)
% % % % % % % % % % % % % title('THD of Ia3');
% % % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % % 
% % % % % % % % % % % % % % subplot(3,1,2);
% % % % % % % % % % % % % % plot(twolevelspwm.get('THD_Van').time, 100*twolevelspwm.get('THD_Van').data)
% % % % % % % % % % % % % % title('THD of Van');
% % % % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % % 
% % % % % % % % % % % % % subplot(2,1,2);
% % % % % % % % % % % % % plot(twolevelseriesparallel_interleaved.get('THD_Vab3').time, 100*twolevelseriesparallel_interleaved.get('THD_Vab3').data)
% % % % % % % % % % % % % title('THD of Vab3');
% % % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % % 
% % % % % % % % % % % % % 
% % % % % % % % % % % % % 
% % % % % % % % % % % % % timelength = round((numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').time))*0.9);
% % % % % % % % % % % % % maxvoltage = max(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').data(timelength:end));
% % % % % % % % % % % % % minvoltage = min(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').data(timelength:end));
% % % % % % % % % % % % % twolevelseriesparallel_DC1Ripple = maxvoltage - minvoltage;
% % % % % % % % % % % % % maxvoltage = max(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').data(timelength:end));
% % % % % % % % % % % % % minvoltage = min(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').data(timelength:end));
% % % % % % % % % % % % % twolevelseriesparallel_DC2Ripple = maxvoltage - minvoltage;
% % % % % % % % % % % % % 
% % % % % % % % % % % % % fprintf('Vc1rms value is: %d \n',mean(twolevelseriesparallel_interleaved.get('Vc1rms').signals(1).values(timelength:end)));
% % % % % % % % % % % % % fprintf('Ic1rms value is: %d \n',mean(twolevelseriesparallel_interleaved.get('Ic1rms').signals(1).values(timelength:end)));
% % % % % % % % % % % % % fprintf('Vc2rms value is: %d \n',mean(twolevelseriesparallel_interleaved.get('Vc2rms').signals(1).values(timelength:end)));
% % % % % % % % % % % % % fprintf('Ic2rms value is: %d \n',mean(twolevelseriesparallel_interleaved.get('Ic2rms').signals(1).values(timelength:end)));
% % % % % % % % % % % % % 
% % % % % % % % % % % % % 
% % % % % % % % % % % % % close all
%% 2 series
count = 1;
n = 1;
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
    
   
for sw_frequency = 1050:5000:101050
    capacitorsabiti = 200e-6*14000;
    DCLINK_Cap = 1.3*capacitorsabiti/sw_frequency;
    Capacitor_values = DCLINK_Cap; %tobesaved
    Sampling_time = 1/(20*50000); %sampling frequency of the model
    Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
    twolevelseriesparallel_interleaved = sim('twolevel_seriesparallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
    N = numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values);
    THDV_2levelseries_IGBTVab1 = 100*twolevelseriesparallel_interleaved.get('THD_Vab1').data(end); %tobesaved
    THDV_2levelseries_IGBTIa1 = 100*twolevelseriesparallel_interleaved.get('THD_Ia1').data(end);%tobesaved
    timelength = round((numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').time))*0.9);
    
    maxvoltage = max(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values(timelength:end));
    minvoltage = min(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values(timelength:end));
    twolevelseriesparallel_DC1Ripple = maxvoltage - minvoltage;
    ripple1vector = twolevelseriesparallel_DC1Ripple; %tobesaved
    ripple1percent = 100*twolevelseriesparallel_DC1Ripple/mean(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values(timelength:end)); %tobesaved
    
    maxvoltage = max(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').signals.values(timelength:end));
    minvoltage = min(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').signals.values(timelength:end));
    twolevelseriesparallel_DC2Ripple = maxvoltage - minvoltage;
    ripple2vector = twolevelseriesparallel_DC2Ripple; %tobesaved
    ripple2percent =100*twolevelseriesparallel_DC2Ripple/mean(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').signals.values(timelength:end)); %tobesaved

    DCLINK_Vc1rms = mean(twolevelseriesparallel_interleaved.get('Vc1rms').signals(1).values(timelength:end)); %tobesaved
    DCLINK_Vc2rms= mean(twolevelseriesparallel_interleaved.get('Vc2rms').signals(1).values(timelength:end));%tobesaved
    
    DCLINK_Ic1rms = mean(twolevelseriesparallel_interleaved.get('Ic1rms').signals(1).values(timelength:end)); %tobesaved
    DCLINK_Ic2rms = mean(twolevelseriesparallel_interleaved.get('Ic2rms').signals(1).values(timelength:end)); %tobesaved
    
    %% spectrums
    DCLINK_cap1_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values,N)/(0.5*N);
    DCLINK_cap1_voltage_spectrum_abs = abs(DCLINK_cap1_voltage_spectrum(1:(N/2+1)));
    DCLINK_cap1_voltage_spectrum_abs(1) = DCLINK_cap1_voltage_spectrum_abs(1)/2;
    
    DCLINK_cap1_current_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_current').signals.values,N)/(0.5*N);
    DCLINK_cap1_current_spectrum_abs = abs(DCLINK_cap1_current_spectrum(1:(N/2+1)));
    DCLINK_cap1_current_spectrum_abs(1) = DCLINK_cap1_current_spectrum_abs(1)/2;

    DCLINK_cap2_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').signals.values,N)/(0.5*N);
    DCLINK_cap2_voltage_spectrum_abs= abs(DCLINK_cap2_voltage_spectrum(1:(N/2+1)));    
    DCLINK_cap2_voltage_spectrum_abs(1) = DCLINK_cap2_voltage_spectrum_abs(1)/2;
    
    DCLINK_cap2_current_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK2_current').signals.values,N)/(0.5*N);
    DCLINK_cap2_current_spectrum_abs = abs(DCLINK_cap2_current_spectrum(1:(N/2+1)));
    DCLINK_cap2_current_spectrum_abs(1) = DCLINK_cap2_current_spectrum_abs(1)/2;

    
    LLab1_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(1).values,N)/(0.5*N);
    LLab1_voltages_spectrum_abs = abs(LLab1_voltages_spectrum(1:(N/2+1)));    
    LLbc1_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(2).values,N)/(0.5*N);
    LLbc1_voltages_spectrum_abs = abs(LLbc1_voltages_spectrum(1:(N/2+1)));    
    LLca1_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(3).values,N)/(0.5*N);
    LLca1_voltages_spectrum_abs = abs(LLca1_voltages_spectrum(1:(N/2+1)));
    
    Ia1_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(1).values,N)/(0.5*N);
    Ia1_Spectrum_abs = abs(Ia1_Spectrum(1:(N/2+1)));    
    Ib1_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(2).values,N)/(0.5*N);
    Ib1_Spectrum_abs = abs(Ib1_Spectrum(1:(N/2+1)));    
    Ic1_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(3).values,N)/(0.5*N);
    Ic1_Spectrum_abs = abs(Ic1_Spectrum(1:(N/2+1)));    

    
    
    LLab3_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages3').signals(1).values,N)/(0.5*N);
    LLab3_voltages_spectrum_abs = abs(LLab3_voltages_spectrum(1:(N/2+1)));    
    LLbc3_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages3').signals(2).values,N)/(0.5*N);
    LLbc3_voltages_spectrum_abs = abs(LLbc3_voltages_spectrum(1:(N/2+1)));    
    LLca3_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages3').signals(3).values,N)/(0.5*N);
    LLca3_voltages_spectrum_abs = abs(LLca3_voltages_spectrum(1:(N/2+1)));
    
    Ia3_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents3').signals(1).values,N)/(0.5*N);
    Ia3_Spectrum_abs = abs(Ia3_Spectrum(1:(N/2+1)));    
    Ib3_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents3').signals(2).values,N)/(0.5*N);
    Ib3_Spectrum_abs = abs(Ib3_Spectrum(1:(N/2+1)));    
    Ic3_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents3').signals(3).values,N)/(0.5*N);
    Ic3_Spectrum_abs = abs(Ic3_Spectrum(1:(N/2+1)));  
    
    freq = (0:(N/2))*Fs/N; 
    
    
  
    
%     Ids1_Inv1_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_1').data;
%     Ids1_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_1').time;
%     
%     Ids1_Inv3_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_3').data;
%     Ids1_Inv3_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_3').time;
%     
%     Ids2_Inv1_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids2_1').data;
%     Ids2_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids2_1').time;
%     
%     Ids2_Inv3_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids2_3').data;
%     Ids2_Inv3_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids2_3').time;
%     
%     Vds1_Inv1_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds1_1').data;
%     Vds1_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds1_1').time;
%     
%     Vds1_Inv3_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds1_3').data;
%     Vds1_Inv3_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds1_3').time;
%     
%     Vds2_Inv1_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds2_1').data;
%     Vds2_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds2_1').time;
%     
%     Vds2_Inv3_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds2_3').data;
%     Vds2_Inv3_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds2_3').time;
      
    fprintf('swf = %d , ripple1percent = %d , ripple2percen = %d, Capacitor size = %d',sw_frequency,ripple1percent,ripple2percent,DCLINK_Cap);
    fprintf('\n')
    
    count = count + 1;
    savename = strcat('topology_B_',num2str(sw_frequency),'Hz');
    save(savename,'Capacitor_values','THDV_2levelseries_IGBTVab1','THDV_2levelseries_IGBTIa1'...
    ,'ripple1vector','ripple1percent','ripple2vector','ripple2percent','DCLINK_Vc1rms','DCLINK_Vc2rms','DCLINK_Ic1rms','DCLINK_Ic2rms'...
    ,'DCLINK_cap1_voltage_spectrum_abs','DCLINK_cap1_current_spectrum_abs','DCLINK_cap2_voltage_spectrum_abs'...
    ,'DCLINK_cap2_current_spectrum_abs','LLab1_voltages_spectrum_abs','LLbc1_voltages_spectrum_abs','LLca1_voltages_spectrum_abs',...
    'Ia1_Spectrum_abs','Ib1_Spectrum_abs','Ic1_Spectrum_abs','LLab3_voltages_spectrum','LLbc3_voltages_spectrum','LLca3_voltages_spectrum'...
    ,'Ia3_Spectrum_abs','Ib3_Spectrum_abs','Ic3_Spectrum_abs','freq');
clear('Capacitor_values','THDV_2levelseries_IGBTVab1','THDV_2levelseries_IGBTIa1'...
    ,'ripple1vector','ripple1percent','ripple2vector','ripple2percent','DCLINK_Vc1rms','DCLINK_Vc2rms','DCLINK_Ic1rms','DCLINK_Ic2rms'...
    ,'DCLINK_cap1_voltage_spectrum_abs','DCLINK_cap1_current_spectrum_abs','DCLINK_cap2_voltage_spectrum_abs'...
    ,'DCLINK_cap2_current_spectrum_abs','LLab1_voltages_spectrum_abs','LLbc1_voltages_spectrum_abs','LLca1_voltages_spectrum_abs',...
    'Ia1_Spectrum_abs','Ib1_Spectrum_abs','Ic1_Spectrum_abs','LLab3_voltages_spectrum','LLbc3_voltages_spectrum','LLca3_voltages_spectrum'...
    ,'Ia3_Spectrum_abs','Ib3_Spectrum_abs','Ic3_Spectrum_abs','freq');

    
end



save('efficiencypart_sp_n1','Ids1_Inv1_data','Ids1_Inv1_time','Ids1_Inv3_data'...
        ,'Ids1_Inv3_time','Ids2_Inv1_data','Ids2_Inv1_time','Ids2_Inv3_data'...
        ,'Ids2_Inv3_time','Vds1_Inv1_data','Vds1_Inv1_time'...
        ,'Vds1_Inv3_data','Vds1_Inv3_time'...
        ,'Vds2_Inv1_data','Vds2_Inv1_time','Vds2_Inv3_data','Vds2_Inv3_time');
    

%% 2 series 2 parallel

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
    
   
for sw_frequency = 31050:5000:101050
    topologytype = 'C'
    capacitorsabiti = 200e-6*14000;
    DCLINK_Cap = 0.9*capacitorsabiti/sw_frequency;
    Capacitor_values = DCLINK_Cap; %tobesaved
    Sampling_time = 1/(20*50000); %sampling frequency of the model
    Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
    twolevelseriesparallel_interleaved = sim('twolevel_seriesparallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
    N = numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values);

    THDV_2levelseries_IGBTVab1 = 100*twolevelseriesparallel_interleaved.get('THD_Vab1').data(end); %tobesaved
    THDV_2levelseries_IGBTIa1 = 100*twolevelseriesparallel_interleaved.get('THD_Ia1').data(end);%tobesaved
    timelength = round((numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').time))*0.9);
    
    maxvoltage = max(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values(timelength:end));
    minvoltage = min(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values(timelength:end));
    twolevelseriesparallel_DC1Ripple = maxvoltage - minvoltage;
    ripple1vector = twolevelseriesparallel_DC1Ripple; %tobesaved
    ripple1percent = 100*twolevelseriesparallel_DC1Ripple/mean(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values(timelength:end)); %tobesaved
    
    maxvoltage = max(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').signals.values(timelength:end));
    minvoltage = min(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').signals.values(timelength:end));
    twolevelseriesparallel_DC2Ripple = maxvoltage - minvoltage;
    ripple2vector = twolevelseriesparallel_DC2Ripple; %tobesaved
    ripple2percent =100*twolevelseriesparallel_DC2Ripple/mean(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').signals.values(timelength:end)); %tobesaved

    DCLINK_Vc1rms = mean(twolevelseriesparallel_interleaved.get('Vc1rms').signals(1).values(timelength:end)); %tobesaved
    DCLINK_Vc2rms= mean(twolevelseriesparallel_interleaved.get('Vc2rms').signals(1).values(timelength:end));%tobesaved
    
    DCLINK_Ic1rms = mean(twolevelseriesparallel_interleaved.get('Ic1rms').signals(1).values(timelength:end)); %tobesaved
    DCLINK_Ic2rms = mean(twolevelseriesparallel_interleaved.get('Ic2rms').signals(1).values(timelength:end)); %tobesaved
    
    %% spectrums
    DCLINK_cap1_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values,N)/(0.5*N);
    DCLINK_cap1_voltage_spectrum_abs = abs(DCLINK_cap1_voltage_spectrum(1:(N/2+1)));
    DCLINK_cap1_voltage_spectrum_abs(1) = DCLINK_cap1_voltage_spectrum_abs(1)/2;
    
    DCLINK_cap1_current_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_current').signals.values,N)/(0.5*N);
    DCLINK_cap1_current_spectrum_abs = abs(DCLINK_cap1_current_spectrum(1:(N/2+1)));
    DCLINK_cap1_current_spectrum_abs(1) = DCLINK_cap1_current_spectrum_abs(1)/2;

    DCLINK_cap2_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK2_voltage').signals.values,N)/(0.5*N);
    DCLINK_cap2_voltage_spectrum_abs= abs(DCLINK_cap2_voltage_spectrum(1:(N/2+1)));    
    DCLINK_cap2_voltage_spectrum_abs(1) = DCLINK_cap2_voltage_spectrum_abs(1)/2;
    
    DCLINK_cap2_current_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK2_current').signals.values,N)/(0.5*N);
    DCLINK_cap2_current_spectrum_abs = abs(DCLINK_cap2_current_spectrum(1:(N/2+1)));
    DCLINK_cap2_current_spectrum_abs(1) = DCLINK_cap2_current_spectrum_abs(1)/2;

    
    LLab1_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(1).values,N)/(0.5*N);
    LLab1_voltages_spectrum_abs = abs(LLab1_voltages_spectrum(1:(N/2+1)));    
    LLbc1_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(2).values,N)/(0.5*N);
    LLbc1_voltages_spectrum_abs = abs(LLbc1_voltages_spectrum(1:(N/2+1)));    
    LLca1_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(3).values,N)/(0.5*N);
    LLca1_voltages_spectrum_abs = abs(LLca1_voltages_spectrum(1:(N/2+1)));
    
    Ia1_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(1).values,N)/(0.5*N);
    Ia1_Spectrum_abs = abs(Ia1_Spectrum(1:(N/2+1)));    
    Ib1_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(2).values,N)/(0.5*N);
    Ib1_Spectrum_abs = abs(Ib1_Spectrum(1:(N/2+1)));    
    Ic1_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents1').signals(3).values,N)/(0.5*N);
    Ic1_Spectrum_abs = abs(Ic1_Spectrum(1:(N/2+1)));       
    
    LLab3_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages3').signals(1).values,N)/(0.5*N);
    LLab3_voltages_spectrum_abs = abs(LLab3_voltages_spectrum(1:(N/2+1)));    
    LLbc3_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages3').signals(2).values,N)/(0.5*N);
    LLbc3_voltages_spectrum_abs = abs(LLbc3_voltages_spectrum(1:(N/2+1)));    
    LLca3_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages3').signals(3).values,N)/(0.5*N);
    LLca3_voltages_spectrum_abs = abs(LLca3_voltages_spectrum(1:(N/2+1)));
    
    Ia3_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents3').signals(1).values,N)/(0.5*N);
    Ia3_Spectrum_abs = abs(Ia3_Spectrum(1:(N/2+1)));    
    Ib3_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents3').signals(2).values,N)/(0.5*N);
    Ib3_Spectrum_abs = abs(Ib3_Spectrum(1:(N/2+1)));    
    Ic3_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents3').signals(3).values,N)/(0.5*N);
    Ic3_Spectrum_abs = abs(Ic3_Spectrum(1:(N/2+1)));    
    
    LLab2_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages2').signals(1).values,N)/(0.5*N);
    LLab2_voltages_spectrum_abs = abs(LLab2_voltages_spectrum(1:(N/2+1)));    
    LLbc2_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages2').signals(2).values,N)/(0.5*N);
    LLbc2_voltages_spectrum_abs = abs(LLbc2_voltages_spectrum(1:(N/2+1)));    
    LLca2_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages2').signals(3).values,N)/(0.5*N);
    LLca2_voltages_spectrum_abs = abs(LLca2_voltages_spectrum(1:(N/2+1)));
    
    Ia2_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents2').signals(1).values,N)/(0.5*N);
    Ia2_Spectrum_abs = abs(Ia2_Spectrum(1:(N/2+1)));    
    Ib2_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents2').signals(2).values,N)/(0.5*N);
    Ib2_Spectrum_abs = abs(Ib2_Spectrum(1:(N/2+1)));    
    Ic2_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents2').signals(3).values,N)/(0.5*N);
    Ic2_Spectrum_abs = abs(Ic2_Spectrum(1:(N/2+1)));     
    
    LLab4_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages4').signals(1).values,N)/(0.5*N);
    LLab4_voltages_spectrum_abs = abs(LLab4_voltages_spectrum(1:(N/2+1)));    
    LLbc4_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages4').signals(2).values,N)/(0.5*N);
    LLbc4_voltages_spectrum_abs = abs(LLbc4_voltages_spectrum(1:(N/2+1)));    
    LLca4_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages4').signals(3).values,N)/(0.5*N);
    LLca4_voltages_spectrum_abs = abs(LLca4_voltages_spectrum(1:(N/2+1)));
    
    Ia4_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents4').signals(1).values,N)/(0.5*N);
    Ia4_Spectrum_abs = abs(Ia4_Spectrum(1:(N/2+1)));    
    Ib4_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents4').signals(2).values,N)/(0.5*N);
    Ib4_Spectrum_abs = abs(Ib4_Spectrum(1:(N/2+1)));    
    Ic4_Spectrum = fft(twolevelseriesparallel_interleaved.get('Phase_currents4').signals(3).values,N)/(0.5*N);
    Ic4_Spectrum_abs = abs(Ic4_Spectrum(1:(N/2+1)));      
    
    
% %     Ids1_Inv1_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_1').data;
% %     Ids1_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_1').time;
% %     
% %     Ids1_Inv3_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_3').data;
% %     Ids1_Inv3_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids1_3').time;
% %     
% %     Ids2_Inv1_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids2_1').data;
% %     Ids2_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids2_1').time;
% %     
% %     Ids2_Inv3_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids2_3').data;
% %     Ids2_Inv3_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Ids2_3').time;
% %     
% %     Vds1_Inv1_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds1_1').data;
% %     Vds1_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds1_1').time;
% %     
% %     Vds1_Inv3_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds1_3').data;
% %     Vds1_Inv3_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds1_3').time;
% %     
% %     Vds2_Inv1_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds2_1').data;
% %     Vds2_Inv1_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds2_1').time;
% %     
% %     Vds2_Inv3_data(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds2_3').data;
% %     Vds2_Inv3_time(count,1:numberelement) = twolevelseriesparallel_interleaved.get('Vds2_3').time;
% %     
    count = count+1;
    
    
    
    
    freq = (0:(N/2))*Fs/N;  
    fprintf('swf = %d , ripple1percent = %d, ripple2percent = %d  , Capacitor size = %d',sw_frequency,ripple1percent,ripple2percent,DCLINK_Cap);
    fprintf('\n') 
    savename = strcat('topology_C_',num2str(sw_frequency),'Hz');
    save(savename,'Capacitor_values','THDV_2levelseries_IGBTVab1','THDV_2levelseries_IGBTIa1'...
    ,'ripple1vector','ripple1percent','ripple2vector','ripple2percent','DCLINK_Vc1rms','DCLINK_Vc2rms','DCLINK_Ic1rms','DCLINK_Ic2rms'...
    ,'DCLINK_cap1_voltage_spectrum_abs','DCLINK_cap1_current_spectrum_abs','DCLINK_cap2_voltage_spectrum_abs'...
    ,'DCLINK_cap2_current_spectrum_abs','LLab1_voltages_spectrum_abs','LLbc1_voltages_spectrum_abs','LLca1_voltages_spectrum_abs',...
    'Ia1_Spectrum_abs','Ib1_Spectrum_abs','Ic1_Spectrum_abs','LLab3_voltages_spectrum','LLbc3_voltages_spectrum','LLca3_voltages_spectrum'...
    ,'Ia3_Spectrum_abs','Ib3_Spectrum_abs','Ic3_Spectrum_abs','LLab2_voltages_spectrum_abs','LLbc2_voltages_spectrum_abs','LLca2_voltages_spectrum_abs',...
    'Ia2_Spectrum_abs','Ib2_Spectrum_abs','Ic2_Spectrum_abs','LLab4_voltages_spectrum_abs','LLbc4_voltages_spectrum_abs','LLca4_voltages_spectrum_abs',...
    'Ia4_Spectrum_abs','Ib4_Spectrum_abs','Ic4_Spectrum_abs','freq');
    clear('Capacitor_values','THDV_2levelseries_IGBTVab1','THDV_2levelseries_IGBTIa1'...
    ,'ripple1vector','ripple1percent','ripple2vector','ripple2percent','DCLINK_Vc1rms','DCLINK_Vc2rms','DCLINK_Ic1rms','DCLINK_Ic2rms'...
    ,'DCLINK_cap1_voltage_spectrum_abs','DCLINK_cap1_current_spectrum_abs','DCLINK_cap2_voltage_spectrum_abs'...
    ,'DCLINK_cap2_current_spectrum_abs','LLab1_voltages_spectrum_abs','LLbc1_voltages_spectrum_abs','LLca1_voltages_spectrum_abs',...
    'Ia1_Spectrum_abs','Ib1_Spectrum_abs','Ic1_Spectrum_abs','LLab3_voltages_spectrum','LLbc3_voltages_spectrum','LLca3_voltages_spectrum'...
    ,'Ia3_Spectrum_abs','Ib3_Spectrum_abs','Ic3_Spectrum_abs','LLab2_voltages_spectrum_abs','LLbc2_voltages_spectrum_abs','LLca2_voltages_spectrum_abs',...
    'Ia2_Spectrum_abs','Ib2_Spectrum_abs','Ic2_Spectrum_abs','LLab4_voltages_spectrum_abs','LLbc4_voltages_spectrum_abs','LLca4_voltages_spectrum_abs',...
    'Ia4_Spectrum_abs','Ib4_Spectrum_abs','Ic4_Spectrum_abs','freq');
    
end

% % save('efficiencypart_sp_n2','Ids1_Inv1_data','Ids1_Inv1_time','Ids1_Inv3_data'...
% %         ,'Ids1_Inv3_time','Ids2_Inv1_data','Ids2_Inv1_time','Ids2_Inv3_data'...
% %         ,'Ids2_Inv3_time','Vds1_Inv1_data','Vds1_Inv1_time'...
% %         ,'Vds1_Inv3_data','Vds1_Inv3_time'...
% %         ,'Vds2_Inv1_data','Vds2_Inv1_time','Vds2_Inv3_data','Vds2_Inv3_time')
    
