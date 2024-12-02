%% PARAMETRI
clear all, close all
s = tf('s');
Kr = 1;
F1 = (1+(s/0.1))/((1+(s/0.2))*(1+(s/10)));
F2 = 1/s;
d = 1.5;
Ga = F1*F2;
%% SPECIFICHE STATICHE
h = 1; % numero poli, a causa della seconda specifica
KF1 = dcgain(F1);
Kf2 = 1; % fatto a mano a causa del polo
Kc = 6.25; % guadagno influenzato solo dalla seconda specifica
% segno di Kc
bode(Kc/s^h*Ga), grid on
nyquist(Kc/s^h*Ga); % confermato che segno di Kc > 0 anche su carta perchè
% ho che n_ic = n_ia+N deve essere 0, e avendo n_ia = 0, anche N deve
% essere 0, perciò vedo che è stabile a sinistra, quindi Kc > 0
Kc = 6.25;
%% SPECIFICHE DINAMICHE
wB = 4;
delta_wB = 0.4;
wc_des = 2.05; % prima avevo preso wc_des = 0.63*wB = 2.52, troppo alta per poi wB al fondo
sovra = 0.25;
Mr_dB = 2.85;
mf_min = 46; % gradi
mG_min = 4.86; % dB
Ga1 = Kc/s^h*Ga;
figure, bode(Ga1), grid on
[m1,f1] = bode(Ga1, wc_des)
% 1° tentativo: devo recuperare (-180-f1) + mf_min = 12° + 46° = 58° -> 66°
% 2° tentativo (con wc_des = 2): devo recuperare 9°+46° = 55° -> 63°
%% RETI DERIVATIVE
% 1° tentativo: dovendo recuperare circa 66°, prendo 2 reti derivative da 33° ciascuna
% 2° tentativo: dovendo recuperare circa 63°, prendo 2 reti derivative da 31.5° ciascuna
md = 4;
wtaud = 1.2; % prima avevo preso 1.2
taud = wtaud/wc_des;
Rd = (1+taud*s)/(1+taud/md*s); % singola rete derivativa
Cd = Kc/s^h*Rd^2; % controllore completo (doppia rete derivativa)
Ga2 = Cd*F1*F2;
[m2,f2] = bode(Ga2, wc_des)
% 1° tentativo:
% vedo da qui che alla mia wc_des = 2.52 ho un modulo di 4.2627 unità naturali
% (in dB: 20log_10(4.2627)=12.6dB) e una fase di -124.8° (quindi 180°-
% 124.8° = 55.2° > 46° = mf_min quindi ok), ma purtroppo qui il problema è 
% il modulo (12.6dB dovrebbe essere 0dB); inserisco quindi una rete attenuatrice
% per ridurre il modulo
% 2° tentativo: m2 = 6.5 (m2_dB = 16dB); f2 = -121° (quindi 180-121 =
% 59° > 46° richiesti quindi ok); va abbassato il modulo da 16 a 0dB (crossover)
%% RETE INTEGRATIVA
% 1° tentativo:
% dovendo recuperare un modulo di 12.6dB prendo una rete di mi = 54.5 (potrei
% anche prendere mi = modulo da recuperare in unità naturali = 4.2627, ma a
% questo punto prendo direttamente la curva con mi = 4.5 per abbondare)
% 2° tentativo: mi = 6.5 (perchè m2 = 6.5)
mi = 6.5; % prima avevo preso 4.5
wtaui = 150; % lo prendo alto per evitare di perdere la fase che ho guadagnato
% con la rete derivativa, ma non altissimo per evitare di ?
taui = wtaui/wc_des;
Ri = (1+taui/mi*s)/(1+taui*s);
Ci = Cd*Ri;
Ga3 = Ga2*Ri;
figure, bode(Ga3), grid on
[m3,f3] = bode(Ga3, wc_des) % da qui vedo che con questa rete ottengo il crossover
% alla wc_des da me sperata e ottengo un margine di fase di circa 56° > 46
% = mf_min (quindi non perdo altra fase inserendo Ri perchè wtaui alto) e
% finalmente ottengo = 0dB (crossover) nell'intorno di wc_des (w = 2.05 rad/s)
figure, margin(Ga3), grid on % a conferma vedo anche da qua i margini e la
%wc (crossover) effettiva (e non quella da me ipotizzata)
W = feedback(Ci*F1*F2, 1/Kr);
Wnorm = W/dcgain(W);
figure, step(Wnorm), grid on % per ts e sovraelongazione
% vedo che:
% 1° tentativo: sovra = 0.27 > 0.25 richiesti; 2° tentativo: sovra = 0.24 < 0.25, ok
% 1° tentativo: ts = 0.6 s; 2° tentativo: ts = 0.72s
figure, bode(Wnorm), grid on % per wB e Mr_dB
% vedo che:
% 1° tentativo: Mr_dB = 3.23dB; 2° tentativo: Mr_dB = 2.78dB
% 1° tentativo: wB = 4.55 rad/s > 4.4 richiesti massimi -> perciò devo revisionare
% il progetto ed abbassare wc_des (wc_des = 2.05)
% 2° tentativo: wB = 3.78 > 3.6 minimo, quindi ok
%% CONDIZIONI SODDISFATTE !!! (2 tentativi)
%% DISCRETIZZAZIONE
wB = 3.78;
T = 2*pi/(20*wB);
Gazoh = Ga3/(1+s*T/2); % per valutare T (se margine minore di margine di fase
% richiesto, devo diminuire T, fino a che non va bene)
figure, margin(Gazoh), grid on % vedo che mf = 51.2° > 46 = mf_min, quindi T ok!
C_z = c2d(Ci,T,'tustin');
F_z = c2d(F1*F2,T,'tustin');
W_z = feedback(C_z*F_z, 1/Kr);
figure, step(W_z), grid on
% vedo che ts = 0.748 quindi ok, e sovra = 0.24 < 0.25 quindi ok

