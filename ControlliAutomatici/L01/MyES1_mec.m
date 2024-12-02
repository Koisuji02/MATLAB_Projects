%% Esercitazione 1 di Laboratorio - Controlli Automatici
% Sistema Meccanico

clear all
close all
clc


%% Definizione del sistema

% Parametri (uso uno switch-case per rendere più veloce il tutto)
% beta = coefficiente attrito viscoso; k = costante elastica della molla;
% w0 = pulsazione; 
% tmax = tempo massimo (scelto da me a seconda del caso per i grafici)
esercizio = input('Inserisci il numero della richiesta: ');
m = 0.2; f0 = 1;
switch esercizio,
case 1, beta = 0.1;  k = 2;  x0 = [0;0];   w0 = 0; tmax = 20;
case 2, beta = 0.01; k = 2;  x0 = [0;0];   w0 = 0; tmax = 200;
case 3, beta = 10;   k = 20; x0 = [0;0];   w0 = 0; tmax = 10;
case 4, beta = 0.1;  k = 2;  x0 = [0;0.2]; w0 = 0; tmax = 20;
case 5, beta = 0.1;  k = 2;  x0 = [0;0];   w0 = 4; tmax = 10;
case 6, beta = 0.01; k = 2;  x0 = [0;0];   w0 = 4; tmax = 10;
case 7, beta = 10;   k = 20; x0 = [0;0];   w0 = 4; tmax = 10;
case 8, beta = 0.1;  k = 2;  x0 = [0;0.2]; w0 = 4; tmax = 10;
end

% Matrici
A = [0, -k/m; 1, -k/beta];
B = [1/m; 0];
C = [1, 0];
D = [0];

% Comando ss -> usato per definire il sistema
sistema = ss(A,B,C,D);


%% Simulare il comportamento del sistema

% t = vettore dei tempi (limitato da tmax, preso dallo switch case)
% u = ingresso, definito dal testo del problema

t=0:0.01:tmax;
u=f0*cos(w0*t);

% Comando lsim -> usato per simulare il comportamento del sistema,
% ottenendo il vettore y dell'evoluzione dell'uscita, il vettore tsim dei
% tempi (che sarà uguale a t preso dalla lsim) e il vettore x
% dell'evoluzione degli stati
[y,tsim,x]=lsim(sistema,u,t,x0);

% GRAFICI per comparare i risultati ottenuti dalla lsim
% Grafico stato x1
figure(1), plot(tsim,x(:,1)), grid on, zoom on, title('Evoluzione dello stato x_1'), 
xlabel('tempo (in s)'), ylabel('velocità v (in m/s)')
% Grafico stato x2
figure(2), plot(tsim,x(:,2)), grid on, zoom on, title('Evoluzione dello stato x_2'), 
xlabel('tempo (in s)'), ylabel('posizione p_A (in m)')
% Grafico uscita y
figure(3), plot(tsim,y), grid on, zoom on, title('Evoluzione dell''uscita y'), 
xlabel('tempo (in s)'), ylabel('velocità v (in m/s)')


%% Calcolo della funzione di trasferimento G(s)

% Trovo G(s), ovvero H(s); si potrebbe usare il comando G = tf(numG,denG),
% ma non ho num e den della funzione in questione, bensì ho la rappresentazione in
% variabili di stato con le matrici A,B,C,D; perciò si usa il comando
% [numG,denG] = ss2tf(A,B,C,D,k) per generare il num e il den della
% funzione di trasferimento. La "k" rappresenta la k-esima colonna della
% matrice di trasferimento nei sistemi MIMO, ma qui ho 1 ingresso e 1
% uscita (SISO), quindi non occorre specificare k. Otterremo quindi una
% funzione di trasferimento G(s) = numG(s)/denG(s)=C((sI-A)^-1)B+D. Oltre a
% ciò si potrebbe anche usare il comando [numG,denG] = tfdata(sistema,'v')
% in quanto il sistema è SISO (v = indica che voglio vettori separati per
% numG e denG)
G = tf(sistema);
[numG,denG] = ss2tf(A,B,C,D); % alternativamente [numG,denG] = tfdata(sistema,'v')
fprintf('Zeri di G(s)'); damp(numG); % Calcolo degli zeri di G(s)
fprintf('Poli di G(s)'); damp(denG); % Calcolo dei poli di G(s)


%% Calcolo analitico delle risposte nel tempo del sistema

% Creo U(s); con s=tf('s') sto creando un'istanza di 's' per rappresentare la
% variabile di Laplace della frequenza s
ingresso = input('Inserisci il numero della richiesta di ingresso U(s): ');
s = tf('s');
switch ingresso,
case 1, U = 1/s;       % alternativamente tf(1,[1,0])
case 2, U = 1/s^2;      % alternativamente tf(1,[1,0,0])
case 3, U = s/(s^2+4^2); % alternativamente tf([1,0],[1,0,4^2])
end

% Calcolo Y(s) = G(s)U(s)
fprintf('Uscita Y(s)');
Y = G*U;

% Prendo num e den di Y(s)
[numY,denY] = tfdata(Y,'v');

% Faccio scomposizione in fratti semplici + residui per ottenere la
% risposta nel tempo
[residui,poli,resto] = residue(numY,denY)


