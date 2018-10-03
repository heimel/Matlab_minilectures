%MAKEFIGUREDEMO makes a figure for ONWAR course
%
% 2018, Alexander Heimel

figure('Name','Example data','NumberTitle','off');
hold on
set(gca,'LineWidth',1.5);

n = 30;
x = rand(n,1)*2*pi;


myfun = @(x) 1./(1+exp(3*x));

y = myfun(x) + 0.2*(rand(n,1)-0.5);

xf = linspace(0,2*pi,100);
yf = myfun(xf);


hdots = plot(x,y,'.');
hline = plot(xf,yf,'o-');

xlabel('Time (s)');
ylabel('Response (Hz)');

axis square
box off
xlim([0 2*pi]);
set(gca,'xtick',0:pi/2:2*pi);
set(gca,'xticklabels',{'0','\pi/2','\pi','3\pi/2','2\pi'});
title('1/e^{3x}');


%set(hline,'linewidth',1.5);
%hline.LineWidth = 2;
plot(xf,sin(xf),'LineWidth',1.5)
set(gca,'tickdir','out');

