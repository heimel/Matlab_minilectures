h = figure('Name','Example','NumberTitle','off')
set(h,'Color',[1 1 1]);

n = 5;
x = repmat(linspace(0,2*pi,20),n,1);
x = x(:);

myfun = @(x) 1./(1+exp(x));
y = myfun(x) + rand(size(x))-0.5;

xf = linspace(0,2*pi,1000);
yf = myfun(xf);
color{1} = [0.1 1 0.5];

plot(x,y,'o','color',color{1},'MarkerFaceColor',color{1});

hold on
set(gca,'FontSize',18)
h = plot(xf,yf,'-');
set(h,'linewidth',2);
xlabel('Time (s)');
ylabel('Response (a.u.)');
box off
axis square
xlim([ 0 2*pi]);
set(gca,'xtick',0:pi/2:2*pi);
set(gca,'xticklabel',{'0','\pi/2','\pi','3\pi/2','2\alpha'})
title('1/(e^x)')
set(gca,'XAxisLocation','origin')


