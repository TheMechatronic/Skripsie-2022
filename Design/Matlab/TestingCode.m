% clear;
% clc;

%%  Title: Eddy Current Brake Calculations and Plots %%
% Auther: DC Eksteen
% Student Number: 22623906
% Contact: 22623906@sun.ac.za
% Date: 2022/09/13
% Version: 2.0
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
% Gap between surface of magnet and center of disc
magnetPlateGap = magnetAirGap + diskThickness/2; % m
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
B0 =  ...
    B(magnetAirGap + diskThickness/2);

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

figure_linewidth = 2;
figure_fontsize = 14;

% % Figure 1: 0 phase
% figureZeroDegrees = figure;
% phaseDegrees = 0;
% hold on;
% grid on;
% % Plot Disk Edge Lines
% xline(magnetAirGap*1000, ...
%     'black', ...
%     'LineWidth', figureLineWidth1);
% xline((magnetAirGap+diskThickness)*1000, ...
%     'black', ...
%     'LineWidth', figureLineWidth1);
% % Plot Flux Density from left
% fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
%     'red', ...
%     'LineWidth', figureLineWidth1);
% % Plot Flux density from right
% fplot(right_B(x), [0 upperLimitXmm], ...
%     'blue', ...
%     'LineWidth', figureLineWidth1);
% % Plot the Total Flux Density by adding
% fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
%     'green', ...
%     'LineWidth', figureLineWidth1);
% % Axis Labels and Scale:
% xlabel('Position (mm)', ...
%     'FontSize', figureFontSize1);
% ylabel('Magnetic Flux Density (T)', ...
%     'FontSize', figureFontSize1);
% ylim([figureLimLowY figureLimHighY]);
% xlim([0 upperLimitXmm]);
% set(gca,'FontSize', figureGcaFontSize1);
% % Save figure in Report File
% exportgraphics(figureZeroDegrees, ...
%     '..\..\Report\graphics\FluxZeroDeg.jpg', ...
%     'Resolution', 600)
% close(figureZeroDegrees);
% 
% % Figure 2: 60 degrees
% figureSixtyDegrees = figure;
% phaseDegrees = 60;
% hold on;
% grid on;
% % Plot Disk Edge Lines
% xline(magnetAirGap*1000, ...
%     'black', ...
%     'LineWidth', figureLineWidth1);
% xline((magnetAirGap+diskThickness)*1000, ...
%     'black', ...
%     'LineWidth', figureLineWidth1);
% % Plot Flux Density from left
% fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
%     'red', ...
%     'LineWidth', figureLineWidth1);
% % Plot Flux density from right
% fplot(right_B(x), [0 upperLimitXmm], ...
%     'blue', ...
%     'LineWidth', figureLineWidth1);
% % Plot the Total Flux Density by adding
% fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
%     'green', ...
%     'LineWidth', figureLineWidth1);
% % Axis Labels and Scale:
% xlabel('Position (mm)', ...
%     'FontSize', figureFontSize1);
% ylabel('Magnetic Flux Density (T)', ...
%     'FontSize', figureFontSize1);
% ylim([figureLimLowY figureLimHighY]);
% xlim([0 upperLimitXmm]);
% set(gca,'FontSize', figureGcaFontSize1);
% % Save figure in Report File
% exportgraphics(figureSixtyDegrees, ...
%     '..\..\Report\graphics\FluxSixtyDeg.jpg', ...
%     'Resolution', 600);
% close(figureSixtyDegrees);
% 
% % Figure 3: 120 degrees
% figureOneTwentyDegrees = figure;
% phaseDegrees = 120;
% hold on;
% grid on;
% % Plot Disk Edge Lines
% xline(magnetAirGap*1000, ...
%     'black', ...
%     'LineWidth', figureLineWidth1);
% xline((magnetAirGap+diskThickness)*1000, ...
%     'black', ...
%     'LineWidth', figureLineWidth1);
% % Plot Flux Density from left
% fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
%     'red', ...
%     'LineWidth', figureLineWidth1);
% % Plot Flux density from right
% fplot(right_B(x), [0 upperLimitXmm], ...
%     'blue', ...
%     'LineWidth', figureLineWidth1);
% % Plot the Total Flux Density by adding
% fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
%     'green', ...
%     'LineWidth', figureLineWidth1);
% % Axis Labels and Scale:
% xlabel('Position (mm)', ...
%     'FontSize', figureFontSize1)
% ylabel('Magnetic Flux Density (T)', ...
%     'FontSize', figureFontSize1)
% ylim([figureLimLowY figureLimHighY]);
% xlim([0 upperLimitXmm]);
% set(gca,'FontSize', figureGcaFontSize1);
% % Save figure in Report File
% exportgraphics(figureOneTwentyDegrees, ...
%     '..\..\Report\graphics\FluxOneTwentyDeg.jpg', ...
%     'Resolution', 600);
% close(figureOneTwentyDegrees);
% 
% % Figure 4: 180 degrees
% phaseDegrees = 180;
% figureOneEightyDegrees = figure;
% hold on;
% grid on;
% % Plot Disk Edge Lines
% xline(magnetAirGap*1000, ...
%     'black', ...
%     'LineWidth', figureLineWidth1);
% xline((magnetAirGap+diskThickness)*1000, ...
%     'black', ...
%     'LineWidth', figureLineWidth1);
% % Plot Flux Density from left
% fplot(left_B(x)*cosd(phaseDegrees), [0 upperLimitXmm], ...
%     'red', ...
%     'LineWidth', figureLineWidth1);
% % Plot Flux density from right
% fplot(right_B(x), [0 upperLimitXmm], ...
%     'blue', ...
%     'LineWidth', figureLineWidth1);
% % Plot the Total Flux Density by adding
% fplot(left_B(x)*cosd(phaseDegrees) + right_B(x), [0 upperLimitXmm], ...
%     'green', ...
%     'LineWidth', figureLineWidth1);
% % Axis Labels and Scale:
% xlabel('Position (mm)', ...
%     'FontSize', figureFontSize1);
% ylabel('Magnetic Flux Density (T)', ...
%     'FontSize', figureFontSize1);
% ylim([figureLimLowY figureLimHighY]);
% xlim([0 upperLimitXmm]);
% set(gca,'FontSize', figureGcaFontSize1);
% % Save figure in Report File
% exportgraphics(figureOneEightyDegrees, ...
%     '..\..\Report\graphics\FluxOneEightyDeg.jpg', ...
%     'Resolution', 600);
% close(figureOneEightyDegrees);
% 
% % Figure for legend
% legendFigure = figure;
% hold on;
% line(nan, nan, ...
%     'Color', 'black');
% line(nan, nan, ...
%     'Color', 'red');
% line(nan, nan, ...
%     'Color', 'blue');
% line(nan, nan, ...
%     'Color', 'green');
% set(gca, 'Visible', 'off');
% hold off
% legend('Disk Edge', ...
%     'Magnetic Flux Density of Variable Magnet', ...
%     'Magnetic Flux Density of Stationary Magnet', ...
%     'Total Magnetic Flux Density');
% % Save figure in Report File
% exportgraphics(legendFigure, ...
%     '..\..\Report\graphics\FluxLegend.jpg', ...
%     'Resolution', 600)
% close(legendFigure)

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
    omega, [0 1000]));
