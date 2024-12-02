%% PARAMETRI
close all, clear all
s = tf('s');
F = 10*(s+10)/(s^2+0.5*s+25);
D1 = 1; % d1 = 1 tipo 0 ramo diretto
D2 = 1; % d2 = t tipo 1 uscita
Dp = 1; % d3 = sin(1000t)
wp = 1000;
Kr = 1;
%% SPECIFICHE STATICHE
h = 1; % 1^ specifica
KF = dcgain(F);
Kc = 2000; % 1^ specifica
Ga = Kc/s^h*F;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc > 0 perchè stabile a sx oppure perchè nic pari dal punto critico (nic
% = N + nia = 2+0 = 2), quindi ho scelto bene segno
Kc = 2000;
Ga = Kc/s^h*F;
%% SPECIFICHE DINAMICHE
wc_des = 39; % 0.58*wB
Mr_dB = 3.522;
mf_min = 42.5;
mG_min = 4.59;
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -192.3 -> mf_tot = 13.5+42.5+8 = 65°
% m1 = 10.9896
%% RETI DERIVATIVE
% 2 reti da 32.5° ciascuna
md = 4;
wtaud = 1.25;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -130.5 -> 49° > 42.5 richiesti quindi ok
% m2 = 20.6863
%% RETE INTEGRATIVA
mi = 32.2;
wtaui = 500;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on
% f3 = -136 -> 44 > 42.5 ° richiesti quindi ok
% m3 = 1.0112 -> wc = 43.9 quindi quasi quella richiesta, ok
W = feedback(Ga2,Kr);
figure, step(W), grid on % per ts e sovra
% sovra = 0.402; % > 0.35 quindi da rifare
sovra = 0.347; % < 0.35 richiesto quindi ok
ts = 0.0346; % 0.032 < ts < 0.048 quindi ok
figure, bode(W), grid on % per wB e Mr_dB
wB = 63.1;
Mr_dB = 4.86;
%% SIMULINK
err_max_inseguimento = 0.004235;
u_max = 1.23;
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB)
Gazoh = Ga2/(1+s*T/2);
figure, margin(Ga2), grid on % 50.9° > 42.5° richiesti quindi T va bene
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F,T,'tustin');
W = feedback(C_z*F_z,Kr);
figure, step(W), grid on % per ts e sovra richiesti
sovra_z = 34.7;
t_z = 0.0349;









