%% DEFINIZIONE DEI PARAMETRI
s = tf('s');
A = 9;
Kr = 1;
Gp = -0.65/(s*(s^2+4*s+1.75));
A1 = 5.5*10^-3;
A2 = A1;
%% SPECIFICHE STATICHE (CALCOLI SU FOGLI)
Kc = 1.5;
h = 0;
Ga1 = Kc/s^h*A*Gp;
% USO NYQUIST DI Ga1 PER CAPIRE IL SEGNO DI Kc
nyquist(Ga1) %Kc < 0 -> perchè stabile a destra oppure N dispari dal punto critico
figure, bode(Ga1), grid on % per farmi il nyquist a mano e verificare
pole(Gp); % per n_ia
Kc = -1.5;
%% SPECIFICHE DINAMICHE (CALCOLI CON FORMULE SU FOGLI)
wB = 3; % ricavato da ts*wB = 3 con ts richiesto = 1
wc_des = 1.9; % ricavato da wc_des = wB * 0.63
Mr = 1.44; % unità naturali; ricavato dalla sovraelongazione con 1+s=0.9*Mr e s richiesta <= 30% (0.3)
Mr_dB = 3.167; % dB -> 20log_10(Mr)
mf_min = 44; % gradi; ottenuto da mf_min°=60°-5*(Mr_dB)
% qui non richiesto, ma mG ricavabile sempre con le formule da Mr_dB
bode(Ga1),grid on
[m1,f1] = bode(Ga1, wc_des) % m1 si aggiunge al margine minimo per dire quanto è il margine da recuperare totale
%% RETE ANTICIPATRICE PER RECUPERO DI FASE RICHIESTO
% rete anticipatrice (x2) con margine totale da recuperare = mf_min - m1 = 60° -> (+5°) 65°
md = 4;
wtaud = 1.1;
taud = wtaud/wc_des;
Rd = (1+taud*s)/(1+(taud/md)*s);
Ga2 = Ga1*Rd^2; % 2 reti derivative
figure, margin(Ga2) % per trovare il nuovo margine di fase
% [m2,f2] = bode(Ga2,wc_des); questo per vedere guadagno e fase alla mia wc_des, che vedo quindi andare circa bene
% vedo attraversare il crossover a wc = 2.2 (quindi accettabile) e trovo
% che la fase vale 180-131 = 49° quindi > 44° richiesto... tutto ok
C = Kc*Rd^2; % controllore finale con aggiunta delle reti
%% VERIFICARE LE SPECIFICHE IN CATENA CHIUSA
% per valutare tempo di salita e sovraelongazione
W = feedback(C*A*Gp, Kr); % sistema in catena chiusa
Wnorm = W/dcgain(W); % importante usare Wnorm e non altro
figure, step(Wnorm) % dallo step di Wnorm valuto la sovraelongazione e il ts richiesti vedendo che
% s = 24% < 30% quindi ok; ts = 0.75 < 1s quindi ok
figure, bode(Wnorm)
wB = 4.1; % vedo dal grafico che il bode di Wnorm tocca -3db in wB = 4.1 rad/s
Mr_dB = 2; % vedo il picco con peak response da bode sempre e vedo che vale 2 dB a w = 1.56 rad/s
%% DISCRETIZZAZIONE
T = 2*pi/(20*wB); % periodo di campionamento
Gazoh = C*A*Gp/(1+s*(T/2)); % funzione per valutare se ridurre T
figure, margin(Gazoh) % uso margin su Gazoh per valutare se il margine
% trovato con quel T soddisfa il margine di fase minimo; margine trovato =
% 42° < 44° quindi riduco T
T = 0.07;
Gazoh = C*A*Gp/(1+s*(T/2));
figure, margin(Gazoh) % con T = 0.07, ho mf = 44.4° > 44° quindi ok
% discretizzo il mio sistema
C_z = c2d(C,T,'tustin') % controllore discretizzato (no ; per vedere la funzione)
F_z = c2d(A*Gp,T,'tustin'); % funzione anello discretizzata
W_z = feedback(C_z*F_z,Kr);
figure, step(W)
% vedo quindi che sia sovraelongazione (s = 24%) sia ts (= 0.75) sono
% soddisfatti anche in discretizzazione quindi ok, progetto finito