function topview_frame = topview(image)
    trap_Points = [180 700; 550 450; 720 450; 1280 700];
    rect_Points =[475 720;475 0;800 0;800 720];
    
    tform = fitgeotrans(trap_Points,rect_Points,'projective');
    topview_frame = imwarp(image,tform,'OutputView',imref2d(size(image)));
end