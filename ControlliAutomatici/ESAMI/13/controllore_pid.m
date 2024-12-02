%% PARAMETRI
clear all, close all
s = tf('s');
F = (3*s+6)/(s^4+6.5*s^3+12*s^2+4.5*s);
N = 10; % dai dati
figure, margin(F), grid on % vedo che mf = 26.4° < 40° posso usare Z-N
% vedo anche che mG = 12.1, non infinito, quindi posso usare anello chiuso
%% quindi uso anello chiuso Z-N
Kp_t = 12.1; % dB, dal margin mG
T_t = 2*pi/1.59; % wmG dal margin
Kp = 0.6*Kp_t;
TI = 0.5*T_t;
TD = 0.125*T_t;
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(RPID*F,1); % dai dati retroazione unitaria
figure, bode(W), grid on % perchè ci chiede wB e Mr_dB
Mr_dB = 7.72;
wB = 4.67; % a -3 dB