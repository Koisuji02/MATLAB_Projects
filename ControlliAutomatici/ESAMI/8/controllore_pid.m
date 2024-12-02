%% PARAMETRI
close all, clear all
s = tf('s');
F = (4*s^2+1200*s+90000)/(s^3+154*s^2+5600*s+20000);
N = 10;
figure, margin(F), grid on % per trovare mG -> mG = inf, no anello chiuso
% mf = 88.4° > 40° -> no Ziegler Nichols
figure, step(F), grid on % per valutare stabilità -> stabile, risposta monotona, si anello aperto
% userò C-C (Cohen Coon)
theta_F = 0.018;
tau_F = 0.268-theta_F;
K_F = 4.5;
Kp = (16*tau_F+3*theta_F)/(12*K_F*theta_F);
TI = theta_F*(32*tau_F+6*theta_F)/(13*tau_F+8*theta_F);
TD = (4*tau_F*theta_F)/(11*tau_F+2*theta_F);
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(F*RPID, 1);
figure, step(W), grid on