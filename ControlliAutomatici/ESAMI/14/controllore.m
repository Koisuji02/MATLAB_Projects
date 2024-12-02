%% PARAMETRI
clear all, close all
s = tf('s');
F1 = 30/(s+15); % tipo 0 a monte
F2 = (3*s+3)/(s^3+10*s^2+24*s); % tipo 1 a valle
Kr = 1;
D1 = 1; % tipo 0
D2 = 4; % tipo 0
%% SPECIFICHE STATICHE
KF1 = dcgain(F1);
KF2 = dcgain(s*F2);
h = 0; % no poli da aggiungere
Kc = 40;
% segno di Kc
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0 perchè stabile a sinistra oppure nic pari dal punto critico
Kc = 40;
Ga = Kc/s^h*F1*F2;
%% SPECIFICHE DINAMICHE
wc_des = 11.6; % rad/s
Mr_dB = 2.5; % dB
mf_min = 47.5;
mG_min = 5;
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -176 -> mf_tot = 47.5 - 4 + 8 = 51.5 = 52°
% m1 = 1.1891
%% RETI DERIVATIVE
% 2 reti da 26°
md = 3;
wtaud = 1;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure,bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -123 -> 57 > 47.5° richiesti quindi ok
% m2 = 2.1404
%% RETE INTEGRATIVA
mi = 2.1404;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on
% f3 = -123.6 -> 56 > 47.5° quindi ok
% m3 = 1.0001 -> m3_dB = 0, crossover sperato dove lo voglio io (da margin
% vedo che wc_des = 11.6)
W = feedback(Ga2,1/Kr);
figure, step(W), grid on % per ts e sovra
ts = 0.18;
sovra = 6.66; % < 20%
figure, bode(W), grid on % per wB e Mr_dB
wB = 20.2;
Mr_dB = 0.489; % 11.8 rad/s
%% SIMULINK
e_inseguimento = 0.0316;
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB)
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % mf = 51.6° > 47.5°, quindi ok
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z,1/Kr);
figure, step(W_z), grid on
sovra_z = 6.83; % < 20% qundi ok
ts_z = 0.178;







