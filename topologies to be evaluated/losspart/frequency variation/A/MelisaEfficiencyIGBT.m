cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\mlv_inv\topologies to be evaluated\compact versions\compact2level\onlyparallel')
open_system('twolevel_parallel.slx');
clear
N = 2^11;
%% values of the signals
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 2050; %Hz
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 0.5/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 0.0201; %duration of the model
%% Load&Source settings
Load_Real_Power = 8000; %W
Load_Power_Factor = 0.9; 
Load_Apparent_Power = Load_Real_Power/Load_Power_Factor; %VA
Load_Reactive_Power = Load_Apparent_Power*sin(acos(Load_Power_Factor)); %VAr
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = ref_frequency/(2*pi); %Hz

n = 1; %number of interleaved inverters 

interleaving_angle = 360/n;
intangle1 = 0;
intangle2 = intangle1 + interleaving_angle;
intangle3 = intangle2 + interleaving_angle;
intangle4 = intangle3 + interleaving_angle;


Vll_rms = ma*DC_Voltage_Source*0.612;
Vln_rms = Vll_rms/sqrt(3);
Iline = Load_Apparent_Power/(Vll_rms*sqrt(3));
% Zload = n*Vll_rms/(Iline*sqrt(3));

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
%% equating the angle of the load angle and the powerfactor angle
Load_Angle = acos(Load_Power_Factor);
Ef = Vln_rms*cos(Load_Angle);
Xs = sqrt((Vln_rms^2-Ef^2)/Iline^2);
%%
Ls = n*Xs/ref_frequency; % n: number of interleaved inverters  
% % % % % % DCLINK_Cap = 200e-6; %Farads
capacitorsabiti = 200e-6*14000;
DCLINK_Cap = capacitorsabiti/sw_frequency;
Rin = 1; %ohm
Vin = DC_Voltage_Source + Rin*(Load_Real_Power/DC_Voltage_Source);

%% commenting out the inverters depending on the 'n' value
if n==4
    set_param('twolevel_parallel/Inverter1','commented','off')
    set_param('twolevel_parallel/Inverter2','commented','off')
%     set_param('twolevel_parallel/Inverter3','commented','off')
%     set_param('twolevel_parallel/Inverter4','commented','off')
    set_param('twolevel_parallel/Inverter 1 Load','commented','off')
    set_param('twolevel_parallel/Inverter 2 Load','commented','off')
%     set_param('twolevel_parallel/Inverter 3 Load','commented','off')
%     set_param('twolevel_parallel/Inverter 4 Load','commented','off')
end   
    if n == 3
        set_param('twolevel_parallel/Inverter1','commented','off')
        set_param('twolevel_parallel/Inverter2','commented','off')
%         set_param('twolevel_parallel/Inverter3','commented','off')
%         set_param('twolevel_parallel/Inverter4','commented','on')
        set_param('twolevel_parallel/Inverter 1 Load','commented','off')
        set_param('twolevel_parallel/Inverter 2 Load','commented','off')
%         set_param('twolevel_parallel/Inverter 3 Load','commented','off')
%         set_param('twolevel_parallel/Inverter 4 Load','commented','on')
    end
        if n == 2
            set_param('twolevel_parallel/Inverter1','commented','off')
            set_param('twolevel_parallel/Inverter2','commented','off')
%             set_param('twolevel_parallel/Inverter3','commented','on')
%             set_param('twolevel_parallel/Inverter4','commented','on')
            set_param('twolevel_parallel/Inverter 1 Load','commented','off')
            set_param('twolevel_parallel/Inverter 2 Load','commented','off')
%             set_param('twolevel_parallel/Inverter 3 Load','commented','on')
%             set_param('twolevel_parallel/Inverter 4 Load','commented','on')
        end
            if n == 1
                set_param('twolevel_parallel/Inverter1','commented','off')
                set_param('twolevel_parallel/Inverter2','commented','on')
%                 set_param('twolevel_parallel/Inverter3','commented','on')
%                 set_param('twolevel_parallel/Inverter4','commented','on')
                set_param('twolevel_parallel/Inverter 1 Load','commented','off')
                set_param('twolevel_parallel/Inverter 2 Load','commented','on')
%                 set_param('twolevel_parallel/Inverter 3 Load','commented','on')
%                 set_param('twolevel_parallel/Inverter 4 Load','commented','on')
            end
                if n == 0
                    set_param('twolevel_parallel/Inverter1','commented','on')
                    set_param('twolevel_parallel/Inverter2','commented','on')
%                     set_param('twolevel_parallel/Inverter3','commented','on')
%                     set_param('twolevel_parallel/Inverter4','commented','on')
                    set_param('twolevel_parallel/Inverter 1 Load','commented','on')
                    set_param('twolevel_parallel/Inverter 2 Load','commented','on')
%                     set_param('twolevel_parallel/Inverter 3 Load','commented','on')
%                     set_param('twolevel_parallel/Inverter 4 Load','commented','on')
                end
                


