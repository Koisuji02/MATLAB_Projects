%% PARAMETRI
close all, clear all
s = tf('s');
F1 = 30/(s+15);
F2 = (3*s+3)/(s^3+10*s^2+24*s);
KF1 = dcgain(F1)
KF2 = dcgain(s*F2)
D1 = 1; % d1 = D1 = 1 (tipo 0)
D2 = 4; % d2 = D2 = 4 (tipo 0)
Kr = 1; % retroazione
%% SPECIFICHE STATICHE
h = 0;
Kc = 40; % per la 1° specifica
% segno di Kc
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0
Kc = 40;
%% SPECIFICHE DINAMICHE
wc_des = 11.6;
Mr = 1.33; % unità naturali
Mr_dB = 2.5; % dB
mf_min = 47.5; % °
mG_min = 5; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga, wc_des)
% m1 = 1.19 (1.5 dB)
% f1 = -176 -> mf_tot = 43.5 + 8° = 51.5° = 52°
%% RETI DERIVATIVE
% 2 reti da 26
md = 3;
wtaud = 1;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1, wc_des)
% m2 = 2.14 (6.6dB)
% f2 = -123 -> 57° > 47.5°, quindi ok
%% RETE INTEGRATIVA
mi = 2.15;
wtaui = 75;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2, wc_des)
figure, margin(Ga2), grid on
% m3 = 0 dB (crossover sperato), con f3 > 47.5 quindi ok
W = feedback(Ga2, 1/Kr);
figure, step(W), grid on % per ts e sovra
figure, bode(W), grid on % per wB e Mr_dB
%% DISCRETIZZAZIONE
% da finire discretizzazione
wB = 20.2;
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2); % la usiamo per capire se T va bene
figure, margin(Gazoh), grid on % vedo che mf = 51>47.5 quindi ok, T va bene
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z, 1/Kr);
figure, step(W), grid on % per ts e sovra
ts = 0.179;
sovra = 0.0728;







