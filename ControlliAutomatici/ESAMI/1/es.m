s = tf('s');
F1 = 30/(s+15);
F2 = (3*s+3)/(s*(s+4)*(s+6));
F2_gain = (3*s+3)/((s+4)*(s+6));
Kr=1;
d1=1;
d2=4;
KF1 = dcgain(F1);
KF2 = dcgain(F2_gain);
Kc1 = Kr/(0.1*KF1*KF2);
Kc2 = d1/(KF1*0.05);
Kc = max(Kc1, Kc2);
nyquist(Kc*F1*F2); % segno di Kc positivo perchè stabile a sinistra
wc_des = 14;
Ga1 = Kc*F1*F2;
figure
bode(Ga1)
grid on
[m1,f1] = bode(Ga1,wc_des);
md = 14;
wtaud = 2.5;
taud = wtaud/wc_des;
Rd = (1+taud*s)/(1+(taud/md)*s)
Ga2 = Ga1*Rd; % anello vecchio più rete nuova anticipatrice
figure, bode(Ga2), grid on
[m2,f2] = bode(Ga2,wc_des);
mi = 2;
wtaui = 60;
taui = wtaui/wc_des;
Ri = (1+(taui/mi)*s)/(1+taui*s)
Ga3 = Ga2*Ri; % anello vecchio più rete nuova attenuatrice
figure, margin(Ga3);
C = Kc*Ri*Rd;
W = feedback(C*F1*F2, 1/Kr);
figure, step(W)
figure, bode(W)
w0 = 0.2; % pulsazione del signale sinusoidale richiesto
sens = feedback(1,Ga3); % funzione di sensibilità, definizione
[ms,fs] = bode(sens, w0);
err = ms*Kr;
wB = 20;
T=2*pi/(20*wB); % periodo di campionamento
Gazoh = Ga3/(1+s*(T/2)); % funzione per valutare se ridurre T
figure, margin(Gazoh);
C_z = c2d(C,T,'tustin'); % controllore discretizzato
F = F1*F2;
F_z = c2d(F,T,'tustin'); % funzione discretizzata
W_z = feedback(C_z*F_z,1);
figure, step(W)