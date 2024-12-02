T = 20; % Durata audio
M = 1; % Durata (s) Finestre temporali
f_campionamento = 44100; % Frequenza di campionamento

audio = audioread("originale.wav")';
audio = audio(1:floor(f_campionamento*T)); % Audio di T secondi

G = length(audio)/f_campionamento;
finestre_audio = zeros(floor(G/M), f_campionamento*M);
for k = 0:floor(T/M)-1
    finestre_audio(k+1,:) = audio(k*f_campionamento*M + 1:(k+1)*f_campionamento*M);
end
N = floor(M * f_campionamento); % Numero di campioni

d_t = [0:N-1]; % Discrete time samples
asse_frequenze = (f_campionamento / N * [-N/2:N/2-1])/1000;
durata_porta = 0.5; % Durata (s) della porta

h1 = zeros(size(d_t)); % Zeri per i campioni richiesti
h1(1:durata_porta*f_campionamento) = ones; % Porta di durata T secondi

figure
hold on, grid on
for k = [1:size(finestre_audio,1)]
    finestra_audio = finestre_audio(k,:);
    y1 = conv(h1, finestra_audio); % Filtraggio uscita
    plot([(k-1)*N:k*N-1], y1(1+floor(durata_porta*f_campionamento):N+floor(durata_porta*f_campionamento)), 'r'); % Plot filtered window
    plot([(k-1)*N:k*N-1], finestra_audio, 'b'); % Plot window
    out((k-1)*N+1:k*N) = y1(1+floor(durata_porta*f_campionamento):N+floor(durata_porta*f_campionamento));
end
xlabel('Tempo')
ylabel('Value')
title('Finestre temporali filtrate');
legend('Finestre temporali', 'Finestre filtrate')
hold off

audiowrite("processato.wav", out, f_campionamento)

rumore_gauss_bianco = randn(1, N);
rumore_filtrato = conv(rumore_gauss_bianco, h1);
X1 = fftshift(fft(rumore_gauss_bianco));
Y1 = fftshift(fft(rumore_filtrato));
Y1 = Y1(N/2:3*N/2-1); % supp (y) = supp (x) + supp (h1) - 1
H1 = Y1 ./ X1;

figure
hold on, grid on
plot(asse_frequenze,abs(H1).^2);
xlabel('Frequenza f(kHz)')
ylabel("|H_1(f)|^2")
title("Funzione di trasferimento |H_1(f)|^2");
hold off

B=1e3; % Banda a 1kHz
t0=0.35; % Ritardo

h2=sinc(2*B*(d_t/f_campionamento-t0));

figure
hold on, grid on
for k=[1:size(finestre_audio,1)]
    finestra_audio=finestre_audio(k,:);
    y2=conv(h2,finestra_audio);
    plot([(k-1)*N:k*N-1],y2(1+floor(t0*f_campionamento):N+floor(t0*f_campionamento)),'r'); % Ritardo i campioni del ritardo della sinc
    plot([(k-1)*N:k*N-1],finestra_audio,'b'); % Plot window
    out((k-1)*N+1:k*N)=y2(1+floor(t0*f_campionamento):N+floor(t0*f_campionamento));
end
xlabel('Tempo')
ylabel("Value")
title("Finestre temporali filtrate");
legend("Finestre temporali","Finestre filtrate")
hold off

out=out*(max(audio))/(max(out)); % Normalize for clipping
audiowrite("processato2.wav",out,f_campionamento)

rumore_gauss_bianco=randn(1,N);
rumore_filtrato=conv(rumore_gauss_bianco,h2);
X2=fftshift(fft(rumore_gauss_bianco));
Y2=fftshift(fft(rumore_filtrato));
Y2=Y2(N/2:3*N/2-1);
H2=Y2./X2;

figure
hold on, grid on
plot(asse_frequenze,abs(H2).^2);
xlabel('Frequenza f(kHz)')
ylabel("|H_2(f)|^2")
title("Funzione di trasferimento |H_2(f)|^2 passa basso B=1 kHz");
hold off
