%% PARAMETRI
close all, clear all
s = tf('s');
Kr = 1;
F1 = 5/s;
F2 = (s+20)/((s+1)*(s+5)^2);
D1 = 0.5; % d1 = 0.5
D2 = 0.1; % d2 = 0.1t
%% SPECIFICHE STATICHE
KF1 = dcgain(s*F1);
KF2 = dcgain(F2);
h = 0;
Kc = 5; % per la 1^ specifica
Ga = Kc/s^h*F1*F2;
% segno di Kc
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0 stabile a sx oppure nic pari dal punto critico
Kc = 5;
Ga = Kc/s^h*F1*F2;
%% SPECIFICHE DINAMICHE
wc_des = 1.74; % 0.58*wB
Mr_dB = 2.5;
mf_min = 47.5;
mG_min = 5;
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -183.5 -> mftot = 47.5 + 3.5 + 8 = 59°
%% RETI DERIVATIVE
% 2 reti da 29.5°
md = 4;
wtaud = 0.95;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -123 -> 56 > 47.5°
% m2 = 9.2351
%% RETE INTEGRATIVA
mi = 9.2351;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
% f3 = -126.4 -> 53° > 47.5 quindi ok
% m3 = 1.0019 -> m3_dB = 0 dove lo voglio io
figure, margin(Ga2), grid on % wc = 1.74 quindi dove lo voglio io
W = feedback(Ga2,1/Kr);
figure, step(W), grid on % per ts e sovra
sovra = 0.174;
ts = 0.988; % 0.8<ts<1.2 quindi ok
figure, bode(W), grid on % per wB e Mr_dB
wB = 3.4; % rad/s
Mr_dB = 1.16; % a 1.16 rad/s
%% SIMULINK
u_max = 8.66; % con gradino unitario
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB)
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % 49.1 ° > 44, quindi T ok
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z,1/Kr);
figure, step(W_z), grid on % solo ts e sovra mi chiede
sovra_z = 0.176;
ts_z = 1.02;









