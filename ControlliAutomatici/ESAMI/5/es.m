%% PARAMETRI
clear all, close all
s = tf('s');
F = (10*(s+10))/(s^2+0.5*s+25);
KF = dcgain(F); % 4
% damp(F); % poli di F
D1 = 1;
D2 = 1;
Kr = 1; % retroazione unitariaù
%% SPECIFICHE STATICHE
h = 1; % 1 polo aggiunto per specifica errore
Kc = 2000; % per specifica errore (per la specifica su d2 ottengo solo 1000)
% segno di Kc?
Ga = Kc/s^h*F;
figure, bode(Ga), grid on % per fare nyquist a mano come controprova
figure, nyquist(Ga), grid on
% vedo che Kc > 0 perchè dal punto critico vedo N pari oppure perchè
% stabile a sinistra (nia = 0 -> se N = 0, nic = N + nia = 0, stabile)
Kc = 2000;
%% SPECIFICHE DINAMICHE
ts = 0.04;
delta_ts = 0.2; % 20%
% wB = 75;
wc_des = 38; % 0.63 * wB = 47.25, abbassata a 46
sovra = 0.35; % 35%
Mr = 1.5; % unità naturali
Mr_dB = 3.52; % dB
mf_min = 42.4; % °
mG_min = 4.592; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga,wc_des)
% 1° tentativo:
% m1 = 9.2599 (19.33 dB); f1 = -191° -> mf_tot=(-180+191)+mf_min = 53.7°
% devo quindi recuperare 54°+8° = 62°
% 2° tentativo:
% recupero 56 + 8 = 64°
%% RETI DERIVATIVE
% uso 2 reti da 31° ciascuna
md = 4;
wtaud = 1.2;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s); % ciascuna rete
Cd = Kc/s^h*Rd^2; % uso 2 reti quindi ^2
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1, wc_des)
% 1° tentativo:
% vedo che ottengo f2 = -129° -> mf = 180-129 = 51° > 42.4° richiesti
% quindi ok; ma al tempo stesso vedo che m2 = 17.43 (24.826 dB), devo
% quindi ridurre da 24.83 dB a 0 dB (crossover)
% 2° tentativo:
% vedo che ottengo f2 = -130 -> mf = 50° > 42.4; m2 = 18.4 (25.3 dB)
%% RETE ATTENUATRICE
% mi = 17.43; % preso dal modulo da recuperare in unità naturali
mi = 31;
wtaui = 400;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2, wc_des)
% vedo che f3 = -135 -> mf = 180-135 = 45° > 42.4° richiesti, quindi ok e
% ora ottengo m3 = 1.0067 (0.058 dB, quindi circa 0 dB) ovvero il crossover
% dove lo voglio io
figure, margin(Ga2), grid on % vedo che ho il crossover a 47.5 (dal mf)
W = feedback(Ga2, Kr);
figure, step(W), grid on % per ts e sovra
figure, bode(W), grid on % per wB e Mr_dB
% vedo che così ho soddisfatto le specifiche perchè:
% ts = 0.0336 -> 0.032 < ts < 0.048
% sovra = 34.9% < 35 % richiesto
% da bode vedo che:
wB = 64.7; % rad/s
Mr_dB_f = 4.9; % dB
%% PUNTO 1.2 beta e gamma con simulink, ma come si fanno?
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2); % per valutare T
figure, margin(Gazoh); grid on % vedo che mf = 45.1° > 42.4° richiesti, quindi T va bene
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F,T,'tustin');
W = feedback(C_z*F_z, Kr);
figure, step(W), grid on
% ts = 0.034, quindi 0.032 < ts < 0.048 quindi ok
% sovra = 34.9 < 35 quindi ok







