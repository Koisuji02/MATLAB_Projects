n = -2:4;
% Creazione di x1 e x2
x1 = zeros(size(n));
x1(n == 0) = 1;
x1(n == 1) = 2;
x1(n == 2) = 1;
x2 = zeros(size(n));
x2(n == 0) = 3;
x2(n == 1) = 2;
x2(n == 2) = 1;
y = conv(x1,x2,'full');

% Rappresenta graficamente i segnali
subplot(3,1,1);
stem(n, x1, 'r', 'LineWidth', 1.5);
title('x1[n]');
xlabel('n');
ylabel('x1[n]');

subplot(3,1,2);
stem(n, x2, 'b', 'LineWidth', 1.5);
title('x2[n]');
xlabel('n');
ylabel('x2[n]');

subplot(3,1,3);
stem(0:length(y)-1, y, 'g', 'LineWidth', 1.5);
title('y');
xlabel('n');
ylabel('y[n]');

