%% Esercitazione di laboratorio #3 - Controlli Automatici
% Es.1 Levitatore magnetico mediante retroazione statica dallo stato
clear all
close all
s = tf('s');

%% Definizione del sistema da controllare (levitatore magnetico)
A=[0, 1; 900, 0];
B=[0; -9];
C=[600, 0];
D=0;
eig_A=eig(A); % autovalori di A

%% 1)Verifica della completa raggiungibilita'
Mr=ctrb(A,B); % controllabilità/raggiungibilità
rank_Mr=rank(Mr); % rango della matrice di controllabilità/raggiungibilità

%% 2)Assegnazione degli autovalori mediante retroazione statica dallo stato
l1=-40;
l2=-60;
K=place(A,B,[l1,l2]);      % Oppure acker(A,B,[l1,l2])
eig_A_minus_BK=eig(A-B*K); % Controllo se effettivamente ho messo gli autovalori
alfa=-1; % Scelta del guadagno alfa (punto 4)

%% 3)Definizione del sistema controllato mediante retroazione dallo stato
Ars=A-B*K;
Brs=alfa*B;
Crs=C-D*K;
Drs=alfa*D;

%% 4)Simulazione del sistema controllato
sistema_retroazionato=ss(Ars,Brs,Crs,Drs); % definizione del sistema con ss
t_r=0:.001:4; % scala temporale
r=sign(sin(2*pi*0.5*t_r)); % onda quadra (dai dati)
% 3 delta richieste dal problema
dx0_1=[ 0.00; 0];
dx0_2=[+0.01; 0];
dx0_3=[-0.01; 0];
% simulazione della risposta all'impulso con i 3 impulsi del sistema
[dy_1,t_dy_1]=lsim(sistema_retroazionato,r,t_r,dx0_1);
[dy_2,t_dy_2]=lsim(sistema_retroazionato,r,t_r,dx0_2);
[dy_3,t_dy_3]=lsim(sistema_retroazionato,r,t_r,dx0_3);

% stampa copiata per facilità -> stampa della simulazione
figure, plot(t_r,r,'k',t_dy_1,dy_1,'r',t_dy_2,dy_2,'g',t_dy_3,dy_3,'b'), grid on,
title(['Risposta \deltay(t) del sistema controllato mediante retroazione', ...
       ' dallo stato al variare di \deltax_0']),
legend('r(t)',' \deltay(t) per \deltax_0^{(1)}', ...
              '  \deltay(t) per \deltax_0^{(2)}','   \deltay(t) per \deltax_0^{(3)}')