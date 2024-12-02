%% PARAMETRI
close all, clear all
s = tf('s');
F = (s^2+11*s+10)/(s^2*(s^2+4*s+8));
Kr = 1;
KF = dcgain(F*s^2);
figure, bode(F), grid on
% da bode vedo che per F ho fase iniziale e fase finale = -180°
f_i = -180; %°
f_f = -180; %°
Kc = 1;
Ga = Kc/Kr*F;
figure, bode(Ga), grid on
figure, nyquist(Ga), grid on
% vedo che Kc > 0 perchè dal punto critico N pari oppure stabile a sinistra
Kc = 1;
W=feedback(Kc*F,1/Kr);
damp(W) % poli

%% VALUTARE ERRORI
We=Kr*feedback(1,Ga); % W_errore
Wd1=feedback(F,Kc/Kr); % W_disturbo1
Wd2=feedback(1,Ga); % W_disturbo2
%% Caso e.1): r(t)=t, d1(t)=0.1, d2(t)=0.5
% -> errore intrinseco di inseguimento a r(t) = t NULLO perché il sistema è di
% tipo 2
% -> effetto del disturbo d1 costante sull'uscita pari a d1/(Kc/Kr) perché ci sono poli
% nell'origine solo nel blocco a valle del disturbo
% -> effetto del disturbo d2 costante sull'uscita NULLO perché c'è almeno un
% polo nell'origine nel blocco a monte del disturbo
errore_r=dcgain(s*We*1/s^2); % stessa cosa di fare tutto a mano con le formule
effetto_d1=dcgain(s*Wd1*0.1/s);
effetto_d2=dcgain(s*Wd2*0.5/s);
errore_tot=errore_r-(effetto_d1+effetto_d2)
open_system('es_V_1')
sim('es_V_1')

%% Caso e.2): r(t)=2t, d1(t)=0, d2(t)=0.01t
% -> errore intrinseco di inseguimento a r(t) = 2t NULLO perché il sistema è di
% tipo 2
% -> effetto del disturbo d1 NULLO essendo nullo il disturbo
% -> effetto del disturbo d2 a rampa sull'uscita NULLO perché il sistema è di
% tipo 2
errore_r=dcgain(s*We*2/s^2);
effetto_d1=dcgain(s*Wd1*0);
effetto_d2=dcgain(s*Wd2*0.01/s^2);
errore_tot=errore_r-(effetto_d1+effetto_d2)
open_system('es_V_2')
sim('es_V_2')

%% Caso e.3):  r(t)=t^2/2, d1(t)=0, d2(t)=0
% -> errore intrinseco di inseguimento a r(t) = t^2/2 pari a Kr/KGa (con KGa = Kc*Kf/Kr)
% perché il sistema è di tipo 2
% -> effetto del disturbo d1 NULLO essendo nullo il disturbo
% -> effetto del disturbo d2 NULLO essendo nullo il disturbo
errore_r=dcgain(s*We*1/s^3);
effetto_d1=dcgain(s*Wd1*0);
effetto_d2=dcgain(s*Wd2*0);
errore_tot=errore_r-(effetto_d1+effetto_d2)
open_system('es_V_3')
sim('es_V_3')

%% Caso e.4):  r(t)=t^2/2, d1(t)=0.1, d2(t)=0.2
% -> errore intrinseco di inseguimento a r(t) = t^2/2 pari a Kr/KGa (con KGa = Kc*Kf/Kr)
% perché il sistema è di tipo 2
% -> effetto del disturbo d1 costante sull'uscita pari a d1/(Kc/Kr) perché ci sono poli
% nell'origine solo nel blocco a valle del disturbo
% -> effetto del disturbo d2 costante sull'uscita NULLO perché c'è almeno un
% polo nell'origine nel blocco a monte del disturbo
errore_r=dcgain(s*We*1/s^3);
effetto_d1=dcgain(s*Wd1*0.1/s);
effetto_d2=dcgain(s*Wd2*0.2/s);
errore_tot=errore_r-(effetto_d1+effetto_d2)
open_system('es_V_4')
sim('es_V_4')