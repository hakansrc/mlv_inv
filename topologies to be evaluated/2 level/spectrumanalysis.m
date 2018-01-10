clear
cd('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\2 level')
simOut = sim('two_level_spwm.slx');
%simOut = sim('two_level_spwm.slx','SimulationMode','normal','AbsTol','1e-6','SaveState','on','StateSaveName','xout','SaveOutput','on','OutputSaveName','yout','SaveFormat', 'Dataset');
Fs = numel(Phase_currents.signals(1).values);            % Sampling frequency                    
%T = 1/Fs;             % Sampling period       
%L = 10000;             % Length of signal
%t = (0:L-1)*T;        % Time vector
N = 2^20;
Ia_Spectrum = fft(Phase_currents.signals(1).values,N*2);
Ia_Spectrum_abs = abs(Ia_Spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;   

%Y_abs = Y_abs/max(Y_abs);


figure;
semilogy(freq,Ia_Spectrum_abs)                          % Plot the magnitude of the samples of CTFT of the audio signal
xlabel('Frequency (Hz)');
ylabel('Magnitude');


% figure;
% plot(numel(phase(Y)),phase(Y))                           % Plot the phase of the samples of CTFT of the audio signal
% ylabel('Phase (radians)');
% xlabel('Frequency (Hz)');
% % axis([0 4000 10^-4 1])                
