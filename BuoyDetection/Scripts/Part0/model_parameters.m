function [mu,sigma]=model_parameters(Samples)
    %mu - Mean
    %sigma = standard deviation
    mu=mean(Samples);
    sigma=sqrt(var(double(Samples)));
end
