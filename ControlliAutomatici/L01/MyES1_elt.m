%% Esercitazione 1 di Laboratorio - Controlli Automatici
% Sistema Elettrico

clear all
close all
clc


%% Definizione del sistema

% Parametri
esercizio = input('Inserisci il numero della richiesta: ');
C=0.2; i0=1;
switch esercizio,
case 1, R=10;  L=0.5;  x0=[0;0];   w0=0; tmax=20;
case 2, R=100; L=0.5;  x0=[0;0];   w0=0; tmax=200;
case 3, R=0.1; L=0.05; x0=[0;0];   w0=0; tmax=10;
case 4, R=10;  L=0.5;  x0=[0;0.2]; w0=0; tmax=20;
case 5, R=10;  L=0.5;  x0=[0;0];   w0=4; tmax=10;
case 6, R=100; L=0.5;  x0=[0;0];   w0=4; tmax=10;
case 7, R=0.1; L=0.05; x0=[0;0];   w0=4; tmax=10;
case 8, R=10;  L=0.5;  x0=[0;0.2]; w0=4; tmax=10;
end

% Matrici
A = [0, -1/C; 1/L, -R/L];
B = [1/C; 0];
C = [1, 0];
D = [0];

% Sistema
sistema = ss(A,B,C,D);


%% Simulare il comportamento del sistema

t=0:0.01:tmax;
u=i0*cos(w0*t);

[y,tsim,x] = lsim(sistema,u,t,x0);

% Grafici
figure(1), plot(tsim,x(:,1)), grid on, zoom on, title('Evoluzione dello stato x_1'), 
xlabel('tempo (in s)'), ylabel('tensione v_C (in V)')
figure(2), plot(tsim,x(:,2)), grid on, zoom on, title('Evoluzione dello stato x_2'), 
xlabel('tempo (in s)'), ylabel('corrente i_L (in A)')
figure(3), plot(tsim,y), grid on, zoom on, title('Evoluzione dell''uscita y'), 
xlabel('tempo (in s)'), ylabel('tensione v_C (in V)')


%% Calcolo della funzione di trasferimento G(s)
% G(s)
G = tf(sistema);
[numG,denG] = ss2tf(A,B,C,D);
fprintf('Zeri'); damp(numG);
fprintf('Poli'); damp(denG);


%% Calcolo analitico delle risposte nel tempo del sistema

% U(s)
ingresso = input('Inserisci il numero della richiesta di ingresso U(s): ');
s = tf('s');
switch ingresso,
case 1, U = 1/s;
case 2, U = 1/s^2;
case 3, U = s/(s^2+4^2);
end

% Y(s)
fprintf('Uscita Y(s)');
Y = G*U;

% Fratti semplici e residui
[numY,denY] = tfdata(Y,'v');
[residui,poli,resto] = residue(numY,denY)


