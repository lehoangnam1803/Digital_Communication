%% Configuration
clear;clc
syms f
T = 1e-4;
fc = 1e6;
fmin = 0.95*1e+6;
fmax = 1.05*1e+6;

%% Power Spectral Density function
y = sinc((f-fc)*pi*T);
h = T*y.^2;

%% Find half power bandwidth
peak_power = limit(h,f,1e6);
half_power = peak_power/2;
eqn_half = h == half_power;
x_low = vpasolve(eqn_half,f,[fmin fc]);
x_high = vpasolve(eqn_half,f,[fc fmax]);
BW_half_power = x_high - x_low;

%% Find rectangular bandwidth
gf = matlabFunction(h);
Total_power = integral(gf,fmin,fmax);
BW_rectangular = Total_power/double(peak_power);

%% Find null2null bandwidth
fs = 1/T;
BW_null2null = 2*fs;

%% Find fraction power containment bandwidth
Half_total_power = integral(gf,fc,fmax);
Limit_bandwidth = Half_total_power*0.995;
for fi=fmax:-fs/1000:fc
    power = integral(gf,fc,fi);
    e = power - Limit_bandwidth;
    if e < 1e-5
        break;
    end
end
BW_containment = 2.*(fi-1e6);

%% Bounded power spectral density
bounded_power = peak_power/100000; % attenuation 50dB
eqn_bounded = h == bounded_power;
x_low_bound = vpasolve(eqn_bounded,f,[fmin fc-3*fs]);
x_high_bound = vpasolve(eqn_bounded,f,[fc+3*fs fmax]);
BW_bounded = x_high_bound - x_low_bound;

%% Plot
fplot(h, [fmin fmax]);
ylim([0 1e-4]);
xlabel('Frequency (Hz)')
grid on
