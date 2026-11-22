%% SIGE - Balance híbrido de una micro-red (ciclo de 24 horas)
clear; clc; close all;          % limpia variables, consola y figuras

horas = 1:24;                   % eje de tiempo: una posición por hora

%% a) Generación solar (kW)
Pmax_solar = 25;                % potencia pico solar [kW]
solar = zeros(1,24);            % noche: horas 1-5 y 19-24 quedan en 0
solar(6:18) = Pmax_solar*sin(pi*(horas(6:18)-6)/12);  % curva diurna con pico de 25 kW en la hora 12

%% b) Generación eólica (kW)
Pmax_eolica = 15;               % potencia nominal máxima de los aerogeneradores [kW]
rng(42);                        % semilla fija para que el resultado sea reproducible
eolica = 3 + 9*rand(1,24);      % valores irregulares entre 3 y 12 kW (simula el viento)
eolica = min(eolica, Pmax_eolica);  % garantiza que nunca supere los 15 kW

%% c) Generación híbrida total (kW)
gen_total = solar + eolica;     % suma elemento a elemento de ambos vectores

%% d) Demanda de la comunidad (kW)
demanda = [3 2.5 2 2.5 3, ...                          % horas 1-5: consumo nocturno (2 a 4 kW)
    6 7 8 9 9.5 10 9.5 9 8.5 8 8.5 9, ...       % horas 6-17: consumo diurno (6 a 10 kW)
    13 15 15 14, ...                            % horas 18-21: pico de demanda (15 kW)
    4 3.5 3];                                   % horas 22-24: consumo nocturno (2 a 4 kW)

%% e) Gráfica
figure;                                         % abre una ventana nueva
plot(horas, gen_total, 'g-o', 'LineWidth', 1.5) % generación total en verde
hold on                                         % mantiene la gráfica para superponer la demanda
plot(horas, demanda, 'r-s', 'LineWidth', 1.5)   % demanda en rojo
hold off                                        % libera la gráfica
title('Balance de energía de la micro-red: generación híbrida vs. demanda')  % título del gráfico
xlabel('Tiempo (horas)')                        % etiqueta del eje X
ylabel('Potencia (kW)')                         % etiqueta del eje Y
xlim([1 24])                                    % límites del eje X: las 24 horas
ylim([0 45])                                    % límites del eje Y para mostrar completo el pico de generación
grid on                                         % cuadrícula de fondo
legend('Generación total (solar + eólica)', 'Demanda de la comunidad', 'Location', 'southoutside')  % leyenda debajo de la gráfica, sin tapar las curvas
exportgraphics(gcf, 'grafica_balance.png', 'Resolution', 300)  % guarda la figura como imagen PNG de alta calidad

%% Análisis: horas de superávit y de déficit
superavit = horas(gen_total > demanda);         % horas en que la generación supera la demanda
deficit   = horas(demanda > gen_total);         % horas en que la demanda supera la generación
disp('Horas de superávit:'); disp(superavit)    % muestra las horas de superávit en la consola
disp('Horas de déficit (se requieren baterías):'); disp(deficit)  % muestra las horas de déficit en la consola