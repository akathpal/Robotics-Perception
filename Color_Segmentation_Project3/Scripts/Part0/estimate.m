function [mu,sigma]=estimate(Samples)
mu=mean(Samples)';
sigma=sqrt(var(double(Samples))');
end
