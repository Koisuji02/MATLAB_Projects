%% Esercitazione di laboratorio #3 - Controlli Automatici
% *Esercizio #3: progetto del controllo di un levitatore magnetico mediante*
% *regolatore dinamico*
%
% Autori: M. Indri, M. Taragna (ultima modifica: 28/04/2020)
%% Introduzione
% Si puo' suddividere il programma in diverse sezioni di codice usando i
% caratteri "%%". Ogni sezione puo' essere eseguita separatamente dalle
% altre con il comando "Run Section" (nella toolbar dell'Editor, subito
% a destra del tasto "Run"). Si puo' ottenere lo stesso risultato
% selezionando la porzione di codice che si vuole eseguire e premendo il
% tasto funzione F9, risparmiando cosi' tempo rispetto all'esecuzione di
% tutto il programma. Si prenda questo script come esempio di riferimento.

clear all, close all, clc

%% Passo 0: definizione del sistema da controllare (levitatore magnetico)

A=[0, 1; 900, 0];
B=[0; -9];
C=[600, 0];
D=0;

%% Passo 1: verifica della completa raggiungibilita' e osservabilita' del sistema da controllare

Mr=ctrb(A,B)
rank_Mr=rank(Mr)

Mo=obsv(A,C)
rank_Mo=rank(Mo)

%% Passo 2: assegnazione degli autovalori dell'osservatore asintotico dello stato

l_oss1=-120
l_oss2=-180
L=place(A',C',[l_oss1,l_oss2])' % In alternativa: acker(A',C',[l_oss1,l_oss2])'
eig_A_minus_LC=eig(A-L*C)       % Verifica della corretta assegnazione degli autovalori

%% Passo 3: assegnazione degli autovalori imposti dalla legge di controllo

l1=-40;
l2=-60;
K=place(A,B,[l1,l2])      % In alternativa: acker(A,B,[l1,l2])
eig_A_minus_BK=eig(A-B*K) % Verifica della corretta assegnazione degli autovalori

% Scelta del guadagno alfa

alfa=-1

% Per imporre la condizione di regolazione dell'uscita, basta scommentare:
% alfa=inv(-(C-D*K)*inv(A-B*K)*B+D)

%% Passo 4: definizione del sistema controllato mediante regolatore dinamico

Areg=[A,-B*K; L*C, A-B*K-L*C];
Breg=[alfa*B; alfa*B];
Creg=[C,-D*K; zeros(size(C)),C-D*K];
Dreg=[alfa*D; alfa*D];

%% Passo 5: simulazione del sistema controllato mediante regolatore dinamico

sistema_con_regolatore=ss(Areg,Breg,Creg,Dreg);
t_r=0:.001:4;
r=sign(sin(2*pi*0.5*t_r));
dx0_1=[ 0.00; 0];
dx0_2=[+0.01; 0];
dx0_3=[-0.01; 0];
dx0oss=[0;0];
dx0tot_1=[dx0_1; dx0oss];
dx0tot_2=[dx0_2; dx0oss];
dx0tot_3=[dx0_3; dx0oss];
[yreg_1,t_yreg_1,xreg_1]=lsim(sistema_con_regolatore,r,t_r,dx0tot_1);
[yreg_2,t_yreg_2,xreg_2]=lsim(sistema_con_regolatore,r,t_r,dx0tot_2);
[yreg_3,t_yreg_3,xreg_3]=lsim(sistema_con_regolatore,r,t_r,dx0tot_3);

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