% % % % % twolevel_interleaved = sim('twolevel_parallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
% % % % % 
% % % % % 
% % % % % %% Spectrum of DCLINK_voltage
% % % % % % Fs = numel(DCLINK_voltage.data);  %Sampling Frequency
% % % % % DCLINK_voltage_spectrum = fft(twolevel_interleaved.get('DCLINK_voltage').data,N*2);
% % % % % DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(2:N/2));
% % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % 
% % % % % DCLINK_voltage_spectrum_abs = DCLINK_voltage_spectrum_abs/max(DCLINK_voltage_spectrum_abs); % normalization
% % % % % figure;
% % % % % semilogy(freq,DCLINK_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % title('Spectrum of DCLINK voltage');
% % % % % xlabel('Frequency (Hz)');
% % % % % ylabel('Magnitude');
% % % % % %% Spectrum of DCLINK_current
% % % % % % Fs = numel(DCLINK_current.data);  %Sampling Frequency
% % % % % DCLINK_current_spectrum = fft(twolevel_interleaved.get('DCLINK_current').data,N*2);
% % % % % DCLINK_current_spectrum_abs = abs(DCLINK_current_spectrum(2:N/2));
% % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % 
% % % % % DCLINK_current_spectrum_abs = DCLINK_current_spectrum_abs/max(DCLINK_current_spectrum_abs); % normalization
% % % % % figure;
% % % % % semilogy(freq,DCLINK_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % title('Spectrum of DCLINK current');
% % % % % xlabel('Frequency (Hz)');
% % % % % ylabel('Magnitude');
% % % % % %% Spectrum of VAB1 only
% % % % % % Fs = numel(LL_voltages.signals(1).values);  %Sampling Frequency
% % % % % LL_voltages_spectrum = fft(twolevel_interleaved.get('LL_voltages1').signals(1).values,N*2);
% % % % % LL_voltages_spectrum_abs = abs(LL_voltages_spectrum(2:N/2));
% % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % 
% % % % % LL_voltages_spectrum_abs = LL_voltages_spectrum_abs/max(LL_voltages_spectrum_abs); % normalization
% % % % % figure;
% % % % % semilogy(freq,LL_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % title('Spectrum of Vab1');
% % % % % xlabel('Frequency (Hz)');
% % % % % ylabel('Magnitude');
% % % % % %% Spectrum of Ia1 only
% % % % % % Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
% % % % % Ia_Spectrum = fft(twolevel_interleaved.get('Phase_currents1').signals(1).values,N*2);
% % % % % Ia_Spectrum_abs = abs(Ia_Spectrum(2:N/2));
% % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % 
% % % % % Ia_Spectrum_abs =Ia_Spectrum_abs/max(Ia_Spectrum_abs); % normalization
% % % % % figure;
% % % % % semilogy(freq,Ia_Spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % title('Spectrum of Ia1');
% % % % % xlabel('Frequency (Hz)');
% % % % % ylabel('Magnitude');
% % % % % %% plotting of THD's
% % % % % figure
% % % % % subplot(2,1,1);
% % % % % plot(twolevel_interleaved.get('THD_Ia1').time, 100*twolevel_interleaved.get('THD_Ia1').data)
% % % % % title('THD of Ia1');
% % % % % xlabel('Time(sec)');
% % % % % ylabel('THD (%)');
% % % % % 
% % % % % % subplot(3,1,2);
% % % % % % plot(twolevelspwm.get('THD_Van').time, 100*twolevelspwm.get('THD_Van').data)
% % % % % % title('THD of Van');
% % % % % % xlabel('Time(sec)');
% % % % % % ylabel('THD (%)');
% % % % % 
% % % % % subplot(2,1,2);
% % % % % plot(twolevel_interleaved.get('THD_Vab1').time, 100*twolevel_interleaved.get('THD_Vab1').data)
% % % % % title('THD of Vab1');
% % % % % xlabel('Time(sec)');
% % % % % ylabel('THD (%)');
% % % % % close all
% % % % % 
% % % % % 
% % % % % timelength = round((numel(twolevel_interleaved.get('DCLINK_voltage').time))*0.9);
% % % % % maxvoltage = max(twolevel_interleaved.get('DCLINK_voltage').data(timelength:end));
% % % % % minvoltage = min(twolevel_interleaved.get('DCLINK_voltage').data(timelength:end));
% % % % % twolevel_DCRipple = maxvoltagef - minvoltage;
% % % % % ripplepercent = 100*twolevel_DCRipple/mean(twolevel_interleaved.get('DCLINK_voltage').data(timelength:end));
% % % % % fprintf('Ripple Percent is: %d \n',ripplepercent)
% % % % % fprintf('Vcrms value is: %d \n',mean(twolevel_interleaved.get('Vcrms').signals(1).values(timelength:end)));
% % % % % fprintf('Icrms value is: %d \n',mean(twolevel_interleaved.get('Icrms').signals(1).values(end)));
% % % % % 
% % % % % 


count = 1;
for sw_frequency = 1050:1000:25050
    capacitorsabiti = 200e-6*14000;
    DCLINK_Cap = 0.5*capacitorsabiti/sw_frequency;
    Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
    twolevel_interleaved = sim('twolevel_parallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
    Ids1(count,1:numel(twolevel_interleaved.get('Ids1').data)) = twolevel_interleaved.get('Ids1').data;        
    
       
    count = count+1;
  
end
save('data','Ids1');



