% Genera il segnale x[n]
n = -15:15;
x = zeros(size(n));
i = (n>=0) & (n<=10);
x(i) = n(i);

% Creazione del vettore n+10
n1_shifted = n + 10;

% Creazione del vettore x1
x1 = zeros(size(n1_shifted));
i = (n1_shifted >= 0) & (n1_shifted <= 10);
x1(i) = n1_shifted(i);

% Creazione del vettore -n+10
n2_shifted = -n + 10;

% Creazione del vettore x2
x2 = zeros(size(n2_shifted));
i = (n2_shifted >= 0) & (n2_shifted <= 10);
x2(i) = n2_shifted(i);

% Creazione di -10delta[n]
delta = zeros(size(n));
delta(n == 0) = 1;
x3 = -10*delta;

%y
y =x1+x2+x3;

% Rappresenta graficamente i segnali
subplot(2,1,1);
stem(n, x, 'r', 'LineWidth', 1.5);
title('Segnale originale x[n]');
xlabel('n');
ylabel('x[n]');

subplot(2,1,2);
stem(n, y, 'b', 'LineWidth', 1.5);
title('y[n]');
xlabel('n');
ylabel('y[n]');
