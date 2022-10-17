clear;
clc;

% Record data from torque tests
% Speed targets:

% 10 kph = 590  = 520
% 15 kph = 885  = 780
% 20 kph = 1180 = 1044
% 25 kph = 1470 = 1300
% 30 kph = 1770 = 1565
% 35 kph = 2060 = 1823
% 40 kph = 2360 = 2088
% 45 kph = 2650 = 2345
% 50 kph = 2950 = 2610


% Test 1: No load + trainer
test_1_speed = [10, 15, 20, 25, 30, 35, 40, 45, 50]
test_1a = [16, (17.5 + 17)/2, 18.3, 18.6, 19, 19.5, 19.5, 20, 20]
test_1b = [20, 19, 18, 17, 16, 15, 14.5, 13.5, 12.3];
test_1b = rot90(rot90(test_1b))
test_1c = [13.5, 15, 16, 17, 17.5, 18, 18.5, 19, 19.3]
test_1d = [9, 10.5, 11.5, 12.5, 13.6, 14, 14.5, 15, 15] 
test_1e = [8, 9, 10, 11, 11.5, 12, 13, 13, 13.5]
test_1f = [9, 10, 11, 12, 12.5, 13, 13.5, 14, 14]
test_1g = [6.5, 8, 8.5, 10, 10.5, 11, 12, 12.5, 12.5]
test_1h = [6, 7.5, 8.5, 9.5, 10, 11, 11.5, 11.5, 12]
test_1i = [7, 8.5, 10, 10.5, 12, 11.5, 12.5, 13, 13.5]
% Observations:
% As more tests are run, the value 0f the resistance torque seems to
% reduce. This is possibly due to the system being run in, and shaft
% allignments rectifying themselves and bearings being worn in. More tests
% were thus conducted to ensure that reliable readings were taken

test_1_fig = figure;
hold on
plot(test_1_speed, test_1a)
plot(test_1_speed, test_1b)
plot(test_1_speed, test_1c)
plot(test_1_speed, test_1d)
plot(test_1_speed, test_1e)
plot(test_1_speed, test_1f)
plot(test_1_speed, test_1g)
plot(test_1_speed, test_1h)
plot(test_1_speed, test_1i)
legend('Test 1a', 'Test 1b', 'Test 1c', 'Test 1d', 'Test 1e', 'Test 1f', 'Test 1g', 'Test 1h', 'Test 1i', 'Location','bestoutside')
% close(test_1_fig);