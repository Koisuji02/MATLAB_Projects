%% PARAMETRI
close all, clear all
s = tf('s');
Kr = 1;
D = 1.5; % d = 1.5 tipo 0, su ramo diretto
F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10)); % tipo 0 a monte
F2 = 1/s; % tipo 1 a valle
B = 1/s;
%% SPECIFICHE STATICHE
h = 1; % specifica b)
KF1 = dcgain(F1);
KF2 = dcgain(s*F2);
Kc = 6.25; % specifica b)
% segno di Kc
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0 stabile a sx oppure perchè nic pari dal punto critico (quindi
% avevo già messo segno giusto)
Kc = 6.25;
Ga = Kc/s^h*F1*F2;
%% SPECIFICHE DINAMICHE
wc_des = 2.32; % 0.58*wB
Mr_dB = 2.85;
mf_min = 45.75;
mG_min = 4.86;
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -191 -> mf_tot = 45.75+11+8 = 65°
% m1 = 2.2560
%% RETI DERIVATIVE
% 2 reti da 32.5 ciascuna
md = 4;
wtaud = 1.2;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -124 -> 56 > 45.75 richiesti quindi ok
% m2 = 5.0502
%% RETE INTEGRATIVA
mi = 5.0502;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on
% f3 = -125 -> 55 > 45.75 quindi ok
% m3 = 1.0005 -> m3_dB = 0, crossover dove voglio io (wc = 2.32)
W = feedback(Ga2, 1/Kr);
figure, step(W), grid on % per ts e sovra
sovra = 0.246; % < 0.25 quindi ok
ts = 0.636;
figure, bode(W), grid on % per wB e Mr_dB
wB = 4.38; % 3.6 < wB < 4.4 quindi ok
Mr_dB = 2.82;
%% SIMULINK
u_max = 1.112;
y_d_inf = 0.009;
err_gradino = 0.0003;
err_parabola = 0.15;
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB)
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % 50° > 45.75 quindi T va bene
C_z = c2d(Ci,T,'tustin')
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z,1/Kr);
figure, step(W), grid on % mi chiede solo ts e sovra
sovra = 0.246; % < 0.25 quindi ok
ts = 0.635;












