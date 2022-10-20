clc;
clear;

speeds27 = linspace(82, 408, 20);
speeds29 = linspace(76, 379, 20);

min_force27 = 80 ./ speeds27;
max_force27 = 400 ./ speeds27;

min_force29 = 80 ./ speeds29;
max_force29 = 400 ./ speeds29;

f = figure;
hold on;
plot(speeds27, min_force27)
plot(speeds27, max_force27)
xlabel('Wheel Speed (rpm)')
ylabel('Applied Braking Force (N)')
legend('80 W', '400 W')
exportgraphics(f, ...
    '..\..\Report\graphics\BrakingForce.jpg', ...
    'Resolution', 600)
close(f)