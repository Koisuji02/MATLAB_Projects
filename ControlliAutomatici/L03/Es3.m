%% Esercitazione di laboratorio #3 - Controlli Automatici
% *Esercizio #3: levitatore magnetico mediante regolatore dinamico
clear all
close all

%% Definizione del sistema da controllare (levitatore magnetico)
A=[0, 1; 900, 0];
B=[0; -9];
C=[600, 0];
D=0;

%% 1)Verifica della completa raggiungibilita' e osservabilita'
% raggiungibilità
Mr=ctrb(A,B);
rank_Mr=rank(Mr);
% osservabilità
Mo=obsv(A,C);
rank_Mo=rank(Mo);

%% 2)Assegnazione degli autovalori dell'osservatore asintotico dello stato
% autovalori da assegnare all'osservatore
l_oss1=-120;
l_oss2=-180;
L=place(A',C',[l_oss1,l_oss2])'; % Oppure acker(A',C',[l_oss1,l_oss2])'
eig_A_minus_LC=eig(A-L*C);       % Verifico la corretta assegnazione degli autovalori

%% 3)Assegnazione degli autovalori imposti dalla legge di controllo
l1=-40;
l2=-60;
K=place(A,B,[l1,l2]);      % Oppure acker(A,B,[l1,l2])
eig_A_minus_BK=eig(A-B*K); % Verifico la corretta assegnazione degli autovalori
alfa=-1; % guadagno alfa punto 4

%% 4)Definizione del sistema controllato mediante regolatore dinamico
Areg=[A,-B*K; L*C, A-B*K-L*C];
Breg=[alfa*B; alfa*B];
Creg=[C,-D*K; zeros(size(C)),C-D*K];
Dreg=[alfa*D; alfa*D];

%% 5)Simulazione del sistema controllato mediante regolatore dinamico
sistema_con_regolatore=ss(Areg,Breg,Creg,Dreg); % definizione sistema complessivo
t_r=0:.001:4; % scala temporale
r=sign(sin(2*pi*0.5*t_r)); % riferimento di prima
% casi degli impulsi
dx0_1=[ 0.00; 0];
dx0_2=[+0.01; 0];
dx0_3=[-0.01; 0];
% impulso osservatore
dx0oss=[0;0];
% impulsi complessivi
dx0tot_1=[dx0_1; dx0oss];
dx0tot_2=[dx0_2; dx0oss];
dx0tot_3=[dx0_3; dx0oss];
% simulazione risposte agli impulsi
[yreg_1,t_yreg_1,xreg_1]=lsim(sistema_con_regolatore,r,t_r,dx0tot_1);
[yreg_2,t_yreg_2,xreg_2]=lsim(sistema_con_regolatore,r,t_r,dx0tot_2);
[yreg_3,t_yreg_3,xreg_3]=lsim(sistema_con_regolatore,r,t_r,dx0tot_3);

% stampa copiata per semplicità
figure, plot(t_r,r,'k',t_yreg_1,yreg_1(:,1),'r',t_yreg_1,yreg_1(:,2),'c--', ...
                       t_yreg_2,yreg_2(:,1),'g',t_yreg_2,yreg_2(:,2),'y--', ...
                       t_yreg_3,yreg_3(:,1),'b',t_yreg_3,yreg_3(:,2),'m--'), grid on,
title(['Risposta \deltay(t) del sistema controllato mediante regolatore', ...
       ' e sua stima \deltay_{oss}(t) al variare di \deltax_0']),
legend('r(t)','\deltay(t) per \deltax_0^{(1)}', '\deltay_{oss}(t) per \deltax_0^{(1)}',...
              '\deltay(t) per \deltax_0^{(2)}', '\deltay_{oss}(t) per \deltax_0^{(2)}',...
              '\deltay(t) per \deltax_0^{(3)}', '\deltay_{oss}(t) per \deltax_0^{(3)}')

figure, plot(t_r,r,'k',t_yreg_1,yreg_1(:,1),'r',t_yreg_1,yreg_1(:,2),'c--', ...
                       t_yreg_2,yreg_2(:,1),'g',t_yreg_2,yreg_2(:,2),'y--', ...
                       t_yreg_3,yreg_3(:,1),'b',t_yreg_3,yreg_3(:,2),'m--'), grid on,
