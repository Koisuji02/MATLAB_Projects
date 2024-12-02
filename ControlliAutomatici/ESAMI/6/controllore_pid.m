%% PARAMETRI
close all, clear all
s = tf('s');
N = 10;
F = (100*s+1000)/(s^5+38*s^4+481*s^3+2280*s^2+3600*s);
figure, margin(F), grid on % vedo che mG finito (mG = 27.1dB) quindi posso usare anello chiuso; vedo
% inoltre che mf = 81.6° > 40°, quindi non Ziegler-Nichols
figure, step(F), grid on % da qui vedo che F è stabile (risposta al gradino
% monotona), quindi posso usare anche anello aperto
% io scelgo anello chiuso con imposizione di fase
mG = 27.1; % dB
w_mG = 3.54; % rad/s
Kp_t = mG;
mf = 81.6; % °
T_t = 2*pi/w_mG;
% imposizione di fase
Kp = Kp_t*cosd(81.6); % 3.9589
TI = T_t/pi*(1+sind(81.6))/(cosd(81.6)); % 7.6935
TD = TI/4; % 1.9234
RPID = Kp*(1+1/(TI*s)+(TD*s)/(1+TD/N*s));
W = feedback(F*RPID, 1); % retroazione unitaria dal testo
figure, bode(W), grid on % per wB e Mr_dB
Mr_dB = 4.52;
wB = 6.4; % a -3dB