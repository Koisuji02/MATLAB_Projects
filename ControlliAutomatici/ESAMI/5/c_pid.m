%% PARAMETRI
close all, clear all
s = tf('s');
F = (4*s^2+1200*s+90000)/(s^3+154*s^2+5600*s+20000);
N = 10;
figure, step(F), grid on
% dato che risposta monotona, posso usare anello aperto
figure, margin(F), grid on
% non posso usare ZIegler-Nichols perchè mf = 88 > 40°, quindi uso
% COHEN-COON
% inoltre non posso usare anello chiuso perchè mG infinito
figure, step(F), grid on
theta_f = 0.015;
tau_f = 0.205;
K_f = 4.5;
% PID
% cohen-coon perchè mf = 88° > 40°
Kp = (16*tau_f+3*theta_f)/(12*K_f*theta_f);
TI = theta_f*(32*tau_f+6*theta_f)/(13*tau_f+8*theta_f);
TD = (4*tau_f*theta_f)/(11*tau_f+2*theta_f);
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(F*RPID,1);
figure, step(W), grid on
% ts = 0.03
% sovra = 32.5%