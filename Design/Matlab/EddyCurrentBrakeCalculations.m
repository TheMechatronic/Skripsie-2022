% Title: Eddy Current Brake Calculations and Plots
% Auther: DC Eksteen
% Student Number: 22623906
% Contact: 22623906@sun.ac.za
% Date: 2022/09/13
% Version: 0.0

clear;
clc;

% Disk Properties:
% Diameter:
disk_D = 0.110; % 110 mm
% Thickness:
disk_t = 0.010; % 10 mm
% Resistivity 
disk_rho = 2.65 * 10^-8; % ohm/m
% Permeability
disk_mu = 1.256e-6; % H/m
% Conductivity:
disk_kappa = 1/0.038e-6;

% Magnet Properties:
% Thickness:
mag_t = 0.005; % 5 mm
% Diameter:
mag_d = 0.015; % 15 mm
% Amount:
mag_n = 16;
% Gap between magnets and plate:
gap = 0.002; % 2 mm
% Gap between surface of magnet and center of disc
mag_g = gap + disk_t/2; % m 
% Br:
mag_Br = 1.3;
% Function to find B at point z away from disk magnet
syms B(z);
B(z) = (mag_Br/2)*((mag_t + z)/(sqrt((mag_d/2)^2 + (mag_t + z)^2)) - z/sqrt((mag_d/2)^2 + z^2));
xup = mag_g*2;
B0 = double(mean(B(linspace(gap,gap+disk_t,10)) + B(-linspace(gap,gap+disk_t,10) + xup)));

xuplim = xup*1000;
syms Bleft(x);
Bleft(x) = B(x/1000);
syms Bright(x);
Bright(x) = B(-x/1000 + xup);

% Figure 1: 0 degrees out of phase
phas = 0;
figure
hold on
xline(gap*1000, 'black')
xline((gap+disk_t)*1000, 'black')
fplot(Bleft(x)*cosd(phas), [0 xuplim], 'red')
fplot(Bright(x), [0 xuplim], 'blue')
fplot(Bleft(x)*cosd(phas) + Bright(x), [0 xuplim], 'green')
xlabel('Position (mm)')
ylabel('Magnetic Flux Density (T)')
ylim([-0.5 0.5])
xlim([0 xuplim])
grid on
title(phas + "^{o}", 'FontSize', 10, 'FontWeight', 'normal')

% Tile 2: 60 degrees
phas = 60;
figure
hold on
xline(gap*1000, 'black')
xline((gap+disk_t)*1000, 'black')
fplot(Bleft(x)*cosd(phas), [0 xuplim], 'red')
fplot(Bright(x), [0 xuplim], 'blue')
fplot(Bleft(x)*cosd(phas) + Bright(x), [0 xuplim], 'green')
%legend('', '', 'Magnetic Flux Density of Variable Magnet', 'Magnetic Flux Density of Stationary Magnet', 'Total Magnetic Flux Density', 'Location', 'southoutside')
xlabel('Position (mm)')
ylabel('Magnetic Flux Density (T)')
ylim([-0.5 0.5])
xlim([0 xuplim])
grid on
title(phas + "^{o}", 'FontSize', 10, 'FontWeight', 'normal')

% Tile 3: 120 degrees
phas = 120;
figure
hold on
xline(gap*1000, 'black')
xline((gap+disk_t)*1000, 'black')
fplot(Bleft(x)*cosd(phas), [0 xuplim], 'red')
fplot(Bright(x), [0 xuplim], 'blue')
fplot(Bleft(x)*cosd(phas) + Bright(x), [0 xuplim], 'green')
%legend('', '', 'Magnetic Flux Density of Variable Magnet', 'Magnetic Flux Density of Stationary Magnet', 'Total Magnetic Flux Density', 'Location', 'southoutside')
xlabel('Position (mm)')
ylabel('Magnetic Flux Density (T)')
ylim([-0.5 0.5])
xlim([0 xuplim])
grid on
title(phas + "^{o}", 'FontSize', 10, 'FontWeight', 'normal')