Tcrit = T0_0(modelSimpleCritSpeed/10) / ...
    (2 / ((modelSimpleCritSpeed/10) / modelSimpleCritSpeed + ...
    modelSimpleCritSpeed / (modelSimpleCritSpeed/10)));
syms T0(omega);

T0(omega) = Tcrit * 2/(omega/modelSimpleCritSpeed + modelSimpleCritSpeed/omega);

width = figure_linewidth - 0;
fsize = figure_fontsize - 2;
figure5 = figure;

xlabel('Velocity', ...
    'FontSize', fsize);

ylabel('Braking Force', ...
    'FontSize', fsize);

hold on

set(gca,'XTick',[],'YTick',[])

fplot(modelSimpleTorqueInf(x/9.54929658551372), ...
    [modelSimpleCritSpeed*9.54929658551372 800*9.54929658551372], ...
    'green', ...
    'LineWidth', width);

fplot(T0_0(x/9.54929658551372), ...
    [0 modelSimpleCritSpeed*9.54929658551372], ...
    'blue', ...
    'LineWidth', width);

fplot(T0(x/9.54929658551372), ...
    [0 800*9.54929658551372], ...
    'red', ...
    'LineWidth', width);

set(gca,'FontSize', fsize);

% legend('$\hat{\psi}$','Interpreter','latex')

