%% Esercitazione di laboratorio #4 - Controlli Automatici
% *Esercizio #1: Simulazione di un DC-motor comandato in armatura*
% *e controllato in velocita'*
close all
clear all

%% Definizione sistema e parametri
Ra=1; La=6e-3; Km=0.5; J=0.1; b=0.02; Ka=10;
s=tf('s');
F1=Ka*Km/((s*La+Ra)*(s*J+b)+Km^2);
F2=-(s*La+Ra)/((s*La+Ra)*(s*J+b)+Km^2);

%% Simulazione in catena aperta in assenza del disturbo Td
Td_amp=0;

open_system('es_motore_no_controllo_velocita') % apre il sistema definito da file simulink
sim('es_motore_no_controllo_velocita') % simula il sistema
w_rif=1/dcgain(F1)*ones(size(tout));

% stampa
figure, plot(tout,vel_ang, tout,w_rif), grid on, ylim([0,1.2]),
title('DC-motor in catena aperta in assenza del disturbo Td'),
legend('\omega(t)','u(t)')

%% Simulazione in catena aperta in presenza del disturbo Td
Td_amp=0.05;

sim('es_motore_no_controllo_velocita')
w_rif=1/dcgain(F1)*ones(size(tout));

% stampa
figure, plot(tout,vel_ang, tout,w_rif), grid on, ylim([0,1.2]),
title('DC-motor in catena aperta in presenza del disturbo Td'),
legend('\omega(t)','u(t)')
% chiudo sistema
close_system('es_motore_no_controllo_velocita')

%% Simulazione in catena chiusa in assenza del disturbo Td
Td_amp=0;
Kc_vec=[0.1, 1, 5];

open_system('es_motore_con_controllo_velocita')
for Kc=Kc_vec,
    sim('es_motore_con_controllo_velocita')
    w_rif=ones(size(tout));
    errore=w_rif-vel_ang;
    % stampa
    figure, plot(tout,vel_ang, tout,w_rif, tout,errore), grid on, ylim([0,1.2]),
    title(['DC-motor controllato in velocita'' con Kc=', num2str(Kc), ...
           ' in assenza del disturbo Td']),
    legend('\omega(t)','\omega_{rif}(t)','e(t)=\omega_{rif}(t)-\omega(t)',4)
end

%% Simulazione in catena chiusa in presenza del disturbo Td
Td_amp=0.05;

for Kc=Kc_vec,
    sim('es_motore_con_controllo_velocita')
    w_rif=ones(size(tout));
    errore=w_rif-vel_ang;
    % stampa
    figure, plot(tout,vel_ang, tout,w_rif, tout,errore), grid on, ylim([0,1.2]),
    title(['DC-motor controllato in velocita'' con Kc=', num2str(Kc), ...
           ' in presenza del disturbo Td']),
    legend('\omega(t)','\omega_{rif}(t)','e(t)=\omega_{rif}(t)-\omega(t)',4)
end
% chiudo sistema
close_system('es_motore_con_controllo_velocita')

%% Calcolo delle f.d.t. in catena chiusa e dei diagrammi di Bode
figure
for Kc=Kc_vec,
    W=feedback(Kc*F1,1);
    z_W=zero(W); % zeri della fdt W
    p_W=pole(W); % poli della fdt W
    damp(W) % pulsazione naturale e smorzamento dei poli
    bode (W) % DdB
    grid on, xlim([1e-1, 1e4]), hold on,
    title('DC-motor controllato in velocita''')
end
legend(['Kc=',num2str(Kc_vec(1))],['Kc=',num2str(Kc_vec(2))],['Kc=',num2str(Kc_vec(3))])