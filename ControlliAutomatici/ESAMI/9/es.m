%% PARAMETRI
close all, clear all
s = tf('s');
Kr = 1;
F = 13.5*(s+4)*(s+10)/(s+3)^3; % a valle, tipo 0
KF = dcgain(F)
D1 = 1; % tipo 0, su ramo diretto
%% SPECIFICHE STATICHE+
h = 1; % per la 1^ specifica
Kc = 5;
% segno di Kc
Ga = Kc/s^h*F;
figure, bode(Ga), grid on % per nyquist a mano
figure, nyquist(Ga), grid on % per nyquist conferma a pc
% vedo che N dal punto critico è pari oppure stabile a sinistra, quindi Kc
% > 0
Kc = 5;
%% SPECIFICHE DINAMICHE
wc_des = 3.5;
mf_min = 50; % °
mG_min = 5.2; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% m1 = 11.0866
% f1 = -177 -> mf_tot = 50-3 = 47°+8 = 55°
%% RETI DERIVATIVE
% 2 reti da 27.5°
md = 3;
wtaud = 1.3;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2;
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -120 -> mf = 60 > 50° quindi ok
% m2 = 25.1083
%% RETE INTEGRATIVA
mi = 25.1083;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ga2 = Ga1*Ri;
Ci = Cd*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
figure, margin(Ga2), grid on % per wc
% f3 = -129 -> mf = 51 > 50° quindi ok
% crossover dove voglio io
W = feedback(Ga2, 1/Kr);
figure, step(W), grid on % per ts e sovra
figure, bode(W), grid on % per wB e Mr_dB
Mr_dB = 1.66; % < 2 quindi ok
wB = 5.87; % quindi ok
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB) % T iniziale
T = 0.01;
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % con questo T va bene, mf = 50° quindi ok
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F,T,'tustin');
W_z = feedback(C_z*F_z,1/Kr);
figure, step(W_z), grid on






