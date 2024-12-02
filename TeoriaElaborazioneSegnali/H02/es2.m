% Definire il segnale audio e i parametri
durata_totale = 20;  % secondi
M = 0.1;  % secondi, durata della sotto-finestra temporale
f_campionamento = 44100;  % Hz, frequenza di campionamento
t = 0:1/f_campionamento:durata_totale-1/f_campionamento;  % asse temporale

% Generare il segnale audio di esempio (ad esempio, una sinusoide)
segnale_audio = audioread("sample3.wav");
segnale_audio = segnale_audio(1:durata_totale*f_campionamento);

% Dividere il segnale in sotto-finestre
num_finestre = durata_totale / M;
finestre_audio = reshape(segnale_audio, floor(M*f_campionamento), num_finestre);

% Calcolare la DFT per ogni sotto-finestra
hold on, grid on
for i = 1:num_finestre
    finestra_corrente = finestre_audio(:, i);
    N = length(finestra_corrente);
    k = 0:N-1;
    
    % Calcolare la DFT senza semplificazioni
    X = zeros(1, N);
    for n = 1:N
        X(n) = sum(finestra_corrente .* exp(-1i*2*pi*(n-1)*(k')/N));
    end
    X = fftshift(X);
    
    % Creare un vettore delle frequenze in kHz
    freq = (k*f_campionamento) / N / 1000;
    
    % Disegnare gli spettri di energia
    subplot(2,1,1);
    plot(freq, (abs(X).^2));
    title('DFT');
    xlabel('Frequenza (kHz)');
    ylabel('|X|^2');
end
hold off

hold on
for i = 1:num_finestre
    finestra_corrente = finestre_audio(:, i);

% Calcolare la FFT usando la funzione di libreria
    Y = fftshift(fft(finestra_corrente));

    % Creare un vettore delle frequenze in kHz
    freq = (k*f_campionamento) / N / 1000;

    % Disegnare gli spettri di energia
    subplot(2,1,2);
    plot(freq, (abs(Y).^2));
    title('FFT');
    xlabel('Frequenza (kHz)');
    ylabel('|X|^2');
end
grid on
hold off