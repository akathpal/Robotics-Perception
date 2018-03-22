clc;
clear all;
close all;
tic
cd ..;
video=VideoReader('input/project_video.mp4');
n=1;

outputVideo = VideoWriter(fullfile('Output_Project_Video_1.avi'));
outputVideo.FrameRate = video.FrameRate;
open(outputVideo);


while (hasFrame(video))
    video_frame = readFrame(video);
    frame = video_frame;
    frame = undistortimage(frame, 1.628055003e+03, 6.71627794e+02, 3.86046312e+02, -2.42565104e-01,-4.77893070e-02,-1.31388084e-03,-8.79107779e-05,2.20573263e-02);
    
    masked_image = mask(frame);
    
    thresholded = threshold(masked_image);
    %figure(1);imshow(thresholded); hold on
    lines = hough_transform(thresholded);
    
    lines_l = struct;
    lines_r = struct;
    slope = zeros(1,length(lines));
    i=1;j=1;
    for k = 1:length(lines)
       slope(k) = (lines(k).point2(2)-lines(k).point1(2))/(lines(k).point2(1)-lines(k).point1(1));
       if((slope(k)>0.5 && slope(k)<1) || (slope(k)<-0.5&& slope(k)>-1))
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
        continue;
    end
    
    if(size(lines_r,2)>1)
        xy_right = max_length(lines_r);
        %plot(xy_right(:,1),xy_right(:,2),'LineWidth',4,'Color','red');
    else
        continue;
    end
    
    
    [direction,ml,cl,mr,cr] = turn(xy_left,xy_right);
    
    green_mask=poly2mask([(480-cl)/ml,(680-cl)/ml,(680-cr)/mr,(480-cr)/mr],[480,680,680,480],720,1280);
    video_frame(:,:,2)=imadd(double(video_frame(:,:,2)),double(100*green_mask));
   
    video_frame = insertText(video_frame,[550,600],['Going ', direction],'fontSize',24,'TextColor','black');
    
    writeVideo(outputVideo,video_frame);
end
close(outputVideo);
toc