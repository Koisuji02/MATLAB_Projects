%% PARAMETRI
close all, clear all
s = tf('s');
N = 10;
F = (3*s+6)/(s^4+6.5*s^3+12*s^2+4.5*s); % ha 1 polo in s = 0, quindi no anello aperto
figure, margin(F), grid on
mG = 12.1; % finito, quindi posso usare anello chiuso
wmG = 1.59;
mf = 26.4; % < 40 quindi posso usare Z-N
wmf = 0.746;
%% QUINDI
figure, step(F), grid on
Kp_t = mG
T_t = 2*pi/wmG
Kp = 0.6*Kp_t
TD = 0.5*T_t
TI = 0.125*T_t
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(RPID*F,1); % retroazione negativa unitaria
figure, bode(W), grid on % ci chiede wB e Mr_dB
wB = 7.25;
Mr_dB = 19.1;