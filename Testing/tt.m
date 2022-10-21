clear 
clc

figure;
axes('box','on','dataaspectratio',[1 1 1],'projection','perspective');
xlabel('This is an x label')
ylabel('This is a y label')
zlabel('This is a z label')

h = rotate3d;
set(h, 'ActionPreCallback', 'set(gcf,''windowbuttonmotionfcn'',@align_axislabel)')
set(h, 'ActionPostCallback', 'set(gcf,''windowbuttonmotionfcn'','''')')