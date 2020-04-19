function Gaussian_func = gaussian_1D(x, mu, sigma)
    %  x     - Input vector
    %  mu    - Mean
    %  sigma - Standard deviation
    Gaussian_func = (1 / (sigma * sqrt(2 * pi))) * exp(-(x - mu).^2 ./ (2 * sigma^2));
end