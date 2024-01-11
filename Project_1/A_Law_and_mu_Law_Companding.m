%% 1. Load speech signal
clear;clc
% 
[mSpeech,Fs] = audioread("MaleSpeech-16-4-mono-20secs.wav");
%sound(mSpeech,Fs)
% Consider the speech signal in 1.5s
t = 0:1/Fs:1.5;
x = mSpeech(1:length(t));
plot(t, x,'LineWidth',2);
xlim([0.52 0.59])
grid on
hold on

%% 2. Quantize the sample signal
L = 16; %the number of quantization levels
V_p = 0.5625; %the peak voltage of signal
% Determine the single quantile interval ?-wide
q = sqrt(4.*(V_p.^2)/(L.^2)); % Use the exact equation

s_q_2 = quan_uni(x,q); % Uniform quantization
% Plot the sample signal and the quantization signal
plot(t,s_q_2,'ro','MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor','r');


%% 3. Calculate the average quantization noise power,...
% the average power of the sample signal and SNR
e_uni = x - s_q_2; % error between sample signal and quantized signal
pow_noise_uni = 0;
pow_sig = 0;
for i = 1:length(t)
    pow_noise_uni = pow_noise_uni + e_uni(i)^2;
    pow_sig = pow_sig + mSpeech(i)^2;
end

%% 5. Compress the sample signal %mSpeech’
mu = 255; % or A = ???; use the standard value
y_max = V_p;
x_max = V_p;
% Replace the compress equation for u-law and A-law
% with x is the 'mSpeech' signal
s_c_5 = sign(x).*y_max.*(log(1+mu.*abs(x)/x_max))./(log(1+mu));
% Plot the compress signal;
plot(t,s_c_5);

%% 6. Quantize the compress signal and plot the quantized signal
s_q_6 = quan_uni(s_c_5,q);
plot(t,s_q_6,'b^','MarkerSize',6,'MarkerEdgeColor','b','MarkerFaceColor','b');

%% 7. Expand
s_e_7 = sign(s_q_6).*(-1 + (1+mu).^(abs(s_q_6)))./(mu);
plot(t,s_e_7,'g*','MarkerSize',6,'MarkerEdgeColor','g','MarkerFaceColor','g');

%% 9. Calculate the average quantization noise power,...
% the average power of the analog signal and SNR
e_com = x - s_e_7;
legend('Sample signal','Quantitize signal', 'Compress signal', 'Quantize the compress', 'Expansion')