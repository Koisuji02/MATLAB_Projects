% Definisci il tuo segnale discreto x[n]
n0 = 5;
n = -10000:10000;
N = 10;
A = 5;
x = zeros(1, 4*(length(n)));
x(n <= N+n0 & n >= -N+n0) = A;

% Calcola l'energia del segnale
energia = sum(abs(x).^2);
potenza = sum(abs(x).^2) / (2*length(n)+1);

% Visualizza il risultato
disp(['Energia del segnale: ' num2str(energia)]);
% Visualizza il risultato
disp(['Potenza del segnale: ' num2str(potenza)]);

% Rappresenta graficamente i segnali
stem(x, 'r', 'LineWidth', 0.75);
title('x[n]');
xlabel('n');
ylabel('x[n]');
grid on