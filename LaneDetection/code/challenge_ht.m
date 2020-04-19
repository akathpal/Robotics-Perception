function lines = challenge_ht(thresholded)
    [H,T,R] = hough(thresholded);
    numberofpeaks = 100;
    P = houghpeaks(H,numberofpeaks); 
    lines = houghlines(thresholded,T,R,P,'FillGap',200,'MinLength',5);
end