% Tile 4: 180 degrees
phas = 180;
figure
hold on
xline(gap*1000, 'black')
xline((gap+disk_t)*1000, 'black')
fplot(Bleft(x)*cosd(phas), [0 xuplim], 'red')
fplot(Bright(x), [0 xuplim], 'blue')
fplot(Bleft(x)*cosd(phas) + Bright(x), [0 xuplim], 'green')
% legend('', '', 'Magnetic Flux Density of Variable Magnet', 'Magnetic Flux Density of Stationary Magnet', 'Total Magnetic Flux Density', 'Location', 'southoutside')
xlabel('Position (mm)')
ylabel('Magnetic Flux Density (T)')
ylim([-0.5 0.5])
xlim([0 xuplim])
grid on
% title(phas + "^{o}", 'FontSize', 10, 'FontWeight', 'normal')
hold off

legend('', '', 'Magnetic Flux Density of Variable Magnet', 'Magnetic Flux Density of Stationary Magnet', 'Total Magnetic Flux Density', 'Orientation', 'vertical');


% Radius of disk offset: (radius)
R = 0.023; % 30 mm 
% Distance between magnet centres:
dc = 2*R*sin(pi/(mag_n/2));
% Distance between magnet edges: (Approximation)
dm = dc - mag_d;

% Permeability in a vacume:
mu_0 = 1.257e-6; % H/m

% Magnet Strength Calculations

% High speed region:
% Current in regions surrounding the pole shadows: 
Iinf = mag_t * mag_Br/mu_0; % A
% Resistance in each of the channels between the pole pairs:
Rinf = 1/disk_kappa * (mag_d)/(disk_t * R); % ohm
% Retarding Force on disk:
syms Tinf(omega);
Tinf(omega) = mag_n * 1/omega * Iinf^2 * Rinf;
c0 = 0.5 * (1 - ( (mag_d*disk_D*0.5)^2 /( (disk_D*0.5)^2 - R^2)^2) );

% Low speed:
syms T0_e(omega);
T0_e(omega) = mag_n * 1/disk_rho * R^2 * (pi*mag_d^2/4) * disk_t * B0^2 * omega;
syms T0_0(omega);
T0_0(omega) = mag_n/2 * disk_kappa * omega*R * B0^2 * pi * mag_d^2/4 * disk_t * c0;

% Combined:
omega_c = double(vpasolve(T0_0 == Tinf, omega, [0 100]));
Tcrit = T0_0(omega_c/10) / (2/((omega_c/10)/omega_c + omega_c/(omega_c/10)));
syms T0(omega);
T0(omega) = Tcrit * 2/(omega/omega_c + omega_c/omega);

figure
xlabel('Angular Velocity (rad/s)')
ylabel('Braking Torque (N m)')
hold on
fplot(Tinf,[omega_c 400])
fplot(T0_0, [0 omega_c])
fplot(T0, [0 400])
%xline(omega_c)
legend('High Speed', 'Low speed', 'Combined')
hold off

% Model 1:
% Correction Factor
c1 = 0.5 * ( 1 - 0.25*( 1 / ( (1+R/(disk_D/2))^2 * (( (disk_D/2) - R) / (mag_d))^2 ) ));
% Critical Force
Te_hat = double(R * (1/mu_0) * sqrt(c1) * (pi/4) * (mag_d)^2 * ( mag_n*0.5*B0 )^2 * sqrt( (2*mag_g)/(mag_d) ) );
% Critical speed
omega_c1 = ((2 / mu_0) * sqrt(1/(c1)) * (disk_rho/disk_t) * sqrt((2*mag_g)/(mag_d)))/ R;
% General Equation
Te(omega) = Te_hat * 2/(omega_c1/(omega) + (omega)/omega_c1);

figure
hold on
fplot(T0_e(z), [0 400])
fplot(Te(omega), [0 400])
legend('Linear Model', 'Model With Saturation Effects')
xlabel('Angular Velocity (rad/s)')
ylabel('Braking Torque (N m)')
hold off

figure
hold on
fplot(Te(omega), [0 400])
fplot(T0,[0 400])
fplot((Te+T0)/2, [0 400], 'black')
legend('Simple Model', 'Advanced Model', 'Average')
xlabel('Angular Velocity (rad/s)')
ylabel('Braking Torque (N m)')
hold off

figure
hold on
fplot((Te+T0)/2, [0 400], 'black')
yyaxis right
fplot((Te+T0)/2 * omega, [0 400], 'red')
legend('Average Torque', 'Power Delivered')
xlabel('Angular Velocity (rad/s)')