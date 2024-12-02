%% PARAMETRI
close all, clear all
s = tf('s');
N = 10;
F = (100*s+1000)/(s^5+38*s^4+481*s^3+2280*s^2+3600*s);
figure, margin(F), grid on % per mG finito per anello chiuso
% per mf < 40° Z-N
figure, step(F), grid on % ha poli in zero quindi instabile, non guardo nemmeno la risposta al gradino
%% QUINDI:
% mf = 81.6° quindi > 40°, no Z-N
% mG finito quindi posso usare anello chiuso, perciò ANELLO CHIUSO +
% IMPOSIZIONE DI FASE:
mG = 27.1;
wmG = 3.54;
mf = 81.6;
wmf = 0.276;
Kp_t = mG
T_t = 2*pi/wmG
Kp = Kp_t*cosd(mf)
TI = T_t/pi*((1+sind(mf))/cosd(mf))
TD = TI/4
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(RPID*F,1); % retroazione unitaria richiesta
figure, bode(W), grid on % ci chiede wB e Mr_dB
wB = 6.36;
Mr_dB = 4.52;