%% PARAMETRI
close all, clear all
s = tf('s');
F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10)); % a monte disturbo, tipo 0
F2 = 1/s; % a valle disturbo, tipo 1
KF1 = dcgain(F1);
KF2 = dcgain(s*F2);
Kr = 1; % retroazione 1/Kr = 1
d = 1.5; % ramo diretto, tipo 0 (costante)
%% SPECIFICHE STATICHE
Kc = 6.25; % per la specifica sulla parabola (b)
h = 1; % per la specifica sulla parabola (b)
% segno di Kc:
Ga = Kc/s^h*F1*F2;
figure, bode(Ga), grid on % per fare nyquist a mano come controprova
figure, nyquist(Ga), grid on
% vedo che N dal punto critico è pari oppure vedo che stabile a sinistra;
% quindi in entrambi casi verifico che Kc > 0
Kc = 6.25;
%% SPECIFICHE DINAMICHE
wB = 4; wB_min = 3.6; wB_max = 4.4; % rad/s
wc_des = 2; % prima 2.52, vado all'intero più vicino per comodità
sovra = 0.25;
Mr = 1.389;
Mr_dB = 2.85; % dB
mf_min = 45.75; % °
mG_min = 4.86; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga, wc_des)
% 1° tentativo:
% m1 = 1.9 (5.57dB); f1 = -191.8 = -192° -> mf_tot = 192-180+mf_min = 58°
% -> vedo che devo recuperare 58+8 = 64°
% 2° tentativo:
% m1 = 3.05; f1 = -188 -> mf_tot = 62° (8+8+45.75)
%% RETI DERIVATIVE
% 1° tentativo:
% prendo 2 reti da 32° ciascuna
% 2° tentativo:
% prendo 2 reti da 31° ciascuna
md = 4;
wtaud = 1.2;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti derivative, quindi ^2
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1, wc_des)
% 1° tentativo:
% ottengo f2 = -125° -> 55° > 45.75° richiesti, quindi ok; ma m2 = 4.2627
% (12.6dB); perciò devo attenuare di 12.6dB -> crossover (0dB)
% 2° tentativo:
% f2 = 59° > 45.75° richiesti; m2 = 6.8341 (16.7dB)
%% RETE INTEGRATIVA
% 1° tentativo: mi = 4.2627;
mi = 6.8341;
wtaui = 150;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2, wc_des)
% ottengo m3 = 1.0004 (0.00347dB), quindi crossover dove lo voglio io,
% mantenendo f3 = -126 -> mf = 54° > 45.75° richiesti, quindi ok
figure, margin(Ga2), grid on % vedo infatti crossover a 2.52 rad/s
W = feedback(Ga2, 1/Kr);
figure, step(W), grid on % per ts e sovra
% 2° tentativo: ottengo:
% ts = 0.736
% sovra = 24.4% < 25% richiesto, quindi ok
figure, bode(W), grid on % per wB e Mr_dB
% wB = 4.82 (-3dB) > 4.4 richiesto -> prendo wc_des più piccola e rifaccio
% 2° tentativo: ottengo:
% wB = 3.7 > 3.6 richiesto, quindi ok
% Mr_dB = 2.79dB a 1.11 rad/s
%% SPECIFICHE DA VEDERE ANCHE CON SIMULINK
%% DISCRETIZZAZIONE
wB = 3.7;
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2);
figure, margin(Gazoh), grid on % per valutare se diminuire T; vedo che mf = 51.4 > 45.75° richiesto
% quindi T va bene così
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(F_z*C_z, 1/Kr);
figure, step(W), grid on % per ts e sovra
% sovra = 24.4% < 25%, quindi ok
% ts = 0.745;







