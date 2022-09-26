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
diskResistivity = 2.65e-8; % ohm/m
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

% Magnet disk properties
magnetDiskR = 0.023; % m
vacumePermeability = 1.257e-6; % H/m

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
figureLimLowY = -0.4;
figureLimHighY = 0.4;

% Figure 1: 0 phase
figureZeroDegrees = figure;
phaseDegrees = 0;
hold on;
grid on;
% Plot Disk Edge Lines
xline(magnetAirGap*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
xline((magnetAirGap+diskThickness)*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
% Plot Flux Density from left
fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
    'red', ...
    'LineWidth', figureLineWidth1);
% Plot Flux density from right
fplot(right_B(x), [0 upperLimitXmm], ...
    'blue', ...
    'LineWidth', figureLineWidth1);
% Plot the Total Flux Density by adding
fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
    'green', ...
    'LineWidth', figureLineWidth1);
% Axis Labels and Scale:
xlabel('Position (mm)', ...
    'FontSize', figureFontSize1);
ylabel('Magnetic Flux Density (T)', ...
    'FontSize', figureFontSize1);
ylim([figureLimLowY figureLimHighY]);
xlim([0 upperLimitXmm]);
set(gca,'FontSize', figureGcaFontSize1);
% Save figure in Report File
exportgraphics(figureZeroDegrees, ...
    '..\..\Report\graphics\FluxZeroDeg.jpg', ...
    'Resolution', 600)
close(figureZeroDegrees);

% Figure 2: 60 degrees
figureSixtyDegrees = figure;
phaseDegrees = 60;
hold on;
grid on;
% Plot Disk Edge Lines
xline(magnetAirGap*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
xline((magnetAirGap+diskThickness)*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
% Plot Flux Density from left
fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
    'red', ...
    'LineWidth', figureLineWidth1);
% Plot Flux density from right
fplot(right_B(x), [0 upperLimitXmm], ...
    'blue', ...
    'LineWidth', figureLineWidth1);
% Plot the Total Flux Density by adding
fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
    'green', ...
    'LineWidth', figureLineWidth1);
% Axis Labels and Scale:
xlabel('Position (mm)', ...
    'FontSize', figureFontSize1);
ylabel('Magnetic Flux Density (T)', ...
    'FontSize', figureFontSize1);
ylim([figureLimLowY figureLimHighY]);
xlim([0 upperLimitXmm]);
set(gca,'FontSize', figureGcaFontSize1);
% Save figure in Report File
exportgraphics(figureSixtyDegrees, ...
    '..\..\Report\graphics\FluxSixtyDeg.jpg', ...
    'Resolution', 600);
close(figureSixtyDegrees);

% Figure 3: 120 degrees
figureOneTwentyDegrees = figure;
phaseDegrees = 120;
hold on;
grid on;
% Plot Disk Edge Lines
xline(magnetAirGap*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
xline((magnetAirGap+diskThickness)*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
% Plot Flux Density from left
fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
    'red', ...
    'LineWidth', figureLineWidth1);
% Plot Flux density from right
fplot(right_B(x), [0 upperLimitXmm], ...
    'blue', ...
    'LineWidth', figureLineWidth1);
% Plot the Total Flux Density by adding
fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
    'green', ...
    'LineWidth', figureLineWidth1);
% Axis Labels and Scale:
xlabel('Position (mm)', ...
    'FontSize', figureFontSize1)
ylabel('Magnetic Flux Density (T)', ...
    'FontSize', figureFontSize1)
ylim([figureLimLowY figureLimHighY]);
xlim([0 upperLimitXmm]);
set(gca,'FontSize', figureGcaFontSize1);
% Save figure in Report File
exportgraphics(figureOneTwentyDegrees, ...
    '..\..\Report\graphics\FluxOneTwentyDeg.jpg', ...
    'Resolution', 600);
close(figureOneTwentyDegrees);

% Figure 4: 180 degrees
phaseDegrees = 180;
figureOneEightyDegrees = figure;
hold on;
grid on;
% Plot Disk Edge Lines
xline(magnetAirGap*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
xline((magnetAirGap+diskThickness)*1000, ...
    'black', ...
    'LineWidth', figureLineWidth1);
% Plot Flux Density from left
fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
    'red', ...
    'LineWidth', figureLineWidth1);
% Plot Flux density from right
fplot(right_B(x), [0 upperLimitXmm], ...
    'blue', ...
    'LineWidth', figureLineWidth1);
% Plot the Total Flux Density by adding
fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
    'green', ...
    'LineWidth', figureLineWidth1);
% Axis Labels and Scale:
xlabel('Position (mm)', ...
    'FontSize', figureFontSize1);
ylabel('Magnetic Flux Density (T)', ...
    'FontSize', figureFontSize1);
ylim([figureLimLowY figureLimHighY]);
xlim([0 upperLimitXmm]);
set(gca,'FontSize', figureGcaFontSize1);
% Save figure in Report File
exportgraphics(figureOneEightyDegrees, ...
    '..\..\Report\graphics\FluxOneEightyDeg.jpg', ...
    'Resolution', 600);
close(figureOneEightyDegrees);

% Figure for legend
legendFigure = figure;
hold on;
line(nan, nan, ...
    'Color', 'black');
line(nan, nan, ...
    'Color', 'red');
line(nan, nan, ...
    'Color', 'blue');
line(nan, nan, ...
    'Color', 'green');
set(gca, 'Visible', 'off');
hold off
legend('Disk Edge', ...
    'Magnetic Flux Density of Variable Magnet', ...
    'Magnetic Flux Density of Stationary Magnet', ...
    'Total Magnetic Flux Density');
