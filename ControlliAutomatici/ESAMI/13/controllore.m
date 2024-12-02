%% PARAMETRI
clear all, close all
s = tf('s');
F1 = 5/s; % tipo 1 a monte
F2 = (s+20)/((s+1)*(s+5)^2); % tipo 0 a valle
Kr = 1;
D1 = 0.5; % d1 = 0.5 costante [tipo 0]
D2 = 0.1; % d2 = 0.1t rampa [tipo 1]
%% SPECIFICHE STATICHE
KF1 = dcgain(s*F1);
KF2 = dcgain(F2);
h = 0;
Kc = 5; % per la 1^ specifica
% segno di Kc
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% vedo che Kc > 0 perchè nic pari dal punto critico e stabile a sx
Kc = 5;
Ga = Kc/s^h*F1*F2;
%% SPECIFICHE DINAMICHE
wc_des = 1.74; % 0.58*wB
Mr_dB = 2.5;
mf_min = 47.5; % °
mG_min = 5; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -183.5 -> mf_tot = 47.5 + 3.5 + 8 = 59°
% m1 = 5.1280 u_nat
%% RETI DERIVATIVE
% 2 reti da circa 30° ciascuna
md = 4;
wtaud = 0.95;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m1,f1] = bode(Ga1,wc_des)
% f1 = -123.7 -> 56° > 47.5° quindi ok
% m1 = 9.2351
%% RETE INTEGRATIVA
mi = 9.2351;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
% f3 = -126.3° -> 53° > 47.5° quindi ok
% m3 = 1.0019 -> m3_dB = 0, quindi crossover dove lo voglio io
figure, margin(Ga2), grid on % wc = 1.74 perfetto!
W = feedback(Ga2,1/Kr);
figure, step(W), grid on % per ts e sovra
ts = 0.99; % quindi ok, 0.8 < ts < 1.2
sovra = 0.174;
figure, bode(W), grid on % per wB e Mr_dB
wB = 3.4;
Mr_dB = 1.16; % quindi < 2.5 perfetto, a w = 1.16 rad/s
%% SIMULINK
u_max = 8.6626; % con r = gradino unitario
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % 49° > 47.5° quindi ok
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z, 1/Kr);
figure, step(W), grid on
ts_z = 0.994; % quindi ok con tustin
sovra_z = 17.4;






