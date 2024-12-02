%% PARAMETRI
close all, clear all
s = tf('s');
F1 = 2.5*(1+s)/(1+0.5*s)^2; % tipo 0 a valle di d1
F2 = 30*(1+0.1*s)/(s*(s+30)^2); % tipo 1 a monte di d1
Kr = 1;
D1 = 0.01; % tipo 0 costante
D2 = 0.2; % d2 = 0.2t tipo 1 rampa
%% SPECIFICHE STATICHE
KF1 = dcgain(F1);
KF2 = dcgain(s*F2);
h = 0;
Kc = 24.024;
% segno di Kc
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0 perchè N dal punto critico pari oppure stabile a sinistra
Kc = 24.024;
%% SPECIFICHE DINAMICHE
wc_des = 20.5; % 0.58*wB
Mr_dB = 2.85;
mf_min = 45.75; %°
mG_min = 4.86; %dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -175.96 -> mf_tot = -4+45.75 = 41.75 = 42 +8 = 50°
%% RETI DERIVATIVE
% 2 reti da 25° ciascuna
md = 3;
wtaud = 0.9;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2; % 2 reti
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -125 -> 55 > 50° richiesti, quindi ok
% m2 = 0.0497 (-26dB)
%% RETE INTEGRATIVA
mi = 0.0497;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on % vedo che crossover proprio dove voglio, 20.3
% f3 = -125 -> 55 > 50° richiesti, quindi ok
% m3 = 0.9993 -> 1, quindi crossover sperato
W = feedback(Ga2, 1/Kr);
figure, step(W), grid on % per ts e sovra
sovra = 0.176; % < 0.25 richiesto quindi ok
ts = 0.0833;
figure, bode(W), grid on % per wB e Mr_dB
wB = 38.4; % < 38.5 quindi ok
Mr_dB = 1.52; % a 10.8 rad/s
%% SIMULINK PER ERRORE A SINUSOIDE
errore_max_sinusoide = 0.00935;
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2);
figure, margin(Ga2), grid on
% 54.8 > 50° quindi ok T
C_z = c2d(Ci,T,'tustin')
F_z = c2d(F1*F2,T,'tustin');
W = feedback(C_z*F_z,1/Kr);
figure, step(W), grid on % ci chiede sovra
sovra = 17.9; % < 25% richiesto, quindi ok






