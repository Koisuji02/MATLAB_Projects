%% PARAMETRI
close all, clear all
s = tf('s');
Gp = -0.65/(s^3+4*s^2+1.75*s); % tipo 1 a valle di d1
Tp = 1; % retroazione
A = 9;
D1 = 5.5*10^-3;
D2 = 5.5*10^-3;
Dp = 10^-3;
wp = 30; % rad/s
%% SPECIFICHE STATICHE
KGp = dcgain(s*Gp);
h = 0;
Kc = 1.496; % da 1^ specifica
% segno di Kc
Ga = Kc/s^h*A*Gp;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% Kc < 0 perchè stabile a destra oppure perchè nic dal punto critico
% dispari
Kc = -1.496;
Ga = Kc/s^h*A*Gp;
%% SPECIFICHE DINAMICHE
wc_des = 1.74; % wB*0.58
Mr_dB = 3.194; % dB
mf_min = 44; % °
mG_min = 4.7224; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% f1 = -190 -> mf_tot = 44 + 10 + 8 = 62°
%% RETI DERIVATIVE
% 2 reti da 31
md = 4;
wtaud = 1;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2;
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -128 -> 52° > 44 richiesti quindi ok
% m2 = 1.3379
%% RETE INTEGRATIVA
mi = 1.3379;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
% f3 = -129 -> 51 > 44° quindi ok
% m3 = 1 -> m3_dB = 0 qunidi crossover sperato
figure, margin(Ga2), grid on % wc = 1.74 = wc_des
W = feedback(Ga2,Tp);
figure, step(W), grid on % per ts e sovra
ts = 0.957; % < 1 quindi ok
sovra = 0.201; % < 0.3 quindi ok
figure, bode(W), grid on % per wB e Mr_dB
wB = 3.11;
Mr_dB = 1.93;
%% SIMULINK
u_max = 1.67;
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on
% mf = 46 > 44° quindi, T ok
C_z = c2d(Ci,T,'tustin');
F_z = c2d(A*Gp,T,'tustin');
W_z = feedback(C_z*F_z,Tp);
figure, step(W), grid on % per ts e sovra
sovra_z = 0.201;
ts_z = 0.957;





