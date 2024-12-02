%% PARAMETRI
close all, clear all
s = tf('s');
F = (100*s+1000)/(s^5+38*s^4+481*s^3+2280*s^2+3600*s);
N = 10;
figure, margin(F), grid on % se mG finito posso usare anello chiuso
% da qui vedo anche se mf < 40, in tal caso posso usare Z-Nichols
figure, step(F), grid on % se stabile posso usare anello aperto
%% QUINDI
% vedo che mG finito (mG = 27.1dB a wmG = 3.54rad/s) quindi posso usare
% anello chiuso, ma mf > 40° quindi no Z-N, ma si imposizione di fase
% la risposta al gradino è monotona, ma cresce sempre, non ha forma tipica
% per anello aperto, quindi scelgo anello chiuso con imposizione di fase
mG = 27.1; % dB
Kp_t = mG;
wmG  = 3.54;
T_t = 2*pi/wmG
mf = 81.6; % °
Kp = Kp_t*cosd(mf)
TI = T_t/pi*((1+sind(mf))/cosd(mf))
TD = TI/4
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(F*RPID,1);
figure, bode(W), grid on % mi chiede wB e Mr_dB
Mr_dB = 4.52;
wB = 6.38;