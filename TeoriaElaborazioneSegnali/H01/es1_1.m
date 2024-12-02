% Genera il segnale x[n]
n = -10:15;
x = zeros(size(n));
i = (n>=0) & (n<=10);
x(i) = n(i);

% Creazione del vettore n+5
n_shifted = n + 5;

% Creazione del vettore y
y = zeros(size(n_shifted));
i = (n_shifted >= 0) & (n_shifted <= 10);
y(i) = n_shifted(i);

% Rappresenta graficamente i segnali
subplot(2,1,1);
stem(n, x, 'r', 'LineWidth', 1.5);
title('Segnale originale x[n]');
xlabel('n');
ylabel('x[n]');

subplot(2,1,2);
stem(n, y, 'b', 'LineWidth', 1.5);
title(['Segnale traslato a sinistra y[n] = x[n+', num2str(k), ']']);
xlabel('n');
ylabel('y[n]');
