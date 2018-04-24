%% Expectation Maximization Implementation
function [mu,sigma] = em_implementation(X,N,d,r)
%X - dataset
%N - no. of gaussians
%d - dimensionality of gaussian
%r - regularizing to avoid sigular covariance matrix

if nargin < 4
    r = 1e-7;
end
%% Randomly select N data points for initial means.
m = size(X, 1);
values = randperm(m);
mu = X(values(1:N), :)+r;
sigma = [];

%% Using covariance of complete data set as initial covariance matrix
for j = 1 : N
    sigma(:,:,j) = cov(X)+eye(d,d)*r;
end

%% Setting initial probabilities equal for each cluster
phi = ones(1, N) * (1 / N);

for iter = 1:1000
    
    for j = 1 : N  
        pdf(:, j) = gaussian_nd(X, mu(j, :), sigma(:,:,j));
    end

    temp_pdf = pdf .* phi;
    weights = temp_pdf./sum(temp_pdf, 2);
    mu_previous = mu;    
   
    for j = 1 : N
    
        % prior probability
        phi(j) = mean(weights(:, j), 1);
        
        % new mean by taking the weighted average of data points
        mu(j,:) =  weights(:, j)' * X;
        mu(j,:) = mu(j,:) ./ sum(weights(:, j), 1);
        
        % Covariance matrix computation
        temp = zeros(d, d)+eye(d,d)*r;
        Xm = X - mu(j, :);
        for i = 1 : m
            temp = temp + (weights(i, j) .* (Xm(i, :)' * Xm(i, :)));
        end
        sigma(:,:,j) = temp ./ sum(weights(:, j));
    end
    
    % convergence.
    if (mu == mu_previous)
        break;
    end
            
end 

end