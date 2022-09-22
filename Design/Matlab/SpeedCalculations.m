% Title: Speed and Torque Calculations
% Auther: DC Eksteen
% Student Number: 22623906
% Contact: 22623906@sun.ac.za
% Date: 2022/09/14
% Version: 1.0

clear;
clc;

% Set constants
figure_linewidth = 2;
figure_fontsize = 14;

% Velocity of Cyclist between 10 km/h and 60 km/h
v = linspace(10,65,50);

% Drum Diameters that were considered:
% 10mm increments between 70mm and 110mm diameter
drum_Diameter = linspace(0.070, 0.110, 5);

% Angular Velocity of the drums: 
drum_Omega = v./((3.6*0.5).*drum_Diameter');
drum_RPM = drum_Omega.*(30/pi);

% Plot output of velocity calculations
% The output gets exported to be included in report!!
% To see output comment the close statement
figure1 = figure;
hold on 
grid off
xlabel('Velocity (km/h)', 'FontSize', figure_fontsize)
ylabel('Angular Velocity (rpm)', 'FontSize', figure_fontsize)
plot(v,drum_RPM(1,:), 'LineWidth', figure_linewidth)
plot(v,drum_RPM(2,:), 'LineWidth', figure_linewidth)
plot(v,drum_RPM(3,:), 'LineWidth', figure_linewidth)
plot(v,drum_RPM(4,:), 'LineWidth', figure_linewidth)
plot(v,drum_RPM(5,:), 'LineWidth', figure_linewidth)
legend('70 mm', '80 mm', '90 mm', '100 mm', '110 mm', ...
    'Location', 'eastoutside')
exportgraphics(figure1, ...
    '..\..\Report\graphics\SpeedCalculations.jpg', ...
    'Resolution', 600)
close(figure1)

% Plot Torque curve for 100 and 200 W
figure2 = figure;
hold on
grid off
plot(v, 100./drum_Omega(3,:), 'LineWidth', figure_linewidth);
plot(v, 200./drum_Omega(3,:), 'LineWidth', figure_linewidth);
plot(v, 400./drum_Omega(3,:), 'LineWidth', figure_linewidth);
xlabel('Velocity (km/h)', 'FontSize', figure_fontsize)
ylabel('Torque (Nm)', 'FontSize', figure_fontsize)
legend('100 W', '200 W', '400 W', ...
    'Location', 'eastoutside')
exportgraphics(figure2, ...
    '..\..\Report\graphics\TorqueCalculations.jpg', ...
    'Resolution', 600)
close(figure2)
