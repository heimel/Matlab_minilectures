%MAKEFIGUREDEMO makes a figure for ONWAR course
%
% 2018, Alexander Heimel

figure('Name','Example data','NumberTitle','off');
set(gca,'FontSize',14);
hold on
set(gca,'LineWidth',1.5);

n = 5;
x = repmat(linspace(0,2*pi,20),n,1);
myfun = @(x) 1./(1+exp(x));

y = myfun(x) + 0.2*(rand(size(x))-0.5);

xf = linspace(0,2*pi,100);
yf = myfun(xf);

color{1} = [200 67 10]/255;
color{2} = [50 200 10]/255;

hdots = plot(x,y,'o','color',color{1});
set(hdots,'MarkerFace',color{1})
hline = plot(xf,yf,'-','color',color{2});
set(hline,'LineWidth',2);

xlabel('Time (s)');
ylabel('Response (Hz)');
set(gca,'XAxisLocation','origin')

axis square
box off
xlim([0 2*pi]);
set(gca,'xtick',0:pi/2:2*pi);
set(gca,'xticklabels',{'0','\pi/2','\pi','3\pi/2','2\pi'});
title('1/e^{x}');


set(gca,'tickdir','out');
saveas(gcf,'example.pdf','pdf');

