function pdf = gaussian_nd(X, mu, Sigma)

n = size(X, 2);
diff = X - mu;
pdf = 1 / sqrt((2*pi)^n * det(Sigma)) * exp(-1/2 * sum((diff * inv(Sigma) .* diff), 2));

end
