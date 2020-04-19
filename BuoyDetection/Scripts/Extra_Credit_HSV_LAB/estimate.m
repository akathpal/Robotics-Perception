function gmms = estimate(Samples,numberOfcomponent)

options = statset('MaxIter',1000);
gmms = fitgmdist(Samples,numberOfcomponent,'Options',options, 'Regularize', 1e-5,'CovarianceType','full');

end