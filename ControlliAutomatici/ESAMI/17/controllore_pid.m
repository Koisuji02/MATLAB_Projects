%% PARAMETRI
close all, clear all
s = tf('s');
N = 10;
F = (3*s+6)/(s^4+6.5*s^3+12*s^2+4.5*s);
figure, margin(F), grid on % per vedere se mG finito e applicare anello chiuso
% per vedere anche se mf < 40° per applicare Ziegler-Nichols
figure, step(F), grid on % per vedere se monotona e fare anello aperto
mG = 12.1; % posso fare anello chiuso
mf = 26.1; % posso fare Z-N
Kp_t = mG;
wmG = 1.59;
T_t = 2*pi/wmG;
Kp = 0.6*Kp_t
TI = 0.5*T_t
TD = 0.125*T_t
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(RPID*F,1);
figure, bode(W), grid on % perchè mi chiede wB e Mr_dB
Mr_dB = 7.72;
wB = 4.67;