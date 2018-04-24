function GMModels = estimate(Samples,numberOfcomponent)

options = statset('MaxIter',100);
GMModels= fitgmdist(Samples,numberOfcomponent,'Options',options, 'Regularize', 1e-5,'CovarianceType','full');

end