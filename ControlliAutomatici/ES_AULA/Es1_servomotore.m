%% 1° PUNTO
clear all
close all
s = tf('s');
%% Parametri
Ra = 6;
L = 3.24e-3;
Km = 0.0535;
J = 20e-6;
beta = 14e-6;
KD = 0.0285;
Kcond = 0.67;
Rs = 7.525;
A = 2.925;
K = 1000;
CIa = K/s;
%% Calcolo fdt tra V_r,Ia(s) e I_a(s)
FrIa = feedback(CIa*A/(L*s+Ra), Rs); % feedback -> 1° argomento = ramo diretto
% 2° argomento = retroazione (assunta automaticamente negativa da feedback)
%% Calcolo fdt F(s) cercata
F = FrIa*Km/(J*s+beta)*KD*Kcond % non metto il ';' per visualizzare l'output

%% 2° PUNTO
Kr = 1;
Kp = 0.4;
C_omega1 = Kp; % fdt caso 1 del controllore (fdt proporzionale)
Ki = 2;
C_omega2 = Kp+Ki/s; % fdt caso 2 del controllore (fdt proporzionale-integrativa)
%% Calcolo fdt ad anello chiuso nei 2 casi
W1 = Kr*feedback(C_omega1*F, 1);
W2 = Kr*feedback(C_omega2*F, 1);
%% Applico gradino unitario (comando step -> 1° argomento = fdt su cui applicare il gradino, 2° argomento = istante finale della simulazione partendo da t=0)
step(W1,5,'b') % blu
hold on % permette di avere tutti i grafici nella stessa finestra per confrontarli
step(W2,5,'g') % verde
hold off