%% PARAMETRI
clear all, close all
s = tf('s');
Kr = 1;
D1 = 0.5; % d1 = D1 su ramo diretto prima di F2 (tipo 0)
D2 = 0.1; % d2 = d2*t su uscita (tipo 1)
F1 = 5/s;
F2 = (s+20)/((s+1)*(s+5)^2);
%% SEPCIFICHE STATICHE
KF1 = dcgain(F1*s);
KF2 = dcgain(F2);
Kc = 5; % modulo
h = 0; % no poli raggiunti
% segno di Kc
Ga1 = Kc/s^h*F1*F2;
KGa1 = dcgain(s*Ga1);
figure, bode(Ga1), grid on
figure, nyquist(Ga1), grid on
% vedo che Kc > 0 (stabile a sinistra, nel punto critico ho N pari)
Kc = 5;
%% SPECIFICHE DINAMICHE
ts = 1; delta_ts = 0.2; wB = 3/ts;
wc_des = 0.63*wB; % 1.89 rad/s
Mr_dB = 2.5; Mr = 1.33; % unità naturali
sovra = 0.2;
mf_min = 47.5; % gradi
mG_min = 5; % dB
% vediamo quanto margine totale devo recuperare
figure, bode(Ga1), grid on
[m1,f1] = bode(Ga1, wc_des)
% m1 = 4.35 unità naturali (12.77dB) e f1 = -188° -> mf_tot = 188-180= 8°+
% + 47.5° =55.5° -> 63° (+8°)
%% RETI DERIVATIVE
% devo recuperare 63°, quindi 2 reti da 31.5° ciascuna
md = 4;
wtaud = 1.2; % circa 31.5° ciascuna
taud = wtaud/wc_des
Rd = (1+s*taud)/(1+s*taud/md);
Cd = Kc/s^h*Rd^2; % 2 reti Rd
Ga2 = Ga1*Rd^2;
figure, bode(Ga2), grid on
[m2,f2] = bode(Ga2, wc_des)
% m2 = 9.7365 unità (19.77dB) da recuperare e fare arrivare a 0; f2 =
% -121°, quindi 180-121 = 59° > 47.5° richiesti, quindi ok
%% RETE INTEGRATIVA
% devo recuperare 19.77dB, quindi prendo mi = 9.7365 = 9.74 unità
mi = 9.74;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+s*taui/mi)/(1+s*taui);
Ci = Cd*Ri;
Ga3 = Ga2*Ri;
figure, bode(Ga3), grid on
[m3,f3] = bode(Ga3, wc_des) % vedo che a wc_des ho il crossover (0dB), quindi ok
figure, margin(Ga3), grid on % da qui vedo che crossover avviene a wc_des = 1.89 rad/s
% e ottengo margine di fase di 55.5°>47.5° richiesti, quindi ok
W = feedback(Ga3, 1/Kr);
%Wnorm = W/dcgain(W);
figure, step(W), grid on % da qui vedo sovra e ts
% sovra = 0.17 < 0.2 richiesti, quindi ok
% ts = 0.93 quindi compreso tra 0.8 e 1.2, quindi ok
figure, bode(W), grid on % da qui vedo Mr_dB e wB (-3dB)
% Mr_dB = 0.741 < 2.5 dB, quindi ok
% wB = 3.82 rad/s a -3dB
%% QUI ANDREBBE FATTO IL CONTROLLO CON SIMULINK
%% DISCRETIZZAZIONE
wB = 3.82;
T = 2*pi/(20*wB); % 0.0822
Gazoh = Ga3/(1+s*T/2); % per controllare T
figure, margin(Gazoh), grid on % vedo che mf = 51.1 > mf_min = 47.5°, quindi T va bene
C_z = c2d(Ci, T, 'tustin');
F_z = c2d(F1*F2, T, 'tustin');
W_z = feedback(C_z*F_z, 1/Kr);
figure, step(W_z), grid on % per sovra e ts
% sovra = 0.17 < 0.2 quindi ok
% ts = 0.905 compreso tra 0.8 e 1.2, quindi ok






