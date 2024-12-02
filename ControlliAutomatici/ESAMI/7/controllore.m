%% PARAMETRI
close all, clear all
s = tf('s');
D1 = 1;
D2 = 1;
F = 10*(s+10)/(s^2+0.5*s+25);
Kr = 1; % retroazione
KF = dcgain(F)
%% SPECIFICHE STATICHE
h = 1; % 1^ specifica
Kc = 2000; % 1^ specifica
% segno di Kc
Ga = Kc/s^h*F;
figure, bode(Ga), grid on % per nyquist a mano
figure, nyquist(Ga), grid on % verifica su matlab
% vedo che stabile a sinistra e N pari dal punto critico, quindi Kc > 0
Kc = 2000;
%% SPECIFICHE DINAMICHE
wc_des = 40; % 1° tentativo = 47.25
Mr = 1.5; Mr_dB = 3.52;
mf_min = 42.4; % °
mG_min = 4.6; % dB
figure, bode(Ga), grid on
[m1,f1] = bode(Ga, wc_des)
% f1=-191.3 -> mf_tot = 11.3+42.4 = 54 + 8 = 62°
% m1 = 9.26
% 2° tentativo: mf_tot = 65°
%% RETI DERIVATIVE
% 2 reti da 31° ciascuna
% 2° tentativo: 2 reti da 32.5° ciascuna
md = 4;
wtaud = 1.2;
taud = wtaud/wc_des
Rd = (1+taud*s)/(1+taud/md*s);
Cd = Kc/s^h*Rd^2; % 2 reti anticipatrici
Ga1 = Ga*Rd^2;
figure, bode(Ga1), grid on
[m2,f2] = bode(Ga1,wc_des)
% f2 = -124.4 -> 55° > 42.4°, quindi ok
% m2 = 20.72 unità (26.33dB) quindi 0dB (crossover)
% 2° tentativo: f2 -> 55 > 42.4° quindi ok; però m2 = 35.45
%% RETE INTEGRATIVA
% mi = 20.72;
mi = 28;
wtaui = 350;
taui = wtaui/wc_des
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga2 = Ga1*Ri;
figure, bode(Ga2), grid on
[m3,f3] = bode(Ga2,wc_des)
% m3 circa a 0 dB quindi ok, f3 -> 42.8 > 42.4° richiesti quindi ok
W = feedback(Ga2,Kr);
figure, step(W), grid on % per ts e sovra
% ts è troppo basso, e sovra è troppo alta -> wc_des  abbassa
% figure, bode(W), grid on % per wB e Mr_dB
figure, bode(W), grid on % per wB e Mr_dB
wB = 67.7;
%% SIMULINK?
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB);
Gazoh = Ga2/(1+s*T/2); % per valutare T
figure, margin(Gazoh), grid on % mf = 45.4 > 42.4°, quindi T ok
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F,T,'tustin');
W_z = feedback(C_z*F_z,Kr);
figure, step(W_z), grid on % per ts e sovra
% ts = 0.0325 > 0.032 richiesto
% sovra = 34.8 < 35% richiesto





