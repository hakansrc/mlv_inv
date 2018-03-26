cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\compact versions\compact2level\onlyparallel')
open_system('twolevel_parallel.slx');
clear
%% values of the signals
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 1050; %Hz
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 0.02; %duration of the model
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
                


% twolevel_interleaved = sim('twolevel_parallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');


% % % % % % % % % % % % % %% Spectrum of DCLINK_voltage
% % % % % % % % % % % % % % Fs = numel(DCLINK_voltage.data);  %Sampling Frequency
% % % % % % % % % % % % % DCLINK_voltage_spectrum = fft(twolevel_interleaved.get('DCLINK_voltage').data,N*2);
% % % % % % % % % % % % % DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % % DCLINK_voltage_spectrum_abs = DCLINK_voltage_spectrum_abs/max(DCLINK_voltage_spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % semilogy(freq,DCLINK_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of DCLINK voltage');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% Spectrum of DCLINK_current
% % % % % % % % % % % % % % Fs = numel(DCLINK_current.data);  %Sampling Frequency
% % % % % % % % % % % % % DCLINK_current_spectrum = fft(twolevel_interleaved.get('DCLINK_current').data,N*2);
% % % % % % % % % % % % % DCLINK_current_spectrum_abs = abs(DCLINK_current_spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % DCLINK_current_spectrum_abs = DCLINK_current_spectrum_abs/max(DCLINK_current_spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % semilogy(freq,DCLINK_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of DCLINK current');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% Spectrum of VAB1 only
% % % % % % % % % % % % % % Fs = numel(LL_voltages.signals(1).values);  %Sampling Frequency
% % % % % % % % % % % % % LL_voltages_spectrum = fft(twolevel_interleaved.get('LL_voltages1').signals(1).values,N*2);
% % % % % % % % % % % % % LL_voltages_spectrum_abs = abs(LL_voltages_spectrum(2:N/2));
% % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % 
% % % % % % % % % % % % % LL_voltages_spectrum_abs = LL_voltages_spectrum_abs/max(LL_voltages_spectrum_abs); % normalization
% % % % % % % % % % % % % figure;
% % % % % % % % % % % % % semilogy(freq,LL_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % title('Spectrum of Vab1');
% % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % % %% Spectrum of Ia1 only
% % % % % % % % % % % % % % Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
% % % % % % % % % % % % % Ia_Spectrum = fft(twolevel_interleaved.get('Phase_currents1').signals(1).values,N*2);
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
% % % % % % % % % % % % % plot(twolevel_interleaved.get('THD_Ia1').time, 100*twolevel_interleaved.get('THD_Ia1').data)
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
% % % % % % % % % % % % % plot(twolevel_interleaved.get('THD_Vab1').time, 100*twolevel_interleaved.get('THD_Vab1').data)
% % % % % % % % % % % % % title('THD of Vab1');
% % % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % % close all


% % % % % % % % % % % % % timelength = round((numel(twolevel_interleaved.get('DCLINK_voltage').time))*0.9);
% % % % % % % % % % % % % maxvoltage = max(twolevel_interleaved.get('DCLINK_voltage').data(timelength:end));
% % % % % % % % % % % % % minvoltage = min(twolevel_interleaved.get('DCLINK_voltage').data(timelength:end));
% % % % % % % % % % % % % twolevel_DCRipple = maxvoltage - minvoltage;
% % % % % % % % % % % % % ripplepercent = 100*twolevel_DCRipple/mean(twolevel_interleaved.get('DCLINK_voltage').data(timelength:end));
% % % % % % % % % % % % % fprintf('Ripple Percent is: %d \n',ripplepercent)
% % % % % % % % % % % % % fprintf('Vcrms value is: %d \n',mean(twolevel_interleaved.get('Vcrms').signals(1).values(timelength:end)));
% % % % % % % % % % % % % fprintf('Icrms value is: %d \n',mean(twolevel_interleaved.get('Icrms').signals(1).values(end)));




count = 1;
for sw_frequency = 10050    
    
    for Load_Real_Power = 800:800:8000
    %       Load_Real_Power = 8000; %W
Load_Power_Factor = 0.9;
Load_Apparent_Power = Load_Real_Power/Load_Power_Factor; %VA
Load_Reactive_Power = Load_Apparent_Power*sin(acos(Load_Power_Factor)); %VAr
Vll_rms = ma*DC_Voltage_Source*0.612;
Vln_rms = Vll_rms/sqrt(3);
Iline = Load_Apparent_Power/(Vll_rms*sqrt(3));

Load_Angle = acos(Load_Power_Factor);
Ef = Vln_rms*cos(Load_Angle);
Xs = sqrt((Vln_rms^2-Ef^2)/Iline^2);
Ls = Xs/ref_frequency; % n: number of interleaved inverters 
    capacitorsabiti = 200e-6*14000;
    DCLINK_Cap = 0.6*capacitorsabiti/sw_frequency;
    Capacitor_values = DCLINK_Cap; %tobesaved
    Sampling_time = 1/(20*50000); %sampling frequency of the model
    Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
    twolevel_interleaved = sim('twolevel_parallel.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
    
%     THDV_2level_IGBTVab1 = 100*twolevel_interleaved.get('THD_Vab1').data(end); %tobesaved
%     THDV_2level_IGBTIa1 = 100*twolevel_interleaved.get('THD_Ia1').data(end); %tobesaved
%     timelength = round((numel(twolevel_interleaved.get('DCLINK_voltage').time))*0.85);
%     maxvoltage = max(twolevel_interleaved.get('DCLINK_voltage').signals.values(timelength:end));
%     minvoltage = min(twolevel_interleaved.get('DCLINK_voltage').signals.values(timelength:end));
%     twolevel_DCRipple = maxvoltage - minvoltage;
%     ripplepercent = 100*twolevel_DCRipple/mean(twolevel_interleaved.get('DCLINK_voltage').signals.values(timelength:end));
%     ripplepercentvector = ripplepercent; %tobesaved
%     ripplevector = twolevel_DCRipple;  %tobesaved
%     DCLINK_Vcrms = mean(twolevel_interleaved.get('Vcrms').signals(1).values(timelength:end)); %tobesaved
%     DCLINK_Icrms = mean(twolevel_interleaved.get('Icrms').signals(1).values(timelength:end)); %tobesaved
%     
%     %% spectrums 
%     N = numel(twolevel_interleaved.get('DCLINK_voltage').signals.values);
%     DCLINK_voltage_spectrum = fft(twolevel_interleaved.get('DCLINK_voltage').signals.values,N)/(0.5*N);
%     DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(1:(N/2+1)));
%     DCLINK_voltage_spectrum_abs(1) = DCLINK_voltage_spectrum_abs(1)/2;
%   
%     DCLINK_current_spectrum = fft(twolevel_interleaved.get('DCLINK_current').signals.values,N)/(0.5*N);
%     DCLINK_current_spectrum_abs = abs(DCLINK_current_spectrum(1:(N/2+1)));
%     DCLINK_current_spectrum_abs(1) = DCLINK_current_spectrum_abs(1)/2;
% %     freqDC(count,1:numel((0:(N/2))*Fs/N)) = (0:(N/2))*Fs/N; 
%     
% %     N = numel(twolevel_interleaved.get('LL_voltages1').signals(1).values);
%     LLab_voltages_spectrum = fft(twolevel_interleaved.get('LL_voltages1').signals(1).values,N)/(0.5*N);
%     LLab_voltages_spectrum_abs = abs(LLab_voltages_spectrum(1:(N/2+1)));
%     
%     LLbc_voltages_spectrum = fft(twolevel_interleaved.get('LL_voltages1').signals(2).values,N)/(0.5*N);
%     LLbc_voltages_spectrum_abs = abs(LLbc_voltages_spectrum(1:(N/2+1)));
%     
%     LLca_voltages_spectrum = fft(twolevel_interleaved.get('LL_voltages1').signals(3).values,N)/(0.5*N);
%     LLca_voltages_spectrum_abs = abs(LLca_voltages_spectrum(1:(N/2+1)));
% 
%     Ia_Spectrum = fft(twolevel_interleaved.get('Phase_currents1').signals(1).values,N)/(0.5*N);
%     Ia_Spectrum_abs = abs(Ia_Spectrum(1:(N/2+1)));
%     
%     Ib_Spectrum = fft(twolevel_interleaved.get('Phase_currents1').signals(2).values,N)/(0.5*N);
%     Ib_Spectrum_abs = abs(Ib_Spectrum(1:(N/2+1)));
%     
%     Ic_Spectrum = fft(twolevel_interleaved.get('Phase_currents1').signals(3).values,N)/(0.5*N);
%     Ic_Spectrum_abs = abs(Ic_Spectrum(1:(N/2+1)));
%     
% %     freqAC(count,1:numel((0:(N/2))*Fs/N)) = (0:(N/2))*Fs/N; 
% 
% 
%     freq = (0:(N/2))*Fs/N; 
%     figure 
% %     semilogy(freq,DCLINK_voltage_spectrum_abs)    
%     
%     
%     fprintf('swf = %d , ripplepercent = %d , Capacitor size = %d',sw_frequency,ripplepercent,DCLINK_Cap);
%     fprintf('\n')
%     savename = strcat('IGBTmodel',num2str(count),'kHz');
%     save(savename,'Capacitor_values','THDV_2level_IGBTVab1','THDV_2level_IGBTIa1','ripplepercentvector'...
%     ,'ripplevector','DCLINK_Vcrms','DCLINK_Icrms','DCLINK_voltage_spectrum_abs','DCLINK_current_spectrum_abs',...
%     'LLab_voltages_spectrum_abs','LLbc_voltages_spectrum_abs','LLca_voltages_spectrum_abs','Ia_Spectrum_abs','Ib_Spectrum_abs','Ic_Spectrum_abs','freq');
%     clear ('Capacitor_values','THDV_2level_IGBTVab1','THDV_2level_IGBTIa1','ripplepercentvector'...
%     ,'ripplevector','DCLINK_Vcrms','DCLINK_Icrms','DCLINK_voltage_spectrum_abs','DCLINK_current_spectrum_abs',...
%     'LLab_voltages_spectrum_abs','LLbc_voltages_spectrum_abs','LLca_voltages_spectrum_abs','Ia_Spectrum_abs','Ib_Spectrum_abs','Ic_Spectrum_abs','freq')
%  
%     count = count+1;
    savename = strcat('topology_A_eff_load_',num2str(Load_Real_Power),'W');
    Isw1 = twolevel_interleaved.get('Isw1').signals.values;
    Isw1_timedata = twolevel_interleaved.get('Isw1').time;
    save(savename, 'Isw1', 'Isw1_timedata')
    Load_Real_Power

end
end
%%
% capacitor_a = capacitor_a*0.53;
% capacitor_b = capacitor_b*0.55;
% capacitor_c = capacitor_c*0.40;
% capacitor_d = capacitor_d*0.80;
% capacitor_e = capacitor_e*0.60;

% 
% figure 
% plot(sw_frequency_a/1000,capacitor_a*1e6,'Linewidth',3);
% hold on
% plot(sw_frequency_b/1000,2*capacitor_b*1e6,'Linewidth',3);
% hold on
% plot(sw_frequency_c/1000,2*capacitor_c*1e6,'Linewidth',3);
% hold on
% plot(sw_frequency_d/1000,2*capacitor_d*1e6,'Linewidth',3);
% hold on
% plot(sw_frequency_e/1000,2*capacitor_e*1e6,'Linewidth',3);
% legend('Topology A','Topology B','Topology C','Topology D','Topology E')
% xlabel('Switching Frequency (kHz)')
% ylabel('Capacitance (µF)')
% title('Switching Frequency vs. Capacitance')
% hold off
% ylim([0 500])
% 
% %%
% figure 
% plot(sw_frequency_a/1000,ripplepercent_a,'Linewidth',3);
% hold on
% plot(sw_frequency_b/1000,ripplepercent_b,'Linewidth',3);
% hold on
% plot(sw_frequency_c/1000,ripplepercent_c,'Linewidth',3);
% hold on
% plot(sw_frequency_d/1000,ripplepercent_d,'Linewidth',3);
% hold on
% plot(sw_frequency_e/1000,ripplepercent_e,'Linewidth',3);
% legend('Topology A','Topology B','Topology C','Topology D','Topology E')
% xlabel('Switching Frequency (kHz')
% ylabel('Ripple Percent (%)')
% title('Switching Frequency vs. Ripple Percent')
% hold off
% 
% 
% %% spectrums kýsmýsýlarý
% 
% axes; hold on;
% numL = 10;
% for ii = 1:5
%     plot3(1:numL,ii.*ones(1,numL),rand(1,numL)); 
% end
% view(45,25)
% ploticin(1:350001) = 1;
% plot3(A_freq_10khz,ploticin,A_DCLINK_Voltage_Spectrum_10khz)



