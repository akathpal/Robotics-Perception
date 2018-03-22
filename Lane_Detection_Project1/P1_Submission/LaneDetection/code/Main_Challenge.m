clc;
clear all;
close all;
tic
cd ..;
video=VideoReader('input/challenge_video.mp4');
n = 1;
outputVideo = VideoWriter(fullfile('Final_Challenge_Video.avi'));
outputVideo.FrameRate = 25;
open(outputVideo);


while (hasFrame(video) && n<=125)
    video_frame = readFrame(video);
    frame = video_frame;
    frame = undistortimage(frame, 1.628055003e+03, 6.71627794e+02, 3.86046312e+02, -2.42565104e-01,-4.77893070e-02,-1.31388084e-03,-8.79107779e-05,2.20573263e-02);
    
    masked_image = mask(frame);
    masked_image = topview(masked_image);
    
    thresholded = combined_threshold(masked_image);
    trap_Points = [180 700; 550 450; 720 450; 1280 700];
    rect_Points =[475 720;475 0;800 0;800 720];
    tform = fitgeotrans(rect_Points,trap_Points,'projective');
    thresholded = imwarp(thresholded,tform,'OutputView',imref2d(size(masked_image)));
    %figure(1);imshow(thresholded);     
    %figure(1);imshow(thresholded);hold on
    lines = challenge_ht(thresholded);
    
    lines_l = struct;
    lines_r = struct;
    slope = zeros(1,length(lines));
    i=1;j=1;
    for k = 1:length(lines)
       slope(k) = ((lines(k).point2(2)-lines(k).point1(2))/(lines(k).point2(1)-lines(k).point1(1)))^-1;
       xy = [lines(k).point1; lines(k).point2];
%        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       if((slope(k)<0.5) || (slope(k)>-0.5))
           if(slope(k) < 0)
               lines_l(i).point1 = lines(k).point1;
               lines_l(i).point2 = lines(k).point2;
               i = i+1;
           else
               lines_r(j).point1 = lines(k).point1;
               lines_r(j).point2 = lines(k).point2;
               j = j+1;
           end
       end
    end
    
    if(size(lines_l,2)>1)
        xy_left = max_length(lines_l);
        %plot(xy_left(:,1),xy_left(:,2),'LineWidth',4,'Color','red');
    else
        xy_left=[180 700;560 500];
    %    continue;
    end
    
    if(size(lines_r,2)>1)
        xy_right = max_length(lines_r);
        %plot(xy_right(:,1),xy_right(:,2),'LineWidth',4,'Color','red');
    else
        xy_right=[730 500;1050 700];
    %    continue;
    end
    
    [direction,ml,cl,mr,cr] = turn(xy_left,xy_right);
    
    green_mask=poly2mask([xy_left(2,1),xy_left(1,1),xy_right(2,1),xy_right(1,1)],[xy_left(2,2),700,700,xy_right(1,2)],720,1280);
    video_frame(:,:,2)=imadd(double(video_frame(:,:,2)),double(100*green_mask));
    video_frame = insertText(video_frame,[550,600],['Going ', direction],'fontSize',24,'TextColor','black');
    %figure(1);imshow(video_frame)
    n = n+1;
    writeVideo(outputVideo,video_frame);
end
close(outputVideo);
toc