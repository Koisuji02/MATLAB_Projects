%% PARAMETRI
close all, clear all
s = tf('s');
Gp = -0.65/(s^3+4*s^2+1.75*s); % tipo 1 a valle di d1
Tp = 1;
A = 9;
D1 = 5.5*10^(-3); % d1 = A1, tipo 0
D2 = 5.5*10^(-3); % d2 = A2t, tipo 1
Dp = 10^(-3); % dp = Ap*sin(30t), sinusoidale
wp = 30;
%% SPECIFICHE STATICHE
KGp = dcgain(Gp*s);
KA = A;
h = 0;
Kc = 1.496;
Ga = Kc/s^h*Gp*A;
% segno di Kc
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc < 0 perchè stabile a dx oppure nic dispari dal p.c, quindi cambio
% segno
Kc = -1.496;
Ga = Kc/s^h*Gp*A;
%% SPECIFICHE DINAMICHE
wc_des = 1.74; % 0.58*wB
Mr_dB = 3.194;
mf_min = 44;
mG_min = 4.7224;
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -190.4 -> mftot = 44+11+8 = 63°
%% RETI DERIVATIVE
% 2 reti da 31.5° ciascuna
md = 4;
wtaud = 1;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -129 -> 51 > 44° quindi ok
% m2 = 1.3379
%% RETE ATTENUATRICE
mi = 1.3379;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on
% f3 = -129 -> 51 > 44° quindi ok
% m3 = 1.0000 -> m3_dB = 0,crossover dove lo voglio io (wc = 1.74)
W = feedback(Ga2,Tp);
figure, step(W), grid on
ts = 0.965; % < 1 quindi ok
sovra = 0.201; % < 0.30 quindi ok
figure, bode(W), grid on
Mr_dB = 1.93;
wB = 3.10;
%% SIMULINK
u_max_dp = 0.0154;
err_inseguimento_rampa = 0.2005;
err_d1 = 0.0004;
err_d2 = 0.0011;
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB)
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % 46.4 > 44 quindi T va bene, T = 0.1013
C_z = c2d(Ci,T,'tustin')
F_z = c2d(Gp*A,T,'tustin');
W_z = feedback(C_z*F_z,Tp);
figure, step(W_z), grid on
sovra_z = 0.202;
ts_z = 0.912;










