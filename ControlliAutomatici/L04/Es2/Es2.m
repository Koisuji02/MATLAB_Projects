%% Esercitazione di laboratorio #4 - Controlli Automatici
% *Esercizio #2: Simulazione di un DC-motor comandato in armatura*
% *e controllato in posizione*
close all
clear all

%% tutto come Es1 ma aggiungo ma cambio F1 in F1/s e F2 in F2/s   !!!!!!!!!

%% Definizione del sistema DC-motor comandato in armatura
Ra=1; La=6e-3; Km=0.5; J=0.1; b=0.02; Ka=10;
s=tf('s');
F1=Ka*Km/((s*La+Ra)*(s*J+b)+Km^2);
F2=-(s*La+Ra)/((s*La+Ra)*(s*J+b)+Km^2);

%% Simulazione in catena aperta in assenza del disturbo Td
Td_amp=0;

open_system('es_motore_no_controllo_posiz')
sim('es_motore_no_controllo_posiz')
pos_rif=ones(size(tout));

% stampa
figure, plot(tout,pos_ang, tout,pos_rif), grid on,
title('DC-motor in catena aperta in assenza del disturbo Td'),
legend('\theta(t)','u(t)')

%% Simulazione in catena aperta in presenza del disturbo Td
Td_amp=0.05;

sim('es_motore_no_controllo_posiz')
pos_rif=ones(size(tout));

% stampa
figure, plot(tout,pos_ang, tout,pos_rif), grid on,
title('DC-motor in catena aperta in presenza del disturbo Td'),
legend('\theta(t)','u(t)')
% chiudo sistema
close_system('es_motore_no_controllo_posiz')

%% Simulazione in catena chiusa in assenza del disturbo Td
Td_amp=0;
Kc_vec=[0.1, 1, 5];

open_system('es_motore_con_controllo_posiz')
for Kc=Kc_vec,
    sim('es_motore_con_controllo_posiz')
    pos_rif=ones(size(tout));
    errore=pos_rif-pos_ang;
    % stampa
    figure, plot(tout,pos_ang, tout,pos_rif, tout,errore), grid on, ylim([-1,2]),
    title(['DC-motor controllato in posizione con Kc=', num2str(Kc), ...
           ' in assenza del disturbo Td']),
    legend('\theta(t)','\theta_{rif}(t)','e(t)=\theta_{rif}(t)-\theta(t)',4)
end

%% Simulazione in catena chiusa in presenza del disturbo Td
Td_amp=0.05;

for Kc=Kc_vec,
    sim('es_motore_con_controllo_posiz')
    pos_rif=ones(size(tout));
    errore=pos_rif-pos_ang;
    % stampa
    figure, plot(tout,pos_ang, tout,pos_rif, tout,errore), grid on, ylim([-1,2]),
    title(['DC-motor controllato in posizione con Kc=', num2str(Kc), ...
           ' in presenza del disturbo Td']),
    legend('\theta(t)','\theta_{rif}(t)','e(t)=\theta_{rif}(t)-\theta(t)',4)
end
% chiudo sistema
close_system('es_motore_con_controllo_posiz')

%% Calcolo delle f.d.t. in catena chiusa e dei diagrammi di Bode
Kc_max=(b*La+Ra*J)*(Ra*b+Km^2)/(J*La*Km*Ka);
figure
for Kc=Kc_vec,
    W=feedback(Kc*F1/s,1);
    z_W=zero(W);
    p_W=pole(W);
    damp(W)
    bode (W), grid on, xlim([1e-1, 1e4]), hold on,
    title('DC-motor controllato in posizione')
end
legend(['Kc=',num2str(Kc_vec(1))],['Kc=',num2str(Kc_vec(2))],['Kc=',num2str(Kc_vec(3))])