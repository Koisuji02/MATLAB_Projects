clear all, close all

s = tf('s');

F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10));
F2 = 1/s

Kr = 1;
F = F1*F2;

zero(F);
damp(F);

Kf = dcgain(s*F);

figure, bode(F)
figure, nyquist(F)

%prendo kc positivo
Kc = 6.25;

Ga1 = Kr*Kc/s*F;

wc_des = 2; %iniziale 2.52

figure, bode(Ga1)
[m_wc_des, f_wc_des] = bode(Ga1, wc_des);

m_wc_des = 20*log10(m_wc_des)
f_wc_des

%aggiungo reeti anticipatrici per recuperare 70 gradi
md = 4;
xd = 1.4; %iniziale 1.72
taud = xd/wc_des

Rd = (1+taud*s)/(1+taud/md*s);

Ga2 = Ga1*Rd^2;
figure, bode(Ga2)
[m_wc_des2, f_wc_des2] = bode(Ga2, wc_des)

%m_wc_des2 = 20*log10(m_wc_des)
%f_wc_des2

%aggiungo rete attenuatrice per perdere 15 db (6.4 in unità naturali)
mi = 8.05 %iniziale 6.5
figure, bode((1+1/8.05*s)/(1+s))
xi = 75; %iniziale 56
taui = xi/wc_des;
Ri = (1+taui/mi*s)/(1+taui*s);

Ga3 = Ga2*Ri;
margin(Ga3);

C = Kc/s*Rd^2*Ri;
Ga = C*F;

W = feedback(Ga, 1/Kr);
figure, bode(W) %frequenza di taglio non va bene, diminuisco wc_des

figure, step(W)