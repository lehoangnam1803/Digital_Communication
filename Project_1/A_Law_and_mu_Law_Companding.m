%% 1. Load speech signal
clear;clc
% 
[mSpeech,Fs] = audioread("MaleSpeech-16-4-mono-20secs.wav");
%sound(mSpeech,Fs)
% Consider the speech signal in 1.5s
t = 0:1/Fs:1.5;
x = mSpeech(1:length(t));

%% 2. Quantize the sample signal
L = 16; %the number of quantization levels
V_p = 0.5625; %the peak voltage of signal
% Determine the single quantile interval ?-wide
q = sqrt(4.*(V_p.^2)/(L.^2)); % Use the exact equation

s_q_2 = quan_uni(x,q); % Uniform quantization

%% 3. Calculate the average quantization noise power,...
% the average power of the sample signal and SNR
e_uni = x - s_q_2; % error between sample signal and quantized signal
pow_noise_uni = 0;
pow_sig = 0;
for i = 1:length(t)
    pow_noise_uni = pow_noise_uni + e_uni(i)^2;
    pow_sig = pow_sig + mSpeech(i)^2;
end

SNR_a_uni = pow_sig/pow_noise_uni;

%% 5. Compress the sample signal %mSpeech’
mu = 255; % or 
A = 87.6; %use the standard value
y_max = V_p;
x_max = V_p;
% Replace the compress equation for u-law and A-law
% with x is the 'mSpeech' signal
s_c_5 = sign(x).*y_max.*(log(1+mu.*abs(x)/x_max))./(log(1+mu));

%% A law
y = zeros(length(t),1);
for i=1:length(t)
    r = abs(x(i))/x_max;
    if r<= 1/A
        y(i) = sign(x(i)).*y_max.*(A.*r)./(1+log(A));
    else
        y(i) = sign(x(i)).*y_max.*(1+ log(A.*r))./(1+log(A));
    end
end

%% 6. Quantize the compress signal
%s_q_6 = quan_uni(s_c_5,q);
s_q_6 = quan_uni(y,q);

%% 7. Expand
s_e_7 = sign(s_q_6).*(-1 + (1+mu).^(abs(s_q_6)))./(mu); % muy-Law
s_e_7_A = zeros(length(t),1); % A-Law
exp = 2.718281828;
for i=1:length(t)
    r_A = abs(y(i))*(1+log(A));
    if r_A<1
        s_e_7_A(i) = sign(y(i))*r_A./A;
    else
        s_e_7_A(i) = sign(y(i))*exp.^(r_A-1)./A;
    end
end

%% 9. Calculate the average quantization noise power,...
% the average power of the analog signal and SNR
e_com = x - s_e_7_A;
pow_noise_com = 0;
for i=1:length(t)
    pow_noise_com = pow_noise_com + e_com(i).^2;
end
SNR_a_com = pow_sig/pow_noise_com;

%% Plot
plot(t, x,'LineWidth',2);
xlim([0.52 0.59])
grid on
hold on

% Plot the sample signal and the quantization signal
plot(t,s_q_2,'ro','MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor','r');

% Plot the compress signal;
plot(t,s_c_5, '-.');

% plot the quantized signal
plot(t,s_q_6,'b^','MarkerSize',6,'MarkerEdgeColor','b','MarkerFaceColor','b');

% Plot expansion
plot(t,s_e_7_A,'g*','MarkerSize',6,'MarkerEdgeColor','g','MarkerFaceColor','g');
legend('Sample signal','Quantitize signal', 'Compress signal', 'Quantize the compress', 'Expansion')
%plot(t,s_e_7,'g*','MarkerSize',6,'MarkerEdgeColor','g','MarkerFaceColor','g');
%legend('Sample signal','Quantitize signal', 'Compress signal', 'Quantize the compress', 'Expansion')