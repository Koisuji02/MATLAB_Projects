% Parametri del segnale
A = 5;
n = -1000:1000;

% Calcola il segnale x[n]
x = A * exp(-1i * 2 * pi * n / length(n));
% Calcola l'energia del segnale
energia = sum(abs(x).^2);
potenza = sum(abs(x).^2) / (length(n)-1);

% Visualizza il risultato
disp(['Energia del segnale: ' num2str(energia)]);
% Visualizza il risultato
disp(['Potenza del segnale: ' num2str(potenza)]);