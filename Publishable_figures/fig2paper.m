% fig2paper
% example for turning a matlab figure into a paper quality figure
% inspired by http://steventhornton.ca/publication-quality-plots-with-matlab/
% 2018, Alexander Heimel


% dock figurs
set(0,'DefaultFigureWindowStyle','docked');

close all

x = -3*pi + 6*pi*rand(30,1);

yfun = @(x) 1./(1+exp(-x));

y = yfun(x  )+ (rand(length(x),1)-0.5)*0.2;
xf = linspace(-3*pi,3*pi,100);
yf = yfun(xf);

% xf = linspace(-3*pi,3*pi,100);
% y1 = exp( -x.^2/10 ).*sin(x);
% y2 = exp( -x.^2/10 ).*cos(x);

fig = figure('NumberTitle','off','Name','Oscillation');
hold on

ax = gca;
ax.XLim = [-3*pi, 3*pi];
ax.YLim = [-1, 1];
ax.XTick = -3*pi:pi:3*pi;    % The locations of the tick marks
ax.XTickLabels = {'-3\pi', '-2\pi', '-\pi', '0', '\pi', '2\pi','3\pi'};
%ax.TickLabelInterpreter = 'LaTeX';
ax.YTick = -1:0.5:1;
%ax.FontName = 'LaTeX';
ax.FontName = 'Calibri';
%ax.Title.Interpreter = 'LaTeX';
%ax.XLabel.Interpreter = 'LaTeX';
%ax.YLabel.Interpreter = 'LaTeX';
ax.Box = 'off';
ax.LineWidth = 1.5;
ax.FontSize = 14;
ax.TickDir = 'out';
title('Sigmoid data 1/(1+e^{-x})')
ylim([-0.2 1.2]);
clr = {[1 0 0]};
plot(x,y,'o','color',clr{1},'markerface',clr{1},'markersize',5);
plot(xf,yf,'linewidth',1.5,'color',clr{1});
%plot(xf,yf);

% plot(x,y1);
% plot(x,y2);
xlabel('Time (s)')
ylabel('Response (Hz)');


