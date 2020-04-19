function [f_dx,f_dy,f_dt] = partialDerivates(img1,img2)

% partial derivative wrt to x
f_dx = conv2(img1,[-1 1; -1 1], 'valid');  
% partial derivative wrt to y
f_dy = conv2(img1, [-1 -1; 1 1], 'valid'); 
% partial derivative wrt to t
f_dt = conv2(img1, ones(2), 'valid') + conv2(img2, -ones(2), 'valid'); % partial on t

end