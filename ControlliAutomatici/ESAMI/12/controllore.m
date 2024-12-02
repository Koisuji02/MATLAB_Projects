%% PARAMETRI
close all, clear all
s = tf('s');
F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10));
F2 = 1/s;
Kr = 1;
D = 1.5;
%% SPECIFICHE STATICHE
h = 1; % per la 2^ specifica
KF1 = dcgain(F1);
KF2 = dcgain(s*F2);
Kc = 30; % per la 3^ specifica
% segno di Kc
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% vedo che Kc>0 perchè N pari dal punto critico oppure stabile a sx
Kc = 30;
%% SPECIFICHE DINAMICHE
wc_des = 2; % 0.58*wB
Mr_dB = 2.85; % Mr unità naturali 1.388889
mf_min = 45.75; % °
mG_min = 4.86; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% vedo che f1 = -188.5° -> mf_tot = 8.5 + 45.75 +8 = 62° da recuperare
% m1 = 10.8290
%% RETI DERIVATIVE
% 2 reti da 31°
md = 4;
wtaud = 1.25;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2;
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -123.6 -> 56° > 45.75° richiesti quindi ok
% m2 = 30.1 -> dobbiamo arrivare a 0 dB crossover
%% RETE INTEGRATIVA
mi = 31.5;
wtaui = 400;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on
% f3 = -132.4 -> 47.8 > 45.75° richiesti quindi ok
% m3 = 0.1dB = 0 dB crossover dove lo voglio io
W = feedback(Ga2,1/Kr);
figure, step(W), grid on % per ts e sovra
% sovra = 33% > 25% richiesto quindi da rifare
ts = 0.674;
sovra = 24.5;
figure, bode(W), grid on % per wB e Mr_dB
wB = 4.36; % 3.6 < wB < 4.4 quindi ok
Mr_dB = 2.84; % a 1.09 rad/s
%% SIMULINK PER GAMMA -> comando applicato massimo con r(t) = 1
u = 0.988;
%% DISCRETIZZARE
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on
% 51.6° > 45.75° quindi T va bene
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z,1/Kr);
figure, step(W), grid on
ts = 0.667;
sovra = 24.5;






