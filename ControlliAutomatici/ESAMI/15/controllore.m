%% PARAMETRI
close all, clear all
s = tf('s');
F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10)); % tipo 0, a monte
F2 = 1/s; % tipo 1 a valle
Kr = 1;
D = 1.5; % tipo 0 disturbo su ramo diretto
%% SPECIFICHE STATICHE
KF1 = dcgain(F1);
KF2 = dcgain(s*F2);
h = 1; % per specifica b)
Kc = 6.25; % per specifica b)
% segno di Kc
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0 perchè nia = 0, quindi nic = 0 solo se N = 0 e lo si ha solo a sx,
% oppure perchè nic dal punto critico -> nic = nia + N = 0+2 = 2 pari,
% quindi avevo già il segno giusto
Kc = 6.25;
Ga = Kc/s^h*F1*F2;
%% SPECIFICHE DINAMICHE
wc_des = 2.32; % 0.58 * wB
Mr_dB = 2.85;
mf_min = 45.75; % °
mG_min = 4.86; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -190 -> mf_tot = 45.75 + 10 + 8 = 64°
% m1 = 2.2560
%% RETI DERIVATIVE
% 2 reti da 32° ciascuna
md = 4;
wtaud = 1.2;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -123.6 -> 56° > 45.75°, quindi ok
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
% f3 = -125.2 -> 54° > 45.75, quindi ancora ok
% m3 = 1.0005 -> m3_dB = 0, crossover dove voglio io (da margin vedo che wc
% = 2.32 rad/s)
W = feedback(Ga2,1/Kr);
figure, step(W), grid on % per ts e sovra
sovra = 0.246; % < 0.25 richiesto quindi ok
ts = 0.636;
figure, bode(W), grid on % per wB e Mr_dB
wB = 4.38; % 3.6 < wB < 4.4 quindi ok
Mr_dB = 2.82; % a 1.37 rad/s
%% SIMULINK
u_max = 1.48; % quando r = 1
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB)
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % 50.1° > 45.75 quindi ok T
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z,1/Kr);
figure, step(W), grid on
sovra_z = 0.246; % <0.25 quindi ok
ts_z = 0.636;




