%% Esercitazione 2 di Laboratorio - Controlli Automatici
% Risposte del 1° e 2° ordine

clear all
close all
clc


%%  Risposte di sistemi del primo ordine a ingressi canonici (Es.1)

s = tf('s');
G1 = 10/(s-5);
G2 = 10/s;
G3 = 10/(s+5);
G4 = 10/(s+20);

figure, impulse(G1,'r') % G1 = red
figure, impulse(G2,'b') % G2 = blue
figure, impulse(G3,'g') % G3 = green
figure, impulse(G4,'y') % G4 = yellow

figure, step(G1,'r'),
figure, step(G2,'b'),
figure, step(G3,'g'),
figure, step(G4,'y')
%pause % usato per fare in modo che l'utente clicchi sulla tastiera per proseguire


%% Risposta al gradino di sistemi del II ordine con due poli reali e nessuno zero (Es.2.1)

s = tf('s');
G1 = 20/((s+1)*(s+10));
G2 = 2/((s+1)^2);
G3 = 0.2/((s+1)*(s+0.1));

figure, step(G1,'r', G2,'b', G3,'y'),grid on % uso step con più parametri
% per avere tutte le G insieme


%% Risposta al gradino di sistemi del II ordine con due poli reali e uno zero (Es.2.2)

s = tf('s');

z1 = 100; z2 = 10; z3 = 1; z4 = 0.5;
G4_1 = (-5/z1)*((s-z1)/((s+1)*(s+5)));
G4_2 = (-5/z2)*((s-z2)/((s+1)*(s+5)));
G4_3 = (-5/z3)*((s-z3)/((s+1)*(s+5)));
G4_4 = (-5/z4)*((s-z4)/((s+1)*(s+5)));
figure, step(G4_1,'r', G4_2,'b', G4_3,'g', G4_4,'y'), grid on

z5 = -0.9; z6 = -0.5; z7 = -0.1;
G4_5 = (-5/z5)*((s-z5)/((s+1)*(s+5)));
G4_6 = (-5/z6)*((s-z6)/((s+1)*(s+5)));
G4_7 = (-5/z7)*((s-z7)/((s+1)*(s+5)));
figure, step(G4_5,'r', G4_6,'b', G4_7,'g'), grid on

z8 = -100; z9 = -10; z10 = -2;
G4_8 = (-5/z8)*((s-z8)/((s+1)*(s+5)));
G4_9 = (-5/z9)*((s-z9)/((s+1)*(s+5)));
G4_10 = (-5/z10)*((s-z10)/((s+1)*(s+5)));
figure, step(G4_8,'r', G4_9,'b', G4_10,'g'), grid on


%% Risposta al gradino di sistemi del II ordine con due poli complessi coniugati (Es.2.3)

s = tf('s');

w1 = 2; w2 = 2; w3 = 1; sg1 = 0.5; sg2 = 0.25; sg3 = 0.5;
G5_1 = (w1^2)/((s^2)+(2*sg1*w1*s)+(w1^2));
G5_2 = (w2^2)/((s^2)+(2*sg2*w2*s)+(w2^2));
G5_3 = (w3^2)/((s^2)+(2*sg3*w3*s)+(w3^2));
figure, step(G5_1,'r', G5_2,'b', G5_3,'g'),grid on

% Calcolo sovraelongazione
sovraelong1 = exp(-pi*sg1/sqrt(1-sg1^2));
sovraelong2 = exp(-pi*sg2/sqrt(1-sg2^2));
sovraelong3 = exp(-pi*sg3/sqrt(1-sg3^2));

% Calcolo del tempo di salita
ts1 = (1/(w1*sqrt(1-sg1^2)))*(pi-acos(sg1))
ts2 = (1/(w2*sqrt(1-sg2^2)))*(pi-acos(sg2))
ts3 = (1/(w3*sqrt(1-sg3^2)))*(pi-acos(sg3))