legend('$F_{HighSpeed}$', '$F_{LowSpeed}$', '$F_{Combined}$', 'Interpreter', 'latex',...
        'Location', 'best')

hold off
%exportgraphics(figure5, '..\..\Report\graphics\EddyCurrentBrake.jpg', 'Resolution', 600)
close(figure5)

%% 
fsize = 14;
designPlot = figure;
hold on
% set(gca, 'Color', 'black');
fplot(T0(x/9.54929658551372), ...
    [590 2950], ...
    'b', ...
    'LineWidth', width);
ylabel('Braking Torque (Nm)', 'FontSize', fsize)
yyaxis right
fplot(x*T0(x/9.54929658551372)/9.54929658551372, ...
    [590 2950], ...
    'red', ...
    'LineWidth', width);
ylabel('Braking Power (W)', 'FontSize', fsize, 'Color', 'black')
xlabel('Brake Disk Speed (rpm)', 'FontSize', fsize)
xlim([500 3000])
lgd = legend('Torque Curve', 'Power Curve', 'Location', 'southeast');
lgd.FontSize = 12;
ax = gca;
ax.YAxis(2).Color = 'black';
% xlabel('Brake Disk Speed (rpm)')
%exportgraphics(designPlot, '..\..\Report\graphics\BrakeDesign.jpg', 'Resolution', 600)


%% 

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
fplot(Te(omega/9.54929658551372), [0 400*9.54929658551372]);
legend(...
    'Model With Saturation Effects');
xlabel('Angular Velocity (rad/s)');
ylabel('Braking Torque (N m)');
hold off;
% exportgraphics(figure6, ...
%     '..\..\Report\graphics\Fig6.jpg', ...
%     'Resolution', 600);
% close(figure6);

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
% exportgraphics(figure7, ...
%     '..\..\Report\graphics\Fig7.jpg', ...
%     'Resolution', 600)
close(figure7)

figure8 = figure;
hold on;
fplot((Te+T0)/2, [0 400], 'black');
yyaxis right;
fplot((Te+T0)/2 * omega, [0 400], 'red');
legend('Average Torque', 'Power Delivered');
xlabel('Angular Velocity (rad/s)');
% exportgraphics(figure8, ...
%                 '..\..\Report\graphics\Fig8.jpg', ...
%                 'Resolution', 600);
close(figure8);

% %% TEST MODEL
% % Tb = σR2Sd ˙θB2
% syms Torque(omega)
% Torque(omega) = diskConductivity*magnetDiskR*pi*(magnetDiameter/2)^2*B0^2*(magnetAmount/2)*omega
% fig1 = figure
% fplot(Torque, [0 4000])


format bank

speed_kph = linspace(10, 50, 9);
n_rpm_drum = 25 / (3 * pi * 90e-3/2) * speed_kph;
n_rpm = n_rpm_drum * 13.28/15;

test1a = [6.6, 7.7, 8.5, 9.1, 9.2, 9.5, 9.8, 10, 10.1];
test1b = [4.5, 5.7, 6.6, 7.1, 7.7, 8.4, 8.4, 8.8, 9.3];
test1c = [7.8, 8.8, 9.9, 10.6, 11.1, 11.6, 12.2, 12.6, 12.8];
test1d = [8.4, 9.7, 10.5, 11.2, 11.7, 12.2, 12.5, 12.6, 13];
test1e = [5.8, 7, 7.9, 8.6, 9.2, 9.7, 10.3, 10.4, 10.9];

test1 = [test1a; test1b; test1c; test1d; test1e];

test1avg = mean(test1);

