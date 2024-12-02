%% PARAMETRI
close all, clear all
s = tf('s');
F = 10*(s+10)/(s^2+0.5*s+25); % tipo 0 a valle di d1
D1 = 1; % d1 = 1 tipo 0, ramo diretto
D2 = 1; % d2 = t tipo 1, uscita
D3 = 1; % d3 = sin(1000t), su retroazione
w3 = 1000;
Kr = 1;
%% SPECIFICHE STATICHE
h = 1; % specifica a)
KF = dcgain(F);
Kc = 2000; % specifica a)
% segno di Kc
Ga = Kc/s^h*F;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0 perchè stabile a sx oppure nic pari dal punto critico (quindi
% avevo già preso bene il segno)
Kc = 2000;
Ga = Kc/s^h*F;
%% SPECIFICHE DINAMICHE
wc_des = 39; % 0.58*wB
Mr_dB = 3.522;
mf_min = 42.4;
mG_min = 4.59;
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -193.6 -> mf_tot = 42.4+13.6+8 = 64°
% m1 = 10.9896
%% RETI DERIVATIVE
% 2 reti da 32° ciascuna
md = 4;
wtaud = 1.25;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -127 -> 53° > 42.4 richiesti quindi ok
% m2 = 30.8924
%% RETE INTEGRATIVA
mi = 32.2171;
wtaui = 500;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on
% f3 = -135 -> 45° > 42.4 richiesti quindi ok
% m3 = 1.0133 -> m3_dB = 0.1 quindi crossover dove lo voglio, wc = 44)
W = feedback(Ga2,1);
figure, step(W), grid on % per ts e sovra
sovra = 0.347; % > 0.35 quindi da rifare
ts = 0.0344; % 0.032 < ts < 0.048 quindi ok
figure, bode(W), grid on % per wB e Mr_dB
Mr_dB = 4.86;
wB = 63.1;
%% SIMULINK
u_max_d3 = 0.96; % con d3
err_inseguimento_r = 0.008234; % con r sinusoidale
err_inseguimento_gradino = 0.000049;
y_d1_inf = 0.0000018;
y_d2_inf = 0.000124;
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB)
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % 45 > 42.4 quindi T va bene
C_z = c2d(Ci,T,'tustin')
F_z = c2d(F,T,'tustin');
W_z = feedback(C_z*F_z,1);
figure, step(W_z), grid on
sovra_z = 0.347;
ts_z = 0.0349;










