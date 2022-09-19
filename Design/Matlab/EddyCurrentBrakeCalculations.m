%%  Title: Eddy Current Brake Calculations and Plots %%
% Auther: DC Eksteen
% Student Number: 22623906
% Contact: 22623906@sun.ac.za
% Date: 2022/09/13
% Version: 0.0
clear;
clc;

%% CONSTANTS AND PROPERTIES: %%
% Aluminium Disk Properties:
diskDiameter = 0.110; % 110 mm
diskThickness = 0.010; % 10 mm 
diskResistivity = 2.65 * 10^-8; % ohm/m
diskPermeability = 1.256e-6; % H/m
diskConductivity = 1/0.038e-6;

% Megnet Properties:
magnetThickness = 0.005; % m
magnetDiameter = 0.015; % m
magnetAmount = 16;
magnetAirGap = 0.003; % m
magnetPlateGap = magnetAirGap + diskThickness/2; % m
% Gap between surface of magnet and center of disc
magnetRemanence = 1.3; % T

%% PLOT THE FLUX DENSITY DISTRIBUTION OVER DISK THICKNESS %%
% Determine the Magnetic Flux Density at point x:
syms B(z);
B(z) = (magnetRemanence/2) * ...
    ((magnetThickness + z) / (sqrt((magnetDiameter / 2)^2 + ...
    (magnetThickness + z)^2)) - ...
    z / sqrt((magnetDiameter / 2)^2 + z^2));
upperLimitX = magnetPlateGap*2;

% Determine Average Flux density over the disk
B0 = double(mean( ...
    B(linspace(magnetAirGap,magnetAirGap+diskThickness,10)) + ...
    B(-linspace(magnetAirGap,magnetAirGap+diskThickness,10)+upperLimitX)));

% Distribution Functions:
upperLimitXmm = upperLimitX*1000;
syms leftB(x);
left_B(x) = B(x/1000);
syms rightB(x);
right_B(x) = B(-x/1000 + upperLimitX);

% Configuration for the Figures:
figureFontSize1 = 20;
figureLineWidth1 = 2;
figureGcaFontSize1 = 18;

% Figure 1: 0 degrees out of phase
figureZeroDeg = figure;
phaseDegrees = 0;
set(gca,'FontSize', figureGcaFontSize1)
hold on
grid on
% Plot Disk Edge Lines
xline(magnetAirGap*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
xline((magnetAirGap+diskThickness)*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
    'red', ...
    'LineWidth', figureLineWidth1);
fplot(right_B(x), [0 upperLimitXmm], ...
    'blue', ...
    'LineWidth', figureLineWidth1);
fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
    'green', ...
    'LineWidth', figureLineWidth1);
% Axis Labels and Scale:
xlabel('Position (mm)', ...
    'FontSize', figureFontSize1);
ylabel('Magnetic Flux Density (T)', ...
    'FontSize', figureFontSize1);
ylim([-0.4 0.4]);
xlim([0 upperLimitX]);
exportgraphics(figureZeroDeg, ...
    '..\..\Report\graphics\FluxZeroDeg.jpg', ...
    'Resolution', 600)
close(figureZeroDeg)

% Tile 2: 60 degrees
phaseDegrees = 60;
figure2 = figure;
set(gca,'FontSize', figureGcaFontSize1)
hold on
xline(magnetAirGap*1000, 'black', 'LineWidth', figureLineWidth1)
xline((magnetAirGap+diskThickness)*1000, 'black', 'LineWidth', figureLineWidth1)
fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], 'red', 'LineWidth', figureLineWidth1)
fplot(right_B(x), [0 upperLimitXmm], 'blue', 'LineWidth', figureLineWidth1)
fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], 'green', 'LineWidth', figureLineWidth1)
xlabel('Position (mm)', 'FontSize', figureFontSize1)
ylabel('Magnetic Flux Density (T)', 'FontSize', figureFontSize1)
ylim([-0.4 0.4])
xlim([0 upperLimitXmm])
grid on
exportgraphics(figure2, '..\..\Report\graphics\FluxSixtyDeg.jpg', 'Resolution', 600)
close(figure2)

% Tile 3: 120 degrees
phaseDegrees = 120;
figure3 = figure;
set(gca,'FontSize', figureGcaFontSize1)
hold on
xline(magnetAirGap*1000, 'black', 'LineWidth', figureLineWidth1)
xline((magnetAirGap+diskThickness)*1000, 'black', 'LineWidth', figureLineWidth1)
fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], 'red', 'LineWidth', figureLineWidth1)
fplot(right_B(x), [0 upperLimitXmm], 'blue', 'LineWidth', figureLineWidth1)
fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], 'green', 'LineWidth', figureLineWidth1)
xlabel('Position (mm)', 'FontSize', figureFontSize1)
ylabel('Magnetic Flux Density (T)', 'FontSize', figureFontSize1)
ylim([-0.5 0.5])
xlim([0 upperLimitXmm])
grid on
exportgraphics(figure3, '..\..\Report\graphics\FluxOneTwentyDeg.jpg', 'Resolution', 600)
close(figure3)

