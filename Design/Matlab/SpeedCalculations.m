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
v = linspace(10,50,50);

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
xlabel('Cycling Speed (km/h)', 'FontSize', figure_fontsize)
ylabel('Roller Speed (rpm)', 'FontSize', figure_fontsize)
plot(v,drum_RPM(1,:), 'LineWidth', figure_linewidth, 'Color', 'black')
plot(v,drum_RPM(2,:), 'LineWidth', figure_linewidth, 'Color', 'red')
plot(v,drum_RPM(3,:), 'LineWidth', figure_linewidth, 'Color', 'blue')
plot(v,drum_RPM(4,:), 'LineWidth', figure_linewidth, 'Color', 'green')
plot(v,drum_RPM(5,:), 'LineWidth', figure_linewidth, 'Color', 'magenta')
exportgraphics(figure1, ...
    '..\..\Report\graphics\SpeedCalculations.jpg', ...
    'Resolution', 600)
close(figure1)

figureother = figure;
hold on 
grid off
xlabel('Cycling Speed (km/h)', 'FontSize', figure_fontsize)
ylabel('Required Braking Torque (Nm)', 'FontSize', figure_fontsize)
plot(v,400./drum_Omega(1,:), 'LineWidth', figure_linewidth, 'Color', 'black')
plot(v,400./drum_Omega(2,:), 'LineWidth', figure_linewidth, 'Color', 'red')
plot(v,400./drum_Omega(3,:), 'LineWidth', figure_linewidth, 'Color', 'blue')
plot(v,400./drum_Omega(4,:), 'LineWidth', figure_linewidth, 'Color', 'green')
plot(v,400./drum_Omega(5,:), 'LineWidth', figure_linewidth, 'Color', 'magenta')

exportgraphics(figureother, ...
    '..\..\Report\graphics\SpeedCalculations2.jpg', ...
    'Resolution', 600)
% close(figureother)

% Figure for legend
legendFigure = figure;
hold on;
line(nan, nan, 'LineWidth', figure_linewidth, ...
    'Color', 'black');
line(nan, nan, 'LineWidth', figure_linewidth, ...
    'Color', 'red');
line(nan, nan, 'LineWidth', figure_linewidth, ...
    'Color', 'blue');
line(nan, nan, 'LineWidth', figure_linewidth, ...
    'Color', 'green');
line(nan, nan, 'LineWidth', figure_linewidth, ...
    'Color', 'magenta')
set(gca, 'Visible', 'off');
hold off
legend('70 mm', '80 mm', '90 mm', '100 mm', '110 mm')
% Save figure in Report File
exportgraphics(legendFigure, ...
    '..\..\Report\graphics\SpeedLegend.jpg', ...
    'Resolution', 600)
close(legendFigure)


% Plot Torque curve for 100 and 200 W
figure2 = figure;
hold on
grid off
plot(25 / (3 * pi * 90e-3/2) * v, 100./drum_Omega(3,:), 'LineWidth', figure_linewidth);
plot(25 / (3 * pi * 90e-3/2) * v, 200./drum_Omega(3,:), 'LineWidth', figure_linewidth);
plot(25 / (3 * pi * 90e-3/2) * v, 400./drum_Omega(3,:), 'LineWidth', figure_linewidth);
xlabel('Roller Speed (rpm)', 'FontSize', figure_fontsize)
ylabel('Braking Torque (Nm)', 'FontSize', figure_fontsize)
xlim([500 3000])
legend('100 W', '200 W', '400 W', ...
    'Location', 'northeast')
exportgraphics(figure2, ...
    '..\..\Report\graphics\TorqueCalculations.jpg', ...
    'Resolution', 600)
close(figure2)

speeds27 = linspace(82, 408, 20);
speeds29 = linspace(76, 379, 20);

min_force27 = 80 ./ speeds27;
max_force27 = 400 ./ speeds27;

min_force29 = 80 ./ speeds29;
max_force29 = 400 ./ speeds29;

f = figure;
hold on;
plot(speeds27, min_force27, 'LineWidth', figure_linewidth)
plot(speeds27, max_force27, 'LineWidth', figure_linewidth)
xlabel('Wheel Speed (rpm)', 'FontSize', figure_fontsize)
ylabel('Applied Braking Force (N)', 'FontSize', figure_fontsize)
legend('80 W', '400 W')
exportgraphics(f, ...
    '..\..\Report\graphics\BrakingForce.jpg', ...
    'Resolution', 600)
close(f)
