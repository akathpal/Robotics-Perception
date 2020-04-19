function lines = hough_transform(thresholded)
    [H,T,R] = hough(thresholded);
    numberofpeaks = 100;
    P = houghpeaks(H,numberofpeaks,'threshold',ceil(0.2*max(H(:)))); 
    lines = houghlines(thresholded,T,R,P,'FillGap',200,'MinLength',10);
end