% Tile 4: 180 degrees
phaseDegrees = 180;
figure4 = figure;
set(gca,'FontSize', figureGcaFontSize1)
hold on
px1 = xline(magnetAirGap*1000, 'black', 'LineWidth', figureLineWidth1);
px2 = xline((magnetAirGap+diskThickness)*1000, 'black', 'LineWidth', figureLineWidth1);
p1 = fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], 'red', 'LineWidth', figureLineWidth1);
p2 = fplot(right_B(x), [0 upperLimitXmm], 'blue', 'LineWidth', figureLineWidth1);
p3 = fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], 'green', 'LineWidth', figureLineWidth1);
xlabel('Position (mm)', 'FontSize', figureFontSize1)
ylabel('Magnetic Flux Density (T)', 'FontSize', figureFontSize1)
ylim([-0.5 0.5])
xlim([0 upperLimitXmm])
grid on
hold off
exportgraphics(figure4, '..\..\Report\graphics\FluxOneEightyDeg.jpg', 'Resolution', 600)
close(figure4)

legendFigure = figure;
hold on;
line(nan, nan, 'Color', 'black');
line(nan, nan, 'Color', 'red');
line(nan, nan, 'Color', 'blue');
line(nan, nan, 'Color', 'green');
set(gca, 'Visible', 'off');
hold off
legend('Disk Edge', 'Magnetic Flux Density of Variable Magnet', 'Magnetic Flux Density of Stationary Magnet', 'Total Magnetic Flux Density');
exportgraphics(legendFigure, '..\..\Report\graphics\FluxLegend.jpg', 'Resolution', 600)
close(legendFigure)

% Radius of disk offset: (radius)
R = 0.023; % 30 mm 
% Distance between magnet centres:
dc = 2*R*sin(pi/(magnetAmount/2));
% Distance between magnet edges: (Approximation)
dm = dc - magnetDiameter;

% Permeability in a vacume:
mu_0 = 1.257e-6; % H/m

% Magnet Strength Calculations

% High speed region:
% Current in regions surrounding the pole shadows: 
Iinf = magnetThickness * magnetRemanence/mu_0; % A
% Resistance in each of the channels between the pole pairs:
Rinf = 1/diskConductivity * (magnetDiameter)/(diskThickness * R); % ohm
% Retarding Force on disk:
syms Tinf(omega);
Tinf(omega) = magnetAmount * 1/omega * Iinf^2 * Rinf;
c0 = 0.5 * (1 - ( (magnetDiameter*diskDiameter*0.5)^2 /( (diskDiameter*0.5)^2 - R^2)^2) );

% Low speed:
syms T0_e(omega);
T0_e(omega) = magnetAmount * 1/diskResistivity * R^2 * (pi*magnetDiameter^2/4) * diskThickness * B0^2 * omega;
syms T0_0(omega);
T0_0(omega) = magnetAmount/2 * diskConductivity * omega*R * B0^2 * pi * magnetDiameter^2/4 * diskThickness * c0;

% Combined:
omega_c = double(vpasolve(T0_0 == Tinf, omega, [0 100]));
Tcrit = T0_0(omega_c/10) / (2/((omega_c/10)/omega_c + omega_c/(omega_c/10)));
syms T0(omega);
T0(omega) = Tcrit * 2/(omega/omega_c + omega_c/omega);

figure5 = figure;
xlabel('Angular Velocity (rad/s)')
ylabel('Braking Torque (N m)')
hold on
fplot(Tinf,[omega_c 400])
fplot(T0_0, [0 omega_c])
fplot(T0, [0 400])
%xline(omega_c)
legend('High Speed', 'Low speed', 'Combined')
hold off
exportgraphics(figure5, '..\..\Report\graphics\Fig5.jpg', 'Resolution', 600)
close(figure5)

% Model 1:
% Correction Factor
c1 = 0.5 * ( 1 - 0.25*( 1 / ( (1+R/(diskDiameter/2))^2 * (( (diskDiameter/2) - R) / (magnetDiameter))^2 ) ));
% Critical Force
Te_hat = double(R * (1/mu_0) * sqrt(c1) * (pi/4) * (magnetDiameter)^2 * ( magnetAmount*0.5*B0 )^2 * sqrt( (2*magnetPlateGap)/(magnetDiameter) ) );
% Critical speed
omega_c1 = ((2 / mu_0) * sqrt(1/(c1)) * (diskResistivity/diskThickness) * sqrt((2*magnetPlateGap)/(magnetDiameter)))/ R;
% General Equation
Te(omega) = Te_hat * 2/(omega_c1/(omega) + (omega)/omega_c1);

figure6 = figure;
hold on
fplot(T0_e(z), [0 400])
fplot(Te(omega), [0 400])
legend('Linear Model', 'Model With Saturation Effects')
xlabel('Angular Velocity (rad/s)')
ylabel('Braking Torque (N m)')
hold off
exportgraphics(figure6, '..\..\Report\graphics\Fig6.jpg', 'Resolution', 600)
close(figure6)

figure7 = figure;
hold on
fplot(Te(omega), [0 400])
fplot(T0,[0 400])
fplot((Te+T0)/2, [0 400], 'black')
legend('Simple Model', 'Advanced Model', 'Average')
xlabel('Angular Velocity (rad/s)')
ylabel('Braking Torque (N m)')
hold off
exportgraphics(figure7, '..\..\Report\graphics\Fig7.jpg', 'Resolution', 600)
close(figure7)

figure8 = figure;
hold on
fplot((Te+T0)/2, [0 400], 'black')
yyaxis right
fplot((Te+T0)/2 * omega, [0 400], 'red')
legend('Average Torque', 'Power Delivered')
xlabel('Angular Velocity (rad/s)')
exportgraphics(figure8, '..\..\Report\graphics\Fig8.jpg', 'Resolution', 600)
close(figure8)