%% PARAMETRI
clear all, close all
s = tf('s');
F = 30*(s+6)/((s+0.8)*(s+5)^2);
N = 20;
figure, margin(F), grid on % mG = inf quindi no anello chiuso
% inoltre mf = 50 > 40, quindi no Ziegler-Nichols
figure, step(F), grid on % risposta monotona -> anello aperto si
% ANELLO APERTO COHEN COON
thetaF = 0.144;
% la risposta a regime y_inf = 9, quindi vedo che nel punto di ascissa
% theta_f + tau_f la y vale 5.67, perciò prendo dal grafico quel punto e
% trovo tau_f
tauF = 1.5 - thetaF;
KF = 9; % y_inf / u con u = 1
Kp = (16*tauF+3*thetaF)/(12*KF*thetaF);
TI = thetaF*(32*tauF+6*thetaF)/(13*tauF+8*thetaF);
TD = (4*tauF*thetaF)/(11*tauF+2*thetaF);
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(RPID*F,1);
figure, step(W), grid on % sovra = 43.3% e ts = 0.262