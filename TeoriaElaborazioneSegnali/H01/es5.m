n = -5:5;
x = 5 * cos(5 * pi * n / 3);

% Trovo l'indice della prima occorrenza del massimo
index1 = find(x == max(x), 1);

% Trovo l'indice della seconda occorrenza del massimo
index2 = find(x == max(x(index1+1:end)), 1)+index1;

% Calcolo il periodo come differenza tra i 2 indici
period = index2 - index1 + 1;
disp(['Period of the signal: ' num2str(period)]);

% Grafici
stem(n, x, 'b', 'LineWidth', 2);
xlabel('n');
ylabel('x[n]');
title('x[n] = 5*cos(5*pi*n/3)');
axis([-7 7 -7 7]);
grid on;