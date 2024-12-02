%% Esercitazione di laboratorio #3 - Controlli Automatici
% *Esercizio #2: osservatore asintotico dello stato
clear all
close all

%% Definizione del sistema da stimare (levitatore magnetico)
A=[0, 1; -2400, -100]; % Ars dell'Esercizio #1
B=[0; 9];              % Brs dell'Esercizio #1
C=[600, 0];            % Crs dell'Esercizio #1
D=[0];                 % Drs dell'Esercizio #1

%% 1)Verifica della completa osservabilita' del sistema
Mo=obsv(A,C);
rank_Mo=rank(Mo);

%% 2)Assegnazione degli autovalori dell'osservatore asintotico dello stato
% autovalori desiderati nell'osservatore
l_oss1=-120;
l_oss2=-180;
L=place(A',C',[l_oss1,l_oss2])'; % Oppure acker(A',C',[l_oss1,l_oss2])'
eig_A_minus_LC=eig(A-L*C);       % Verifico la corretta assegnazione degli autovalori

%% 3)Definizione del sistema complessivo (sistema da stimare piu' osservatore asintotico)
Atot=[A,zeros(size(A)); L*C, A-L*C];
Btot=[B; B];
Ctot=[C, zeros(size(C)); zeros(size(C)), C];
Dtot=[D; D];

%% 4)Simulazione del sistema complessivo
sistema_con_osservatore=ss(Atot,Btot,Ctot,Dtot); % definizione sistema complessivo
t_r=0:.001:4; % scala temporale
r=sign(sin(2*pi*0.5*t_r));
% casi stati iniziali
x0_1=[ 0.00; 0];
x0_2=[+0.01; 0];
x0_3=[-0.01; 0];
x0oss=[0; 0];
% stati iniziali sistema complessivo
x0tot_1=[x0_1; x0oss];
x0tot_2=[x0_2; x0oss];
x0tot_3=[x0_3; x0oss];
% simulazione con casi stati iniziali
[ytot_1,t_ytot_1,xtot_1]=lsim(sistema_con_osservatore,r,t_r,x0tot_1);
[ytot_2,t_ytot_2,xtot_2]=lsim(sistema_con_osservatore,r,t_r,x0tot_2);
[ytot_3,t_ytot_3,xtot_3]=lsim(sistema_con_osservatore,r,t_r,x0tot_3);

% stampe copiate per facilità
figure, plot(t_r,r,'k',t_ytot_1,ytot_1(:,1),'r',t_ytot_1,ytot_1(:,2),'c--', ...
                       t_ytot_2,ytot_2(:,1),'g',t_ytot_2,ytot_2(:,2),'y--', ...
                       t_ytot_3,ytot_3(:,1),'b',t_ytot_3,ytot_3(:,2),'m--'), grid on,
title(['Risposta y(t) del sistema e sua stima y_{oss}(t) al variare di x(t=0)']),
legend('r(t)','y(t) per x_0^{(1)}', 'y_{oss}(t) per x_0^{(1)}',...
              'y(t) per x_0^{(2)}', 'y_{oss}(t) per x_0^{(2)}',...
              'y(t) per x_0^{(3)}', 'y_{oss}(t) per x_0^{(3)}')

figure, plot(t_r,r,'k',t_ytot_1,ytot_1(:,1),'r',t_ytot_1,ytot_1(:,2),'c--', ...
                       t_ytot_2,ytot_2(:,1),'g',t_ytot_2,ytot_2(:,2),'y--', ...
                       t_ytot_3,ytot_3(:,1),'b',t_ytot_3,ytot_3(:,2),'m--'), grid on,
title(['Risposta y(t) del sistema e sua stima y_{oss}(t) al variare di x(t=0)']),
legend('r(t)','y(t) per x_0^{(1)}', 'y_{oss}(t) per x_0^{(1)}',...
              'y(t) per x_0^{(2)}', 'y_{oss}(t) per x_0^{(2)}',...
              'y(t) per x_0^{(3)}', 'y_{oss}(t) per x_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);

figure, plot(t_ytot_1,xtot_1(:,1),'r',t_ytot_1,xtot_1(:,3),'c--', ...
             t_ytot_2,xtot_2(:,1),'g',t_ytot_2,xtot_2(:,3),'y--', ...
             t_ytot_3,xtot_3(:,1),'b',t_ytot_3,xtot_3(:,3),'m--'), grid on,
title(['Stato x_1(t) del sistema e sua stima x_{oss,1}(t) al variare di x(t=0)']),
legend('x_1(t) per x_0^{(1)}', 'x_{oss,1}(t) per x_0^{(1)}',...
       'x_1(t) per x_0^{(2)}', 'x_{oss,1}(t) per x_0^{(2)}',...
       'x_1(t) per x_0^{(3)}', 'x_{oss,1}(t) per x_0^{(3)}')

figure, plot(t_ytot_1,xtot_1(:,1),'r',t_ytot_1,xtot_1(:,3),'c--', ...
             t_ytot_2,xtot_2(:,1),'g',t_ytot_2,xtot_2(:,3),'y--', ...
             t_ytot_3,xtot_3(:,1),'b',t_ytot_3,xtot_3(:,3),'m--'), grid on,
title(['Stato x_1(t) del sistema e sua stima x_{oss,1}(t) al variare di x(t=0)']),
legend('x_1(t) per x_0^{(1)}', 'x_{oss,1}(t) per x_0^{(1)}',...
       'x_1(t) per x_0^{(2)}', 'x_{oss,1}(t) per x_0^{(2)}',...
       'x_1(t) per x_0^{(3)}', 'x_{oss,1}(t) per x_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);

figure, plot(t_ytot_1,xtot_1(:,2),'r',t_ytot_1,xtot_1(:,4),'c--', ...
             t_ytot_2,xtot_2(:,2),'g',t_ytot_2,xtot_2(:,4),'y--', ...
             t_ytot_3,xtot_3(:,2),'b',t_ytot_3,xtot_3(:,4),'m--'), grid on,
title(['Stato x_2(t) del sistema e sua stima x_{oss,2}(t) al variare di x(t=0)']),
legend('x_2(t) per x_0^{(1)}', 'x_{oss,2}(t) per x_0^{(1)}',...
       'x_2(t) per x_0^{(2)}', 'x_{oss,2}(t) per x_0^{(2)}',...
       'x_2(t) per x_0^{(3)}', 'x_{oss,2}(t) per x_0^{(3)}')
   
figure, plot(t_ytot_1,xtot_1(:,2),'r',t_ytot_1,xtot_1(:,4),'c--', ...
             t_ytot_2,xtot_2(:,2),'g',t_ytot_2,xtot_2(:,4),'y--', ...
             t_ytot_3,xtot_3(:,2),'b',t_ytot_3,xtot_3(:,4),'m--'), grid on,
title(['Stato x_2(t) del sistema e sua stima x_{oss,2}(t) al variare di x(t=0)']),
legend('x_2(t) per x_0^{(1)}', 'x_{oss,2}(t) per x_0^{(1)}',...
       'x_2(t) per x_0^{(2)}', 'x_{oss,2}(t) per x_0^{(2)}',...
       'x_2(t) per x_0^{(3)}', 'x_{oss,2}(t) per x_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);