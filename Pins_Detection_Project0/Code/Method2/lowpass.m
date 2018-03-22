function filtered_image = lowpass(image,sigma)

% gaussian kernel 3*3 
[A,B]=meshgrid(-1:1,-1:1);
h=exp(-1*(A.^2 + B.^2)/(2*sigma^2));
h= h / sum(h(:));
filtered_image = imfilter(image,h,'conv');