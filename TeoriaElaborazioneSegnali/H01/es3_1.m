% Definisci il tuo segnale discreto x[n]
n = 0:1000;
x = exp(-n);

% Calcola l'energia del segnale
energia = sum(abs(x).^2);
potenza = sum(abs(x).^2) / (2*length(n)-1);

% Visualizza il risultato
disp(['Energia del segnale: ' num2str(energia)]);
% Visualizza il risultato
disp(['Potenza del segnale: ' num2str(potenza)]);