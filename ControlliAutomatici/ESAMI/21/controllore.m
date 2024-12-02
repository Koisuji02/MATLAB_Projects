%% PARAMETRI
close all, clear all
s = tf('s');
F1 = 5/s; % tipo 1 a monte
F2 = (s+20)/((s+1)*(s+5)^2); % tipo 0 a valle
Kr = 1;
D1 = 0.5; % d1 = 0.5 tipo 0, su ramo diretto
D2 = 0.1; % d2 = 0.1t tipo 1, su uscita
%% SPECIFICHE STATICHE
h = 0;
KF1 = dcgain(F1*s);
KF2 = dcgain(F2);
Kc = 5; % specifica a)
% segno di Kc
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0 perchè stabile a sx da nyquist oppure perchè dal punto critico ho
% nic pari (nic = 2), quindi avevo già preso bene il segno
Kc = 5;
Ga = Kc/s^h*F1*F2;
%% SPECIFICHE DINAMICHE
wc_des = 1.74; % 0.58*wB
Mr_dB = 2.5;
mf_min = 47.5; %°
mG_min = 5;
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -183.5 = -184 -> mf_tot = 47.5+4+8 = 60°
%% RETI DERIVATIVE
% 2 reti da 30° ciascuna
md = 4;
wtaud = 0.97;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -122.5 -> 57 > 47.5° richiesti, quindi ok
% m2 = 9.4002
%% RETE INTEGRATIVA
mi = 9.4002;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on
% f3 = -126 -> 54 > 47.5° richiesti, quindi ok
% m3 = 1.0019 -> m3_dB = 0, crossover sperato a wc = 1.74 rad/s
W = feedback(Ga2,1/Kr);
figure, step(W), grid on
ts = 0.995; % 0.8 < ts < 1.2, quindi ok
sovra = 0.168; % 16.8%
figure, bode(W), grid on
wB = 3.41;
Mr_dB = 1.08; % < 2.5 quindi ok
%% SIMULINK
u_max = 8.51;
err_inseguimento_rampa = 0.05;
y_d1_uscita = 0;
y_d2_uscita = 0.005;
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB)
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % 49.7 > 47.5 quindi T va bene, T = 0.0921
C_z = c2d(Ci,T,'tustin')
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z,1/Kr);
figure, step(W_z), grid on
sovra_z = 0.17; % 17%
ts_z = 1.01;







