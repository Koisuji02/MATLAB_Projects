% Genera il segnale x[n]
n = -15:15;
x = zeros(size(n));
i = (n>=0) & (n<=10);
x(i) = n(i);

% Creazione del vettore n+5
n_reverse = -n;

% Creazione del vettore x1
x1 = zeros(size(n_reverse));
i = (n_reverse >= 0) & (n_reverse <= 10);
x1(i) = n_reverse(i);

% xp
xp = (1/2) * (x+x1);

%xd
xd = (1/2) * (x-x1);

%y
y = xp+xd;

% Rappresenta graficamente i segnali
subplot(3,1,1);
stem(n, xp, 'r', 'LineWidth', 1.5);
title('xp[n]');
xlabel('n');
ylabel('xp[n]');

subplot(3,1,2);
stem(n, xd, 'b', 'LineWidth', 1.5);
title('xd[n]');
xlabel('n');
ylabel('xd[n]');

subplot(3,1,3);
stem(n, y, 'g', 'LineWidth', 1.5);
title('y[n]');
xlabel('n');
ylabel('y[n]');


