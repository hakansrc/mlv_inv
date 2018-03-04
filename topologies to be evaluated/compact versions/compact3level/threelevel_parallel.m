cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\compact versions\compact3level')
open_system('threelevel_spwm.slx');
% clear
N = 2^20;
%% values of the signals
ma = 0.9;
ref_frequency = 2*pi*50; %radians per sec
sw_frequency = 52050; %Hz
Sampling_time = 1/(20*sw_frequency); %sampling frequency of the model
Fs = 0.5/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
stop_time = 2; %duration of the model
%% Load&Source settings
Load_Real_Power = 8000; %W
Load_Power_Factor = 0.9; 
Load_Apparent_Power = Load_Real_Power/Load_Power_Factor; %VA
Load_Reactive_Power = Load_Apparent_Power*sin(acos(Load_Power_Factor)); %VAr
DC_Voltage_Source = 540; %Volts
Load_Nominal_Freq = ref_frequency/(2*pi); %Hz

n = 1; %number of parallel modules (2 at max)

interleaving_angle = 360/n;
intangle1 = 0;
intangle2 = intangle1 + interleaving_angle;

Vll_rms = ma*DC_Voltage_Source*0.612;
Vln_rms = Vll_rms/sqrt(3);
Iline = Load_Apparent_Power/(Vll_rms*sqrt(3));

theta = acos((Load_Real_Power/3)/(Vln_rms*Iline));


% Zload = n*Vll_rms/(Iline*sqrt(3));  %ohm total
% Rload = Zload*Load_Power_Factor;  %ohm total
% Xload = Zload*sin(acos(Load_Power_Factor)); %ohm total
% Lload = Xload/ref_frequency;


Rin = 1; %ohm
Vin = DC_Voltage_Source + Rin*(Load_Real_Power/DC_Voltage_Source);

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
Ls = n*Xs/ref_frequency; % n: number of interleaved inverters  

DCLINK_Cap1 = 1000e-6; %Farads
DCLINK_Cap2 = 1000e-6; %Farads
%% commenting out the inverters depending on the 'n' value

if n == 2
    set_param('threelevel_spwm/Load 1','commented','off')
    set_param('threelevel_spwm/Load 2','commented','off')
end
if n == 1
    set_param('threelevel_spwm/Load 1','commented','off')
    set_param('threelevel_spwm/Load 2','commented','on')
end
if n == 0
    set_param('threelevel_spwm/Load 1','commented','on')
    set_param('threelevel_spwm/Load 2','commented','on')
end

