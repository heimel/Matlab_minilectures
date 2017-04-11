function fitting_example
%FITTING_EXAMPLE show fminsearch in fitting a model 
%
% 2017, Alexander Heimel

% measure data
n_trials = 20;
data.x = repmat(0:0.1:1,n_trials,1)
data.y = measure_model( data.x );

% plot data
figure
plot(data.x(:),data.y(:),'o')

% % fit model
fit_params = fminsearch( @(p) poly_cost(p,data),[1 1 1])
% 
% 
% % plot model fit
x = unique(data.x);
hold on
plot(x,polyval(fit_params,x),'-');

function cost = poly_cost(params,data)
cost = sum((polyval(params,data.x(:)) - data.y(:) ).^2);

function y = measure_model( x )
model_params = [5 -4 3];
y = polyval(model_params,x) + rand(size(x));