tab = table(speed_kph', n_rpm_drum', round(n_rpm' / 5) * 5);
tab.Properties.VariableNames = {'Speed (kph)', 'Drum Speed (rpm)', 'Motor Speed (rpm)'};

test1_fig = figure;
hold on
plot(speed_kph, test1a)
plot(speed_kph, test1b)
plot(speed_kph, test1c)
plot(speed_kph, test1d)
plot(speed_kph, test1e)
plot(speed_kph, test1avg)
legend('test a', 'test b', 'test c', 'test d', 'test e', 'avg')
close(test1_fig)

test2a = [12.2, 13.8, 14.9, 15.8, 16.2, 16.8, 17, 17.3, 17.6];

fig2 = figure;
plot(test2a)
close(fig2)

test520 = [14.2, 14.6, 15.5, 16.7, 18, 19.3, 20.6, 21.3, 21.6, 21.5, 20.8, 19.9, 18.3, 16.8, 15.4, 14.1, 13.3, 12.8, 12.7]; % 40
test785 = [17.9, 19.6, 21.4, 23.2, 24.9, 26, 26.4, 26.3, 25.3, 23.8, 21.5, 19.4, 17.4, 15.6, 14.5, 13.5, 13.6, 14.8]; % 48
test1045 = [17.5, 18.1, 19.8, 21.7, 24.3, 26.5, 28.2, 29.4, 30, 29.8, 29, 27.1, 25.2, 22.6, 20.2, 18.3, 16.5, 15.8, 15.7, 16.4]; % 61
test1305 = [19.9, 20.8, 22.7, 25.1, 27.8, 30, 32.3, 33.8, 34.4, 34.2, 33.4, 31.3, 28.5, 26, 23.2, 20.7, 19, 17.7, 17.7, 18.6]; % 71
test1565 = [21.7, 21.4, 22.2, 24.5, 27.2, 30.3, 33, 35.6, 37.3, 37.6, 37.4, 36.2, 34.2, 31.1, 28, 25, 22.3, 20.2, 19, 18.8, 19.4, 21.5]; % 82
test1825 = [25.5, 24.8, 25.8, 27.9, 30.7, 34, 37, 39.5, 41.3, 42.1, 41.9, 40.4, 37.7, 34.6, 31.4, 28.3, 25.4, 23.3, 21, 22.4, 22.9, 25]; % 92
test2085 = [26.4, 26.8, 27.5, 29, 30.7, 34.8, 37.2, 39.5, 41.2, 42.3, 41.3, 40, 37.5, 34.5, 31, 27.6, 25.4, 23, 21.5, 22.9];
test2350 = [24.3, 24.4, 26.3, 28.8, 32, 35.1, 38, 40.1, 41.2, 41.3, 40.1, 38.7, 35.6, 32.3, 29.1, 26.1, 23.55, 21.89, 21.1, 21.7];
test2610 = [26.3, 26.8, 28.4, 31.1, 34.2, 37.2, 40.1, 42, 42.8, 42.8, 41.3, 39.3, 35.7, 32.3, 29, 26, 23.9, 22.2, 22, 22.8];

fig3 = figure;
hold on
plot(test520)
plot(test785)
plot(test1045)
plot(test1305)
plot(test1565)
plot(test1825)
plot(test2085)
plot(test2350)
plot(test2610)
legend('520', '785', '1045', '1305', '1565', '1825', '2085', '2350', '2610')
% close(fig3)


work520 = (test520(9:18) - test1a(1))/14;
work785 = (test785(7:16) - test1a(2))/14;
work1045 = (test1045(9:18) - test1a(3))/14;
work1305 = (test1305(9:18) - test1a(4))/14;
work1565 = (test1565(10:19) - test1a(5))/14;
work1825 = (test1825(10:19) - test1a(6))/14;
work2085 = (test2085(10:19) - test1a(7))/14;
work2350 = (test2085(10:19) - test1a(8))/14;
work2610 = (test2610(9:18) - test1a(9))/14;

valid520  =  (test520(1:10)    - test2a(1)) / 14;
valid785  =  (test785(1:10)   - test2a(2)) / 14;
valid1045 =  (test1045(1:10)  - test2a(3)) / 14;
valid1305 =  (test1305(1:10)  - test2a(4)) / 14;
valid1565 =  (test1565(2:11) - test2a(5)) / 14;
valid1825 =  (test1825(2:11) - test2a(6)) / 14;
valid2085 =  (test2085(2:11) - test2a(7)) / 14;
valid2350 =  (test2085(2:11) - test2a(8)) / 14;
valid2610 =  (test2610(1:10)  - test2a(9)) / 14;

work = [work520; work785; work1045; work1305; work1565; work1825; work2085; work2350; work2610];

fig4 = figure;
hold on
plot(linspace(0,45,10),work520, 'LineWidth', 2)
plot(linspace(0,45,10),work785, 'LineWidth', 2) 
plot(linspace(0,45,10),work1045, 'LineWidth', 2)
plot(linspace(0,45,10),work1305, 'LineWidth', 2)
plot(linspace(0,45,10),work1565, 'LineWidth', 2)
plot(linspace(0,45,10),work1825, 'LineWidth', 2)
plot(linspace(0,45,10),work2085, 'LineWidth', 2)
plot(linspace(0,45,10),work2350, 'LineWidth', 2)
plot(linspace(0,45,10),work2610, 'LineWidth', 2)
legend('520 rpm', '785 rpm', '1045 rpm', '1305 rpm', '1565 rpm', '1825 rpm', '2085 rpm', '2610 rpm')
xlabel('Magnet Array Phase ( ^{o})', 'FontSize', 15)
ylabel('Braking Torque (Nm)', 'FontSize', 15)
exportgraphics(fig4, '..\..\Report\graphics\TestGraph.jpg', 'Resolution', 600)
%close(fig4)

maxSpd = [max(work520), max(work785), max(work1045), max(work1305), max(work1565), max(work1825), max(work2085), max(work2350), max(work2610)];
minSpd = [min(work520), min(work785), min(work1045), min(work1305), min(work1565), min(work1825), min(work2085), min(work2350), min(work2610)];
Spd = [10, 15, 20, 25, 30, 35, 40, 45, 50];

bottom = 25 / (3 * pi * 90e-3/2) * 10;
top = 25 / (3 * pi * 90e-3/2) * 50;

fig5 = figure;
hold on
scatter(25 / (3 * pi * 90e-3/2) * Spd, maxSpd, 'LineWidth', 2)
% plot(25 / (3 * pi * 90e-3/2) * Spd, minSpd)
fplot(T0(x/9.54929658551372), ...
    [bottom top], ...
    'red', 'LineWidth', 2);
legend('Measured Data', 'Theoretical Model', 'Location','southeast')
xlabel('Speed (rpm)', 'FontSize', 15)
ylabel('Braking Torque (Nm)', 'FontSize', 15)
exportgraphics(fig5, '..\..\Report\graphics\TestComp.jpg', 'Resolution', 600)

%close(fig5)

powMax = Spd/0.09/2 .* maxSpd ;
powMin = Spd/0.09/2 .* minSpd;

power_plot = figure;
hold on
plot(Spd,powMax)
plot(Spd,powMin)
hold off
% close(power_plot)


angles = linspace(0,45, 10);
[x, y] = meshgrid(rot90(angles), Spd);

vect1 = [angles'; angles'; angles'; angles'; angles'; angles'; angles'; angles'; angles'];
vect2 = [zeros(10,1) + Spd(1); zeros(10,1) + Spd(2); zeros(10,1) + Spd(3); zeros(10,1) + Spd(4); zeros(10,1) + Spd(5); zeros(10,1) + Spd(6); zeros(10,1) + Spd(7); zeros(10,1) + Spd(8); zeros(10,1) + Spd(9)];
vect3 = [rot90(work520); rot90(work785); rot90(work1045); rot90(work1305); rot90(work1565); rot90(work1825); rot90(work2085); rot90(work2350); rot90(work2610)];
vect4 = [rot90(valid520); rot90(valid785); rot90(valid1045); rot90(valid1305); rot90(valid1565); rot90(valid1825); rot90(valid2085); rot90(valid2350); rot90(valid2610)];

vect = [vect1, vect2, vect3] ;
% surf(x,y,work,'FaceAlpha',0.5)
%scatter3(zeros(1,10) + 10, angles, rot90(work520))
%scatter3(zeros(1,10) + 15, angles, rot90(work785))
%plot3(zeros(1,10) + 10, angles, rot90(work520))
%plot3(zeros(1,10) + 15, angles, rot90(work785))
%plot(surffit, [vect1,vect2],vect3)
[surffit, gob, out] = fit([vect1, vect2], vect3, 'poly23')

figg = figure;

%scatter3(x, y, work)
% scatter3(vect1,vect2,vect3); hold on
%scatter3(vect1,vect2,vect4); hold on
alpha 0.5
plot(surffit,[vect1,vect2], vect3)

yl = ylabel('Roller Speed (km/h)', 'FontSize', 15, 'Rotation', -27);
yl.Position(2) = yl.Position(2) - 9;
xl = xlabel('Magnet Array Phase ( ^{o})', 'FontSize', 15, 'Rotation', 17);
xl.Position(2) = xl.Position(2) + 8;
xl.Position(1) = xl.Position(1) + 12;
zlabel('Braking Torque (Nm)', 'FontSize', 15);
exportgraphics(figg, '..\..\Report\graphics\Valid.jpg', 'Resolution', 600)
%close(figg)