% % % % % % % % % % % % % simOut = sim('three_levelparallel_spwm.slx'); %run the simulation
% % % % % % % % % % % % threelevelspwm_p = sim('threelevel_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
% % % % % % % % % % % % 
% % % % % % % % % % % % 
% % % % % % % % % % % % %% Spectrum of DCLINK_voltage
% % % % % % % % % % % % % Fs = numel(DCLINK_voltage.data);  %Sampling Frequency
% % % % % % % % % % % % DCLINK_voltage_spectrum = fft(threelevelspwm_p.get('DCLINK_voltage').data,N*2);
% % % % % % % % % % % % DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(2:N/2));
% % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % 
% % % % % % % % % % % % DCLINK_voltage_spectrum_abs = DCLINK_voltage_spectrum_abs/max(DCLINK_voltage_spectrum_abs); % normalization
% % % % % % % % % % % % figure;
% % % % % % % % % % % % semilogy(freq,DCLINK_voltage_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % title('Spectrum of DCLINK voltage');
% % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % %% Spectrum of DCLINK_current
% % % % % % % % % % % % % Fs = numel(DCLINK_current.data);  %Sampling Frequency
% % % % % % % % % % % % DCLINK_current_spectrum = fft(threelevelspwm_p.get('DCLINK_current').data,N*2);
% % % % % % % % % % % % DCLINK_current_spectrum_abs = abs(DCLINK_current_spectrum(2:N/2));
% % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % 
% % % % % % % % % % % % DCLINK_current_spectrum_abs = DCLINK_current_spectrum_abs/max(DCLINK_current_spectrum_abs); % normalization
% % % % % % % % % % % % figure;
% % % % % % % % % % % % semilogy(freq,DCLINK_current_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % title('Spectrum of DCLINK current');
% % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % %% Spectrum of VAB1 only
% % % % % % % % % % % % % Fs = numel(LL_voltages.signals(1).values);  %Sampling Frequency
% % % % % % % % % % % % LL_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages1').signals(1).values,N*2);
% % % % % % % % % % % % LL_voltages_spectrum_abs = abs(LL_voltages_spectrum(2:N/2));
% % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % 
% % % % % % % % % % % % LL_voltages_spectrum_abs = LL_voltages_spectrum_abs/max(LL_voltages_spectrum_abs); % normalization
% % % % % % % % % % % % figure;
% % % % % % % % % % % % semilogy(freq,LL_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % title('Spectrum of Vab1');
% % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % %% Spectrum of Ia1 only
% % % % % % % % % % % % % Fs = numel(Phase_currents.signals(1).values);  %Sampling Frequency
% % % % % % % % % % % % Ia_Spectrum = fft(threelevelspwm_p.get('Phase_currents1').signals(1).values,N*2);
% % % % % % % % % % % % Ia_Spectrum_abs = abs(Ia_Spectrum(2:N/2));
% % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % 
% % % % % % % % % % % % Ia_Spectrum_abs =Ia_Spectrum_abs/max(Ia_Spectrum_abs); % normalization
% % % % % % % % % % % % figure;
% % % % % % % % % % % % semilogy(freq,Ia_Spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % title('Spectrum of Ia1');
% % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % ylabel('Magnitude');
% % % % % % % % % % % % %% plotting of THD's
% % % % % % % % % % % % figure
% % % % % % % % % % % % subplot(2,1,1);
% % % % % % % % % % % % plot(threelevelspwm_p.get('THD_Ia1').time, 100*threelevelspwm_p.get('THD_Ia1').data)
% % % % % % % % % % % % title('THD of Ia1');
% % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % 
% % % % % % % % % % % % % subplot(3,1,2);
% % % % % % % % % % % % % plot(twolevelspwm.get('THD_Van').time, 100*twolevelspwm.get('THD_Van').data)
% % % % % % % % % % % % % title('THD of Van');
% % % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % 
% % % % % % % % % % % % subplot(2,1,2);
% % % % % % % % % % % % plot(threelevelspwm_p.get('THD_Vab1').time, 100*threelevelspwm_p.get('THD_Vab1').data)
% % % % % % % % % % % % title('THD of Vab1');
% % % % % % % % % % % % xlabel('Time(sec)');
% % % % % % % % % % % % ylabel('THD (%)');
% % % % % % % % % % % % % close all



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

%% one module part

n = 1;

Ls = n*Xs/ref_frequency; % n: number of interleaved inverters  

DCLINK_Cap1 = 1000e-6; %Farads
DCLINK_Cap2 = 1000e-6; %Farads
%% commenting out the inverters depending on the 'n' value

if n == 2
    set_param('threelevel_spwm/Load 1','commented','off')
    set_param('threelevel_spwm/Load 2','commented','off')
end
if n == 1
    set_param('threelevel_spwm/Load 1','commented','off')
    set_param('threelevel_spwm/Load 2','commented','on')
end
if n == 0
    set_param('threelevel_spwm/Load 1','commented','on')
    set_param('threelevel_spwm/Load 2','commented','on')
end
count = 1;
for sw_frequency = 1050:1000:101050
    capacitorsabiti = 200e-6*14000;
    DCLINK_Cap1 = 1.20*capacitorsabiti/sw_frequency;
    DCLINK_Cap2 = 1.20*capacitorsabiti/sw_frequency;
    Capacitor_values = DCLINK_Cap1; %tobesaved
    Sampling_time = 1/(20*50000); %sampling frequency of the model
    Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
    threelevelspwm_p = sim('threelevel_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
    N = numel(threelevelspwm_p.get('DCLINK_voltage').signals.values);

    THD_Vab1 = 100*threelevelspwm_p.get('THD_Vab1').data(end); %tobesaved
    THD_Ia1 = 100*threelevelspwm_p.get('THD_Ia1').data(end);%tobesaved
    THD_Van1 = 100*threelevelspwm_p.get('THD_Van1').data(end);%tobesaved
    
%     THD_Vab2 = 100*threelevelspwm_p.get('THD_Vab2').data(end); %tobesaved
%     THD_Ia2 = 100*threelevelspwm_p.get('THD_Ia2').data(end);%tobesaved
%     THD_Van2 = 100*threelevelspwm_p.get('THD_Van2').data(end);%tobesaved
%     timelength = round((numel(threelevelspwm_p.get('DCLINK_voltage').time))*0.9);
%     
    maxvoltage = max(threelevelspwm_p.get('upperc_voltage').signals.values(timelength:end));
    minvoltage = min(threelevelspwm_p.get('upperc_voltage').signals.values(timelength:end));
    threelevel_upperc_ripple = maxvoltage - minvoltage;
    ripple1vector_upperc = threelevel_upperc_ripple; %tobesaved
    ripple1percent_upperc = 100*threelevel_upperc_ripple/mean(threelevelspwm_p.get('upperc_voltage').signals.values(timelength:end)); %tobesaved

    maxvoltage = max(threelevelspwm_p.get('lowerc_voltage').signals.values(timelength:end));
    minvoltage = min(threelevelspwm_p.get('lowerc_voltage').signals.values(timelength:end));
    threelevel_lowerc_ripple = maxvoltage - minvoltage;
    ripple1vector_lowerc = threelevel_lowerc_ripple; %tobesaved
    ripple1percent_lowerc = 100*threelevel_lowerc_ripple/mean(threelevelspwm_p.get('lowerc_voltage').signals.values(timelength:end)); %tobesaved

    maxvoltage = max(threelevelspwm_p.get('DCLINK_voltage').signals.values(timelength:end));
    minvoltage = min(threelevelspwm_p.get('DCLINK_voltage').signals.values(timelength:end));
    threelevel_DCLINK_ripple = maxvoltage - minvoltage;
    ripple1vector_DCLINK = threelevel_DCLINK_ripple; %tobesaved
    ripple1percent_DCLINK = 100*threelevel_DCLINK_ripple/mean(threelevelspwm_p.get('DCLINK_voltage').signals.values(timelength:end)); %tobesaved
       
    
    lowerc_Vrms = mean(threelevelspwm_p.get('lowerc_vrms').signals(1).values(timelength:end)); %tobesaved
    lowerc_Irms = mean(threelevelspwm_p.get('lowerc_Irms').signals(1).values(timelength:end)); %tobesaved
    upperc_Vrms = mean(threelevelspwm_p.get('upperc_vrms').signals(1).values(timelength:end)); %tobesaved
    upperc_Irms = mean(threelevelspwm_p.get('upperc_Irms').signals(1).values(timelength:end)); %tobesaved
    DCLINK_Vrms = mean(threelevelspwm_p.get('DCLINK_voltage').signals(1).values(timelength:end)); %tobesaved
    DCLINK_Irms = mean(threelevelspwm_p.get('DCLINK_current').signals(1).values(timelength:end));
    In_rms = mean(threelevelspwm_p.get('Ineutralrms').signals(1).values(timelentgh:end));
    
    
    %% spectrums
    DCLINK_upperc_voltage_spectrum = fft(threelevelspwm_p.get('upperc_voltage').signals.values,N)/(0.5*N);
    DCLINK_upperc_voltage_spectrum_abs = abs(DCLINK_upperc_voltage_spectrum(1:(N/2+1)));
    DCLINK_upperc_voltage_spectrum_abs(1) = DCLINK_upperc_voltage_spectrum_abs(1)/2;
    
    DCLINK_upperc_current_spectrum = fft(threelevelspwm_p.get('upperc_current').signals.values,N)/(0.5*N);
    DCLINK_upperc_current_spectrum_abs = abs(DCLINK_upperc_current_spectrum(1:(N/2+1)));
    DCLINK_upperc_current_spectrum_abs(1) = DCLINK_upperc_current_spectrum_abs(1)/2;

    DCLINK_lowerc_voltage_spectrum = fft(threelevelspwm_p.get('lowerc_voltage').signals.values,N)/(0.5*N);
    DCLINK_lowerc_voltage_spectrum_abs = abs(DCLINK_lowerc_voltage_spectrum(1:(N/2+1)));
    DCLINK_lowerc_voltage_spectrum_abs(1) = DCLINK_lowerc_voltage_spectrum_abs(1)/2;
       
    DCLINK_lowerc_current_spectrum = fft(threelevelspwm_p.get('lowerc_current').signals.values,N)/(0.5*N);
    DCLINK_lowerc_current_spectrum_abs = abs(DCLINK_lowerc_current_spectrum(1:(N/2+1)));
    DCLINK_lowerc_current_spectrum_abs(1) = DCLINK_lowerc_current_spectrum_abs(1)/2;
    
    DCLINK_voltage_spectrum = fft(threelevelspwm_p.get('DCLINK_voltage').signals.values,N)/(0.5*N);
    DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(1:(N/2+1)));
    DCLINK_voltage_spectrum_abs(1) = DCLINK_voltage_spectrum_abs(1)/2;
    
    DCLINK_current_spectrum = fft(threelevelspwm_p.get('DCLINK_current').signals.values,N)/(0.5*N);
    DCLINK_current_spectrum_abs = abs(DCLINK_current_spectrum(1:(N/2+1)));
    DCLINK_current_spectrum_abs(1) = DCLINK_current_spectrum_abs(1)/2;
     
    
    LLab1_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages1').signals(1).values,N)/(0.5*N);
    LLab1_voltages_spectrum_abs = abs(LLab1_voltages_spectrum(1:(N/2+1)));    
    LLbc1_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages1').signals(2).values,N)/(0.5*N);
    LLbc1_voltages_spectrum_abs = abs(LLbc1_voltages_spectrum(1:(N/2+1)));    
    LLca1_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages1').signals(3).values,N)/(0.5*N);
    LLca1_voltages_spectrum_abs = abs(LLca1_voltages_spectrum(1:(N/2+1)));
    
    Ia1_Spectrum = fft(threelevelspwm_p.get('Phase_currents1').signals(1).values,N)/(0.5*N);
    Ia1_Spectrum_abs = abs(Ia1_Spectrum(1:(N/2+1)));    
    Ib1_Spectrum = fft(threelevelspwm_p.get('Phase_currents1').signals(2).values,N)/(0.5*N);
    Ib1_Spectrum_abs = abs(Ib1_Spectrum(1:(N/2+1)));    
    Ic1_Spectrum = fft(threelevelspwm_p.get('Phase_currents1').signals(3).values,N)/(0.5*N);
    Ic1_Spectrum_abs = abs(Ic1_Spectrum(1:(N/2+1))); 
    
    
    
    
%     LLab2_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages2').signals(1).values,N)/(0.5*N);
%     LLab2_voltages_spectrum_abs = abs(LLab2_voltages_spectrum(1:(N/2+1)));    
%     LLbc2_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages2').signals(2).values,N)/(0.5*N);
%     LLbc2_voltages_spectrum_abs = abs(LLbc2_voltages_spectrum(1:(N/2+1)));    
%     LLca2_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages2').signals(3).values,N)/(0.5*N);
%     LLca2_voltages_spectrum_abs = abs(LLca2_voltages_spectrum(1:(N/2+1)));
%     
%     Ia2_Spectrum = fft(threelevelspwm_p.get('Phase_currents2').signals(1).values,N)/(0.5*N);
%     Ia2_Spectrum_abs = abs(Ia2_Spectrum(1:(N/2+1)));    
%     Ib2_Spectrum = fft(threelevelspwm_p.get('Phase_currents2').signals(2).values,N)/(0.5*N);
%     Ib2_Spectrum_abs = abs(Ib2_Spectrum(1:(N/2+1)));    
%     Ic2_Spectrum = fft(threelevelspwm_p.get('Phase_currents2').signals(3).values,N)/(0.5*N);
%     Ic2_Spectrum_abs = abs(Ic2_Spectrum(1:(N/2+1)));   

    phasecurrentstime = threelevelspwm_p.get('Phase_currents1').time;
    Ia1 = threelevelspwm_p.get('Phase_currents1').signals(1).values;
%     Ia2 = threelevelspwm_p.get('Phase_currents2').signals(1).values; 
    Vab1 = threelevelspwm_p.get('LL_voltages1').signals(1).values;
%     Vab2 = threelevelspwm_p.get('LL_voltages2').signals(1).values;
    
    count = count + 1;
    freq = (0:(N/2))*Fs/N; 
    clc
    fprintf('swf = %d , rippleupperc = %d, ripplelowerc = %d  ,rippleDCLINK = %d ,Capacitor size = %d',sw_frequency,ripple1percent_upperc,ripple1percent_lowerc,ripple1percent_DCLINK,DCLINK_Cap);
    fprintf('\n')
    savename = strcat('topology_D_',num2str(sw_frequency),'Hz');
    
    save(savename,'Capacitor_values','THD_Vab1','THD_Ia1','THD_Van1'... %,'THD_Vab2','THD_Ia2','THD_Van2'...
        ,'ripple1vector_upperc','ripple1percent_upperc','ripple1vector_lowerc','ripple1percent_lowerc'...
        ,'ripple1vector_DCLINK','ripple1percent_DCLINK',...
        'lowerc_Vrms','lowerc_Irms','upperc_Vrms','upperc_Irms','DCLINK_Vrms','DCLINK_Irms','In_rms',...
        'DCLINK_upperc_voltage_spectrum_abs','DCLINK_upperc_current_spectrum_abs'...
        ,'DCLINK_lowerc_voltage_spectrum_abs','DCLINK_lowerc_current_spectrum_abs',...
        'DCLINK_voltage_spectrum_abs','DCLINK_current_spectrum_abs',...
        'LLab1_voltages_spectrum_abs','LLbc1_voltages_spectrum_abs','LLca1_voltages_spectrum_abs'...
        ,'Ia1_Spectrum_abs','Ib1_Spectrum_abs','Ic1_Spectrum_abs',...
        'phasecurrentstime','Ia1','Vab1','freq')
    clear('Capacitor_values','THD_Vab1','THD_Ia1','THD_Van1'... %,'THD_Vab2','THD_Ia2','THD_Van2'...
        ,'ripple1vector_upperc','ripple1percent_upperc','ripple1vector_lowerc','ripple1percent_lowerc'...
        ,'ripple1vector_DCLINK','ripple1percent_DCLINK',...
        'lowerc_Vrms','lowerc_Irms','upperc_Vrms','upperc_Irms','DCLINK_Vrms','DCLINK_Irms','In_rms',...
        'DCLINK_upperc_voltage_spectrum_abs','DCLINK_upperc_current_spectrum_abs'...
        ,'DCLINK_lowerc_voltage_spectrum_abs','DCLINK_lowerc_current_spectrum_abs',...
        'DCLINK_voltage_spectrum_abs','DCLINK_current_spectrum_abs',...
        'LLab1_voltages_spectrum_abs','LLbc1_voltages_spectrum_abs','LLca1_voltages_spectrum_abs'...
        ,'Ia1_Spectrum_abs','Ib1_Spectrum_abs','Ic1_Spectrum_abs',...
        'phasecurrentstime','Ia1','Vab1','freq')
    
    
end

%% two module part

n = 2;

Ls = n*Xs/ref_frequency; % n: number of interleaved inverters  

DCLINK_Cap1 = 1000e-6; %Farads
DCLINK_Cap2 = 1000e-6; %Farads
%% commenting out the inverters depending on the 'n' value

if n == 2
    set_param('threelevel_spwm/Load 1','commented','off')
    set_param('threelevel_spwm/Load 2','commented','off')
end
if n == 1
    set_param('threelevel_spwm/Load 1','commented','off')
    set_param('threelevel_spwm/Load 2','commented','on')
end
if n == 0
    set_param('threelevel_spwm/Load 1','commented','on')
    set_param('threelevel_spwm/Load 2','commented','on')
end
count = 1;
for sw_frequency = 1050:1000:101050
        capacitorsabiti = 200e-6*14000;
    DCLINK_Cap1 = 1.20*capacitorsabiti/sw_frequency;
    DCLINK_Cap2 = 1.20*capacitorsabiti/sw_frequency;
    Capacitor_values = DCLINK_Cap1; %tobesaved
    Sampling_time = 1/(20*50000); %sampling frequency of the model
    Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band
    threelevelspwm_p = sim('threelevel_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
    N = numel(threelevelspwm_p.get('DCLINK_voltage').signals.values);

    THD_Vab1 = 100*threelevelspwm_p.get('THD_Vab1').data(end); %tobesaved
    THD_Ia1 = 100*threelevelspwm_p.get('THD_Ia1').data(end);%tobesaved
    THD_Van1 = 100*threelevelspwm_p.get('THD_Van1').data(end);%tobesaved
    
    THD_Vab2 = 100*threelevelspwm_p.get('THD_Vab2').data(end); %tobesaved
    THD_Ia2 = 100*threelevelspwm_p.get('THD_Ia2').data(end);%tobesaved
    THD_Van2 = 100*threelevelspwm_p.get('THD_Van2').data(end);%tobesaved
    timelength = round((numel(threelevelspwm_p.get('DCLINK_voltage').time))*0.9);
    
    maxvoltage = max(threelevelspwm_p.get('upperc_voltage').signals.values(timelength:end));
    minvoltage = min(threelevelspwm_p.get('upperc_voltage').signals.values(timelength:end));
    threelevel_upperc_ripple = maxvoltage - minvoltage;
    ripple1vector_upperc = threelevel_upperc_ripple; %tobesaved
    ripple1percent_upperc = 100*threelevel_upperc_ripple/mean(threelevelspwm_p.get('upperc_voltage').signals.values(timelength:end)); %tobesaved

    maxvoltage = max(threelevelspwm_p.get('lowerc_voltage').signals.values(timelength:end));
    minvoltage = min(threelevelspwm_p.get('lowerc_voltage').signals.values(timelength:end));
    threelevel_lowerc_ripple = maxvoltage - minvoltage;
    ripple1vector_lowerc = threelevel_lowerc_ripple; %tobesaved
    ripple1percent_lowerc = 100*threelevel_lowerc_ripple/mean(threelevelspwm_p.get('lowerc_voltage').signals.values(timelength:end)); %tobesaved

    maxvoltage = max(threelevelspwm_p.get('DCLINK_voltage').signals.values(timelength:end));
    minvoltage = min(threelevelspwm_p.get('DCLINK_voltage').signals.values(timelength:end));
    threelevel_DCLINK_ripple = maxvoltage - minvoltage;
    ripple1vector_DCLINK = threelevel_DCLINK_ripple; %tobesaved
    ripple1percent_DCLINK = 100*threelevel_DCLINK_ripple/mean(threelevelspwm_p.get('DCLINK_voltage').signals.values(timelength:end)); %tobesaved
       
    
    lowerc_Vrms = mean(threelevelspwm_p.get('lowerc_vrms').signals(1).values(timelength:end)); %tobesaved
    lowerc_Irms = mean(threelevelspwm_p.get('lowerc_Irms').signals(1).values(timelength:end)); %tobesaved
    upperc_Vrms = mean(threelevelspwm_p.get('upperc_vrms').signals(1).values(timelength:end)); %tobesaved
    upperc_Irms = mean(threelevelspwm_p.get('upperc_Irms').signals(1).values(timelength:end)); %tobesaved
    DCLINK_Vrms = mean(threelevelspwm_p.get('DCLINK_voltage').signals(1).values(timelength:end)); %tobesaved
    DCLINK_Irms = mean(threelevelspwm_p.get('DCLINK_current').signals(1).values(timelength:end));
    In_rms = mean(threelevelspwm_p.get('Ineutralrms').signals(1).values(timelentgh:end));
    
    
    %% spectrums
    DCLINK_upperc_voltage_spectrum = fft(threelevelspwm_p.get('upperc_voltage').signals.values,N)/(0.5*N);
    DCLINK_upperc_voltage_spectrum_abs = abs(DCLINK_upperc_voltage_spectrum(1:(N/2+1)));
    DCLINK_upperc_voltage_spectrum_abs(1) = DCLINK_upperc_voltage_spectrum_abs(1)/2;
    
    DCLINK_upperc_current_spectrum = fft(threelevelspwm_p.get('upperc_current').signals.values,N)/(0.5*N);
    DCLINK_upperc_current_spectrum_abs = abs(DCLINK_upperc_current_spectrum(1:(N/2+1)));
    DCLINK_upperc_current_spectrum_abs(1) = DCLINK_upperc_current_spectrum_abs(1)/2;

    DCLINK_lowerc_voltage_spectrum = fft(threelevelspwm_p.get('lowerc_voltage').signals.values,N)/(0.5*N);
    DCLINK_lowerc_voltage_spectrum_abs = abs(DCLINK_lowerc_voltage_spectrum(1:(N/2+1)));
    DCLINK_lowerc_voltage_spectrum_abs(1) = DCLINK_lowerc_voltage_spectrum_abs(1)/2;
       
    DCLINK_lowerc_current_spectrum = fft(threelevelspwm_p.get('lowerc_current').signals.values,N)/(0.5*N);
    DCLINK_lowerc_current_spectrum_abs = abs(DCLINK_lowerc_current_spectrum(1:(N/2+1)));
    DCLINK_lowerc_current_spectrum_abs(1) = DCLINK_lowerc_current_spectrum_abs(1)/2;
    
    DCLINK_voltage_spectrum = fft(threelevelspwm_p.get('DCLINK_voltage').signals.values,N)/(0.5*N);
    DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(1:(N/2+1)));
    DCLINK_voltage_spectrum_abs(1) = DCLINK_voltage_spectrum_abs(1)/2;
    
    DCLINK_current_spectrum = fft(threelevelspwm_p.get('DCLINK_current').signals.values,N)/(0.5*N);
    DCLINK_current_spectrum_abs = abs(DCLINK_current_spectrum(1:(N/2+1)));
    DCLINK_current_spectrum_abs(1) = DCLINK_current_spectrum_abs(1)/2;
     
    
    LLab1_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages1').signals(1).values,N)/(0.5*N);
    LLab1_voltages_spectrum_abs = abs(LLab1_voltages_spectrum(1:(N/2+1)));    
    LLbc1_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages1').signals(2).values,N)/(0.5*N);
    LLbc1_voltages_spectrum_abs = abs(LLbc1_voltages_spectrum(1:(N/2+1)));    
    LLca1_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages1').signals(3).values,N)/(0.5*N);
    LLca1_voltages_spectrum_abs = abs(LLca1_voltages_spectrum(1:(N/2+1)));
    
    Ia1_Spectrum = fft(threelevelspwm_p.get('Phase_currents1').signals(1).values,N)/(0.5*N);
    Ia1_Spectrum_abs = abs(Ia1_Spectrum(1:(N/2+1)));    
    Ib1_Spectrum = fft(threelevelspwm_p.get('Phase_currents1').signals(2).values,N)/(0.5*N);
    Ib1_Spectrum_abs = abs(Ib1_Spectrum(1:(N/2+1)));    
    Ic1_Spectrum = fft(threelevelspwm_p.get('Phase_currents1').signals(3).values,N)/(0.5*N);
    Ic1_Spectrum_abs = abs(Ic1_Spectrum(1:(N/2+1))); 
    
    
    
    
    LLab2_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages2').signals(1).values,N)/(0.5*N);
    LLab2_voltages_spectrum_abs = abs(LLab2_voltages_spectrum(1:(N/2+1)));    
    LLbc2_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages2').signals(2).values,N)/(0.5*N);
    LLbc2_voltages_spectrum_abs = abs(LLbc2_voltages_spectrum(1:(N/2+1)));    
    LLca2_voltages_spectrum = fft(threelevelspwm_p.get('LL_voltages2').signals(3).values,N)/(0.5*N);
    LLca2_voltages_spectrum_abs = abs(LLca2_voltages_spectrum(1:(N/2+1)));
    
    Ia2_Spectrum = fft(threelevelspwm_p.get('Phase_currents2').signals(1).values,N)/(0.5*N);
    Ia2_Spectrum_abs = abs(Ia2_Spectrum(1:(N/2+1)));    
    Ib2_Spectrum = fft(threelevelspwm_p.get('Phase_currents2').signals(2).values,N)/(0.5*N);
    Ib2_Spectrum_abs = abs(Ib2_Spectrum(1:(N/2+1)));    
    Ic2_Spectrum = fft(threelevelspwm_p.get('Phase_currents2').signals(3).values,N)/(0.5*N);
    Ic2_Spectrum_abs = abs(Ic2_Spectrum(1:(N/2+1)));   

    phasecurrentstime = threelevelspwm_p.get('Phase_currents1').time;
    Ia1 = threelevelspwm_p.get('Phase_currents1').signals(1).values;
    Ia2 = threelevelspwm_p.get('Phase_currents2').signals(1).values; 
    Vab1 = threelevelspwm_p.get('LL_voltages1').signals(1).values;
    Vab2 = threelevelspwm_p.get('LL_voltages2').signals(1).values;
    
    count = count + 1;
    freq = (0:(N/2))*Fs/N; 
    clc
    fprintf('swf = %d , rippleupperc = %d, ripplelowerc = %d  ,rippleDCLINK = %d ,Capacitor size = %d',sw_frequency,ripple1percent_upperc,ripple1percent_lowerc,ripple1percent_DCLINK,DCLINK_Cap);
    fprintf('\n')
    savename = strcat('topology_D_',num2str(sw_frequency),'Hz');
    
    save(savename,'Capacitor_values','THD_Vab1','THD_Ia1','THD_Van1','THD_Vab2','THD_Ia2','THD_Van2'...
        ,'ripple1vector_upperc','ripple1percent_upperc','ripple1vector_lowerc','ripple1percent_lowerc'...
        ,'ripple1vector_DCLINK','ripple1percent_DCLINK',...
        'lowerc_Vrms','lowerc_Irms','upperc_Vrms','upperc_Irms','DCLINK_Vrms','DCLINK_Irms','In_rms',...
        'DCLINK_upperc_voltage_spectrum_abs','DCLINK_upperc_current_spectrum_abs'...
        ,'DCLINK_lowerc_voltage_spectrum_abs','DCLINK_lowerc_current_spectrum_abs',...
        'DCLINK_voltage_spectrum_abs','DCLINK_current_spectrum_abs',...
        'LLab1_voltages_spectrum_abs','LLbc1_voltages_spectrum_abs','LLca1_voltages_spectrum_abs'...
        ,'LLab2_voltages_spectrum_abs','LLbc2_voltages_spectrum_abs','LLca2_voltages_spectrum_abs'...
        ,'Ia1_Spectrum_abs','Ib1_Spectrum_abs','Ic1_Spectrum_abs',...
        'phasecurrentstime','Ia1','Vab1','Vab2','Ia2','freq')
    clear('Capacitor_values','THD_Vab1','THD_Ia1','THD_Van1','THD_Vab2','THD_Ia2','THD_Van2'...
        ,'ripple1vector_upperc','ripple1percent_upperc','ripple1vector_lowerc','ripple1percent_lowerc'...
        ,'ripple1vector_DCLINK','ripple1percent_DCLINK',...
        'lowerc_Vrms','lowerc_Irms','upperc_Vrms','upperc_Irms','DCLINK_Vrms','DCLINK_Irms','In_rms',...
        'DCLINK_upperc_voltage_spectrum_abs','DCLINK_upperc_current_spectrum_abs'...
        ,'DCLINK_lowerc_voltage_spectrum_abs','DCLINK_lowerc_current_spectrum_abs',...
        'DCLINK_voltage_spectrum_abs','DCLINK_current_spectrum_abs',...
        'LLab1_voltages_spectrum_abs','LLbc1_voltages_spectrum_abs','LLca1_voltages_spectrum_abs'...
        ,'LLab2_voltages_spectrum_abs','LLbc2_voltages_spectrum_abs','LLca2_voltages_spectrum_abs'...
        ,'Ia1_Spectrum_abs','Ib1_Spectrum_abs','Ic1_Spectrum_abs',...
        'Ia2_Spectrum_abs','Ib2_Spectrum_abs','Ic2_Spectrum_abs'...
        ,'phasecurrentstime','Ia1','Vab1','Vab2','Ia2','freq')
    
  

end