title(['Risposta \deltay(t) del sistema controllato mediante regolatore', ...
       ' e sua stima \deltay_{oss}(t) al variare di \deltax_0']),
legend('r(t)','\deltay(t) per \deltax_0^{(1)}', '\deltay_{oss}(t) per \deltax_0^{(1)}',...
              '\deltay(t) per \deltax_0^{(2)}', '\deltay_{oss}(t) per \deltax_0^{(2)}',...
              '\deltay(t) per \deltax_0^{(3)}', '\deltay_{oss}(t) per \deltax_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);

figure, plot(t_yreg_1,xreg_1(:,1),'r',t_yreg_1,xreg_1(:,3),'c--', ...
             t_yreg_2,xreg_2(:,1),'g',t_yreg_2,xreg_2(:,3),'y--', ...
             t_yreg_3,xreg_3(:,1),'b',t_yreg_3,xreg_3(:,3),'m--'), grid on,
title(['Stato \deltax_1(t) del sistema controllato mediante regolatore', ...
       ' e sua stima \deltax_{oss,1}(t) al variare di \deltax_0']),
legend('\deltax_1(t) per \deltax_0^{(1)}', '\deltax_{oss,1}(t) per \deltax_0^{(1)}',...
       '\deltax_1(t) per \deltax_0^{(2)}', '\deltax_{oss,1}(t) per \deltax_0^{(2)}',...
       '\deltax_1(t) per \deltax_0^{(3)}', '\deltax_{oss,1}(t) per \deltax_0^{(3)}')

figure, plot(t_yreg_1,xreg_1(:,1),'r',t_yreg_1,xreg_1(:,3),'c--', ...
             t_yreg_2,xreg_2(:,1),'g',t_yreg_2,xreg_2(:,3),'y--', ...
             t_yreg_3,xreg_3(:,1),'b',t_yreg_3,xreg_3(:,3),'m--'), grid on,
title(['Stato \deltax_1(t) del sistema controllato mediante regolatore', ...
       ' e sua stima \deltax_{oss,1}(t) al variare di \deltax_0']),
legend('\deltax_1(t) per \deltax_0^{(1)}', '\deltax_{oss,1}(t) per \deltax_0^{(1)}',...
       '\deltax_1(t) per \deltax_0^{(2)}', '\deltax_{oss,1}(t) per \deltax_0^{(2)}',...
       '\deltax_1(t) per \deltax_0^{(3)}', '\deltax_{oss,1}(t) per \deltax_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);

figure, plot(t_yreg_1,xreg_1(:,2),'r',t_yreg_1,xreg_1(:,4),'c--', ...
             t_yreg_2,xreg_2(:,2),'g',t_yreg_2,xreg_2(:,4),'y--', ...
             t_yreg_3,xreg_3(:,2),'b',t_yreg_3,xreg_3(:,4),'m--'), grid on,
title(['Stato \deltax_2(t) del sistema controllato mediante regolatore', ...
       ' e sua stima \deltax_{oss,2}(t) al variare di \deltax_0']),
legend('\deltax_2(t) per \deltax_0^{(1)}', '\deltax_{oss,2}(t) per \deltax_0^{(1)}',...
       '\deltax_2(t) per \deltax_0^{(2)}', '\deltax_{oss,2}(t) per \deltax_0^{(2)}',...
       '\deltax_2(t) per \deltax_0^{(3)}', '\deltax_{oss,2}(t) per \deltax_0^{(3)}')

figure, plot(t_yreg_1,xreg_1(:,2),'r',t_yreg_1,xreg_1(:,4),'c--', ...
             t_yreg_2,xreg_2(:,2),'g',t_yreg_2,xreg_2(:,4),'y--', ...
             t_yreg_3,xreg_3(:,2),'b',t_yreg_3,xreg_3(:,4),'m--'), grid on,
title(['Stato \deltax_2(t) del sistema controllato mediante regolatore', ...
       ' e sua stima \deltax_{oss,2}(t) al variare di \deltax_0']),
legend('\deltax_2(t) per \deltax_0^{(1)}', '\deltax_{oss,2}(t) per \deltax_0^{(1)}',...
       '\deltax_2(t) per \deltax_0^{(2)}', '\deltax_{oss,2}(t) per \deltax_0^{(2)}',...
       '\deltax_2(t) per \deltax_0^{(3)}', '\deltax_{oss,2}(t) per \deltax_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);