% Save figure in Report File
exportgraphics(legendFigure, ...
    '..\..\Report\graphics\FluxLegend.jpg', ...
    'Resolution', 600)
close(legendFigure)

%% BRAKE DESIGN CALCULATIONS %%
% Determine Magnet Disk Parameters:
megnetDiskCentres = 2*magnetDiskR * sin(pi / (magnetAmount/2) );
magnetDiskEdges = megnetDiskCentres - magnetDiameter;

%% SIMPLE MODEL CALCULATIONS %%
% High speed region:
% Current in regions surrounding the pole shadows: 
modelSimpleCurrentMax = magnetThickness * ...
    magnetRemanence / vacumePermeability; % A
% Resistance in each of the channels between the pole pairs:
modelSimpleResistanceMax = 1 / diskConductivity * ...
    (magnetDiameter) / (diskThickness * magnetDiskR); % ohm
% Retarding Force on disk:
syms modelSimpleTorqueInf(omega);
modelSimpleTorqueInf(omega) = magnetAmount * ...
    1/omega * ...
    modelSimpleCurrentMax^2 * ...
    modelSimpleResistanceMax;
c0 = 0.5 * (1 - ( (magnetDiameter*diskDiameter/2)^2 / ...
    ((diskDiameter/2)^2 - magnetDiskR^2)^2));

syms Tx(n);
Tx(n) = (1/diskResistivity * (B0)^2 * n * magnetDiskR) ...
    / 60000000;
%% Low speed:
syms T0_e(omega);
T0_e(omega) = magnetAmount * ...
    1/diskResistivity ...
    * magnetDiskR^2 * ...
    (pi*magnetDiameter^2/4) * ...
    diskThickness * ...
    B0^2 * ...
    omega;

syms T0_0(omega);
T0_0(omega) = magnetAmount/2 * ...
    diskConductivity * ...
    omega * ...
    magnetDiskR * ...
    B0^2 * ...
    pi * ...
    magnetDiameter^2/4 * ...
    diskThickness * ...
    c0;

% Combined:
modelSimpleCritSpeed = double( ...
    vpasolve(T0_0 == modelSimpleTorqueInf, ...
    omega, [0 100]));
Tcrit = T0_0(modelSimpleCritSpeed/10) / ...
    (2 / ((modelSimpleCritSpeed/10) / modelSimpleCritSpeed + ...
    modelSimpleCritSpeed / (modelSimpleCritSpeed/10)));
syms T0(omega);
T0(omega) = Tcrit * 2/(omega/modelSimpleCritSpeed + modelSimpleCritSpeed/omega);

figure5 = figure;
xlabel('Angular Velocity (rad/s)')
ylabel('Braking Torque (N m)')
hold on
fplot(Tx(n), [0 modelSimpleCritSpeed], ...
    'yellow')
fplot(modelSimpleTorqueInf,[modelSimpleCritSpeed 400])
fplot(T0_0, [0 modelSimpleCritSpeed])
fplot(T0, [0 400])
%xline(omega_c)
legend('', 'High Speed', 'Low speed', 'Combined')
hold off
exportgraphics(figure5, '..\..\Report\graphics\Fig5.jpg', 'Resolution', 600)
close(figure5)

% Model 1:
% Correction Factor
c1 = 0.5 * ( 1 - 0.25*( 1 / ( (1+magnetDiskR/(diskDiameter/2))^2 * (( (diskDiameter/2) - magnetDiskR) / (magnetDiameter))^2 ) ));
% Critical Force
Te_hat = double(magnetDiskR * (1/vacumePermeability) * sqrt(c1) * (pi/4) * (magnetDiameter)^2 * ( magnetAmount*0.5*B0 )^2 * sqrt( (2*magnetPlateGap)/(magnetDiameter) ) );
% Critical speed
omega_c1 = ((2 / vacumePermeability) * sqrt(1/(c1)) * (diskResistivity/diskThickness) * sqrt((2*magnetPlateGap)/(magnetDiameter)))/ magnetDiskR;
% General Equation
Te(omega) = Te_hat * 2/(omega_c1/(omega) + (omega)/omega_c1);

figure6 = figure;
hold on;
fplot(T0_e(z), [0 400]);
fplot(Te(omega), [0 400]);
legend('Linear Model', ...
    'Model With Saturation Effects');
xlabel('Angular Velocity (rad/s)');
ylabel('Braking Torque (N m)');
hold off;
exportgraphics(figure6, ...
    '..\..\Report\graphics\Fig6.jpg', ...
    'Resolution', 600);
close(figure6);

figure7 = figure;
hold on;
fplot(Te(omega), [0 400]);
fplot(T0,[0 400]);
fplot((Te+T0)/2, [0 400], ...
    'black');
legend('Simple Model', ...
    'Advanced Model', ...
    'Average');
xlabel('Angular Velocity (rad/s)');
ylabel('Braking Torque (N m)');
hold off
exportgraphics(figure7, ...
    '..\..\Report\graphics\Fig7.jpg', ...
    'Resolution', 600)
close(figure7)

figure8 = figure;
hold on;
fplot((Te+T0)/2, [0 400], 'black');
yyaxis right;
fplot((Te+T0)/2 * omega, [0 400], 'red');
legend('Average Torque', 'Power Delivered');
xlabel('Angular Velocity (rad/s)');
exportgraphics(figure8, ...
                '..\..\Report\graphics\Fig8.jpg', ...
                'Resolution', 600);
close(figure8);

%% TEST MODEL
% Tb = σR2Sd ˙θB2
syms Torque(omega)
Torque(omega) = diskConductivity*magnetDiskR*pi*(magnetDiameter/2)^2*B0^2*(magnetAmount/2)*omega
fig1 = figure
fplot(Torque, [0 4000])
