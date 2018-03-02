Sampling_time = 1/(15*sw_frequency); %sampling frequency of the model
Fs = 1/Sampling_time;  %Sampling Frequency for the spectrum analysis  %5e-6 goes up to 50kHz band

%%
% Fs = numel(LL_voltages.signals(1).values);  %Sampling Frequency
% % % % % % % % % % % % % % % % % % N = numel(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(1).values);
% % % % % % % % % % % % % % % % % % LL_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(1).values,N)/(0.5*N);
% % % % % % % % % % % % % % % % % % LL_voltages_spectrum_abs = abs(LL_voltages_spectrum(2:N/2));
% % % % % % % % % % % % % % % % % % freq = (1:N/2-1)*Fs/N;   
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % LL_voltages_spectrum_abs = LL_voltages_spectrum_abs/max(LL_voltages_spectrum_abs); % normalization
% % % % % % % % % % % % % % % % % % figure;
% % % % % % % % % % % % % % % % % % plot(freq,LL_voltages_spectrum_abs) % Plot the magnitude of the samples of CTFT of the audio signal
% % % % % % % % % % % % % % % % % % title('Spectrum of Vab1');
% % % % % % % % % % % % % % % % % % xlabel('Frequency (Hz)');
% % % % % % % % % % % % % % % % % % ylabel('Magnitude');

% % % % % % % % % % % P = power_fftscope(Phase_currents1);
% % % % % % % % % % % P.set('MaxFrequency','sw_frequency')


N = numel(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(1).values);
% power_fftscope(Phase_currents1);
Fs = 1/Sampling_time;
LL_voltages_spectrum = fft(twolevelseriesparallel_interleaved.get('LL_voltages1').signals(1).values,N)/(0.5*N);
LL_voltages_spectrum_abs = abs(LL_voltages_spectrum(2:N/2));
freq = (1:N/2-1)*Fs/N;       
figure;
semilogy(freq,LL_voltages_spectrum_abs)% Plot the magnitude of the samples of CTFT of the audio signal
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% timelength = round((numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').time))*0.9);
% N = numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values);
% % power_fftscope(Phase_currents1);
% Fs = 1/Sampling_time;
% DCLINK_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values,N)/(0.5*N);
% DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(2:N/2));
% freq = (1:N/2-1)*Fs/N;       
% figure;
% semilogy(freq,DCLINK_voltage_spectrum_abs)% Plot the magnitude of the samples of CTFT of the audio signal
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');


N = numel(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values);
% power_fftscope(Phase_currents1);
Fs = 1/Sampling_time;
DCLINK_voltage_spectrum = fft(twolevelseriesparallel_interleaved.get('DCLINK1_voltage').signals.values,N)/(0.5*N);
DCLINK_voltage_spectrum_abs = abs(DCLINK_voltage_spectrum(1:(N/2+1)));
DCLINK_voltage_spectrum_abs(1) = DCLINK_voltage_spectrum_abs(1)/2;
freq = (0:(N/2))*Fs/N;       
figure;
semilogy(freq,DCLINK_voltage_spectrum_abs)% Plot the magnitude of the samples of CTFT of the audio signal
xlabel('Frequency (Hz)');
ylabel('Magnitude');



