%% PARAMETRI
clear all, close all
s = tf('s');
Kr = 1;
F = 0.5*(1+5/9*s+s^2/9)/((1+0.25*s)^2*(1+s/15)^2);
D1 = 0.4; % d1 = D1 t (tipo 1)
D2 = 0.2; % d2 = D2 (tipo 0)
%% SPECIFICHE STATICHE
h = 1; % 1^ specifica
KF = dcgain(F);
Kc = 100; % 1^ specifica
% segno di Kc
Ga = Kc/s^h*F;
figure, bode(Ga), grid on % a mano
figure, nyquist(Ga), grid on % conferma
% da qui vedo che Kc > 0 perchè N pari dal punto critico e stabile a
% sinistra
Kc = 100;
%% SPECIFICHE DINAMICHE
wc_des = 17.4;
mf_min = 47.5;
mG_min = 5;
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -179.1 -> mf_tot = 47.5-1+8 = 55°
% m1 = 2.0933
%% RETI DERIVATIVE
% 2 reti da 27.5 ciascuna
md = 3;
wtaud = 1.3;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2;
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -121.07 -> 59° > 47.5° richiesti, quindi ok
% m2 = 4.7407
%% RETE INTEGRATIVA
mi = 4.7407;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2, wc_des)
figure, margin(Ga2), grid on
% vedo che crossover dove voglio io (17.4 rad/s) e comunque 56° > 47.5
% richiesti
W = feedback(Ga2, 1/Kr);
figure, step(W), grid on % per ts e sovra
figure, bode(W), grid on % per wB e Mr_dB
Mr_dB = 0.554; % < 2.5 quindi ok
wB = 31.5; % compresa tra 27 e 33 quindi ok
u_max = 2.3745; % con r = gradino
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % vedo che 52.7 > 47.5 richiesto quindi ok
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F,T,'tustin');
W_z = feedback(C_z*F_z,1/Kr);
figure, step(W), grid on % per ts e sovra
sovra = 0.0759; % 7.59%
ts = 0.12;






