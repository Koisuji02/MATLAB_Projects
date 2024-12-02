%% Esercitazione di laboratorio #2 - Controlli Automatici
% Stabilità LTI

clear all
close all
clc


%% Stabilita' interna di sistemi LTI TC

B = [1; 1]; C = [1, 3]; D = [0];
A1 = [-0.5, 1; 0, -2];
A2 = [-0.5, 1; 0, -1];
A3 = [-0.5, 1; 0,  0];
A4 = [-0.5, 1; 0,  1];
x0 = [1; 2]; % consigliati dal prof (anche se su traccia dice x0 = [0;0]

T = 0:0.1:50; % scelgo io l'asse dei tempi per comodità
U = (0*T); % ingresso nullo

% definisco i sistemi con ss e lsim
s1 = ss(A1, B, C, D);
[YS1, TS1, XS1] = lsim(s1, U, T, x0);

s2 = ss(A2, B, C, D);
[YS2, TS2, XS2] = lsim(s2, U, T, x0);

s3 = ss(A3, B, C, D);
[YS3, TS3, XS3] = lsim(s3, U, T, x0);

s4 = ss(A4, B, C, D);
[YS4, TS4, XS4] = lsim(s4, U, T, x0);

% grafici
% Evoluzione dello stato X1
figure, plot(TS1,XS1(:,1),'r', TS2,XS2(:,1),'g', TS3,XS3(:,1),' b', TS4,XS4(:,1),'y'),grid on, zoom on,
title('Evoluzione TC dello stato x_1 (matrici A_1, A_2, A_3, A_4)');
xlabel('tempo[s]'), ylabel('velocità [m/s]')

% Evoluzione dello stato X2
figure, plot(TS1,XS1(:,2),'r', TS2,XS2(:,2),'g', TS3,XS3(:,2),' b', TS4,XS4(:,2),'y'),grid on,
title('Evoluzione TC dello stato x_2 (matrici A_1, A_2, A_3, A_4)');
xlabel('tempo[s]'), ylabel('velocità [m/s]')

% Proiezione di X2 e X1
figure, plot(XS1(:,1),XS1(:,2),'r', XS2(:,1),XS2(:,2),'g'),grid on,
title ('Matrici TC A_1 e A_2'), xlabel ('Stato X_1'), ylabel ('Stato X_2')
 
figure, plot (XS3(:,1),XS3(:,2),'b',XS4(:,1),XS4(:,2),'r') ,grid on,
title('Matrici TC A_3 e A_4'), xlabel ('Stato X_1'), ylabel ('Stato X_2')


%% Stabilita' interna di sistemi dinamici LTI a tempo discreto

T = 0:1:20;
U = (0*T); % resizing ingresso nullo

SYS1 = ss(A1,B,C,D,-1); % -1 perchè tempo-invariante (stazionario)
[YS1,TS1,XS1] = lsim(SYS1,U,T,x0) ;

SYS2 = ss(A2,B,C,D,-1);
[YS2,TS2,XS2] = lsim(SYS2,U,T,x0);

SYS3 = ss(A3,B,C,D,-1);
[YS3,TS3,XS3] = lsim(SYS3,U,T,x0);

SYS4 = ss(A4,B,C,D,-1);
[YS4,TS4,XS4] = lsim(SYS4,U,T,x0);

% grafici
% Evoluzione dello stato X1
figure, plot(TS3,XS3(:,1),'g',TS4,XS4(:,1),' b'),grid on,
title('Evoluzione TD dello stato x_1 (matrici A_3 e A_4)');
xlabel('tempo[s]'), ylabel('velocità [m/s]'),

figure, plot(TS2,XS2(:,1),'b'),grid on,
title('Evoluzione TD dello stato x_1 (matrice A_2)');
xlabel('tempo[s]'), ylabel('velocità [m/s]'),

figure, plot(TS1,XS1(:,1),'b'), grid on, zoom on,
title('Evoluzione TD dello stato x_1 (matrice A_1)'),
xlabel('tempo[s]'), ylabel('velocità [m/s]'),

% Evoluzione dello stato X2
figure, plot(TS3,XS3(:,2),'g',TS4,XS4(:,2)),grid on,
title('Evoluzione TD dello stato x_2 (matrici A_3 e A_4)');
xlabel('tempo[s]'), ylabel('velocità [m/s]'),

figure, plot(TS2,XS2(:,2),'b'),grid on,
title('Evoluzione TD dello stato x_2 (matrice A_2)');

figure, plot(TS1,XS1(:,2),'b'), grid on, zoom on,
title('Evoluzione TD dello stato x_2 (matrice A_1)'),
xlabel('tempo[s]'), ylabel('velocità [m/s]'),

% Proiezione di X2 su X1
figure, plot(XS4(:,1),XS4(:,2),'r',XS3(:,1),XS3(:,2),'g'), grid on,
title ('Matrici TD A_3 e A_4'), xlabel ('Stato X_1'), ylabel ('Stato X_2'),

figure, plot (XS2(:,1),XS2(:,2),'b'), grid on ,
title('Matrice TD A_2'), xlabel ('Stato X_1'), ylabel ('Stato X_2'),
 
figure, plot (XS1(:,1),XS1(:,2),'b'), grid on ,
title('Matrice TD A_1'), xlabel ('Stato X_1'), ylabel ('Stato X_2'),