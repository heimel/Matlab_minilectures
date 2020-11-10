function y = sinplot( x, xlab )
%SINPLOT plots the sine of a vector
%
% Y = SINPLOT( X )
%   X is a vector
%   Y is the sine of X
%
% 2019, Alexander Heimel

if nargin<2
    xlab = 'Time (s)';
end

y = sin( x );
plot(x,y,'-','linewidth',5,'color',[0 1 0]);

hold on
plot(x,sin(x+pi),'-','linewidth',5,'color',[1 0 1]);
xlim([min(x) max(x)]);
ylim([min(y) max(y)]);
plot([min(x) max(x)],[0 0],'-k');
xlabel(xlab);
ylabel('Potential (V)');
box off
hold off
