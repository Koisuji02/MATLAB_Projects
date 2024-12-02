% Definire il segnale audio e i parametri
durata_totale = 20;  % secondi
M = 0.5;  % secondi, durata della sotto-finestra temporale
f_campionamento = 44100;  % Hz, frequenza di campionamento
t = 0:1/f_campionamento:durata_totale-1/f_campionamento;  % asse temporale

% Generare il segnale audio di esempio (ad esempio, una sinusoide)
segnale_audio = audioread("sample3.wav");
segnale_audio = segnale_audio(1:durata_totale*f_campionamento);

% Dividere il segnale in sotto-finestre
num_finestre = durata_totale / M;
finestre_audio = reshape(segnale_audio, floor(M*f_campionamento), num_finestre);

% Disegnare gli spettri di energia
figure;

hold on, grid on

for i = 1:num_finestre
    
    % Calcolo della finestra corrente dalle finestre audio
    finestra_corrente = finestre_audio(:, i);

    N = length(finestra_corrente);
    
    % Creare un vettore delle frequenze in kHz
    freq = (-N/2:1:N/2-1)*f_campionamento / N / 1000;
    
    % k da 0 a N-1
    k = 0:N-1;
    
    % Calcolare la DFT senza semplificazioni
    X = zeros(1, N);
    for n = 1:N
        X(n) = sum(finestra_corrente .* exp(-1i*2*pi*(n-1)*(k')/N));
    end
    X = fftshift(X);
    
    % Disegnare lo spettro di energia
    plot(freq, (abs(X).^2));

end

title('DFT');
xlabel('Frequenza (kHz)');
ylabel('|X|^2');

hold off

% DFT
figure;

hold on, grid on

for i = 1:num_finestre

    % Calcolo la finestra corrente dalle finestre audio
    finestra_corrente = finestre_audio(:, i);
    
    N = length(finestra_corrente);
    
    % Creare un vettore delle frequenze in kHz
    freq = (-N/2:1:N/2-1)*f_campionamento / N / 1000;

    % Calcolare la FFT usando la funzione di libreria
    Y = fftshift(fft(finestra_corrente));
    
    % Disegnare lo spettro di energia
    plot(freq, (abs(Y).^2));

end

title('FFT');
xlabel('Frequenza (kHz)');
ylabel('|X|^2');

hold off