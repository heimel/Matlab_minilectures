function fitting_example
%FITTING_EXAMPLE show fminsearch in fitting a model 
%
% 2017-2020, Alexander Heimel

%% measure data
%clear all
nature_params = [5 -4 3];
disp(['Nature: ' mat2str(nature_params)]);

n_trials = 10;
data.x = repmat(0:0.1:1,n_trials,1) + 0.1*(rand(n_trials,11)-0.5);
data.y = polyval(nature_params,data.x) + (rand(size(data.x))-0.5);

% plot data
figure;
plot(data.x(:),data.y(:),'ob','MarkerFace',[0 0 1])
box off

%% fit linear model
lm = fitlm(data.x(:),data.y(:))
co = lm.Coefficients.Estimate;
x = linspace(min(data.x(:)),max(data.x(:)),100);
hold on
h.lm = plot(x,co(1) + co(2)*x,'-','linewidth',2);

%% fit model using polyfit
polyfit_params = polyfit(data.x(:),data.y(:),2);
disp(['Polyfit: ' mat2str(polyfit_params,3)]);
hold on
%x = unique(data.x);
h.poly = plot(x,polyval(polyfit_params,x),'-k','linewidth',2);

%% fit model using fminsearch
fmin_params = fminsearch( @(p) poly_cost(p,data),[1 1 1]);
disp(['Fminsearch: ' mat2str(fmin_params,3)]);
hold on
h.fmin = plot(x,polyval(fmin_params,x),'-','linewidth',2);

function cost = poly_cost(params,data)
cost = sum((polyval(params,data.x(:)) - data.y(:) ).^2);

