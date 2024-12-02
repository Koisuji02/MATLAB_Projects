%% PARAMETRI
clear all, close all
s = tf('s');
F = (3*s+6)/(s*(s^3+6.5*s^2+12*s+4.5));
N = 10;
figure, margin(F), grid on % mG = 12.1 dB a wG = 1.59 rad/s
% avendo margine di fase mf = 26° < 40° posso usare catena aperta senza
% imposizione di margine fase
mG = 12.1; Kp_t = mG;
wG = 1.59; T_t = 2*pi/1.59;
% definisco PID
Kp = 0.6*Kp_t;
TI = 0.5*T_t;
TD = 0.125*T_t;
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(F*RPID, 1);
figure, step(W), grid on % per ts e sovra
figure, bode(W), grid on % per wB e Mr_dB
% wB = 4.65 rad/s (a -3dB)
% Mr_dB = 7.72dB