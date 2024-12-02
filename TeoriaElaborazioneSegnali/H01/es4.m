% Definisco i segnali
[x_ref, fs] = audioread('three_ref.wav');
[x1, ~] = audioread('four_noise.wav');
[x2, ~] = audioread('three_noise.wav');

% Grafici
subplot('Position', [0.1 0.6 0.8 0.35]);
plot(x1);
xlabel('n');
ylabel('x1[n]');
title('Segnale audio four noise.wav');
grid on;

subplot('Position', [0.1 0.6 0.8 0.35]);
plot(x2);
xlabel('n');
ylabel('x2[n]');
title('Segnale audio three noise.wav');
grid on;

subplot('Position', [0.1 0.1 0.8 0.35]);
plot(x_ref);
xlabel('n');
ylabel('x_ref[n]');
title('Segnale audio three ref.wav');
grid on;

% Metodo 1
disp("Metodo 2:")

% Normalizzo i segnali
alpha1 = sqrt(sum(x_ref.^2) / sum(x1.^2));
alpha2 = sqrt(sum(x_ref.^2) / sum(x2.^2));

x1_normalized = alpha1 * x1;
x2_normalized = alpha2 * x2;

% Calcolo la differenza dei segnali
e1 = x1_normalized - x_ref;
e2 = x2_normalized - x_ref;

% Calcolo le energie delle differenze
energy_e1 = sum(e1.^2);
energy_e2 = sum(e2.^2);

% Comparo le energie
if energy_e1 < energy_e2
    disp('e1[n] ha energia minore.');
elseif energy_e2 < energy_e1
    disp('e2[n] ha energia minore.');
else
    disp('Stessa energia.');
end

% Metodo 2
disp("Metodo 2:")

% Cross-correlazione
R_ref = xcorr(x_ref, x_ref);
Rc1 = xcorr(x_ref, x1);
Rc2 = xcorr(x_ref, x2);

Rc1_normalized = Rc1 * sqrt(sum(R_ref.^2) / sum(Rc1.^2));
Rc2_normalized = Rc2 * sqrt(sum(R_ref.^2) / sum(Rc2.^2));

energy_e1_method2 = sum((Rc1_normalized - R_ref).^2);
energy_e2_method2 = sum((Rc2_normalized - R_ref).^2);


% Confronto delle energie
if energy_e1_method2 < energy_e2_method2
    disp('e1[n] ha energia minore.');
elseif energy_e2_method2 < energy_e1_method2
    disp('e2[n] ha energia minore.');
else
    disp('Stessa energia.');
end