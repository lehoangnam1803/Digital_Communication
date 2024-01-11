clear;clc
% 1. Load speech signal
[mSpeech,Fs] = audioread("MaleSpeech-16-4-mono-20secs.wav");
%sound(mSpeech,Fs)
% Consider the speech signal in 1.5s
t = 0:1/Fs:1.5;
plot(t,mSpeech(1:length(t)),'LineWidth',2);
xlim([0.52 0.59])
grid on
hold on

% 2. Quantize the sample signal
L = 16; %the number of quantization levels
V_p = 0.5625; %the peak voltage of signal
% Determine the single quantile interval ?-wide
q = sqrt(4.*(V_p.^2)/(L.^2)); % Use the exact equation

s_q_2 = quan_uni(mSpeech(1:length(t)),q); % Uniform quantization
% Plot the sample signal and the quantization signal
plot(t,s_q_2,'ro','MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor','r');

% 3. Calculate the average quantization noise power,...
% the average power of the sample signal and SNR
e_uni = mSpeech(1:length(t)) - s_q_2; % error between sample signal and quantized signal
pow_noise_uni = 0;
pow_sig = 0;
for i = 1:length(t)
    pow_noise_uni = pow_noise_uni + e_uni(i)^2;
    pow_sig = pow_sig + mSpeech(i)^2;
end